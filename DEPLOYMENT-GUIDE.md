# MOA App - Cloud Deployment Guide

**Date:** March 22, 2026
**Status:** ✅ Successfully Deployed to Cloud

---

## Overview

The MOA (Meet on App) iOS application has been successfully deployed to the cloud with Firebase Firestore database and Railway backend hosting. The app now works from anywhere with internet connection (WiFi or cellular data).

---

## Architecture

- **Frontend:** SwiftUI iOS App
- **Backend:** Node.js + Express (Deployed on Railway)
- **Database:** Firebase Firestore (Real-time NoSQL cloud database)
- **Authentication:** JWT tokens with bcrypt password hashing

---

## Important URLs and Credentials

### Railway Backend
- **Production URL:** `https://likelionmoa-production.up.railway.app`
- **Health Check:** `https://likelionmoa-production.up.railway.app/health`
- **Dashboard:** https://railway.app

### Firebase
- **Project ID:** `meet-on-app`
- **Console:** https://console.firebase.google.com

### GitHub Repository
- **Repo:** `yunhoc13/LIKELION_MOA`
- **Branch:** `main`

---

## What We Accomplished Today

### 1. Database Migration (SQLite → Firebase Firestore)

**Why:**
- Enable real-time synchronization across devices
- Cloud-based storage accessible from anywhere
- No need for local database files

**What Changed:**
- Created Firebase project with Cloud Firestore
- Installed Firebase Admin SDK in backend (`firebase-admin` npm package)
- Completely rewrote `server.js` to use Firestore instead of SQLite
- Added `FirebaseService.swift` for iOS real-time listeners
- Updated all iOS views to use Firebase real-time sync
- Migrated all user data and activities from SQLite to Firestore

**Files Modified:**
- `moa-backend/server.js` - Complete rewrite for Firestore
- `likelion/FirebaseService.swift` - New file for real-time listeners
- `likelion/MOAApp.swift` - Added Firebase initialization
- `likelion/HomeTabView.swift` - Real-time sync instead of polling
- `likelion/CategoryActivityListView.swift` - Real-time sync
- `likelion/MyEventsTabView.swift` - Real-time sync
- `likelion/CalendarTabView.swift` (ActivityDetailView) - Real-time updates

### 2. Cloud Backend Deployment (Railway)

**Why:**
- Make backend accessible from anywhere
- No longer need local server running
- Professional production environment

**Steps Taken:**

1. **Prepared Backend for Cloud:**
   - Modified `server.js` to support environment variables for Firebase credentials
   - Updated `package.json` with Node.js version requirement (`>=18.0.0`)
   - Added `.gitignore` entry for `firebase-service-account.json`

2. **Created Railway Project:**
   - Connected GitHub repository
   - Configured root directory: `moa-backend`
   - Set up environment variables

3. **Environment Variables Configured:**
   - `JWT_SECRET`: `test_secret_key_12345`
   - `PORT`: `3000` (Railway uses 8080 internally)
   - `FIREBASE_SERVICE_ACCOUNT`: Full JSON service account credentials

4. **Generated Public Domain:**
   - Domain: `likelionmoa-production.up.railway.app`
   - Port: 8080 (auto-assigned by Railway)
   - Protocol: HTTPS (secure)

### 3. iOS App Configuration

**Updated:**
- `likelion/APIService.swift` line 5:
  - From: `http://10.0.0.112:3000` (local IP)
  - To: `https://likelionmoa-production.up.railway.app` (cloud URL)

### 4. Testing & Verification

**Tested Successfully:**
- ✅ User login on WiFi
- ✅ User login on cellular data
- ✅ Create activity
- ✅ Join activity
- ✅ Leave activity
- ✅ Real-time sync across views
- ✅ Data persistence in Firebase Firestore

---

## How the System Works Now

### User Authentication Flow
1. User enters email/password in iOS app
2. iOS app sends POST request to `https://likelionmoa-production.up.railway.app/api/auth/login`
3. Railway backend validates credentials against Firebase Firestore
4. Backend generates JWT token and returns it
5. iOS app stores token and uses it for subsequent requests

