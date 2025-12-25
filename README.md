# cs_310_project - Outfitly

OUTFITLY

## Short Description
A smart wardrobe assistant that allows users to digitize their clothing, create stylish outfits, receive personalized outfit suggestions, and share their style with friends.

## Main Purpose
Outfitly addresses the timeless problem of "I have a closet full of clothes, but nothing to wear." It solves this by creating a searchable, digital inventory of a user's entire wardrobe, preventing items from being forgotten. By offering a tool to create and save outfits, it reduces the daily stress and time spent on deciding what to wear. Furthermore, its suggestion engine provides inspiration and helps users maximize the potential of their existing clothes, promoting more sustainable fashion habits.

### Group Members
- **Ali Yılmaz** – 32281               (Project Coordinator)
- **Zeynep Okkıran** – 32304           (Testing & Quality Assurance Lead )
- **Nurgül Kardelen Kömürcü** – 32289  (Integration & Repository Lead )
- **Cem Kaya** – 31957                 (Documentation & Submission Lead )
- **Mete Yılmazbaş** – 34349           (Presentation & Communication Lead)

## Testing

The test `closet_item_model_test.dart` verifies that data retrieved from Firestore is correctly mapped into the item model and that a default placeholder image is used when the `imageUrl` field is missing, ensuring robustness against incomplete data.

The test `outfits_provider_add_test.dart` checks that the `OutfitsProvider` correctly exposes a stream of outfits, confirming that the provider’s interface supports reactive data flow to the user interface.

The test `login_page_test.dart` validates the login form by ensuring that an appropriate error message is displayed when an invalid email address is submitted, confirming correct client-side validation behavior.

The test `my_outfit_add_widget_test.dart` verifies that tapping the add outfit button on the My Outfits page correctly triggers navigation to the outfit creation screen, ensuring that the user interaction flow works as intended.


## How to Run Tests

Before running the tests, project dependencies are fetched using `flutter pub get`. The unit tests are executed individually using `flutter test test/closet_item_model_test.dart` and `flutter test test/outfits_provider_add_test.dart` to verify core application logic. The widget tests are then run using `flutter test test/login_page_test.dart` and `flutter test test/my_outfit_add_widget_test.dart` to validate user interface behavior and interactions. Finally, all tests can be executed together using the `flutter test` command, which runs the entire test suite and confirms that all tests pass successfully.
