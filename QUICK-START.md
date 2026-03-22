# MOA App - Quick Start Guide

**Use this guide every time you want to work on your app!**

---

## Working on iOS App (Most Common)

### What You Need
✅ Your Mac
✅ Your iPhone (connected via cable or on same WiFi)
✅ Xcode
✅ Internet connection

### Steps

1. **Open Xcode:**
   - Navigate to `/Users/yunho/Desktop/likelion/`
   - Double-click `likelion.xcodeproj`

2. **Select Your Device:**
   - At the top of Xcode, click the device dropdown
   - Select your iPhone from the list

3. **Build & Run:**
   - Press `⌘R` (Command + R)
   - OR click the Play button ▶️ at top left
   - Wait for the app to install on your phone

4. **Test Your App:**
   - App will launch automatically
   - Login with your account
   - Everything works from cloud - no need to run local server!

### That's It! 🎉
Your backend is running 24/7 on Railway, so you don't need to do anything else.

---

## Checking If Backend Is Running

### Quick Health Check
Open Safari and go to:
```
https://likelionmoa-production.up.railway.app/health
```

**Should see:** `{"status":"ok"}`

If you see this, your backend is running fine!

---

## Monitoring & Management Websites

### 1. Railway Dashboard (Backend Hosting)
**URL:** https://railway.app

**When to open:**
- Check if backend is running
- View server logs
- Monitor usage/costs
- Change environment variables

**How to use:**
1. Log in to Railway
2. Click on your project
3. Click on your service
4. Click "Deployments" to see logs
5. Click "Variables" to manage environment variables

### 2. Firebase Console (Database)
**URL:** https://console.firebase.google.com

**When to open:**
- View/edit database data
- Check user accounts
- See activities
- Monitor database usage

**How to use:**
1. Log in to Firebase
2. Click "meet-on-app" project
3. Click "Firestore Database" in left menu
4. Browse collections:
   - `users` - All user accounts
   - `activities` - All activities

### 3. GitHub (Code Repository)
**URL:** https://github.com/yunhoc13/LIKELION_MOA

**When to open:**
- View your code online
- Check commit history
- Share code with others

---

## Making Changes to iOS App

### 1. Open Xcode
- Open `likelion.xcodeproj`

### 2. Make Your Changes
- Edit Swift files
- Modify UI
- Add features

### 3. Test
- Build & Run (⌘R)
- Test on your phone

### 4. Commit Changes
Open Terminal and run:
```bash
cd /Users/yunho/Desktop/likelion
git add .
git commit -m "Describe what you changed"
git push
```

---

## Making Changes to Backend

### Option A: Test Locally First (Recommended)

#### 1. Open Terminal
```bash
cd /Users/yunho/Desktop/likelion/moa-backend
```

#### 2. Start Local Server
```bash
node server.js
```

**You should see:**
```
Checking Firebase credentials...
FIREBASE_SERVICE_ACCOUNT exists: false
Using Firebase credentials from local file
Firebase Firestore connected successfully
Server running on port 3000
```

#### 3. Update iOS App to Use Local Server
In Xcode, edit `APIService.swift` line 5:
```swift
private let baseURL = "http://10.0.0.112:3000"  // Your Mac's IP
```

#### 4. Test Your Changes
- Run iOS app
- Test the changes
- Check Terminal for server logs

#### 5. Switch Back to Production
In `APIService.swift`:
```swift
private let baseURL = "https://likelionmoa-production.up.railway.app"
```

#### 6. Deploy to Railway
```bash
cd /Users/yunho/Desktop/likelion
git add .
git commit -m "Describe your backend changes"
git push
```

Railway will automatically deploy your changes!

### Option B: Deploy Directly (Quick Changes)

1. Edit backend files
2. Commit and push:
```bash
cd /Users/yunho/Desktop/likelion
git add .
git commit -m "Your changes"
git push
```
3. Railway auto-deploys (check Railway Dashboard)
4. Test with iOS app

---

## Troubleshooting

### App Shows "Server Error"

**Check 1: Is Railway Running?**
- Go to https://railway.app
- Check deployment status
- Should say "Active" or "Running"