### Real-Time Activity Updates
1. iOS app opens a Firebase listener when view appears
2. Any changes to Firestore activities collection trigger updates
3. iOS app automatically refreshes UI with new data
4. Multiple users see changes in real-time

### Data Flow
```
iOS App (SwiftUI)
    ↕ HTTPS
Railway Backend (Node.js + Express)
    ↕
Firebase Firestore (Cloud Database)
```

---

## Project Structure

```
likelion/
├── likelion/                          # iOS App
│   ├── APIService.swift               # API communication (uses Railway URL)
│   ├── FirebaseService.swift          # Real-time Firebase listeners
│   ├── MOAApp.swift                   # App entry point (Firebase init)
│   ├── HomeTabView.swift              # Home screen (real-time activities)
│   ├── CategoryActivityListView.swift # Category filter view
│   ├── MyEventsTabView.swift          # User's events (real-time)
│   ├── CalendarTabView.swift          # Activity detail view
│   ├── CreateActivityView.swift       # Create new activity
│   └── GoogleService-Info.plist       # Firebase iOS config
│
├── moa-backend/                       # Backend Server
│   ├── server.js                      # Express server (Firestore integration)
│   ├── package.json                   # Dependencies
│   ├── firebase-service-account.json  # Firebase credentials (NOT in git)
│   └── .env                           # Local environment variables
│
├── railway.json                       # Railway configuration
└── DEPLOYMENT-GUIDE.md                # This file
```

---

## API Endpoints

All endpoints are available at: `https://likelionmoa-production.up.railway.app`

### Authentication
- `POST /api/auth/signup` - Create new user account
- `POST /api/auth/login` - User login
- `PUT /api/auth/profile/:id` - Update user profile

### Activities
- `GET /api/activities` - Get all activities (optional query: `?category=...`)
- `POST /api/activities` - Create new activity
- `PUT /api/activities/:id/join` - Join an activity
- `PUT /api/activities/:id/leave` - Leave an activity (1-hour restriction)

### Health Check
- `GET /health` - Server health check (returns `{"status":"ok"}`)

---

## Important Files & Credentials

### Local Files (DO NOT COMMIT)
- `moa-backend/firebase-service-account.json` - Firebase Admin credentials
- `moa-backend/.env` - Local environment variables

### Firebase Credentials Location
- **Production:** Stored in Railway environment variable `FIREBASE_SERVICE_ACCOUNT`
- **Local Development:** File at `moa-backend/firebase-service-account.json`

### Where to Find Credentials
- **Firebase Console:** https://console.firebase.google.com
  - Project Settings → Service Accounts → Generate New Private Key
- **Railway Variables:** Railway Dashboard → Your Service → Variables tab

---

## Maintenance & Monitoring

### Check Backend Status
Visit: `https://likelionmoa-production.up.railway.app/health`
- Should return: `{"status":"ok"}`

### View Logs
1. Go to Railway Dashboard
2. Click on your service
3. Click "Deployments" tab
4. Click latest deployment
5. View logs in real-time

### Monitor Database
1. Go to Firebase Console
2. Click "Firestore Database"
3. View collections:
   - `users` - User accounts
   - `activities` - All activities

### Railway Free Tier Limits
- Watch your usage in Railway dashboard
- Free tier may have bandwidth/usage limits
- Service may sleep after inactivity (first request wakes it up)

---

## Troubleshooting

### App Shows "Server Error"
1. Check Railway deployment status (should be "Active")
2. Test health endpoint: `https://likelionmoa-production.up.railway.app/health`
3. Check Railway logs for errors
4. Verify environment variables are set (JWT_SECRET, FIREBASE_SERVICE_ACCOUNT)

### Login Not Working
1. Check Railway logs for error messages
2. Verify JWT_SECRET environment variable is set
3. Ensure Firebase credentials are valid
4. Check if user exists in Firestore database

