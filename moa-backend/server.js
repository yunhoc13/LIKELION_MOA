const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Database setup
const dbPath = path.join(__dirname, 'moa.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Database connection failed:', err);
  } else {
    console.log('Database connected at', dbPath);
    initializeDatabase();
  }
});

// Helper function to format SQLite dates to ISO8601
function formatDateToISO8601(sqliteDate) {
  if (!sqliteDate) return null;
  try {
    // SQLite returns dates like "2024-12-01 10:30:45"
    // Convert to ISO8601 like "2024-12-01T10:30:45Z"
    const date = new Date(sqliteDate + 'Z');
    return date.toISOString();
  } catch (e) {
    return sqliteDate;
  }
}

// Initialize database
function initializeDatabase() {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      email TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      name TEXT NOT NULL,
      university TEXT NOT NULL,
      major TEXT,
      graduation_year TEXT,
      bio TEXT,
      profile_picture_url TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `, (err) => {
    if (err) {
      console.error('Error creating users table:', err);
    } else {
      console.log('Users table ready');
    }
  });

  db.run(`
    CREATE TABLE IF NOT EXISTS activities (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      category TEXT NOT NULL,
      description TEXT NOT NULL,
      host_user_id TEXT NOT NULL,
      host_name TEXT NOT NULL,
      location_name TEXT NOT NULL,
      location_lat REAL NOT NULL,
      location_lng REAL NOT NULL,
      start_date_time DATETIME NOT NULL,
      end_date_time DATETIME,
      is_instant INTEGER DEFAULT 0,
      max_participants INTEGER NOT NULL,
      current_participants INTEGER DEFAULT 1,
      status TEXT DEFAULT 'open',
      participants TEXT DEFAULT '[]',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (host_user_id) REFERENCES users(id)
    )
  `, (err) => {
    if (err) {
      console.error('Error creating activities table:', err);
    } else {
      console.log('Activities table ready');
    }
  });
}

// Middleware
app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Signup
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { email, password, name, university } = req.body;

    if (!email || !password || !name || !university) {
      return res.status(400).json({ message: 'All fields required' });
    }

    const hashedPassword = await bcrypt.hash(password, 12);
    const userId = Date.now().toString();

    db.run(
      'INSERT INTO users (id, email, password_hash, name, university) VALUES (?, ?, ?, ?, ?)',
      [userId, email, hashedPassword, name, university],
      function(err) {
        if (err) {
          if (err.message.includes('UNIQUE constraint failed')) {
            return res.status(409).json({ message: 'Email already registered' });
          }
          return res.status(500).json({ message: err.message });
        }

        const token = jwt.sign({ id: userId, email }, process.env.JWT_SECRET, { expiresIn: '7d' });

        res.status(201).json({
          message: 'Signup successful',
          token,
          user: {
            id: userId,
            email,
            name,
            university
          }
        });
      }
    );
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Login
app.post('/api/auth/login', (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password required' });
    }

    db.get('SELECT * FROM users WHERE email = ?', [email], async (err, user) => {
      if (err) {
        return res.status(500).json({ message: err.message });
      }

      if (!user) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }

      const validPassword = await bcrypt.compare(password, user.password_hash);

      if (!validPassword) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }

      const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '7d' });

      res.json({
        message: 'Login successful',
        token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          university: user.university,
          major: user.major,
          graduation_year: user.graduation_year,
          bio: user.bio
        }
      });
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Update profile
app.put('/api/auth/profile/:id', (req, res) => {
  try {
    const { id } = req.params;
    const { major, graduation_year, bio } = req.body;

    console.log('Profile update request:', { id, major, graduation_year, bio });

    db.run(
      'UPDATE users SET major = ?, graduation_year = ?, bio = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
      [major || null, graduation_year || null, bio || null, id],
      function(err) {
        if (err) {
          return res.status(500).json({ message: err.message });
        }

        // Fetch updated user
        db.get('SELECT * FROM users WHERE id = ?', [id], (err, user) => {
          if (err) {
            return res.status(500).json({ message: err.message });
          }

          // Generate token
          const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '7d' });

          res.json({
            message: 'Profile updated',
            token,
            user: {
              id: user.id,
              email: user.email,
              name: user.name,
              university: user.university,
              major: user.major,
              graduation_year: user.graduation_year,
              bio: user.bio
            }
          });
        });
      }
    );
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Create Activity
app.post('/api/activities', (req, res) => {
  try {
    const { title, category, description, hostUserId, hostName, locationName, locationLat, locationLng, startDateTime, endDateTime, maxParticipants } = req.body;

    if (!title || !category || !description || !hostUserId || !hostName || !locationName || !startDateTime || !maxParticipants) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const activityId = Date.now().toString();
    const participants = JSON.stringify([hostUserId]);

    db.run(
      'INSERT INTO activities (id, title, category, description, host_user_id, host_name, location_name, location_lat, location_lng, start_date_time, end_date_time, max_participants, participants) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [activityId, title, category, description, hostUserId, hostName, locationName, locationLat || 0, locationLng || 0, startDateTime, endDateTime || null, maxParticipants, participants],
      function(err) {
        if (err) {
          return res.status(500).json({ message: err.message });
        }

        // Fetch created activity
        db.get('SELECT * FROM activities WHERE id = ?', [activityId], (err, activity) => {
          if (err) {
            return res.status(500).json({ message: err.message });
          }

          res.status(201).json({
            message: 'Activity created successfully',
            activity: {
              id: activity.id,
              title: activity.title,
              category: activity.category,
              description: activity.description,
              hostUserId: activity.host_user_id,
              hostName: activity.host_name,
              locationName: activity.location_name,
              locationLat: activity.location_lat,
              locationLng: activity.location_lng,
              startDateTime: formatDateToISO8601(activity.start_date_time),
              endDateTime: activity.end_date_time ? formatDateToISO8601(activity.end_date_time) : null,
              isInstant: activity.is_instant === 1,
              maxParticipants: activity.max_participants,
              currentParticipants: activity.current_participants,
              status: activity.status,
              participants: JSON.parse(activity.participants),
              createdAt: formatDateToISO8601(activity.created_at),
              updatedAt: formatDateToISO8601(activity.updated_at)
            }
          });
        });
      }
    );
  } catch (error) {
    console.error('Create activity error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Join Activity
app.put('/api/activities/:id/join', (req, res) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;

    if (!userId) {
      return res.status(400).json({ message: 'User ID is required' });
    }

    // Fetch the activity
    db.get('SELECT * FROM activities WHERE id = ?', [id], (err, activity) => {
      if (err) {
        return res.status(500).json({ message: err.message });
      }

      if (!activity) {
        return res.status(404).json({ message: 'Activity not found' });
      }

      // Parse participants
      let participants = JSON.parse(activity.participants);

      // Check if user already joined
      if (participants.includes(userId)) {
        return res.status(400).json({ message: 'Already joined this activity' });
      }

      // Add user to participants
      participants.push(userId);
      const newCurrentParticipants = activity.current_participants + 1;

      // Update activity
      db.run(
        'UPDATE activities SET participants = ?, current_participants = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
        [JSON.stringify(participants), newCurrentParticipants, id],
        function(err) {
          if (err) {
            return res.status(500).json({ message: err.message });
          }

          // Fetch updated activity
          db.get('SELECT * FROM activities WHERE id = ?', [id], (err, updatedActivity) => {
            if (err) {
              return res.status(500).json({ message: err.message });
            }

            res.json({
              message: 'Successfully joined activity',
              activity: {
                id: updatedActivity.id,
                title: updatedActivity.title,
                category: updatedActivity.category,
                description: updatedActivity.description,
                hostUserId: updatedActivity.host_user_id,
                hostName: updatedActivity.host_name,
                locationName: updatedActivity.location_name,
                locationLat: updatedActivity.location_lat,
                locationLng: updatedActivity.location_lng,
                startDateTime: formatDateToISO8601(updatedActivity.start_date_time),
                endDateTime: updatedActivity.end_date_time ? formatDateToISO8601(updatedActivity.end_date_time) : null,
                isInstant: updatedActivity.is_instant === 1,
                maxParticipants: updatedActivity.max_participants,
                currentParticipants: updatedActivity.current_participants,
                status: updatedActivity.status,
                participants: JSON.parse(updatedActivity.participants),
                createdAt: formatDateToISO8601(updatedActivity.created_at),
                updatedAt: formatDateToISO8601(updatedActivity.updated_at)
              }
            });
          });
        }
      );
    });
  } catch (error) {
    console.error('Join activity error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Get Activities
app.get('/api/activities', (req, res) => {
  try {
    const { category } = req.query;

    let query = 'SELECT * FROM activities';
    let params = [];

    if (category) {
      query += ' WHERE category = ?';
      params.push(category);
    }

    query += ' ORDER BY start_date_time ASC';

    db.all(query, params, (err, activities) => {
      if (err) {
        return res.status(500).json({ message: err.message });
      }

      const formattedActivities = activities.map(activity => ({
        id: activity.id,
        title: activity.title,
        category: activity.category,
        description: activity.description,
        hostUserId: activity.host_user_id,
        hostName: activity.host_name,
        locationName: activity.location_name,
        locationLat: activity.location_lat,
        locationLng: activity.location_lng,
        startDateTime: formatDateToISO8601(activity.start_date_time),
        endDateTime: activity.end_date_time ? formatDateToISO8601(activity.end_date_time) : null,
        isInstant: activity.is_instant === 1,
        maxParticipants: activity.max_participants,
        currentParticipants: activity.current_participants,
        status: activity.status,
        participants: JSON.parse(activity.participants),
        createdAt: formatDateToISO8601(activity.created_at),
        updatedAt: formatDateToISO8601(activity.updated_at)
      }));

      res.json({
        activities: formattedActivities
      });
    });
  } catch (error) {
    console.error('Get activities error:', error);
    res.status(500).json({ message: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
