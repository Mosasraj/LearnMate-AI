# LearnMate AI – Personalized Offline Learning Assistant

**Bharat AI-SoC Challenge 2026–27 | Problem Statement 4**

LearnMate AI is an AI-powered personalized learning assistant designed to help students learn technical concepts through simple explanations, personalized guidance, and offline AI assistance.

The application aims to make learning more accessible by providing an AI tutor that can work directly on an Android device without requiring a continuous internet connection for AI inference.

## 1. Problem Statement

Many students face difficulties understanding technical subjects because of complex explanations, limited access to personalized guidance, and dependence on internet-based learning platforms.

Students need a learning assistant that can:
- Explain difficult concepts in simple language.
- Adapt explanations to their learning profile.
- Support independent learning.
- Provide AI assistance even without an internet connection.

## 2. Proposed Solution

LearnMate AI provides a personalized learning environment with an on-device AI tutor.

The application combines a Flutter-based mobile interface with an offline language model integrated through Android native code and ExecuTorch.

The AI tutor uses the learner's stored profile to provide context-aware explanations and learning assistance.

## 3. Key Features

- **AI Tutor:** Ask questions and receive AI-generated explanations.
- **Offline AI Inference:** Generate responses using an on-device language model.
- **Personalized Learning:** Use learner profile information to provide more relevant explanations.
- **Learner Assessment:** Collect student learning information and preferences.
- **Study Dashboard:** Access learning features from a central dashboard.
- **Study Planner:** Organize learning activities.
- **Profile Management:** Store learner information locally.

## 4. Technology Stack

| Component | Technology |
|---|---|
| Mobile application | Flutter |
| Programming language | Dart |
| Android native integration | Kotlin |
| AI inference framework | ExecuTorch 1.5.1 |
| Language model | Llama 3.2 1B Instruct SpinQuant INT4 |
| Model format | `.pte` |
| Local storage | SharedPreferences |
| Development tools | VS Code, Android Studio |

## 5. System Architecture

<img width="2510" height="1724" alt="mermaid-diagram" src="https://github.com/user-attachments/assets/2cdc2894-9f55-4ee9-8abf-31631cfc42cf" />


## 6. Offline AI Implementation

The application integrates the Llama 3.2 1B Instruct SpinQuant INT4 model using ExecuTorch.

The model is loaded and executed on the Android device.

The communication between Flutter and native Android code is handled using a Flutter MethodChannel:

`learnmate/ai`

The Kotlin layer handles model inference and returns generated responses to the Flutter application.

The learner profile is stored locally using SharedPreferences and used to provide relevant context to the AI tutor.

**Important:** The model weights and tokenizer are large local assets. They are not included in this GitHub repository. They must be obtained and configured separately before running the offline AI functionality.

## 7. Project Structure

```text
learnmate_ai/
│
├── lib/
│   ├── main.dart
│   ├── assessment_page.dart
│   ├── chat_page.dart
│   └── ...
│
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── kotlin/
│                   └── ...
│
├── assets/
│
├── pubspec.yaml
├── .gitignore
└── README.md
```
## Application Screenshots
### Dashboard
<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/0433307a-97ec-4530-b2f8-f1810fff5527" />


### Learner Assessment
<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/23b1af74-438e-4d64-a223-a8a8aa6314b0" />

### AI Tutor
<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/321de3c0-0f8b-40f6-b3b1-6d4e79e78e0b" />

## 8. Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio
- Android SDK
- A compatible Android device
- Required offline model and tokenizer files

### Clone the Repository

```bash
git clone https://github.com/Mosasraj/LearnMate-AI.git
```

### Open the Project

```bash
cd LearnMate-AI
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

**Note:** The offline AI functionality requires the compatible model and tokenizer files to be configured in the Android native implementation. These files are intentionally excluded from this repository.

## 9. Current Development Status

- Flutter application interface implemented.
- Learner assessment and local profile storage implemented.
- AI chat interface implemented.
- Flutter-to-Android MethodChannel integration implemented.
- ExecuTorch integration implemented.
- Offline model loading and text generation tested on an Android device.

Further testing and optimization are required to improve response quality, personalization, performance, and overall reliability.

## 10. Future Enhancements

- Improve personalized learning recommendations.
- Add structured learning paths for different subjects.
- Improve technical concept understanding and response accuracy.
- Optimize model loading time and memory consumption.
- Add learning progress tracking.
- Improve multilingual learning support.
- Expand offline learning capabilities.

## 11. Team Information

**Institution:** Saveetha Engineering College

**Challenge:** Bharat AI-SoC Challenge 2026–27

**Problem Statement:** PS4

**Project:** LearnMate AI

**Team Members:**
1. Poojith Prasath M
2. Jegadeesh S
3. Mosas Raj A

## 12. Repository

GitHub: https://github.com/Mosasraj/LearnMate-AI

---

**LearnMate AI – Making Personalized Learning Accessible Through On-Device AI.**

