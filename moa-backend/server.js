const express = require('express');
const admin = require('firebase-admin');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Initialize Firebase Admin SDK
// Support both local file and environment variables for deployment
let credential;

if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  // Production: Use environment variable
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  credential = admin.credential.cert(serviceAccount);
} else {
  // Development: Use local file
  const serviceAccount = require('./firebase-service-account.json');
  credential = admin.credential.cert(serviceAccount);
}

admin.initializeApp({
  credential: credential
});

const db = admin.firestore();

console.log('Firebase Firestore connected successfully');

// Helper function to convert Firestore Timestamp or Date to ISO string
function toISOString(dateOrTimestamp) {
  if (!dateOrTimestamp) return null;

  // If it's a Firestore Timestamp
  if (dateOrTimestamp.toDate && typeof dateOrTimestamp.toDate === 'function') {
    return dateOrTimestamp.toDate().toISOString();
  }

  // If it's already a Date object
  if (dateOrTimestamp instanceof Date) {
    return dateOrTimestamp.toISOString();
  }

  // If it's a string, try to parse it
  if (typeof dateOrTimestamp === 'string') {
    return new Date(dateOrTimestamp).toISOString();
  }

  return null;
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

    // Check if email already exists
    const usersRef = db.collection('users');
    const emailQuery = await usersRef.where('email', '==', email).get();

    if (!emailQuery.empty) {
      return res.status(409).json({ message: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 12);
    const userId = Date.now().toString();

    const userData = {
      id: userId,
      email,
      password_hash: hashedPassword,
      name,
      university,
      major: null,
      graduation_year: null,
      bio: null,
      profile_picture_url: null,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp()
    };

    await usersRef.doc(userId).set(userData);

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
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password required' });
    }

    // Find user by email
    const usersRef = db.collection('users');
    const userQuery = await usersRef.where('email', '==', email).get();

    if (userQuery.empty) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const userDoc = userQuery.docs[0];
    const user = userDoc.data();

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
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Update profile
app.put('/api/auth/profile/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { major, graduation_year, bio } = req.body;

    console.log('Profile update request:', { id, major, graduation_year, bio });

    const userRef = db.collection('users').doc(id);

    await userRef.update({
      major: major || null,
      graduation_year: graduation_year || null,
      bio: bio || null,
      updated_at: admin.firestore.FieldValue.serverTimestamp()
    });

    // Fetch updated user
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found' });
    }

    const user = userDoc.data();

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
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Create Activity
app.post('/api/activities', async (req, res) => {
  try {
    const { title, category, description, hostUserId, hostName, hostUniversity, locationName, locationLat, locationLng, startDateTime, endDateTime, maxParticipants } = req.body;

    if (!title || !category || !description || !hostUserId || !hostName || !hostUniversity || !locationName || !startDateTime || !maxParticipants) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const activityId = Date.now().toString();
    const participants = [hostUserId];

    const activityData = {
      id: activityId,
      title,
      category,
      description,
      hostUserId,
      hostName,
      hostUniversity,
      locationName,
      locationLat: locationLat || 0,
      locationLng: locationLng || 0,
      startDateTime: new Date(startDateTime),
      endDateTime: endDateTime ? new Date(endDateTime) : null,
      isInstant: false,
      maxParticipants,
      currentParticipants: 1,
      status: 'open',
      participants,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };

    await db.collection('activities').doc(activityId).set(activityData);

    // Fetch created activity
    const activityDoc = await db.collection('activities').doc(activityId).get();
    const activity = activityDoc.data();

    res.status(201).json({
      message: 'Activity created successfully',
      activity: {
        id: activity.id,
        title: activity.title,
        category: activity.category,
        description: activity.description,
        hostUserId: activity.hostUserId,
        hostName: activity.hostName,
        hostUniversity: activity.hostUniversity,
        locationName: activity.locationName,
        locationLat: activity.locationLat,
        locationLng: activity.locationLng,
        startDateTime: toISOString(activity.startDateTime),
        endDateTime: toISOString(activity.endDateTime),
        isInstant: activity.isInstant,
        maxParticipants: activity.maxParticipants,
        currentParticipants: activity.currentParticipants,
        status: activity.status,
        participants: activity.participants,
        createdAt: toISOString(activity.createdAt) || new Date().toISOString(),
        updatedAt: toISOString(activity.updatedAt) || new Date().toISOString()
      }
    });
  } catch (error) {
    console.error('Create activity error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Join Activity
app.put('/api/activities/:id/join', async (req, res) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;

    if (!userId) {
      return res.status(400).json({ message: 'User ID is required' });
    }

    const activityRef = db.collection('activities').doc(id);
    const activityDoc = await activityRef.get();

    if (!activityDoc.exists) {
      return res.status(404).json({ message: 'Activity not found' });
    }

    const activity = activityDoc.data();

    // Check if user already joined
    if (activity.participants.includes(userId)) {
      return res.status(400).json({ message: 'Already joined this activity' });
    }

    // Add user to participants
    const newParticipants = [...activity.participants, userId];
    const newCurrentParticipants = activity.currentParticipants + 1;

    await activityRef.update({
      participants: newParticipants,
      currentParticipants: newCurrentParticipants,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // Fetch updated activity
    const updatedActivityDoc = await activityRef.get();
    const updatedActivity = updatedActivityDoc.data();

    res.json({
      message: 'Successfully joined activity',
      activity: {
        id: updatedActivity.id,
        title: updatedActivity.title,
        category: updatedActivity.category,
        description: updatedActivity.description,
        hostUserId: updatedActivity.hostUserId,
        hostName: updatedActivity.hostName,
        hostUniversity: updatedActivity.hostUniversity,
        locationName: updatedActivity.locationName,
        locationLat: updatedActivity.locationLat,
        locationLng: updatedActivity.locationLng,
        startDateTime: toISOString(updatedActivity.startDateTime),
        endDateTime: toISOString(updatedActivity.endDateTime),
        isInstant: updatedActivity.isInstant,
        maxParticipants: updatedActivity.maxParticipants,
        currentParticipants: updatedActivity.currentParticipants,
        status: updatedActivity.status,
        participants: updatedActivity.participants,
        createdAt: toISOString(updatedActivity.createdAt) || new Date().toISOString(),
        updatedAt: toISOString(updatedActivity.updatedAt) || new Date().toISOString()
      }
    });
  } catch (error) {
    console.error('Join activity error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Leave Activity
app.put('/api/activities/:id/leave', async (req, res) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;

    if (!userId) {
      return res.status(400).json({ message: 'User ID is required' });
    }

    const activityRef = db.collection('activities').doc(id);
    const activityDoc = await activityRef.get();

    if (!activityDoc.exists) {
      return res.status(404).json({ message: 'Activity not found' });
    }

    const activity = activityDoc.data();

    // Check if user is a participant
    if (!activity.participants.includes(userId)) {
      return res.status(400).json({ message: 'You are not a participant of this activity' });
    }

    // Check if user is the host (host cannot leave their own activity)
    if (activity.hostUserId === userId) {
      return res.status(400).json({ message: 'Host cannot leave their own activity' });
    }

    // Check if activity starts in less than 1 hour
    const startTime = activity.startDateTime.toDate ? activity.startDateTime.toDate() : new Date(activity.startDateTime);
    const now = new Date();
    const oneHourFromNow = new Date(now.getTime() + 60 * 60 * 1000);

    if (startTime <= oneHourFromNow) {
      return res.status(400).json({ message: 'Cannot leave activity within 1 hour of start time' });
    }

    // Remove user from participants
    const newParticipants = activity.participants.filter(id => id !== userId);
    const newCurrentParticipants = activity.currentParticipants - 1;

    await activityRef.update({
      participants: newParticipants,
      currentParticipants: newCurrentParticipants,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // Fetch updated activity
    const updatedActivityDoc = await activityRef.get();
    const updatedActivity = updatedActivityDoc.data();

    res.json({
      message: 'Successfully left activity',
      activity: {
        id: updatedActivity.id,
        title: updatedActivity.title,
        category: updatedActivity.category,
        description: updatedActivity.description,
        hostUserId: updatedActivity.hostUserId,
        hostName: updatedActivity.hostName,
        hostUniversity: updatedActivity.hostUniversity,
        locationName: updatedActivity.locationName,
        locationLat: updatedActivity.locationLat,
        locationLng: updatedActivity.locationLng,
        startDateTime: toISOString(updatedActivity.startDateTime),
        endDateTime: toISOString(updatedActivity.endDateTime),
        isInstant: updatedActivity.isInstant,
        maxParticipants: updatedActivity.maxParticipants,
        currentParticipants: updatedActivity.currentParticipants,
        status: updatedActivity.status,
        participants: updatedActivity.participants,
        createdAt: toISOString(updatedActivity.createdAt) || new Date().toISOString(),
        updatedAt: toISOString(updatedActivity.updatedAt) || new Date().toISOString()
      }
    });
  } catch (error) {
    console.error('Leave activity error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Get Activities
app.get('/api/activities', async (req, res) => {
  try {
    const { category } = req.query;

    let activitiesRef = db.collection('activities');

    if (category) {
      activitiesRef = activitiesRef.where('category', '==', category);
    }

    const snapshot = await activitiesRef.orderBy('startDateTime', 'asc').get();

    const formattedActivities = snapshot.docs.map(doc => {
      const activity = doc.data();
      return {
        id: activity.id,
        title: activity.title,
        category: activity.category,
        description: activity.description,
        hostUserId: activity.hostUserId,
        hostName: activity.hostName,
        hostUniversity: activity.hostUniversity,
        locationName: activity.locationName,
        locationLat: activity.locationLat,
        locationLng: activity.locationLng,
        startDateTime: toISOString(activity.startDateTime),
        endDateTime: toISOString(activity.endDateTime),
        isInstant: activity.isInstant,
        maxParticipants: activity.maxParticipants,
        currentParticipants: activity.currentParticipants,
        status: activity.status,
        participants: activity.participants,
        createdAt: toISOString(activity.createdAt) || new Date().toISOString(),
        updatedAt: toISOString(activity.updatedAt) || new Date().toISOString()
      };
    });

    res.json({
      activities: formattedActivities
    });
  } catch (error) {
    console.error('Get activities error:', error);
    res.status(500).json({ message: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
