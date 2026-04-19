# 🎬 TMDB Movies App

An iOS app built with **SwiftUI** that lets users browse, search, and explore movies using the [TMDB API](https://www.themoviedb.org/documentation/api).

---

## ✨ Features

- Browse movies with infinite pagination
- Filter movies by genre
- Local search across loaded movies
- Movie details (overview, genres, budget, revenue, runtime, and more)
- Offline support with local caching
- Image caching for faster load times

---

## 🏗️ Architecture

The app follows **Clean Architecture** with clear separation of concerns:

```
Presentation  →  ViewModel (ObservableObject + Combine)
Domain        →  UseCases + Protocols
Data          →  Remote Repositories + Network Layer
```

**Design Pattern:** MVVM  
**Reactive layer:** Combine  
**UI Framework:** SwiftUI  

---

## 🗂️ Project Structure

```
TMDB/
├── MoviesList/
│   ├── View/               # SwiftUI Views
│   ├── ViewModel/          # Business logic
│   ├── UseCase/            # Domain layer
│   ├── Repository/         # Data layer
│   ├── Model/              # Request & Response models
│   └── Configurator/       # Dependency injection
│
├── MovieDetails/
│   ├── View/
│   ├── ViewModel/
│   ├── UseCase/
│   ├── Repository/
│   ├── Model/
│   └── Configurator/
│
└── Core/
    ├── Network/            # JahezNetwork client
    ├── Cache/              # Movies + image caching
    └── Utilities/          # Constants, helpers
```

---

## 🔧 Requirements

| Tool | Version |
|------|---------|
| Xcode | 15.0+ |
| iOS | 16.0+ |
| Swift | 5.9+ |

---


## 📦 Dependencies

Managed via **Swift Package Manager**:

| Package | Purpose |
|---------|---------|
| `JahezNetwork` | Networking layer |
| `JahezDesign` | Shared UI components |
| `JahezUtilities` | Shared utilities and helpers |
