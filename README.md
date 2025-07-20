# Arkanghel App

Project Arkanghel is a comprehensive mobile learning and assessment platform designed to facilitate employee training and skill development. The application provides a dual-interface system catering to both Admins and Employees, creating a seamless and efficient training ecosystem.

## Project Background

The Aboitiz Group is a diversified conglomerate in the Philippines with operations in power, banking, food, infrastructure, and real estate. One of its major subsidiaries, AboitizPower, is a leading energy provider committed to sustainable and reliable power solutions, employing nearly 4,000 people nationwide. Its corporate headquarters is in Bonifacio Global City, Taguig, with a major office in Cebu City.

As part of its digital transformation roadmap, AboitizPower launched Project Arkanghel, an initiative to modernize its coal-fired power plants into smart facilities—aimed at improving performance, reducing downtime, and fostering a data-driven culture. In partnership with REPCO NEX Industrial Solutions, AboitizPower is pioneering the first smart power plants in the Philippines. To complement this transformation, efficient employee training and development have become critical, especially for initiatives such as Boiler Digital Twin, Anomaly Detection, and Data Architecture.

Currently, training progress is tracked manually using Google Sheets, where administrators verify module completion per employee. Reporting is also done manually through Looker Studio, which lacks real-time analytics. Employees access training materials via multiple platforms like Google Drive and Box, creating inefficiencies and inconsistencies. With seven workstreams and numerous chapters to manage, this manual system is time-consuming, error-prone, and difficult to scale.

To address these challenges, we propose a Data-Driven Learning Management System (LMS)—a centralized platform designed to streamline training, automate assessments, and provide real-time dashboards for administrators. The LMS will allow easy module assignment, monitor learner progress, and deliver actionable analytics to support data-driven decisions. For employees, it consolidates training materials in one responsive, mobile-friendly interface built with Flutter and Dart, ensuring accessibility and engagement across locations.

By replacing fragmented, manual processes with a smart, integrated system, this LMS supports Project Arkanghel’s vision of operational excellence through technology and data-driven insights.

## Features

### Admin Features

*   **User Management:**
    *   View a comprehensive list of all registered users.
    *   Assign and update user roles (Admin or Employee).
    *   Easily remove users with a slide-to-delete gesture.

*   **Workstream Management:**
    *   Create, edit, and organize training workstreams.
    *   Structure learning paths for different departments or skill sets.

*   **Assessment Management:**
    *   Build and deploy assessments to evaluate employee knowledge.
    *   Track assessment completion and performance across the organization.

*   **Dashboard & Analytics:**
    *   Get a high-level overview of user activity and training progress from a central dashboard.
    *   Monitor the company-wide leaderboard to identify top performers.

### Employee Features

*   **Personalized Dashboard:**
    *   A dedicated dashboard to track personal progress and quickly access assigned modules.

*   **Learning Modules:**
    *   Browse and complete training modules at your own pace.
    *   Filter modules by category to easily find relevant content.

*   **Assessments & Results:**
    *   Take assessments to test your knowledge and complete workstreams.
    *   Instantly view your scores and pass/fail status in the "My Results" section.

*   **Leaderboard:**
    *   See your rank and compare your performance with colleagues on a gamified leaderboard.
    *   Stay motivated by competing for the top spots.

### Built With

