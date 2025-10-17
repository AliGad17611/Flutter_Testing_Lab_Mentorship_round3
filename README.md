# Flutter Testing Laboratory - Week 4 Assignment

## 🧩 Overview
This project is part of the Flutter Mentorship Round 3 (Week 4 Assignment).
It focuses on **Git workflow** and **Flutter testing** (unit, widget, and integration).

---

## 🧱 Fixed Widgets
### 1️⃣ User Registration Form
- Added proper email regex validation.
- Implemented strong password rules (length, uppercase, digit, symbol).
- Form now validates all fields before submission.
- Added unit and widget tests for validation.

### 2️⃣ Shopping Cart
- Fixed duplicate item handling.
- Corrected discount and total calculations.
- Added comprehensive unit tests for cart operations and edge cases.

### 3️⃣ Weather Display
- Corrected temperature conversion formulas.
- Added null safety and error handling for API responses.
- Fixed loading state management.
- Added unit and widget tests.

---

## 🧰 Git Workflow Used
1. Forked the provided repository.
2. Created `develop` branch from `main`.
3. For each widget:
   - Created a feature branch (e.g., `feature/widget1-registration`).
   - Fixed issues, wrote tests.
   - Created a detailed Pull Request describing:
     - Bugs fixed
     - Solutions
     - Test summary
4. Merged all features into `develop`, then merged `develop` into `main`.

---

## 🧪 Testing
All tests are implemented and passing.

Run tests using:
```bash
flutter test