**Check 2: Test Health Endpoint**
- Go to https://likelionmoa-production.up.railway.app/health
- Should see: `{"status":"ok"}`

**Check 3: View Logs**
- Railway Dashboard → Deployments → Latest → Logs
- Look for errors

**Fix:**
- If deployment crashed, check logs for error
- If needed, redeploy from Railway Dashboard

### Can't Build in Xcode

**Check 1: Clean Build Folder**
- In Xcode: Product → Clean Build Folder (⇧⌘K)
- Then build again (⌘R)

**Check 2: Restart Xcode**
- Quit Xcode completely
- Open again

### Phone Not Showing in Xcode

**Fix:**
- Unplug and replug cable
- Trust computer on iPhone if prompted
- Check cable is not damaged

### Firebase Connection Issues

**Check:**
- Internet connection working?
- Firebase Console: https://console.firebase.google.com
- Check if project still exists

---

## Daily Development Workflow

### Morning / Starting Work

1. ✅ Open Xcode (`likelion.xcodeproj`)
2. ✅ Plug in iPhone (or ensure on same WiFi)
3. ✅ Check Railway is running (optional): https://railway.app
4. ✅ Build & Run (⌘R)

### During Development

1. Make changes in Xcode
2. Build & Run to test (⌘R)
3. Check Firebase Console if working with data
4. Check Railway logs if debugging backend issues

### Ending Work / Committing Changes

1. Git commit your changes:
```bash
cd /Users/yunho/Desktop/likelion
git add .
git commit -m "What you worked on today"
git push
```

2. Close Xcode
3. Done! Backend keeps running on Railway 24/7

---

## Important URLs - Bookmark These!

### Development
- **Xcode Project:** `/Users/yunho/Desktop/likelion/likelion.xcodeproj`

### Production
- **Backend API:** https://likelionmoa-production.up.railway.app
- **Health Check:** https://likelionmoa-production.up.railway.app/health

### Management Dashboards
- **Railway:** https://railway.app
- **Firebase:** https://console.firebase.google.com
- **GitHub:** https://github.com/yunhoc13/LIKELION_MOA

### Documentation
- **Deployment Guide:** `/Users/yunho/Desktop/likelion/DEPLOYMENT-GUIDE.md`
- **Project Status:** `/Users/yunho/Desktop/likelion/PROJECT-STATUS.md`
- **This Quick Start:** `/Users/yunho/Desktop/likelion/QUICK-START.md`

---

## Common Commands

### Start Local Backend (for testing)
```bash
cd /Users/yunho/Desktop/likelion/moa-backend
node server.js
```

### Commit Code Changes
```bash
cd /Users/yunho/Desktop/likelion
git add .
git commit -m "Your message"
git push
```

### Check Git Status
```bash
cd /Users/yunho/Desktop/likelion
git status
```

### View Recent Commits
```bash
cd /Users/yunho/Desktop/likelion
git log --oneline -5
```

---

## Weekend/Long Break Checklist

### Before You Leave
- [ ] Commit all changes to GitHub
- [ ] Test app one final time
- [ ] Check Railway is running
- [ ] Note any issues in PROJECT-STATUS.md

### When You Return
- [ ] Pull latest changes: `git pull`
- [ ] Check Railway status: https://railway.app
- [ ] Test health endpoint
- [ ] Open Xcode and build

---

## Tips

✨ **You don't need to run a local server!** Your backend is always running on Railway.

✨ **Save often!** Commit your changes to GitHub regularly.

✨ **Test on real device!** Always test on your iPhone, not just simulator.

✨ **Check Railway logs** when debugging backend issues.

✨ **Use Firebase Console** to view/edit data directly.

✨ **Keep documentation updated!** Update PROJECT-STATUS.md as you make changes.

---

## Need Help?

1. Check DEPLOYMENT-GUIDE.md for detailed info
2. Check PROJECT-STATUS.md for current status
3. View Railway logs for backend errors
4. Check Xcode console for iOS errors
5. Look at Firebase Console for database issues

---

**Happy coding! 🚀**
