//
//  MOA_Product_Spec.md
//  likelion
//
//  Created by 최윤호 on 11/20/25.
//

1. Service Overview

Project name: MOA (Meet on App)
One-line intro: A local matching app that helps Boston-based Korean students quickly find people to eat, study, or do sports with nearby.

Concept

A local, lightweight activity-matching platform for Boston.

Focus:

Very simple categories and flows at first

Works well specifically for Boston-area Korean college students (BU, BC, Northeastern, MIT, Harvard, etc.)

2. Target Users & Use Cases

Primary target:

Korean students in Boston:

Undergraduates, graduates, exchange students

Secondary:

Korean young professionals near campuses (Allston, Cambridge, downtown, etc.)

Typical use cases:

“I want someone to eat lunch with near BU in the next hour.”

“I want to find 3–4 people to play basketball at FitRec tonight.”

“I need a study group for CS/Math/GRE preparation this weekend.”

“I just want to grab coffee and talk in Korean near Harvard Square.”

3. Core Product Goals

Location-based real-time meetups

Show nearby activities based on current location and time.

Everyday, low-pressure activities

Focus on study, meals, sports, and light socializing (etc.).

Local partnerships for revenue

Promote Boston-area restaurants, cafés, gyms, etc. through in-app banners and offers.

Campus + local hybrid community

Encourage interaction across students, alumni, and local workers.

4. Navigation & Information Architecture
4.1 Main Screens / Tabs

Logo / Splash Screen

Login / Signup / Forgot Password / Reset Password

New User Profile Setup (optional onboarding)

Home Tab (default after login)

Category Tab

Calendar Tab

Profile Tab

(Later: Chat / Group DM details can be implemented in separate screens)

4.2 Bottom Navigation (always visible after login)

Home

Default tab after login.

Shows highlighted/popular activities + quick category overview.

Categories

Shows buttons for each main category:

Study

Meal Buddy

Sports

Others (e.g., Cafe chat / misc.)

Calendar

Monthly/weekly view of activities by date.

User can see:

Activities they created

Activities they joined

Optionally, browse all activities by date.

Profile

Basic user information & settings.

Safety / verification options.

Account management (logout, delete account, etc. later).

5. User Flows (High Level)
5.1 Authentication & Onboarding

First-time user

Open app → Logo/Splash

Navigate to Login page

Tap “Sign Up” → open Sign Up page

Fill in email (.edu or general), password, name, university, etc.

Agree to terms → submit

After successful signup → redirect back to Login page

User enters credentials → Login

On first login, show Basic Profile Setup:

Profile photo (optional)

Nickname / display name

University, major, graduation year

Basic intro

Finish setup → redirect to Home

Returning user

Open app → Logo/Splash

Redirect to Login (if no active session)

Enter ID & password → Home

Forgot password

On Login page → tap “Forgot password?”

Enter email → receive reset instructions (email flow or in-app verification)

Set new password → redirect back to Login → then Home.

5.2 Home Tab Flow

Home screen (after login):

Top area:

Small category chips (horizontal selector aligned in the middle):

Study | Meal Buddy | Sports | Others

User can tap these to filter the main list if needed.

Main content area (center):

A feed of popular / recommended activities in s squared with related picture or image.

At least 4 popular posts always visible by default.

Card layout for each activity:

Title

Category

Short description

Time (start time / date)

Location (short text; later map pin)

Number of people joined vs capacity

“Join” or “View details” button.

Bottom navigation: as defined above.

Interaction:

Tap on an activity card → Activity Detail page:

Full description

Host profile

Participant list or count

“Join” / “Cancel join” button

Category-specific options (see section 6).

Tap category chips on top → filter feed (e.g., only Study activities).

5.3 Category Tab Flow

Category Tab screen:

Simple layout with 4 large buttons / cards, one per category:

Study

Meal Buddy

Sports

Others (Cafe talk & misc.)

Tapping a category leads to:

Category Activity List:

List of upcoming activities under that category.

Option: Filter by date/time, distance, school, etc.


5.4 Calendar Tab Flow

Calendar screen:

Default view: Monthly calendar.

Mark dates where the user has:

Created an activity

Joined an activity.

Tapping a date:

Shows a list of activities on that day:

Time

Category

Title

Location

Tapping an item → Activity Detail.

Optional future behavior:

Toggle:

“My activities only”

“All nearby activities on this date”

5.5 Profile Tab Flow

Profile screen:

Shows:

Profile photo (optional)

Name / nickname

University and department

Short bio / introduction

Basic stats (e.g., number of activities joined, badges).

Sections:

Account information

Email (read-only)

School (editable)

Graduation year (optional)

Verification

Email verification status (.edu or not)

Social account linking (Instagram, LinkedIn, etc.)

App settings

Notification preferences

Language (currently Korean/English toggle – optional)

Safety and community

View and manage blocked users

Report history (if any)

Logout / Delete account

6. Category & Activity Specifications
6.1 Common Activity Model (all categories)

Base fields:

id

category (Study | MealBuddy | Sports | Others)

title

description

hostUserId

locationName (string)

locationLat, locationLng (for map)

startDateTime

endDateTime (optional)

isInstant (boolean; “join now” vs scheduled)

maxParticipants

currentParticipants

status (open | full | finished | cancelled)

createdAt

updatedAt

Join / Participation:

participants: list of user IDs

