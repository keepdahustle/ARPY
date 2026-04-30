# ANALISIS MENDALAM FLOW DAN NAVIGASI APLIKASI ARPY

## Ringkasan Aplikasi
ARPY (Augmented Reality untuk Pembelajaran Python) adalah aplikasi pendidikan yang menggabungkan:
- **Autentikasi Pengguna** (Login/Register)
- **Pembelajaran Interaktif** (Materi + Quiz)
- **Visualisasi 3D** (Model viewer untuk konsep Python)
- **Tracking Progress** (Poin, Sertifikat, Riwayat)
- **Manajemen Proyek** (Project submission)

---

## FLOW APLIKASI SECARA KESELURUHAN

### 1. ENTRY POINT & AUTENTIKASI
**File:** `main.dart` → `login_screen.dart`

**Alur:**
1. Aplikasi dimulai dari `main()` yang menjalankan `ARPYApp()`
2. `ARPYApp` menentukan home page ke `LoginScreen`
3. `LoginScreen` melakukan pengecekan login status:
   - Jika sudah login → langsung ke `MainNavigation`
   - Jika belum → tampilkan form login

**Fitur Login:**
- Email validation (harus mengandung @)
- Password validation (minimal 6 karakter)
- Account lookup di SharedPreferences
- Password verification
- Error handling untuk akun tidak ditemukan

**Fitur Register:**
- Form registrasi di `RegisterScreen`
- Input: Email, Password, Username, Full Name, School
- Penyimpanan akun ke local storage

---

### 2. MAIN NAVIGATION HUB
**File:** `main_navigation.dart`

**Struktur Bottom Navigation Bar:**
```
[Home] [Tasks] [FAB SPACER] [Help] [Profile]
  0      1         2         3      4
```

**Screens yang dapat diakses:**
1. **Home Screen** (HomeScreen)
2. **Tasks Screen** (TasksScreen)
3. **Help Screen** (HelpScreen)
4. **Profile Screen** (ProfileScreen)

**Fitur Special:**
- FAB (Floating Action Button) di posisi tengah untuk AR Scan
- Bottom navigation dengan styling custom
- Persistent navigation across all main screens

---

### 3. HOME SCREEN - LEARNING MATERIALS
**File:** `home_screen.dart`

**Konten:**
- Tampilkan 4 materi pembelajaran Python:
  - **Integer** (tipe data untuk bilangan bulat)
  - **Float** (tipe data untuk bilangan desimal)
  - **String** (tipe data untuk teks)
  - **Set** (tipe data koleksi unik)

**Interaksi per Material:**
- **"Pelajari Materi" Button:**
  - Membuka `ARScanScreen` (camera + AR detection)
  - Jika tidak aktif (card belum terdeteksi) → tombol disabled
  - Jika aktif → navigasi ke `ARResultScreen`

- **"Info Material" Card:**
  - Menampilkan ringkasan materi
  - Click untuk membuka `MaterialDetailScreen`

---

### 4. AR SCAN FLOW
**File:** `ar_scan_screen.dart` → `ar_result_screen.dart`

**Alur AR Scanning:**
1. User membuka AR Scan Screen
2. Sistem meminta permission kamera
3. Camera preview ditampilkan dengan:
   - Status banner (scanning/detected)
   - Flash toggle button
   - Help button
   - Close button
4. Saat card terdeteksi:
   - Banner berubah ke hijau "Kartu AR Terdeteksi!"
   - Button "Pelajari Materi" menjadi aktif
5. Click "Pelajari Materi":
   - Navigasi ke `ARResultScreen` dengan material name

**AR Result Screen:**
1. Tampilkan 3D Model Viewer (menggunakan `model_viewer_plus`)
2. Rotation slider untuk mengontrol model
3. Material description
4. Button actions:
   - "Lihat Selengkapnya" → Material Detail
   - "Lihat Visualisasi AR" → AR Scan Screen
   - "Info" → Material Detail Screen

---

### 5. TASKS SCREEN - LEARNING MANAGEMENT
**File:** `tasks_screen.dart`

**Konten Utama:**
- Progress summary (Completed quizzes, projects, total points)
- 2 tab/section:

#### 5.1 QUIZ SECTION
**File:** `quiz_materials_screen.dart` → `quiz_screen.dart` → `quiz_result_screen.dart`

**Alur Quiz:**
1. Open Quiz Materials Screen
2. List semua materi (Integer, Float, String, Set)
3. Setiap material menampilkan:
   - Status (completed/not completed)
   - Score jika sudah selesai
   - Percentage score
4. Click material:
   - Jika sudah completed → tampilkan hasil sebelumnya
   - Option untuk retry quiz
5. Quiz Screen:
   - Tampilkan 5 pertanyaan per material
   - Multiple choice (4 opsi)
   - Instant feedback per pertanyaan
   - Counter untuk jawaban benar
6. Quiz Result Screen:
   - Score: X/5
   - Percentage
   - Message: Passed/Failed
   - Option: Retry atau Back