### Activities Not Showing
1. Check Firebase Firestore console
2. Verify `activities` collection exists and has data
3. Check iOS app logs in Xcode console
4. Ensure Firebase listeners are active (check `FirebaseService.swift`)

### Real-Time Updates Not Working
1. Verify Firebase listeners are started in view's `onAppear`
2. Check Firestore security rules
3. Ensure `GoogleService-Info.plist` is in Xcode project
4. Check Firebase initialization in `MOAApp.swift`

---

## Development Workflow

### Making Backend Changes

1. **Edit code locally:**
   ```bash
   cd /Users/yunho/Desktop/likelion/moa-backend
   # Edit server.js or other files
   ```

2. **Test locally:**
   ```bash
   node server.js
   # Test at http://localhost:3000
   ```

3. **Deploy to Railway:**
   ```bash
   git add .
   git commit -m "Your commit message"
   git push
   # Railway automatically deploys from GitHub
   ```

### Making iOS Changes

1. **Edit in Xcode**
2. **Build & Run (⌘R)**
3. **Test on device**
4. **Commit changes:**
   ```bash
   git add .
   git commit -m "Your commit message"
   git push
   ```

---

## Security Notes

### Credentials Security
- ✅ `firebase-service-account.json` is in `.gitignore` (not committed to GitHub)
- ✅ Firebase credentials stored as Railway environment variable
- ✅ Passwords hashed with bcrypt (12 rounds)
- ✅ JWT tokens for authentication (7-day expiration)

### To Improve Security (Future)
- [ ] Use stronger JWT_SECRET (generate random 256-bit key)
- [ ] Add rate limiting to prevent brute force attacks
- [ ] Implement refresh tokens
- [ ] Add input validation and sanitization
- [ ] Configure Firestore security rules
- [ ] Enable HTTPS only (already done with Railway)
- [ ] Add request logging and monitoring

---

## Next Steps & Future Improvements

### Immediate Tasks
- [ ] Test app with multiple users simultaneously
- [ ] Monitor Railway usage and costs
- [ ] Set up alerts for backend errors

### Feature Enhancements
- [ ] Add user profile pictures (Firebase Storage)
- [ ] Implement push notifications
- [ ] Add chat/messaging feature
- [ ] Activity ratings and reviews
- [ ] Search and filter improvements
- [ ] Activity categories expansion

### Technical Improvements
- [ ] Add backend error monitoring (e.g., Sentry)
- [ ] Implement caching for better performance
- [ ] Add API rate limiting
- [ ] Set up CI/CD pipeline
- [ ] Add automated testing
- [ ] Database backup strategy

---

## Key Learnings

### SQLite → Firebase Migration
- Firestore Timestamps need special handling (`.toDate()` method)
- Environment variables crucial for production deployments
- Real-time listeners provide better UX than polling

### Railway Deployment
- Root directory configuration essential for monorepos
- Environment variables must be set before deployment works
- Railway auto-assigns PORT (8080), different from local (3000)
- Domain provisioning can take 30-60 seconds

### iOS Development
- SwiftUI + Firebase integration requires proper initialization
- Real-time listeners improve user experience significantly
- HTTPS required for production (Railway provides this)

---

## Support & Resources

### Documentation
- Firebase Firestore: https://firebase.google.com/docs/firestore
- Railway Docs: https://docs.railway.app
- Express.js: https://expressjs.com

### Contact
- GitHub Issues: https://github.com/yunhoc13/LIKELION_MOA/issues

---

## Summary

✅ **Backend:** Successfully deployed to Railway
✅ **Database:** Migrated to Firebase Firestore
✅ **iOS App:** Updated to use cloud backend
✅ **Testing:** Verified on WiFi and cellular data
✅ **Production URL:** https://likelionmoa-production.up.railway.app

**The MOA app is now a fully cloud-connected application accessible from anywhere!**

---

*Last Updated: March 22, 2026*
