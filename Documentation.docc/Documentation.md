# GeoRocksIOS 🪨📱

![GeoRocksIOS Logo](Resources/logo.png)

GeoRocksIOS is an advanced iOS application designed to provide users with an immersive experience related to various types of rocks. Built with **SwiftUI** for a fluid and intuitive user interface and powered by **Firebase** for secure authentication, features such as user sign-in, detailed rock data, multimedia support, and interactive maps are delivered by the application.

## Table of Contents 📑

- [Features](#features-gear)
- [Screenshots](#screenshots)
- [Technologies Used](#technologies-used)
- [Installation](#installation-box)
- [Usage](#usage)
- [Architecture](#architecture)
- [Contributing](#contributing-handshake)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

## Features ⚙️

- **User Authentication**  
  - **Sign In**: Secure login using email and password.  
  - **Create Account**: Registration of new users with email verification.  
  - **Forgot Password**: Passwords can be reset via email links.
  
- **Rock Catalog**  
  - **List of Rocks**: Browsing through a comprehensive catalog of rocks is enabled.  
  - **Rock Details**: Access to images, videos, descriptions, and additional data is provided.
  
- **Multimedia Integration**  
  - **Images**: High-resolution images can be viewed.  
  - **Videos**: Curated videos for an in-depth look are available.
  
- **Interactive Maps**  
  - **Location Tracking**: Geological locations of each rock can be explored using embedded maps.
  
- **Responsive Design**  
  - Optimization for a variety of iOS devices ensures consistency in user experience.

## Screenshots 📸

Screenshots of significant app views showcasing design and functionality:

![Login Screen](login_screen.png)  
*Login Screen*

![Main Rocks View](main_rocks_view.png)  
*Main Rocks View*

![Rock Detail View](rock_detail_view.png)  
*Rock Detail View*

## Technologies Used 🛠️

- **SwiftUI**: Utilized for constructing the app’s UI.  
- **Firebase Authentication**: Ensures reliable user account creation, login, and password reset flows.  
- **Combine**: Employed for asynchronous data binding and event handling.  
- **MapKit**: Provides interactive map views for geological data visualization.  
- **AVKit**: Facilitates video playback within the app.  
- **URLSession**: Handles communication with the backend API.

## Installation 📦

### Prerequisites

- **Xcode 14.0 or later**: Ensure that the latest version of Xcode is installed.
- **Swift 5.5 or later**: Utilizes modern Swift language features.
- **CocoaPods or Swift Package Manager (SPM)**: Required for dependency management (optional).

### Steps

1. **Clone the Repository**

    ```bash
    git clone https://github.com/enigmak9/GeoRocksIOS.git
    ```

2. **Navigate to the Project Directory**

    ```bash
    cd GeoRocksIOS
    ```

3. **Install Dependencies**

    - If using CocoaPods:

        ```bash
        pod install
        ```

      Then open the workspace:

        ```bash
        open GeoRocksIOS.xcworkspace
        ```

    - If using Swift Package Manager, dependencies will be resolved automatically.

4. **Configure Firebase**

    - **Add the `GoogleService-Info.plist`**:
      - Download it from your Firebase project settings.
      - Drag it into your Xcode project’s Project Navigator.

    - **Initialize Firebase**:
      - In `GeoRocksIOSApp.swift` (or `AppDelegate.swift` if using UIKit lifecycle), ensure `FirebaseApp.configure()` is present:

        ```swift
        import Firebase

        init() {
            FirebaseApp.configure()
        }
        ```

5. **Build and Run**

    - Select either a simulator or a physical device from Xcode.
    - Press `Cmd + R` to compile and run the application.

## Usage 🚀

1. **Launch the Application**
   - If the user is not authenticated, a `LoginView` appears.

2. **Authentication**
   - **Sign In**: Enter valid credentials to access main features.
   - **Create Account**: Register a new profile if needed.
   - **Forgot Password**: Initiate password recovery via an email link.

3. **Rock Catalog**
   - After signing in, the `MainRocksView` is entered to browse or search for rocks.
   - Selecting any rock displays detailed information such as images, videos, and map locations.

4. **Logout**
   - Logging out can be done anytime from the `MainRocksView` via the provided button.

## Architecture 🏛️

GeoRocksIOS follows an MVVM (Model-View-ViewModel) pattern to maintain a clean and testable code structure.

### Models
- **RockDto**: Represents essential rock information in a list.
- **RockDetailDto**: Contains in-depth information.

### ViewModels
- **AuthViewModel**: Handles authentication logic.
- **RocksViewModel**: Manages fetching and storing rock lists.
- **RockDetailViewModel**: Fetches detailed rock information.

### Views
- **LoginView**: User sign-in interface.
- **CreateAccountView**: Registration interface.
- **ForgotPasswordView**: Password reset interface.
- **MainRocksView**: Main user interface after login.
- **RocksListView**: Displays fetched rocks in a list.
- **RockDetailView**: Displays detailed rock information.
- **MapView**: Shows rock localities on a map.

### Services
- **NetworkingService**: Handles API calls for data retrieval.
- **UserService**: Manages user profile and password update requests.

## Contributing 🤝

Contributions are encouraged. To participate, please follow these steps:

1. **Fork the Repository**
   - Click the "Fork" button in the repository’s header.

2. **Clone Your Fork**

    ```bash
    git clone https://github.com/<your-username>/GeoRocksIOS.git
    ```

3. **Create a New Branch**

    ```bash
    git checkout -b feature/YourFeatureName
    ```

4. **Implement Changes**
   - Add the new functionality or bug fix.

5. **Commit Your Changes**

    ```bash
    git commit -m "Describe the changes made"
    ```

6. **Push to Your Fork**

    ```bash
    git push origin feature/YourFeatureName
    ```

7. **Create a Pull Request**
   - Go to the original repository and submit a PR describing your changes.

## License 📝

Distributed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact 📫

**Carlos Ignacio Padilla Herrera**

- **Email**: [enigmak9@protonmail.com](mailto:enigmak9@protonmail.com)
- **GitHub**: [@enigmak9](https://github.com/enigmak9)

Feel free to reach out with questions or collaboration requests.

## Acknowledgments 🙏

- Apple SwiftUI Documentation
- Firebase Authentication
- MapKit Framework
- AVKit Framework
- Apiary Mock Server

This documentation was generated and curated by EnigmaK9.