**Scoring:**
- Pass jika score >= 4/5
- Save best score per material
- Award points ke user profile

#### 5.2 PROJECTS SECTION
**File:** `projects_screen.dart` → `project_detail_screen.dart`

**Alur Projects:**
1. Open Projects Screen
2. List semua projects:
   - Project name
   - Description
   - Status (not started, in progress, submitted)
3. Click project:
   - Buka Project Detail Screen
   - Tampilkan full description dan requirements
4. Submit Project:
   - Input/upload project work
   - Save submission dengan timestamp
   - Update status ke "submitted"

---

### 6. HELP SCREEN - FAQ
**File:** `help_screen.dart`

**Fitur:**
- Expandable FAQ items
- Pertanyaan umum dan jawaban
- Smooth animation saat expand/collapse
- Scrollable content

---

### 7. PROFILE SCREEN - USER MANAGEMENT
**File:** `profile_screen.dart` → `edit_profile_screen.dart`

**Konten Profile:**
1. **User Information:**
   - Username
   - Full Name
   - School/Institution
   - Avatar/Profile picture

2. **Statistics:**
   - Completed Quizzes count
   - Completed Projects count
   - Total Points
   - Achievements/Badges

3. **Actions:**
   - **Edit Profile:** Update user data (nama, sekolah)
   - **Download Certificate:** Generate PDF sertifikat
   - **View Achievements:** Tampilkan badges
   - **Logout:** Logout user

**Certificate Generation:**
- Generate PDF dengan informasi user
- Download ke device
- Using `printing` dan `pdf` packages

---

## ARSITEKTUR DATA FLOW

### Local Storage (SharedPreferences)
```
Account Management:
- accounts_list (list of JSON)
  └─ {email, password, username, fullName, school}

User Session:
- login_status (boolean)
- current_user_data (JSON)
  └─ {email, username, fullName, school, profileImageUrl}

Progress Tracking:
- quiz_results_{material_name} (list)
  └─ {score, totalQuestions, percentage, date}
- best_scores_{material_name}
  └─ {score, totalQuestions, percentage}
- project_progress (list)
  └─ {projectName, status, submission, date}
- total_points (integer)
```

### Navigation Routes
```
/login      → LoginScreen
/home       → MainNavigation (default to HomeScreen)
/register   → RegisterScreen (from LoginScreen)
```

### Screen Navigation Graph
```
LoginScreen
    ↓
MainNavigation
    ├── HomeScreen
    │   ├── ARScanScreen
    │   │   └── ARResultScreen
    │   │       └── MaterialDetailScreen
    │   └── MaterialDetailScreen
    │
    ├── TasksScreen
    │   ├── QuizMaterialsScreen
    │   │   └── QuizScreen
    │   │       └── QuizResultScreen
    │   └── ProjectsScreen
    │       └── ProjectDetailScreen
    │
    ├── HelpScreen
    │
    └── ProfileScreen
        ├── EditProfileScreen
        └── [Certificate Download]
```

---

## KEY FEATURES ANALYSIS

### 1. Authentication
- Login with email/password
- Account registration
- Login status persistence
- Error handling & validation

### 2. Content Management
- 4 learning materials (Python data types)
- Each material has:
  - Description
  - 3D model (GLB format)
  - Quiz (5 questions)
  - Optional project assignment

### 3. Learning Interaction
- AR scanning (camera + card detection)
- 3D model visualization
- Quiz with instant feedback
- Score tracking & certification

### 4. User Progress
- Points system
- Quiz completion tracking
- Project submission tracking
- Certificate generation

### 5. UI/UX
- Modern Material Design 3
- Smooth animations
- Responsive layouts
- Custom color scheme (primaryDarkBlue, secondaryLightBlue, etc.)
- Google Fonts (Poppins)

---

## IMPORTANT NOTES

### ARCore Integration
- **Status:** Removed (beralih ke model viewer 3D internal)
- **Reason:** Fokus pada mobile 3D visualization tanpa AR hardware
- **Alternative:** ModelViewerPlus untuk 3D model rendering

### Data Persistence
- Local-only (SharedPreferences)
- No backend/cloud sync
- Data stored per device
- Account data isolated per user email

### 3D Models
- Location: `assets/3d/Integer.glb`
- Format: GLB (binary glTF)
- Viewer: `model_viewer_plus` package
- Interactive: Rotation, zoom, background manipulation

---

## SUMMARY
ARPY adalah aplikasi pembelajaran Python yang mengintegrasikan:
1. **Authentication** → Login/Register flow
2. **Content Delivery** → 4 learning materials
3. **Interactive Learning** → Quiz + 3D visualization
4. **Progress Tracking** → Poin, sertifikat, statistik
5. **User Management** → Profile, edit, logout

Flow-nya dimulai dari login, masuk ke main navigation hub, dan user dapat menjelajahi materi, mengikuti quiz, submit project, dan melacak progress mereka.