*   [Flutter](https://flutter.dev/)
*   [Dart](https://dart.dev/)

## Key Dependencies

*   **[provider](https://pub.dev/packages/provider):** Used for state management to efficiently propagate changes throughout the app.
*   **[fl_chart](https://pub.dev/packages/fl_chart):** Powers the dynamic charts and graphs in the admin and employee dashboards.
*   **[url_launcher](https://pub.dev/packages/url_launcher):** Enables opening external links, useful for linking to supplementary resources.
*   **[intl](https://pub.dev/packages/intl):** Handles internationalization and date/number formatting for a consistent user experience.
*   **[file_picker](https://pub.dev/packages/file_picker):** Allows users to pick files from their device, essential for uploading assessment materials.
*   **[video_player](https://pub.dev/packages/video_player):** Integrates video playback for engaging learning modules.
*   **[flutter_pdfview](https://pub.dev/packages/flutter_pdfview):** Renders PDF documents directly within the app.
*   **[sliding_up_panel](https://pub.dev/packages/sliding_up_panel):** Implements elegant sliding panels for a modern UI.
*   **[webview_flutter](https://pub.dev/packages/webview_flutter):** Displays web content within the app, perfect for embedding articles or web pages.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

Make sure you have the Flutter SDK installed on your machine.
*   [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/your_username/app_arkanghel.git
    ```
2.  Navigate to the project directory
    ```sh
    cd app_arkanghel
    ```
3.  Install dependencies
    ```sh
    flutter pub get
    ```

### Running the App

1.  Connect a device or start an emulator.
2.  Run the app
    ```sh
    flutter run
    ```

## Usage

The application is designed for two main roles:

*   **Admin:** Manages the platform's content and users. Responsibilities include adding/updating user roles, creating workstreams, and deploying assessments.
*   **Employee:** Engages with the learning material. Can browse modules, complete assessments, and view personal results and leaderboard standings.

## Development Model

The team followed the **Agile development model** for creating the mobile application. This approach involves breaking the work into smaller parts and completing them in cycles, allowing for regular updates and improvements. The process includes the planning and gathering requirements phase, designing the app, developing its features, testing and fixing issues, launching the app, and reviewing the results. Using this method helped the team adjust to changes quickly and improve the app based on feedback and testing.

### Initiation and Requirement Analysis
In this phase, the team will define the project's main objective: to develop an Android mobile app with a clean and intuitive UI that provides real-time access to learning modules. The app's primary goal is to ensure smooth navigation and interaction with training content. Requirements will focus on optimizing the app for Android, using Flutter and Dart to build a responsive, accessible interface that meets the needs of the target users.

### Planning and Designing
The team will analyze the gathered requirements and identify the necessary tools and software for development. A wireframe design will be created to illustrate how the app's interface will appear. The design will prioritize clarity and ease of navigation, ensuring the layout is optimized for mobile devices.

### Development Sprint 1: Initial UI Build
During the first sprint, the team will focus on developing the core UI components such as the login screen, home screen, and course list. Flutter and Dart will be used to implement the app's interactive elements. The goal is to establish a functional and visually consistent interface, enabling users to easily access their training content.

### Development Sprint 2: UI Enhancements and Interactions
In the second sprint, the team will enhance the app by adding interactive UI elements such as progress bars, navigation menus, and action buttons. The interface will be refined to improve user flow and make interactions intuitive. The focus will also be on optimizing the layout for various Android screen sizes to ensure responsiveness and smooth navigation.

### App Testing and Debugging
Once the initial UI is implemented, the team will conduct comprehensive testing to verify that all interface components are functioning as expected. This includes testing the layout for responsiveness on various Android devices, ensuring that navigation and interactive buttons are working correctly. Any bugs or issues identified during testing will be addressed in this phase.

### Review and Feedback
The team will assess the design clarity, navigation efficiency, and overall interaction flow. The feedback will be incorporated into subsequent sprints to refine the app's interface and improve any aspects that require attention.

### Launch Preparation and Final Testing
Since this project primarily focuses on the user interface (UI), the application is not yet ready for deployment on the Google Play Store. However, upon completing all remaining development tasks and implementing the necessary features, it can be prepared for official release.

The final testing phase ensures that all routes, navigation flows, and core functions operate as intended. This includes verifying user interactions, screen transitions, and any integrated features to guarantee a smooth and error-free user experience.

## Getting Help

If you encounter any issues or have questions, please file an issue on the project's GitHub repository.

## Maintainers & Contributors

This project is maintained by student developers. We welcome contributions from the community. Please feel free to fork the repository and submit a pull request.


