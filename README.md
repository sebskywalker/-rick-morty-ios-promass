# Rick & Morty iOS App

A native iOS application built with UIKit + SwiftUI that consumes the Rick & Morty API.

This project was developed as part of a technical iOS challenge focused on:
- API integration
- pagination
- local persistence
- UIKit architecture
- SwiftUI interoperability
- offline handling

---

# Features

## Characters List
- Fetch characters from the Rick & Morty API
- Infinite scroll pagination
- Search characters by name
- Dark mode support
- Dynamic favorites system

## Character Detail
- Detail screen built with SwiftUI
- UIKit → SwiftUI navigation using UIHostingController
- Extended character information
- Responsive UI for light and dark mode

## Favorites
- Save favorite characters
- Remove favorites directly from:
  - Characters screen
  - Favorites screen using swipe-to-delete
- Core Data persistence
- Favorites available offline

## Offline Mode
- Internet connection detection
- Offline alert handling
- Fallback to saved favorites

## Launch Screen
- Custom launch screen
- Light mode and dark mode support
- Responsive centered logo

---

# Technologies Used

- Swift
- UIKit
- SwiftUI
- Core Data
- URLSession
- UITableView
- UISearchController
- UITabBarController
- UINavigationController

---

# Architecture

This project follows a UIKit MVC architecture with SwiftUI interoperability for the detail screen.

```text
UIKit
│
├── UITableView
├── NavigationController
├── TabBarController
├── Core Data
│
└── SwiftUI
    └── CharacterDetailView
```

---

# Project Structure

```text
controller/
model/
services/
view/
```

---

# Screenshots

## Characters

| Light Mode | Dark Mode |
|---|---|
| <img src="screenshots/caracters.png" width="250"> | <img src="screenshots/darkmodecharacters.png" width="250"> |

---

## Character Detail

| Light Mode | Dark Mode |
|---|---|
| <img src="screenshots/details.png" width="250"> | <img src="screenshots/darkmodedetails.png" width="250"> |

---

## Favorites

| Light Mode | Dark Mode |
|---|---|
| <img src="screenshots/favorites.png" width="250"> | <img src="screenshots/darkmodefavorites.png" width="250"> |

---

## Search Characters

<img src="screenshots/serch.png" width="250">

---

## Remove Favorites

### Swipe To Delete

| Before Delete | Delete Action |
|---|---|
| <img src="screenshots/deletefav2.png" width="250"> | <img src="screenshots/deletefav1.png" width="250"> |

---

## Offline Alert

<img src="screenshots/no internet.png" width="250">

---

## Launch Screen

| Light Mode | Dark Mode |
|---|---|
| <img src="screenshots/launch.png" width="250"> | <img src="screenshots/launchdark.png" width="250"> |

---

# Installation

1. Clone the repository

```bash
git clone <your-repo-url>
```

2. Open the project in Xcode

3. Run the app on simulator or physical device

---

# API

Rick & Morty API:
https://rickandmortyapi.com/

---

# Future Improvements

- Image caching
- Pull to refresh
- Unit testing
- Better loading states
- Improved animations
- Enhanced offline persistence

---

# Author

Sebastián Verástegui

iOS Developer
