# GeoRocksIOS

![GeoRocksIOS Logo](Resources/logo.png)

GeoRocksIOS is a sophisticated iOS application designed to provide users with an interactive and informative experience about various rocks. Leveraging **SwiftUI** for a seamless user interface and **Firebase** for robust authentication, GeoRocksIOS offers features such as user authentication, detailed rock information, multimedia integration, and interactive maps.

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

## Features

- **User Authentication:**
  - **Sign In:** Secure login using email and password.
  - **Create Account:** Register new users with email verification.
  - **Forgot Password:** Reset password via email.

- **Rock Catalog:**
  - **List of Rocks:** Browse through a comprehensive list of rocks.
  - **Rock Details:** Access detailed information about each rock, including images, videos, descriptions, and properties.
  
- **Multimedia Integration:**
  - **Images:** View high-quality images of rocks.
  - **Videos:** Watch related videos for an immersive experience.
  
- **Interactive Maps:**
  - **Location Tracking:** View the geographical locations where each rock is found using integrated maps.

- **Responsive Design:**
  - Optimized for various iOS devices ensuring a consistent user experience.

## Screenshots

*Include screenshots of your application here to showcase its design and functionality.*

![Login Screen](login_screen.png)
*Login Screen*

![Main Rocks View](main_rocks_view.png)
*Main Rocks View*

![Rock Detail View](rock_detail_view.png)
*Rock Detail View*

## Technologies Used

- **SwiftUI:** For building the user interface.
- **Firebase Authentication:** For managing user sign-in, registration, and password reset functionalities.
- **Combine:** For handling asynchronous events and data binding.
- **MapKit:** For displaying interactive maps.
- **AVKit:** For integrating video playback within the app.
- **URLSession:** For networking and fetching data from the backend API.

## Installation

### Prerequisites

- **Xcode 14.0 or later:** Ensure you have the latest version of Xcode installed.
- **Swift 5.5 or later:** The project is built using Swift 5.5 features.
- **CocoaPods or Swift Package Manager (Optional):** For managing dependencies, if any.

### Steps

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/enigmak9/GeoRocksIOS.git
   ```

2. **Navigate to the Project Directory:**

   ```bash
   cd GeoRocksIOS
   ```

3. **Install Dependencies:**

   If your project uses CocoaPods:

   ```bash
   pod install
   ```

   Open the workspace:

   ```bash
   open GeoRocksIOS.xcworkspace
   ```

   If using Swift Package Manager, dependencies should resolve automatically.

4. **Configure Firebase:**

   - **Add `GoogleService-Info.plist`:**
     - Download the `GoogleService-Info.plist` file from your Firebase project settings.
     - Add the file to your Xcode project by dragging it into the Project Navigator.
   
   - **Initialize Firebase:**
     - Firebase is initialized in `GeoRocksIOSApp.swift`. Ensure that the initialization code is present:
       
       ```swift
       import Firebase

       init() {
           FirebaseApp.configure()
       }
       ```

5. **Build and Run:**

   - Select the desired simulator or your physical device.
   - Press `Cmd + R` to build and run the application.

## Usage

1. **Launching the App:**
   - Upon launching, if the user is not authenticated, the **LoginView** is presented.

2. **Authentication:**
   - **Sign In:**
     - Enter your registered email and password.
     - Tap "Sign In" to access the main features.
   - **Create Account:**
     - Navigate to the **Create Account** view.
     - Provide a valid email and password to register.
   - **Forgot Password:**
     - Navigate to the **Forgot Password** view.
     - Enter your email to receive a password reset link.

3. **Exploring Rocks:**
   - After signing in, access the **MainRocksView**.
   - Tap "View All Rocks" to browse the list.
   - Select a rock to view detailed information, including images, videos, and location maps.

4. **Logging Out:**
   - Tap the "Logout" button in the **MainRocksView** to sign out.

## Architecture

GeoRocksIOS follows the **MVVM (Model-View-ViewModel)** architectural pattern, ensuring a clean separation of concerns and enhancing testability.

- **Models:**
  - `RockDto`: Represents the basic information of a rock.
  - `RockDetailDto`: Contains detailed information about a specific rock.

- **ViewModels:**
  - `AuthViewModel`: Manages user authentication logic.
  - `RocksViewModel`: Handles fetching and managing the list of rocks.
  - `RockDetailViewModel`: Manages the retrieval of detailed rock information.

- **Views:**
  - `LoginView`: User authentication interface.
  - `CreateAccountView`: Account registration interface.
  - `ForgotPasswordView`: Password reset interface.
  - `MainRocksView`: Main interface post-authentication.
  - `RocksListView`: Displays the list of rocks.
  - `RockDetailView`: Shows detailed information about a selected rock.
  - `MapView`: Interactive map displaying rock locations.

- **Services:**
  - `NetworkingService`: Handles all networking tasks, including fetching data from the backend API.

## Contributing

Contributions are welcome! To contribute to GeoRocksIOS, follow these steps:

1. **Fork the Repository:**

   Click the "Fork" button at the top-right corner of the repository page.

2. **Clone Your Fork:**

   ```bash
   git clone https://github.com/EnigmaK9/GeoRocksIOS.git
   ```

3. **Create a New Branch:**

   ```bash
   git checkout -b feature/YourFeatureName
   ```

4. **Make Your Changes:**

   Implement your feature or bug fix.

5. **Commit Your Changes:**

   ```bash
   git commit -m "Add your descriptive commit message"
   ```

6. **Push to Your Fork:**

   ```bash
   git push origin feature/YourFeatureName
   ```

7. **Create a Pull Request:**

   Navigate to the original repository and click "New Pull Request". Provide a clear description of your changes.

## License

Distributed under the MIT License. See `LICENSE` for more information.

![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## Contact

**Carlos Ignacio Padilla Herrera**

- **Email:** [enigmak9@protonmail.com](mailto:enigmak9@protonmail.com)
- **GitHub:** [@enigmak9](https://github.com/enigmak9)

Feel free to reach out for any queries or collaborations.

## Acknowledgments

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Firebase Authentication](https://firebase.google.com/products/auth)
- [MapKit Framework](https://developer.apple.com/documentation/mapkit)
- [AVKit Framework](https://developer.apple.com/documentation/avkit)
- [Apiary Mock Server](https://apiary.io/)

---

*This README was generated by [EnigmaK9](https://github.com/EnigmaK9).*
