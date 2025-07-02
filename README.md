# TipCalcPro 💰

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=Flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A beautiful and intuitive tip calculator with bill splitting functionality, built with Flutter.

## Features ✨

- 💵 Calculate tips and split bills with ease
- 🌗 Dark/Light mode toggle
- 📊 Multiple tip percentage presets (10%, 15%, 18%, 20%, 25%)
- 👥 Split bills between any number of people
- 📅 History of previous calculations
- 📱 Responsive design for all screen sizes
- 🎨 Material 3 design with dynamic theming

## Installation 🛠️

### Prerequisites
- Flutter SDK (version 3.13.0 or higher)
- Dart SDK (version 3.1.0 or higher)

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/MrRogueKnight/TipCalcPro.git
   cd TipCalcPro
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Building for Production 🚀

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Windows
```bash
flutter build windows --release
```

## Packages Used 📦
- `shared_preferences`: For storing theme preferences
- `intl`: For date formatting
- `flutter/services`: For haptic feedback

## Project Structure 📂
```
lib/
├── main.dart            # Main application entry point
├── widgets/
│   ├── amount_card.dart # Total amount display card
│   ├── bill_input.dart  # Bill amount input field
│   ├── tip_presets.dart # Tip percentage selector
│   ├── split_controls.dart # Bill split controls
│   └── history_list.dart # Calculation history
```

## Contributing 🤝
Contributions are welcome! Please follow these steps:
1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License 📄
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
