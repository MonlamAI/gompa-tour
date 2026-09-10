# Neykor (གནས་སྐོར། / नेकोर)

Neykor (GonpaTour) is a mobile application built with Flutter that allows users to view, search, and scan for information about Buddhist monasteries, sacred statues/deities, pilgrimage sites, and religious festivals. Developed under the executive organ of the **Department of Religion and Culture (ཆོས་རིག་ལས་ཁུངས། / धर्म एवं संस्कृति विभाग)**, Central Tibetan Administration (CTA), it displays rich multimedia content including descriptive text, audio recordings, images, and geolocation maps.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Demo](#demo)
3. [Features](#features)
4. [Project Structure](#project-structure)
5. [Libraries Used](#libraries-used)
6. [Installation and Setup](#installation-and-setup)
7. [Environment Configuration](#environment-configuration)
8. [Usage](#usage)
9. [Supported Languages](#supported-languages)
10. [Contributing](#contributing)
11. [License](#license)

---

## Project Overview

**Neykor** enables pilgrims, travelers, researchers, and Buddhist communities to discover and explore sacred Buddhist monasteries, statues, pilgrimage sites, and festivals across India, Nepal, and Bhutan. Presenting rich multimedia content such as historical descriptions, audio recordings, photo galleries, and map navigation, it serves as a modern digital tool for preserving and promoting Tibetan religious and cultural heritage.

---

## Demo

<table>
  <tr>
    <td><img src="https://github.com/OpenPecha/gompa-tour/blob/develop/demo/0.png?raw=true" alt="Screenshot 1" width="240"></td>
    <td><img src="https://github.com/OpenPecha/gompa-tour/blob/develop/demo/1.png?raw=true" alt="Screenshot 2" width="240"></td>
    <td><img src="https://github.com/OpenPecha/gompa-tour/blob/develop/demo/2.png?raw=true" alt="Screenshot 3" width="240"></td>
  </tr>
  <tr>
    <td><img src="https://github.com/OpenPecha/gompa-tour/blob/develop/demo/3.png?raw=true" alt="Screenshot 4" width="240"></td>
    <td><img src="https://github.com/OpenPecha/gompa-tour/blob/develop/demo/4.png?raw=true" alt="Screenshot 5" width="240"></td>
    <td><img src="https://github.com/OpenPecha/gompa-tour/blob/develop/demo/5.png?raw=true" alt="Screenshot 6" width="240"></td>
  </tr>
</table>

---

## Features

- **Four Core Categories**:
  - **Deities & Statues (རྟེན་བཤད།)**: Comprehensive background and spiritual iconography of sacred statues.
  - **Monasteries / Gonpas (ཆོས་སྡེ།)**: Detailed profiles of 250+ monasteries across all Tibetan Buddhist schools.
  - **Pilgrimage Sites (གནས་བཤད།)**: Sacred Buddhist pilgrimage destinations with histories and locations.
  - **Festivals (དུས་ཆེན།)**: Religious festivals, dates, rituals, and celebration schedules.
- **Interactive OpenStreetMap**: View nearby monasteries and pilgrimage sites with real-time GPS location and distance calculations.
- **QR Code Scanner**: Scan QR codes on-site at monasteries and statues for instant access to historical information.
- **Universal Multi-Language Search**: Fast real-time search across all categories matching queries in Tibetan, English, and Hindi.
- **Multimedia Support**: Photo galleries, audio streaming, and built-in Text-to-Speech (TTS) narration.
- **Multilingual UI**: Native script rendering and localized interfaces in Tibetan (བོད་ཡིག), English (EN), and Hindi (हिन्दी).
- **Dark Mode & Theming**: Full support for Light, Dark, and System appearance themes.

---

## Project Structure

The project follows a clean, modular folder structure:

```plaintext
lib/
├── config/              # App routing (GoRouter), themes, styles, and constants
├── helper/              # Localization helpers and SQLite database helpers
├── l10n/                # Localization files (app_bo.arb, app_en.arb, app_hi.arb)
│   └── generated/       # Generated localization classes
├── models/              # Data models (Gonpa, Statue, Festival, PilgrimSite)
├── repo/                # API and SQLite database repositories
├── states/              # State management providers using Riverpod
├── ui/
│   ├── screen/          # Full-screen views (Home, Map, QR, Search, Settings, Detail screens)
│   └── widget/          # Reusable UI widgets (Cards, AudioPlayer, ImageCache, AppBar)
└── util/                # Debouncers, QR extractors, translation helpers
```

---

## Libraries Used

The following major libraries are used in the project:

- **[Riverpod](https://pub.dev/packages/riverpod)**: Flexible, compile-safe state management for asynchronous data fetching and reactive UI updates.
- **[GoRouter](https://pub.dev/packages/go_router)**: Declarative routing and deep linking between app screens.
- **[Sqflite](https://pub.dev/packages/sqflite)**: Local embedded SQLite database for offline storage and caching.
- **[http](https://pub.dev/packages/http)**: Network client for fetching data and media from REST APIs.
- **[flutter_map](https://pub.dev/packages/flutter_map)** & **[latlong2](https://pub.dev/packages/latlong2)**: High-performance OpenStreetMap rendering and geospatial calculations.
- **[mobile_scanner](https://pub.dev/packages/mobile_scanner)** & **[qr_flutter](https://pub.dev/packages/qr_flutter)**: Fast QR code scanning and QR generation.
- **[audioplayers](https://pub.dev/packages/audioplayers)** & **[flutter_tts](https://pub.dev/packages/flutter_tts)**: Audio playback for sacred recordings and Text-to-Speech narration.
- **[flutter_dotenv](https://pub.dev/packages/flutter_dotenv)**: Loading environment configuration variables from `.env`.
- **[geolocator](https://pub.dev/packages/geolocator)**: Device location services and GPS positioning.

---

## Installation and Setup

To set up the project locally, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/OpenPecha/gompa-tour.git
   cd gompa-tour
   ```

2. **Install dependencies**:
   Ensure Flutter (or [FVM](https://fvm.app/)) is installed, then run:
   ```bash
   fvm flutter pub get
   # or
   flutter pub get
   ```

3. **Set up environment configurations**:
   Create a `.env` file in the project root (see [Environment Configuration](#environment-configuration)).

4. **Generate localizations**:
   ```bash
   fvm flutter gen-l10n
   ```

5. **Run the app**:
   ```bash
   fvm flutter run
   ```

---

## Environment Configuration

Create a `.env` file in the root directory:

```env
BASE_URL=https://api.neykor.net
IMAGE_BASE_URL=https://s3.ap-south-1.amazonaws.com/gompa.tour
```

---

## Usage

The application is structured into five primary navigation tabs:

### 1. Home
- **Deities (Statues)**: Browse sacred statues and deities with detailed iconography and spiritual significance.
- **Organizations (Monasteries)**:
  - Browse monasteries categorized by Tibetan Buddhist tradition (*Nyingma, Kagyu, Sakya, Gelug, Bon, Jonang, Remey, Shalu, Bodong, Others*).
  - Filter monasteries by State and Region across India, Nepal, and Bhutan.
- **Pilgrimage**: Explore holy pilgrimage destinations with historical context.
- **Festivals**: View upcoming religious festivals and ceremonial programs.

### 2. Map
- Interactive map view displaying markers for monasteries and pilgrimage sites.
- Geolocation pinpointing your current position and distance to nearby sacred sites.
- Tap any marker to view quick details or open full directions in Google Maps.

### 3. Scan
- Fast QR code scanner for scanning Neykor QR codes placed at monasteries and statues.
- Instantly opens the corresponding detail screen with audio, images, and history.

### 4. Search
- Universal search across statues, monasteries, pilgrimage sites, and festivals.
- Searches in Tibetan, English, and Hindi simultaneously.
- Recent search chips for quick re-searching.

### 5. Settings
- **Theme**: Switch between Light, Dark, and System appearance.
- **Language**: Switch app language between **Tibetan (བོད་ཡིག)**, **English (EN)**, and **Hindi (हिन्दी)**.
- **About Us**: Information about the Department of Religion and Culture (CTA).
- **About App**: Background on the Neykor application and its preservation mission.
- **Tibetan Prayer App**: Link to the official digital prayer app.
- **Share App**: Share the app store download link.

---

## Supported Languages

- བོད་ཡིག (**Tibetan**) - Default language on first launch
- **English** (EN)
- हिन्दी (**Hindi**)

---

## Contributing

We welcome contributions to improve the GonpaTour app! If you want to contribute, please:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Create a pull request.

---

## License

This project is licensed under the MIT License.
