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

```text
          LEARNMATE AI
                |
        Flutter Mobile App
                |
    +-----------+-----------+
    |           |           |
 Dashboard   Assessment   Study Planner
    |           |           |
    +-----------+-----------+
                |
             AI Tutor
                |
          MethodChannel
                |
       Android Native Layer
             (Kotlin)
                |
          ExecuTorch
                |
      Llama 3.2 1B Model
                |
       Generated Response
                |
        Flutter Chat UI
```

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

*The exact file structure may vary depending on the current implementation.*

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
1. [Team Member 1]
2. [Team Member 2]
3. [Team Member 3]

## 12. Repository

GitHub: https://github.com/Mosasraj/LearnMate-AI

---

**LearnMate AI – Making Personalized Learning Accessible Through On-Device AI.**

