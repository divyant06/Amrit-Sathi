# Amrit Sathi 🇮🇳 🎒

> **An AI-powered, offline-first group travel companion designed to redefine how you explore India.**

Amrit Sathi isn't just another generic travel booking app. It is a contextual, persistent travel brain that helps you plan, navigate, and stay connected with your squad—even when you lose signal in the mountains. 

Built with **Flutter** and powered by **Google Gemini**, Amrit Sathi features a premium dark-mode aesthetic and intelligent local caching to ensure your travel data is always at your fingertips.

---

### ✨ Core Features

* **🤖 AI Travel Copilot:** Powered by Google Gemini. Ask for hyper-contextual itineraries, hidden gems, or cultural insights, and the AI builds your trip on the fly.
* **🗺️ Offline Squad Map:** Lose network in the Himalayas? The local persistent memory simulates offline tracking so you never lose your group.
* **📸 Story & Reels UI:** A modern, dynamic social feed to capture and share your travel moments seamlessly.
* **🌙 Premium Native UI:** Built from the ground up with a custom sleek `#0B1120` dark theme, complete with a native splash screen and optimized asset bundles.

---

### 🛠️ Tech Stack

* **Framework:** Flutter / Dart
* **AI Engine:** Google Gemini (`google_generative_ai`)
* **Environment Security:** `flutter_dotenv` (Local vault for API keys)
* **Architecture:** Offline-First with Persistent Memory

---

### 🚀 Getting Started

Want to run Amrit Sathi locally? Follow these steps:

**1. Clone the repository**
```bash
git clone [https://github.com/divyant06/Amrit-Sathi.git](https://github.com/divyant06/Amrit-Sathi.git)
cd Amrit-Sathi

2. Install Dependencies

Bash
flutter pub get
3. Setup the AI Vault (.env)
Because security is a priority, API keys are not committed to this repository. You must create your own local environment file.

Create a file named .env in the root directory.

Add your Gemini API key like this:

Code snippet
GEMINI_API_KEY=your_actual_api_key_here
4. Run the App

Bash
flutter run
(To build a production-ready physical APK for your Android device, run: flutter build apk --release --no-tree-shake-icons)

🤝 Connect & Feedback
Currently in active development. If you want the beta .apk to test it on your physical phone, or if you have brutal feedback, reach out!

Built with ❤️ by Divyant