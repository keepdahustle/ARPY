# DIAGRAM NAVIGASI APLIKASI ARPY (SIMPLIFIED VIEW)

## 1. STRUKTUR NAVIGASI UTAMA

```
┌─────────────────────────────────────────┐
│          LOGIN SCREEN                   │
│  Email & Password Authentication        │
│  (atau Register jika akun baru)         │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│      MAIN NAVIGATION HUB                │
│  ┌──────────────────────────────────┐  │
│  │  [Home] [Tasks] [Help] [Profile] │  │
│  └──────────────────────────────────┘  │
│         Bottom Navigation Bar           │
└──────────┬──────────────────────────────┘
           │
    ┌──────┴──────┬──────────┬──────────┐
    │             │          │          │
    ▼             ▼          ▼          ▼
  HOME         TASKS       HELP      PROFILE
```

---

## 2. HOME FLOW (Learning Materials)

```
┌─────────────────────────────────────┐
│       HOME SCREEN                   │
│  Display 4 Materials:               │
│  • Integer  • Float                 │
│  • String   • Set                   │
└─────────────┬───────────────────────┘
              │
         Click Material
              │
              ▼
┌──────────────────────────────┐
│   AR SCAN SCREEN             │
│  (Camera Preview + Buttons)  │
│                              │
│  Detection Status:           │
│  ○ Scanning... (amber)       │
│  ● Card Detected (green)     │
└──────────────┬───────────────┘
               │
      Card Detected ✓
               │
               ▼
┌──────────────────────────────┐
│   AR RESULT SCREEN           │
│  • 3D Model Viewer           │
│  • Rotation Slider           │
│  • Material Description      │
│  • Buttons: Details / AR / ..│
└──────────────────────────────┘
              │
              ├─→ Material Detail Screen
              ├─→ Back to AR Scan
              └─→ Home Screen
```

---

## 3. TASKS FLOW (Learning & Projects)

```
┌──────────────────────────────┐
│      TASKS SCREEN            │
│  Progress Summary:           │
│  • Quizzes Completed: X      │
│  • Projects Submitted: Y     │
│  • Total Points: Z           │
└──────────┬───────────────────┘
           │
      ┌────┴────┐
      │          │
      ▼          ▼
   QUIZ      PROJECTS
   │              │
   ▼              ▼
┌─────────┐   ┌──────────┐
│Materials│   │ Projects │
│ List    │   │  List    │
└────┬────┘   └────┬─────┘
     │             │
     ▼             ▼
┌─────────────┐ ┌──────────────┐
│ Quiz Screen │ │Project Detail│
│  (5 Q's)    │ │  (Submit)    │
└────┬────────┘ └──────────────┘
     │
     ▼
┌──────────────┐
│Quiz Result   │
│Score: X/5    │
│Pass/Fail     │
└──────────────┘
```

---

## 4. HELP FLOW (FAQ)

```
┌──────────────────────────┐
│    HELP SCREEN           │
│  FAQ (Expandable)        │
│                          │
│  ▶ Q: How to use?        │
│  ▶ Q: How to submit?     │
│  ▶ Q: How to logout?     │
│  ▶ Q: Reset password?    │
└──────────────────────────┘
         │
    Click to Expand
         │
         ▼
    Show Answer
    (Collapse)
```

---

## 5. PROFILE FLOW (User Management)

```
┌───────────────────────────────┐
│    PROFILE SCREEN             │
│  ┌─────────────────────────┐  │
│  │ User Info:              │  │
│  │ • Username              │  │
│  │ • School                │  │
│  │ • Total Points          │  │
│  │ • Achievements          │  │
│  └─────────────────────────┘  │
└───────┬───────────────────────┘
        │
    ┌───┴────┬──────────┬──────────┐
    │         │          │          │
    ▼         ▼          ▼          ▼
  EDIT   CERTIFICATE  ACHIEVEMENTS LOGOUT
  │         │           │          │
  ▼         ▼           ▼          ▼
UPDATE    DOWNLOAD    VIEW      CONFIRM
PROFILE   PDF         BADGES    LOGOUT
  │                              │
  └──────────┬──────────────────┘
             │
             ▼
      Back to Main Nav
      (or Login Screen
       if Logout)
```

---

## 6. DATA PERSISTENCE LAYERS

