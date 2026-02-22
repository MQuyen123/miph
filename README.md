# 🎬 MIHP — Movie Streaming App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.8-blue?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.8-blue?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Architecture-Clean-green" alt="Architecture">
  <img src="https://img.shields.io/badge/State-BLoC-purple" alt="State">
  <img src="https://img.shields.io/github/actions/workflow/status/YOUR_USERNAME/mihp/ci.yml?label=CI" alt="CI">
</p>

Ứng dụng xem phim chất lượng cao, xây dựng với **Flutter** theo kiến trúc **Clean Architecture** và **BLoC Pattern**.

## ✨ Tính năng

- 🏠 Trang chủ với carousel phim nổi bật
- 🔍 Tìm kiếm phim với debounce
- 🗂️ Lọc theo thể loại, quốc gia, năm
- 🎬 Xem chi tiết phim (poster, mô tả, danh sách tập)
- ▶️ Video player HLS với multi-server
- ❤️ Yêu thích (lưu local)
- 📜 Lịch sử xem + tiếp tục xem
- 🌙 Dark theme (Netflix-style)

## 🏗️ Kiến trúc

```
lib/
├── core/           # Constants, Theme, Network, Router, Widgets
├── features/       # Feature modules (Clean Architecture)
│   ├── home/
│   ├── movie_detail/
│   ├── search/
│   ├── category/
│   ├── watch/
│   ├── favorite/
│   └── history/
├── injection_container.dart
└── main.dart
```

Mỗi feature theo cấu trúc: `data/` → `domain/` → `presentation/`

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | Flutter 3.8 |
| State Management | flutter_bloc |
| Networking | Dio |
| Navigation | GoRouter |
| DI | GetIt |
| Local Storage | Hive |
| Video Player | Chewie + video_player |
| Images | CachedNetworkImage |

## 🚀 Getting Started

```bash
# Clone
git clone https://github.com/YOUR_USERNAME/mihp.git
cd mihp

# Install dependencies
flutter pub get

# Run (debug)
flutter run

# Run (release)
flutter run --release

# Analyze
flutter analyze

# Test
flutter test
```

## 📦 Build

```bash
# Android APK
flutter build apk --release

# Android AAB (Play Store)
flutter build appbundle --release

# Split per ABI (smaller APK)
flutter build apk --split-per-abi --release
```

## 🧪 CI/CD

Project sử dụng **GitHub Actions** với 2 workflows:

| Workflow | Trigger | Mô tả |
|---|---|---|
| `ci.yml` | Push/PR → `main`, `develop` | Analyze + Test |
| `build.yml` | Push tag `v*` | Build Release APK + Upload artifact |

## 📄 License

MIT License
