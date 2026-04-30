# 📚 ARPY - Augmented Reality for Python Learning

> **Aplikasi Edukasi Pemrograman Python dengan Teknologi Augmented Reality & 3D Model Viewer**

![Platform](https://img.shields.io/badge/Platform-Flutter-blue?style=flat-square)
![Language](https://img.shields.io/badge/Language-Dart-blue?style=flat-square)
![Min SDK](https://img.shields.io/badge/Min%20SDK-Android%2021%2B-brightgreen?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## 📖 Daftar Isi

- [Tentang Project](#tentang-project)
- [Fitur Utama](#fitur-utama)
- [Arsitektur Project](#arsitektur-project)
- [Teknologi & Dependensi](#teknologi--dependensi)
- [Setup & Instalasi](#setup--instalasi)
- [Struktur Folder](#struktur-folder)
- [Panduan Penggunaan](#panduan-penggunaan)
- [Alur Aplikasi](#alur-aplikasi)
- [Data Persistence](#data-persistence)
- [Sistem Penilaian Quiz](#sistem-penilaian-quiz)
- [Troubleshooting](#troubleshooting)
- [Kontribusi](#kontribusi)

---

## 🎯 Tentang Project

**ARPY (Augmented Reality for Python)** adalah aplikasi mobile pendidikan yang dirancang untuk memudahkan pembelajaran pemrograman Python melalui pengalaman interaktif. Aplikasi ini menggabungkan konsep pembelajaran tradisional dengan teknologi 3D visualization dan Augmented Reality untuk meningkatkan engagement siswa.

### Visi & Misi

- **Visi**: Membuat pembelajaran pemrograman Python lebih menarik dan interaktif melalui teknologi AR/3D
- **Misi**: Menyediakan platform pembelajaran yang user-friendly dengan fitur tracking progress, kuis interaktif, dan visualisasi 3D

### Target Pengguna

- Siswa SMA/SMK yang belajar pemrograman Python
- Peserta bootcamp/kursus pemrograman
- Educator/Guru yang mengajar Python

---

## ✨ Fitur Utama

### 1. **🔐 Sistem Autentikasi**

- Login dengan Email & Password
- Registrasi akun baru dengan validasi data
- Persistent login status menggunakan SharedPreferences
- Session management yang aman

### 2. **📚 Pembelajaran Materi Python**

- 6 tipe data Python fundamental:
  - **Integer** - Bilangan bulat
  - **Float** - Bilangan desimal
  - **String** - Teks/karakter
  - **Boolean** - Nilai True/False
  - **Set** - Kumpulan nilai unik
  - **Dictionary** - Pasangan key-value
- Deskripsi lengkap setiap materi
- Visual cards dengan icon yang menarik

### 3. **🎬 3D Model Viewer (AR Scan)**

- Tampilkan model 3D dalam format GLB
- Interactive 3D viewer dengan rotasi manual
- Slider untuk mengontrol rotasi objek
- Preview sebelum pembelajaran detail
- **Note**: ARCore native plugin telah dihapus, menggunakan model_viewer_plus

### 4. **📝 Sistem Quiz Interaktif**

- Quiz per material (5 soal per material)
- Multiple choice questions dengan feedback
- Sistem scoring otomatis (0-5)
- Pass threshold: 4/5 soal benar
- Points reward untuk setiap quiz lulus
- History tracking untuk setiap attempt
- Opsi retry unlimited

### 5. **📊 Progress Tracking & Statistics**

- Dashboard progress dengan:
  - Total poin yang dikumpulkan
  - Jumlah quiz yang lulus
  - Jumlah projects yang selesai
  - Persentase completion
- Visual progress cards
- Statistics per material

### 6. **💼 Project Management**

- Daftar projects untuk praktek
- Submission projects dari user
- Tracking status project (pending/submitted)
- Simple project detail view

### 7. **❓ FAQ & Help Center**

- Daftar pertanyaan yang sering diajukan
- Expandable FAQ items
- Kategori help yang terorganisir
- Tips & tricks untuk menggunakan app

### 8. **👤 User Profile Management**

- View & edit profil user
- Tampilkan sekolah/institusi
- Points & achievement tracking
- Certificate generation (PDF export)
- Logout functionality

---

## 🏗️ Arsitektur Project

### **Architecture Pattern: Multi-Screen Navigation**

```
┌─────────────────────────────────────────┐
│           MainNavigation Hub             │
│  (Bottom Navigation + FAB untuk AR)      │
├─────────────────────────────────────────┤
│  Home  │  Tasks  │  FAB (AR)  │  Help   │
│        │         │            │  Profile│
└─────────────────────────────────────────┘
         ↓         ↓         ↓          ↓
    ┌────────┐ ┌───────┐ ┌──────┐ ┌──────┐
    │  Home  │ │ Tasks │ │ Help │ │Profile│
    │ Screen │ │Screen │ │Screen│ │Screen │
    └────────┘ └───────┘ └──────┘ └──────┘
       ↓          ↓↓
   ┌─────────┐ ┌──────────┐ ┌──────────┐
   │AR Scan  │ │Quiz      │ │Projects  │
   │Screen   │ │Materials │ │Screen    │
   └─────────┘ └──────────┘ └──────────┘
```

### **Separation of Concerns**

- **Screens**: UI components untuk setiap halaman
- **Models**: Data structures (QuizQuestion, PythonMaterial)
- **Utils**: Helper functions & storage service
- **Widgets**: Reusable UI components

---

## 💻 Teknologi & Dependensi

### **Framework & Language**

- **Flutter 3.0+** - Cross-platform mobile framework
- **Dart 3.0+** - Programming language untuk Flutter
- **Material Design 3** - Modern UI design system

### **Key Dependencies**

| Package              | Version  | Fungsi                  |
| -------------------- | -------- | ----------------------- |
| `google_fonts`       | ^6.1.0   | Custom fonts (Poppins)  |
| `camera`             | ^0.10.5  | Camera access & preview |
| `permission_handler` | ^12.0.1  | Handle permissions      |
| `model_viewer_plus`  | ^1.9.3   | 3D GLB viewer           |
| `shared_preferences` | ^2.5.4   | Local data storage      |
| `printing`           | ^5.10.4  | PDF print functionality |
| `pdf`                | ^3.11.0  | PDF generation          |
| `file_picker`        | ^10.3.10 | File selection          |
| `intl`               | ^0.19.0  | Internationalization    |
| `provider`           | ^6.0.0   | State management        |
| `url_launcher`       | ^6.1.10  | Open URLs/links         |

### **Platform Requirements**

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Supported dengan limitations

### **ARCore Status**

⚠️ **ARCore native framework telah dihapus** dari project ini. Diganti dengan:

- `model_viewer_plus` untuk 3D visualization
- Camera preview sederhana untuk "AR Scan" UX
- Local model files dalam format GLB

---

## 🚀 Setup & Instalasi

### **Prerequisites**

- Flutter SDK 3.0+
- Android SDK (untuk development Android)
- Visual Studio Code atau Android Studio
- Git

### **Langkah Instalasi**

#### 1. Clone Repository

```bash
git clone <repository-url>
cd ARPY
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Configure Android (Optional)

```bash
cd android
# Update build.gradle.kts jika perlu
cd ..
```

#### 4. Run Application

```bash
# Development (debug mode)
flutter run

# Release mode
flutter run --release

# Spesifik device
flutter run -d <device-id>
```

#### 5. Build APK/AAB (Optional)

```bash
# Build APK
flutter build apk

# Build App Bundle (untuk Google Play)
flutter build appbundle
```

---

## 📁 Struktur Folder

```
ARPY/
├── lib/
│   ├── main.dart                          # Entry point aplikasi
│   ├── models/
│   │   ├── quiz_question.dart            # QuizQuestion & PythonMaterial model
│   │   └── project_model.dart            # Project model
│   ├── screens/                           # 18 Screen implementations
│   │   ├── login_screen.dart             # Authentication
│   │   ├── register_screen.dart          # User registration
│   │   ├── main_navigation.dart          # Bottom navigation hub
│   │   ├── home_screen.dart              # Material display
│   │   ├── ar_scan_screen.dart           # AR camera preview
│   │   ├── ar_result_screen.dart         # 3D model viewer
│   │   ├── tasks_screen.dart             # Progress & menu
│   │   ├── quiz_materials_screen.dart    # Quiz material selection
│   │   ├── quiz_screen.dart              # Quiz questions
│   │   ├── quiz_result_screen.dart       # Quiz score display
│   │   ├── projects_screen.dart          # Projects list
│   │   ├── project_detail_screen.dart    # Project detail & submission
│   │   ├── material_detail_screen.dart   # Material description
│   │   ├── help_screen.dart              # FAQ
│   │   ├── profile_screen.dart           # User profile
│   │   ├── edit_profile_screen.dart      # Profile editor
│   │   ├── ar_core_screen.dart           # Placeholder (removed)
│   │   └── ar_core_ndk_screen.dart       # Placeholder (removed)
│   ├── utils/
│   │   ├── app_colors.dart               # Color constants
│   │   ├── app_animations.dart           # Animation utilities
│   │   ├── storage_service.dart          # SharedPreferences wrapper
│   │   └── app_themes.dart               # Theme configuration
│   └── widgets/                           # Reusable UI components
│       ├── custom_text_field.dart        # Form input
│       ├── error_card.dart               # Error display
│       ├── faq_item.dart                 # FAQ expandable item
│       ├── project_card.dart             # Project card widget
│       ├── quiz_card.dart                # Quiz progress card
│       ├── ar_card_widget.dart           # Material AR card
│       ├── scan_history_card.dart        # Scan history display
│       └── modern_dialog.dart            # Custom dialog
├── assets/
│   ├── images/                           # UI images & icons
│   ├── logos/                            # App logos
│   ├── ARCard/                           # AR card images
│   └── 3d/
│       ├── Integer.glb                   # 3D model untuk Integer
│       ├── Float.glb                     # 3D model untuk Float
│       ├── String.glb                    # 3D model untuk String
│       ├── Boolean.glb                   # 3D model untuk Boolean
│       ├── Set.glb                       # 3D model untuk Set
│       └── Dictionary.glb                # 3D model untuk Dictionary
├── android/                               # Android native code
│   ├── app/build.gradle.kts              # Dependencies
│   ├── settings.gradle.kts               # Project settings
│   └── gradle.properties
├── build/                                 # Build output (generated)
├── pubspec.yaml                          # Dependencies & assets
├── analysis_options.yaml                 # Linting rules
├── README.md                             # Project documentation
└── ARPY_APPLICATION_FLOWCHART.puml       # PlantUML flowchart
```

---

## 📚 Panduan Penggunaan

### **User Journey - Scenario Umum**

#### Scenario 1: Siswa Baru (First Time User)

1. **Launch App** → LoginScreen muncul
2. **Klik "Daftar"** → RegisterScreen
3. **Isi Data**:
   - Nama lengkap
   - Email
   - Password
   - Sekolah/Institusi
4. **Klik "Buat Akun"** → Account tersimpan di SharedPreferences
5. **Otomatis Login** → MainNavigation ditampilkan

#### Scenario 2: Belajar Materi & Quiz

1. **Home Tab** → Lihat 6 materi Python
2. **Pilih Material** (e.g., "Integer")
3. **Klik "Pelajari Materi"** → ARScanScreen
   - Camera preview ditampilkan
   - Simulated card detection
4. **Lanjut** → ARResultScreen
   - 3D model (Integer.glb) ditampilkan
   - Rotasi slider untuk interaksi
5. **View Details** → MaterialDetailScreen dengan penjelasan lengkap
6. **Back to Home** atau explore materi lain

#### Scenario 3: Mengerjakan Quiz

1. **Tasks Tab** → Klik "Quiz"
2. **Pilih Material** untuk quiz
3. **Mulai Quiz** → 5 soal ditampilkan
4. **Jawab Soal** → Feedback instant (Correct/Incorrect)
5. **Selesai** → QuizResultScreen:
   - Tampil skor (e.g., 4/5)
   - Status: ✅ Lulus / ❌ Gagal
   - Poin reward jika lulus
6. **Opsi Retry** atau back to tasks

#### Scenario 4: Mengumpulkan Projects

1. **Tasks Tab** → Klik "Projects"
2. **Lihat Daftar Projects**
3. **Pilih Project** → Detail screen
4. **Upload/Submit** → Kirim hasil pekerjaan
5. **Tracking Status** → Pending/Submitted

#### Scenario 5: Profile & Achievement

1. **Profile Tab** → View user info
2. **Lihat Statistics**:
   - Total poin: 250 pts
   - Quiz lulus: 5/6
   - Projects: 3/5
3. **Options**:
   - Edit profile → Update nama/sekolah
   - Download certificate → PDF dengan achievement
   - Logout → Kembali ke Login

---

## 🔄 Alur Aplikasi

### **Main Application Flow**

```
┌─────────────────────────────────────────────────────────┐
│ START → Check Existing Login → Cached Session?         │
│                    ↓                    ↓               │
│                   Ya                   Tidak            │
│                    ↓                    ↓               │
│          MainNavigation          LoginScreen            │
│                    ←─────────────────←               │
│                                                         │
│              LoginScreen Flow                          │
│              ┌─────────────────┐                       │
│              │ Input Email Pwd │                       │
│              └────────┬────────┘                       │
│                       ↓                                │
│              ┌─────────────────┐                       │
│              │ Validate Data   │                       │
│              └────┬────────┬───┘                       │
│                   │        │                           │
│               Valid     Invalid                        │
│                   ↓        ↓                           │
│              Success   Error Msg                       │
│                   ↓        ↓                           │
│          MainNav  ←Retry← LoginScreen                 │
│                                                         │
│           MainNavigation Hub (Loop)                    │
│     ┌──────────────────────────────────┐              │
│     ↓              ↓        ↓           ↓              │
│   HOME           TASKS    HELP      PROFILE            │
│     │              ↓↓       │           │              │
│     ↓         ┌─────┴───┐   ↓           ↓              │
│   Material    Quiz  Project Help     Profile           │
│     │          │      │     │           │              │
│   AR Scan  ┌──┘  ┌────┘     │        Edit/Logout      │
│     │      ↓     ↓          │           │              │
│   AR Result Quiz Proj ←─────┴──────────┴──────┐        │
│     │      Result  Detail                     │        │
│     └──────→ Return to MainNav ←──────────────┘        │
│                                                         │
│           ┌─────────── Logout ──────────┐              │
│           ↓                              │              │
│    Confirm & Clear Session       Return to Login       │
│           │                              │              │
│           └──────────→ Stop ←────────────┘              │
└─────────────────────────────────────────────────────────┘
```

### **Quiz Flow Detail**

```
QuizMaterialsScreen
        ↓
   Select Material
        ↓
   QuizScreen (5 questions)
   ├─ Display Q1, Q2, Q3, Q4, Q5
   ├─ User answer each question
   ├─ Instant feedback (correct/incorrect)
   ├─ Increment score counter
        ↓
   Calculate Final Score
        ↓
   QuizResultScreen
   ├─ Display score (e.g., 4/5)
   ├─ Pass/Fail status
   ├─ Points awarded (if pass)
   ├─ Save to storage
        ↓
   ┌──────────────────────┐
   │ Retry Quiz? / Back   │
   └──┬──────────────┬────┘
      Retry          Back
      │              │
      └→ QuizScreen  └→ MainNav
```

### **Detailed Flowchart**

Lihat file: `ARPY_APPLICATION_FLOWCHART.puml` untuk detail lengkap dengan semua decision points dan branches.

---

## 💾 Data Persistence

### **Storage Architecture**

Aplikasi menggunakan **SharedPreferences** untuk penyimpanan data lokal. Tidak ada backend/cloud sync.

### **Data yang Disimpan**

#### 1. **Login & User Profile**

```dart
// SharedPreferences keys:
- "login_status" → bool (true/false)
- "user_email" → String
- "user_name" → String
- "user_school" → String
- "total_points" → int
- "created_at" → String (ISO 8601)
```

#### 2. **Quiz History & Progress**

```dart
- "quiz_history" → JSON array
  {
    "material_id": "integer",
    "score": 4,
    "total_questions": 5,
    "passed": true,
    "date": "2026-04-28T10:30:00Z"
  }

- "quiz_best_scores" → Map per material
  {
    "integer": 4,
    "float": 5,
    "string": 3,
    "boolean": 5,
    "set": 4,
    "dictionary": 5
  }

- "quiz_completion_count" → int (berapa quiz selesai)
```

#### 3. **Projects Tracking**

```dart
- "projects_submitted" → JSON array
  {
    "project_id": "proj_001",
    "status": "submitted",
    "submission_date": "2026-04-28",
    "file_path": "..."
  }

- "projects_count" → int
```

#### 4. **Account Database**

```dart
// Semua accounts tersimpan dalam SharedPreferences
- "accounts" → JSON array
  {
    "email": "user@example.com",
    "password": "hashed_pwd",
    "name": "John Doe",
    "school": "SMA Maju Jaya",
    "created_date": "2026-04-28"
  }
```

### **StorageService Helper**

File: `lib/utils/storage_service.dart`

Method-method utama:

```dart
// Login & User
StorageService.saveLoginStatus(bool isLoggedIn)
StorageService.getLoginStatus() → bool

StorageService.saveUserProfile(UserProfile profile)
StorageService.getUserProfile() → UserProfile

// Quiz
StorageService.saveQuizResult(QuizResult result)
StorageService.getQuizHistory() → List<QuizResult>
StorageService.getBestScore(String materialId) → int

// Projects
StorageService.saveProjectSubmission(Project project)
StorageService.getSubmittedProjects() → List<Project>
```

---

## 🎯 Sistem Penilaian Quiz

### **Scoring Logic**

#### Per Question

- ✅ **Jawaban Benar**: +1 poin
- ❌ **Jawaban Salah**: 0 poin
- Total: 5 soal per material

#### Overall Score

- **Skor Akhir**: Jumlah jawaban benar / Total soal × 100%
- Contoh: 4 benar dari 5 = 4/5 = 80%

#### Pass/Fail Criteria

```
├─ Skor ≥ 4/5 (≥80%) → ✅ LULUS
│  └─ Award: +50 poin
│  └─ Save to "quiz_best_scores"
│
└─ Skor < 4/5 (<80%) → ❌ GAGAL
   └─ Award: 0 poin
   └─ Dapat retry unlimited
```

### **Points System**

| Activity                 | Points     |
| ------------------------ | ---------- |
| Quiz Passed (4-5/5)      | +50 pts    |
| Project Submitted        | +30 pts    |
| All 6 Quizzes Passed     | +100 bonus |
| Perfect Score (5/5 Quiz) | +25 bonus  |

### **Leaderboard Potential**

```
Dashboard Stats:
- Total Points: 250 pts
- Quizzes Passed: 5/6
- Projects Submitted: 3/5
- Completion: 65%
- Avg Quiz Score: 4.2/5
```

---

## 🛠️ Troubleshooting

### **Common Issues & Solutions**

#### 1. **Build Error: Target of URI doesn't exist**

```bash
Solution:
$ flutter clean
$ flutter pub get
$ flutter run
```

#### 2. **Camera Permission Denied**

```
Issue: AR Scan Screen tidak bisa akses kamera
Solution:
- Grant permission saat prompt muncul
- Settings → App → ARPY → Permissions → Camera → Allow
- Android 6+ requires runtime permissions
```

#### 3. **Login Forever Loop**

```
Issue: After login, masih ke LoginScreen
Solution:
- Check SharedPreferences saving:
  await StorageService.saveLoginStatus(true)
- Clear app cache: Settings → Apps → ARPY → Storage → Clear Cache
- Uninstall & reinstall app
```

#### 4. **3D Model Not Loading**

```
Issue: GLB files tidak muncul di ARResultScreen
Solution:
- Pastikan assets ada di: assets/3d/{material}.glb
- Verify pubspec.yaml memiliki asset path
- Run: flutter clean && flutter pub get
- Check model_viewer_plus dependency version
```

#### 5. **Quiz Data Not Saving**

```
Issue: Setelah quiz selesai, score tidak tersimpan
Solution:
- Check StorageService.saveQuizResult() implementation
- Verify SharedPreferences initialized correctly
- Check permissions: READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
```

#### 6. **PDF Generation Error**

```
Issue: Certificate download gagal
Solution:
- Check printing & pdf package versions
- Ensure proper permissions
- Restart app dan try again
```

---

## 🤝 Kontribusi

### **Guidelines**

1. **Fork** repository
2. **Create feature branch**: `git checkout -b feature/AmazingFeature`
3. **Commit changes**: `git commit -m 'Add AmazingFeature'`
4. **Push to branch**: `git push origin feature/AmazingFeature`
5. **Open Pull Request**

### **Development Standards**

- Follow Dart style guide
- Add comments untuk complex logic
- Test sebelum submit PR
- Update documentation jika ada perubahan API

---

## 📄 License

Distributed under the MIT License. See `LICENSE` file for more information.

---

## 🎉 Changelog

### Version 1.0.0 (Initial Release)

- ✅ Authentication system (Login/Register)
- ✅ 6 Learning materials with 3D models
- ✅ Quiz system with scoring
- ✅ Project submission tracking
- ✅ User profile & statistics
- ✅ FAQ & Help center
- ✅ Local data persistence
- ✅ Material Design 3 UI

**Last Updated**: 28 April 2026  
**Project Version**: 1.0.0  
**Status**: ✅ Active Development
