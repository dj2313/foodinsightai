# FoodSight AI 🍎🤖

**FoodSight AI** is a smart, AI-powered meal planning and pantry management application built with **Flutter**. It leverages **Google's Gemini 1.5 Flash** to analyze food items via camera and generate personalized recipes, helping users reduce food waste and cook creative meals.

## ✨ Key Features

### 👁️ Vision Agent (Pantry Scanner)
- **Instant Recognition**: Point your camera at groceries to automatically identify them.
- **Smart Details**: Auto-detects item names, categories, and estimates freshness/expiry dates.
- **Seamless Integration**: Directly adds scanned items to your digital pantry.

### 👨‍🍳 Chef Agent (Magic Meal)
- **AI Recipe Generation**: Creates custom recipes based *only* on the ingredients you currently have.
- **Detailed Instructions**: Provides step-by-step cooking guides, nutritional breakdowns, and calorie counts.
- **Adaptive Cooking**: Suggests meals that fit your dietary preferences (Coming Soon).

### 📦 Smart Pantry Management
- **Inventory Tracking**: Keep track of what's in your fridge.
- **Expiry Alerts**: Visual indicators for expiring soon items (Freshness Score).
- **Categorization**: Organized views for Vegetables, Fruits, Dairy, etc.

### 🎨 Modern UI/UX
- **Glassmorphic Design**: Premium aesthetic with blur effects and gradients.
- **Smooth Animations**: Powered by `flutter_animate` for a delightful user experience.
- **MVVM Architecture**: Clean, maintainable code using Riverpod for state management.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **AI Model**: [Google Gemini 1.5 Flash](https://deepmind.google/technologies/gemini/) (`google_generative_ai`)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth & Firestore)
- **Animations**: `flutter_animate`, `lottie`
- **Navigation**: Standard Flutter Navigation (moving to GoRouter planned)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed.
- A **Gemini API Key** from [Google AI Studio](https://aistudio.google.com/).

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/dj2313/foodinsightai.git
    cd mealplanner
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Environment Setup**
    - Create a `.env` file in the root directory.
    - Add your API Key:
      ```env
      GEMINI_API_KEY=your_actual_api_key_here
      ```
    - *Note: The `.env` file is git-ignored for security.*

4.  **Run the App**
    ```bash
    flutter run
    ```

## 📸 Screenshots

*(Add screenshots of Onboarding, Home, Pantry, and Recipe screens here)*

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## 📄 License

This project is licensed under the MIT License.
