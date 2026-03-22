# MOA App - Project Status Tracker

**Project Name:** MOA (Meet on App)
**Last Updated:** March 22, 2026
**Status:** 🟢 Production - Deployed & Active

---

## Quick Links

- **Live App Backend:** https://likelionmoa-production.up.railway.app
- **Health Check:** https://likelionmoa-production.up.railway.app/health
- **Railway Dashboard:** https://railway.app
- **Firebase Console:** https://console.firebase.google.com
- **GitHub Repo:** https://github.com/yunhoc13/LIKELION_MOA

---

## Current Status

### Production Environment
- ✅ Backend deployed on Railway
- ✅ Database on Firebase Firestore
- ✅ iOS app configured for cloud backend
- ✅ Tested on WiFi and cellular data
- ✅ Real-time synchronization working

### Active Features
- ✅ User authentication (signup/login)
- ✅ Create activities
- ✅ Join activities
- ✅ Leave activities (with 1-hour restriction)
- ✅ View activities by category
- ✅ My Events (created & joined)
- ✅ Real-time updates across devices
- ✅ Calendar view
- ✅ Location-based activities

---

## System Architecture

```
┌─────────────────┐
│   iOS App       │
│   (SwiftUI)     │
└────────┬────────┘
         │ HTTPS
         ↓
┌─────────────────┐
│   Railway       │
│   Backend       │
│   (Node.js)     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Firebase      │
│   Firestore     │
└─────────────────┘
```

---

## Database Schema

### Users Collection
```javascript
{
  id: String,
  email: String,
  password_hash: String,
  name: String,
  university: String,
  major: String | null,
  graduation_year: String | null,
  bio: String | null,
  profile_picture_url: String | null,
  created_at: Timestamp,
  updated_at: Timestamp
}
```

### Activities Collection
```javascript
{
  id: String,
  title: String,
  category: String,
  description: String,
  hostUserId: String,
  hostName: String,
  hostUniversity: String,
  locationName: String,
  locationLat: Number,
  locationLng: Number,
  startDateTime: Date,
  endDateTime: Date | null,
  isInstant: Boolean,
  maxParticipants: Number,
  currentParticipants: Number,
  status: String,
  participants: [String],
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

---

## Recent Changes

### March 22, 2026 - Cloud Deployment ✅
- Migrated from SQLite to Firebase Firestore
- Deployed backend to Railway
- Updated iOS app to use cloud URL
- Added real-time synchronization
- Cleaned up sample data

### Previous Sessions
- Leave activity feature with 1-hour restriction
- Real-time Firebase listeners
- Category-based filtering
- My Events view

---

## Known Issues

### None Currently 🎉

---

## Upcoming Tasks

### High Priority
- [ ] Monitor Railway usage and costs
- [ ] Test with multiple simultaneous users
- [ ] Set up error monitoring/alerting

### Medium Priority
- [ ] Improve error handling and user feedback
- [ ] Add loading states for better UX
- [ ] Implement activity search functionality
- [ ] Add user profile editing

### Low Priority / Future Features
- [ ] Push notifications for activity updates
- [ ] User profile pictures
- [ ] Activity chat/messaging
- [ ] Activity ratings and reviews
- [ ] Enhanced location features (map view)
- [ ] Activity categories expansion
- [ ] Social features (friends, followers)

---

## Development Environment

### Local Setup
```bash
# Backend
cd /Users/yunho/Desktop/likelion/moa-backend
node server.js

# iOS App
# Open likelion.xcodeproj in Xcode
# Build & Run (⌘R)
```

### Environment Variables (Local)
Located in: `/Users/yunho/Desktop/likelion/moa-backend/.env`
```
JWT_SECRET=test_secret_key_12345
PORT=3000
```

### Environment Variables (Production)
Set in Railway Dashboard:
- `JWT_SECRET`
- `PORT`
- `FIREBASE_SERVICE_ACCOUNT`

---

## Testing Checklist

### Before Each Release
- [ ] Test signup with new user
- [ ] Test login with existing user
- [ ] Create new activity
- [ ] Join activity
- [ ] Leave activity
- [ ] Check My Events shows correct data
- [ ] Verify real-time sync works
- [ ] Test on WiFi
- [ ] Test on cellular data
- [ ] Check Firebase data is correct

---

## Performance Metrics

### Current Stats
- **Backend Response Time:** < 500ms (average)
- **Real-time Sync Latency:** < 1 second
- **Active Users:** TBD
- **Total Activities Created:** Check Firebase Console
- **Total Users:** Check Firebase Console

### Monitoring
- Railway Dashboard: https://railway.app
- Firebase Console: https://console.firebase.google.com

---

## Deployment History

| Date | Version | Changes | Status |
|------|---------|---------|--------|
| Mar 22, 2026 | v1.0 | Initial cloud deployment | ✅ Success |

---

## Team & Contacts

### Developer
- **Name:** Yunho
- **GitHub:** yunhoc13

### Resources
- **Documentation:** See DEPLOYMENT-GUIDE.md
- **Issues:** https://github.com/yunhoc13/LIKELION_MOA/issues

---

## Important Notes

### Railway
- Free tier has usage limits
- Service may sleep after inactivity
- Monitor usage in dashboard

### Firebase
- Currently in test mode (for development)
- Should configure security rules for production
- Monitor usage and quotas

### Security
- Firebase credentials stored as environment variable
- JWT tokens expire after 7 days
- Passwords hashed with bcrypt

---

## Quick Commands

### View Railway Logs
1. Go to Railway Dashboard
2. Click your service
3. Deployments → Latest → Logs

### Deploy New Version
```bash
git add .
git commit -m "Description of changes"
git push
# Railway auto-deploys from GitHub
```

### Check Firebase Data
1. Go to Firebase Console
2. Firestore Database
3. Browse collections

### Test Health Endpoint
```bash
curl https://likelionmoa-production.up.railway.app/health
```

---

## Backup & Recovery

### Database Backup
- Firebase Firestore has automatic backups
- Manual export available in Firebase Console
- Consider scheduling regular exports

### Code Backup
- ✅ Stored on GitHub
- Branch: `main`
- Keep commits regular and descriptive

---

## Version History

### v1.0 (Current) - March 22, 2026
- Cloud deployment complete
- Firebase Firestore integration
- Real-time synchronization
- Full authentication system
- Activity management (create, join, leave)

---

*Keep this file updated as the project evolves!*
