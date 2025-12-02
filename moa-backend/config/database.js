const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'moa_db',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
  connectionTimeoutMillis: 5000,
  idleTimeoutMillis: 30000,
  max: 20,
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
});

// Test connection with retry logic
let retries = 5;
const testConnection = () => {
  pool.query('SELECT NOW()', (err, res) => {
    if (err) {
      if (retries > 0) {
        console.log(`Database connection failed. Retrying... (${retries} attempts left)`);
        retries--;
        setTimeout(testConnection, 2000);
      } else {
        console.error('Database connection failed after multiple retries:', err.message);
      }
    } else {
      console.log('Database connected successfully at', res.rows[0].now);
    }
  });
};

// Wait a bit before testing connection
setTimeout(testConnection, 1000);

module.exports = pool;
