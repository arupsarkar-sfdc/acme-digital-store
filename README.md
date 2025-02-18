# AcmeDigitalStore iOS Application

## Overview

The **AcmeDigitalStore** is a modular and scalable iOS application built using Swift. It integrates various frameworks and services to provide a seamless digital shopping experience. The app leverages **Swift Package Manager (SPM)** for dependency management and includes several custom components, models, services, and utilities to ensure maintainability and extensibility.

---

## Project Structure

### **1. Package Dependencies**
The app uses the following dependencies:
- **Cdp 2.0.4**: Likely handles customer data platform functionalities.
- **SFMCSDK 1.1.3**: Salesforce Marketing Cloud SDK for push notifications, in-app messaging, and analytics integration.
- **Swift-InAppMessaging 1.7.0**: Provides in-app messaging capabilities for user engagement.

---

### **2. Folder Structure**

#### **Config**
- Contains configuration files (e.g., `configFile`) for managing environment-specific settings or app constants.

#### **Events**
- Handles event-driven logic, possibly for analytics or user interaction tracking.

#### **Extensions**
- Contains Swift extensions to enhance existing classes or add reusable functionality.

#### **Images**
- Stores image assets used across the application.

#### **Models**
- Defines data structures for various entities like:
  - `Address`: Represents user addresses.
  - `CartItem`: Represents items in the shopping cart.
  - `Product`: Represents product details.
  - `Review`: Represents product reviews.

#### **Preview Content**
- Provides mock data or UI previews for SwiftUI development.

#### **Services**
This folder holds the core business logic and integrations:
- **ConsentService**: Manages user consent preferences (e.g., GDPR compliance).
- **DataCloudLoggingService**: Logs events to a data cloud service.
- **DataCloudService**: Handles interactions with Salesforce Data Cloud.
- **EinsteinPersonalizationService**: Integrates AI-driven personalization features.
- **EngagementTrackingService**: Tracks user engagement metrics.
- **LocationTrackingService**: Handles location-based services.
- **ProfileDataService**: Manages user profile data.
- **ProfileService**: Provides profile-related operations.
- **ReviewService**: Handles product review submissions and retrievals.
- **SalesforceJWTService**: Manages JWT authentication for Salesforce APIs.
- **TokenService**: Handles token generation and management.

#### **Utilities**
Contains helper classes and modifiers:
- `ConfigurationManager`: Manages app configurations.
- `LocationAwareViewModifier`: Adds location-based behavior to views.
- `ScreenTrackingViewModifier`: Tracks screen navigation events for analytics.

#### **ViewControllers**
Holds view controllers for managing UIKit-based screens (if applicable).

#### **Views**
This folder organizes SwiftUI views into components and screens:
1. **Components**:
   - `CheckoutView`: Handles checkout UI logic.
   - `PrivacySettingsView`: Displays privacy settings options.
   - `ProductCardView` & `ProductDetailView`: Show product information in card or detailed formats.
   - `ProfileCardView` & `ProfileFormView`: Manage user profile display and editing.
   - `SearchBar` & `ShoppingCartButton`: Provide search functionality and cart actions.

2. **Screens/Models**:
   - Contains primary views like:
     - `AccountView`: User account management screen.
     - `ChatView`: Chat or customer support interface.
     - `HomeView`: Main landing page with trending products (`TrendingProductsView`).
     - `ShoppingCartView`: Displays items in the user's cart.
     - `SearchResultsView`: Shows search results based on user queries.

#### **Assets**
Stores additional assets such as colors, fonts, or other resources used by the app.

---

## Key Features

### Dependency Management
The app uses Swift Package Manager (SPM) for integrating third-party libraries like SFMCSDK and Swift-InAppMessaging, ensuring easy updates and compatibility with modern iOS development practices.

### Modular Architecture
The project is organized into distinct modules (e.g., Services, Views, Utilities), promoting separation of concerns and scalability.

### Salesforce Integration
The app integrates with Salesforce's Marketing Cloud SDK to enable features like:
- Push notifications
- In-app messaging
- User engagement tracking

### AI Personalization
EinsteinPersonalizationService provides AI-driven recommendations tailored to individual users' preferences.

### Privacy Compliance
The ConsentService ensures compliance with privacy regulations like GDPR by managing user consent preferences effectively.

## Embedded Videos

To better understand the features of the AcmeDigitalStore application, check out the following video tutorials:

### [Real Time Einstein Personalization and Mobile Engagement](pplx://action/followup)
[![RT Personalization](https://play.vidyard.com/5h3CHqzXzuB8rQwR4vSHWo.jpg)](https://play.vidyard.com/5h3CHqzXzuB8rQwR4vSHWo)

### [Agentforce Chat](pplx://action/followup)
[![Agentic AI Chatbot](https://play.vidyard.com/HH2aF8pAX4uZVmNaPw2Fe9.jpg)](https://play.vidyard.com/HH2aF8pAX4uZVmNaPw2Fe9)

### [Ingestion API and Vector Database](pplx://action/followup)
[![Data Cloud VDB and Ingestion API](https://share.vidyard.com/watch/ntWrTYkD8Ga7r8ZWJucZdt.jpg)](https://share.vidyard.com/watch/ntWrTYkD8Ga7r8ZWJucZdt)

Click on any of the thumbnails above to watch the respective videos on Vidyard!

---
## Contributors

We would like to thank the following contributor(s) for their valuable contributions to this project:

- [@username](https://github.com/brendansheridan) - Added MIAW setup, configuration, agent and flow in service cloud org.

Your contributions make this project better! 🎉
## How to Run

1. Clone the repository:
2. Open the project in Xcode:
3. Install dependencies via SPM if not already resolved:
- Go to Xcode > File > Packages > Resolve Package Versions.

4. Build and run the project on your desired device or simulator.

---

## Contribution Guidelines

1. Fork the repository and create a feature branch:
2. Commit your changes with clear messages:
3. Push your branch and create a pull request.

---