Optional: requirements (e.g., “bring laptop”, “beginner welcome”)

6.2 Category: Meal Buddy (🍚 Meal Friends)

Goal: Find people to eat together (lunch/dinner).

Special fields / behavior:

Location

Use Google Maps to suggest nearby restaurants automatically.

Host chooses from suggested list or enters custom location.

Time slots

Simplified presets:

Lunch (e.g., 11:00–14:00)

Dinner (e.g., 17:00–20:00)

Host picks a specific start time within these ranges.

Group size

minParticipants: 2

maxParticipants: 2–6 (selectable)

Filters (for recommendation & joining)

Optional:

Preferred language (Korean/English)

Same university only (toggle)

Gender preference (optional; needs careful design for fairness/safety)

Partnership / Ads

If restaurant is a partner location:

Show a small banner inside the Activity Detail:

Example: “10% OFF at [Restaurant] for MOA users.”

Later: this can be part of revenue model.

6.3 Category: Sports (⚽ Sports)

Goal: Help users form small sports groups (basketball, futsal, jogging, etc.).

Special fields / behavior:

Sport type

Options: Basketball, Futsal, Jogging, Yoga, Gym, etc.

Additional free-text field for “Other” sport names.

Location

Examples: Charles River Esplanade, BU FitRec, MIT Gym, local parks.

Select from map / search.

Team size & auto-matching

Host sets:

maxParticipants (e.g., 10 for basketball)

Once the number of participants reaches maxParticipants:

Status becomes “full”.

Show “Matched” / “Game confirmed” in UI.

Optionally automatically create a group chat room.

Equipment

Boolean field: equipmentProvided (true/false).

If partnership with sports shop:

Show link or banner to equipment rental/discount page.

6.4 Category: Study (📚 Study)

Goal: Match students for study sessions and exam prep.

Special fields / behavior:

Topic / subject

Free text: e.g.,

“CS330 Algorithms midterm prep”

“GRE Quant practice”

“TOEFL Speaking”

“Statistics final review”

Filters

University (BU, BC, MIT, etc.)

Course code (optional)

Time window (morning/afternoon/evening)

Location type (library, café, online meeting).

Recurring schedule

Option to set repeating events:

Weekly (e.g., every Wednesday at 7pm)

Monthly

Store fields:

isRecurring (boolean)

recurrenceType (weekly/monthly)

recurrenceEndDate

Resource sharing

Allow host to attach:

Google Docs link

Notion page URL

These links appear in the Activity Detail and maybe within the chat later.

6.5 Category: Others / Cafe Talk (☕ Community)

Goal: For all non-study, non-sports, non-meal activities – especially light socializing.

Examples:

“Coffee chat in Korean”

“Language exchange EN–KO”

“Walk along Charles River”

“Board game night”

Fields:

Same as common activity model.

subtype field (e.g., cafe chat, language exchange, etc.)

7. Home Tab – Design & Behavior

Header:

App name/logo

Category chips: Study | Meal Buddy | Sports | Others

Main feed content:

Default sort:

Popular and/or soonest activities near user’s current location.

Each card shows:

Category badge

Title

Short description (1–2 lines)

Time (date + time)

Location (short)

Participant count (e.g., “3 / 6 joined”)

Join/View button.

Interactions:

Pull-to-refresh for latest activities.

Filter by category via top chips.

Optional search icon for keyword search in a later version.

8. Safety, Verification, and Community Management
8.1 User Verification

Email verification

Accept both .edu email and general email.

Mark .edu users as “Student verified” (e.g., badge icon).

Profile verification

Optional linking to:

Instagram

LinkedIn

Show small social icons on Profile and Activity Detail (if user chooses to display them).

8.2 Community Safety Features

Report system

Users can report:

Inappropriate behavior

No-shows

Harassment, etc.

Fields: reason, description, optional screenshot.

Review / rating

After an activity ends:

Participants can rate (e.g., 1–5 stars) and leave comments.

Host rating and participant rating can be aggregated into trust scores.

Visibility of location

Exact location details (precise map pin) can be:

Visible only to participants, not to everyone in the app.

Before joining:

Show only general area (e.g., “Near BU West Campus”).

Block / mute

Users can block others.

Blocked users cannot join each other’s activities or send messages.

9. Chat & Communication (High-Level)

(Can be implemented with Firebase or similar later.)

When a user joins an activity:

Automatically create or join a group chat for that activity.

Chat features:

Text messages

Basic system messages (e.g., “Yunho joined this activity”)

In Activity Detail:

“Open chat” button once user is a participant.

10. Future AI-Focused Features (Direction Only)

(For later versions; not required for v0.1 but good context for Claude.)

Smart suggestions:

Recommend activities based on:

User’s university, schedule, previous participation.

Auto-fill activity forms:

Suggest title/description templates based on category & time.

Safety AI:

Automatically detect inappropriate language in activity descriptions or chat.

11. Summary of v0.1 Scope

For the first implementation, MOA should focus on:

Authentication

Login, Signup, Forgot Password, basic profile setup.

Core navigation

Bottom tabs: Home, Categories, Calendar, Profile.

Activities

Activity model shared across 4 categories.

Create, list, view detail, join/unjoin.

Basic UI

Home feed with 4 popular activities.

Category selector + simple filtering.

Profile & Safety (Minimum)

Email verification status.

Basic profile editing.

Simple report button (even if backend logic is minimal at first).