```
┌──────────────────────────────────────┐
│   LOCAL STORAGE (SharedPreferences)  │
│                                      │
│  ├─ Accounts Database                │
│  │  └─ {email, password, name, ...}  │
│  │                                   │
│  ├─ Current User Session             │
│  │  └─ {email, username, school, ...}│
│  │                                   │
│  ├─ Quiz Results                     │
│  │  └─ {material, score, date, ...}  │
│  │                                   │
│  ├─ Project Progress                 │
│  │  └─ {name, status, submission}    │
│  │                                   │
│  └─ User Statistics                  │
│     └─ {total_points, badges, ...}   │
└──────────────────────────────────────┘
```

---

## 7. SCREEN HIERARCHY & RELATIONSHIPS

```
                    LoginScreen
                         │
                         ▼
                  MainNavigation
                  /   │   │   \
                 /    │   │    \
              Home  Tasks Help Profile
               │      │    │      │
              ├─►AR  ├─►Quiz     ├─►Edit
              │   Scan │  │      │
              │    │   │  │      ├─►Cert
              │    │   │  │      │
              │    ▼   ▼  │      ▼
              │   AR  Quiz Profile
              │  Result Result   Info
              │    │      │      
              ├─►Matl  Projects  
              │  Detail  ├─►Proj
              │         │ Detail
              └────────►────────┘
                       │
                Return to Main Nav
```

---

## 8. KEY STATES & TRANSITIONS

```
Application States:
┌─────────────┐
│ UNAUTHENTICATED
└──────┬──────┘
       │ Login Success
       ▼
┌─────────────┐
│ AUTHENTICATED
│ (Main Nav)
└──────┬──────┘
       │ Logout
       ▼
┌─────────────┐
│ UNAUTHENTICATED
│ (Login Screen)
└─────────────┘

Screen States:
- Loading (Loading initial data)
- Loaded (Data ready)
- Error (Error occurred)
- Idle (Waiting for user action)
```

---

## 9. MATERIAL COMPONENTS

### Learning Materials Structure:
```
Material = {
  name: "Integer",
  description: "Tipe data untuk bilangan bulat",
  model3D: "assets/3d/Integer.glb",
  quiz: {
    questions: 5,
    difficulty: "Easy"
  },
  project: {
    name: "Integer Program",
    description: "Buat program..."
  }
}
```

### Quiz Structure:
```
Quiz = {
  material: "Integer",
  questions: [
    {
      text: "Apa itu integer?",
      options: ["A", "B", "C", "D"],
      correct: 0
    },
    ...
  ],
  passingScore: 4  // 4 out of 5
}
```

---

## 10. COMPLETE USER JOURNEY EXAMPLE

```
START
  │
  ▼
Login Screen
(Email: user@example.com, Password: 123456)
  │
  ▼
Main Navigation [Home selected by default]
  │
  ▼
Home Screen - Material Cards Visible
  │
  ▼
Click "Integer" Material
  │
  ▼
AR Scan Screen - Camera Active
  │
  ▼ [Card detected after 3 seconds]
  │
  ▼
"Pelajari Materi" Button Activated (green)
  │
  ▼
Click "Pelajari Materi"
  │
  ▼
AR Result Screen - 3D Model Displayed
  │
  ├─▶ Click "Lihat Selengkapnya" → Material Detail
  │
  ├─▶ Click "Lihat Visualisasi AR" → AR Scan Screen (loop)
  │
  └─▶ Click Back → Home Screen
        │
        ▼
      Click Tasks Button
        │
        ▼
      Tasks Screen - Progress Summary
        │
        ├─▶ Quiz → Quiz Materials → Select Integer → Quiz Screen (5 Q)
        │         → Quiz Result Screen (Score: 4/5 - PASS)
        │         → Awards 10 points
        │
        └─▶ Projects → Project List → Select → Submit Project
                    → Save Submission
        │
        ▼
      Click Profile Button
        │
        ▼
      Profile Screen - User Stats (Points: 10, Badges: 1)
        │
        ├─▶ Edit Profile → Update Name/School → Save
        │
        ├─▶ Download Certificate → Generate PDF → Download
        │
        └─▶ Logout → Clear Data → Back to Login Screen

END
```

---

## NOTES
- Semua data disimpan secara lokal (SharedPreferences)
- Tidak ada koneksi internet yang diperlukan
- Each user session terisolasi per email
- Quiz scoring: Pass jika >= 4/5
- Material: Integer, Float, String, Set
- 3D Models menggunakan format GLB
