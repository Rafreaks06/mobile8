# mobile8

Aplikasi Flutter sederhana dengan autentikasi Firebase (Firebase Auth).

## Fitur

- Login dengan email dan password (Firebase Authentication)
- Deteksi status login otomatis (StreamBuilder `authStateChanges`)
- Halaman info user: UID, email, status verifikasi email, terakhir login
- Logout

## Struktur

```
lib/
  main.dart               # inisialisasi Firebase, home: AuthWrapper
  firebase_options.dart   # konfigurasi Firebase (projectraf)
  widgets/
    auth_wrapper.dart     # StreamBuilder authStateChanges
  screens/
    login_screen.dart     # form login email/password
    user_info_screen.dart # dashboard user + logout
```

## Cara Menjalankan

```bash
git pull
flutter pub get
flutter run
```

## Catatan

- Form login (`login_screen.dart` bagian `build`) direkonstruksi dari field state di screenshot — periksa kembali tampilannya.
- Login hanya berfungsi bila akun sudah terdaftar di Firebase Authentication (tidak ada alur daftar di aplikasi ini).
