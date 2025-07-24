# Food Delivery App

A modern Flutter application for food delivery, featuring user authentication, profile management, localization (English & Arabic), and a beautiful, theme-adaptive UI.

## Features
- User login, OTP verification, and signup
- Profile editing and persistent user data
- Location access and permissions
- Themed UI (light/dark mode)
- Drawer with navigation to profile, cart, favorites, settings, and more
- Full localization support (English & Arabic)
- Responsive design using flutter_screenutil

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio, VSCode, or any preferred IDE

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/Ahmed4r/Food-Delivery.git
   cd food_delivery
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Localization
- The app supports both English and Arabic.
- Language can be changed from the settings page.
- All user-facing strings are localized using [easy_localization](https://pub.dev/packages/easy_localization).

## Main Dependencies
- [easy_localization](https://pub.dev/packages/easy_localization)
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)
- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [image_picker](https://pub.dev/packages/image_picker)

## Project Structure
- `lib/screens/` - All main screens (login, profile, settings, etc.)
- `lib/widgets/` - Reusable widgets (custom drawer, buttons, etc.)
- `assets/lang/` - Localization files (en.json, ar.json)
- `assets/images/` - App images

## Screenshots
![Login Screen](assets/images/login.png)
![Home Screen](assets/images/home.png)
![Profile Screen](assets/images/profile.png)
![Settings Screen](C:\Users\ahmed\Desktop\Screenshot_1753300429.png)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
