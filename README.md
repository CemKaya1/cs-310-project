# cs_310_project - Outfitly

OUTFITLY

## Project Overview & Motivation
Outfitly is a smart wardrobe assistant mobile application developed using Flutter and Firebase.
The motivation behind this project is to solve a common daily problem: having many clothes but struggling to decide what to wear. Outfitly helps users digitize their wardrobes, organize clothing items, and create outfit combinations in a simple and intuitive way.

By providing outfit creation and suggestion features, the application saves time, and encourages users to make better use of their existing clothes. This approach also promotes more sustainable fashion habits by discouraging unnecessary purchases. Outfitly addresses the timeless problem of “I have a closet full of clothes, but nothing to wear.”
It achieves this by:

-Creating a searchable digital inventory of the user’s wardrobe

-Preventing clothing items from being forgotten

-Allowing users to create, save, and manage outfits

-Reducing daily stress and time spent choosing outfits

-Supporting sustainable fashion practices

### Group Members
- **Ali Yılmaz** – 32281               (Project Coordinator)
- **Zeynep Okkıran** – 32304           (Testing & Quality Assurance Lead )
- **Nurgül Kardelen Kömürcü** – 32289  (Integration & Repository Lead )
- **Cem Kaya** – 31957                 (Documentation & Submission Lead )
- **Mete Yılmazbaş** – 34349           (Presentation & Communication Lead)
  
## Features

- User authentication using Firebase Authentication  
- Digital wardrobe management (add, view, and store clothing items)  
- Outfit creation and saving  
- Light and Dark mode support  
- Real-time data synchronization with Cloud Firestore
  
## Tech Stack

- **Flutter (Dart)**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
  
## Setup & Run Instructions

1. Install Flutter (recommended version: latest stable)
2. 
3. Clone the repository:
    ```bash
   git clone <repository-url>
    
4. Navigate to the project directory:
   
  cd cs_310_project

6. Install dependencies:
   
  flutter pub get

7. Configure Firebase:
   
-Create a Firebase project
-Enable Authentication and Cloud Firestore
-Add the Firebase configuration files (google-services.json / GoogleService-Info.plist)

9. Run the application:
   
 flutter run

## Testing

The project includes both unit tests and widget tests to ensure data integrity, UI correctness, and navigation flow.

The test `closet_item_model_test.dart` verifies that data retrieved from Firestore is correctly mapped into the item model and that a default placeholder image is used when the `imageUrl` field is missing, ensuring robustness against incomplete data.

The test `outfits_provider_add_test.dart` checks that the `OutfitsProvider` correctly exposes a stream of outfits, confirming that the provider’s interface supports reactive data flow to the user interface.

The test `login_page_test.dart` validates the login form by ensuring that an appropriate error message is displayed when an invalid email address is submitted, confirming correct client-side validation behavior.

The test `my_outfit_add_widget_test.dart` verifies that tapping the add outfit button on the My Outfits page correctly triggers navigation to the outfit creation screen, ensuring that the user interaction flow works as intended.

## How to Run Tests

Before running the tests, project dependencies are fetched using `flutter pub get`. The unit tests are executed individually using `flutter test test/closet_item_model_test.dart` and `flutter test test/outfits_provider_add_test.dart` to verify core application logic. The widget tests are then run using `flutter test test/login_page_test.dart` and `flutter test test/my_outfit_add_widget_test.dart` to validate user interface behavior and interactions. Finally, all tests can be executed together using the `flutter test` command, which runs the entire test suite and confirms that all tests pass successfully.
