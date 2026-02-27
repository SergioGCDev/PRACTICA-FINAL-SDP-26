# Tankōdex

> A manga collection manager for iOS and iPadOS, built with SwiftUI and SwiftData.

Tankōdex lets you browse top-rated manga, search by title or demographic, and track your personal collection — from wishlist to completed — with per-volume reading progress.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Requirements](#requirements)
- [Installation](#installation)
- [Screenshots](#screenshots)
- [Project Structure](#project-structure)
- [API](#api)

---

## Features

### Browsing
- **News screen** — top-rated featured cards and a recently-added section.
- **Search screen** — full-text search (3-character minimum) with demographic segmented filter.
- **Infinite scroll** — next pages are loaded automatically as the user scrolls.

### Collection management
- Add any manga to your library with a single tap, choosing its initial status.
- Four reading statuses: **Wishlist · Reading · Collected · Completed**.
- Track **volumes owned** and **current reading volume** per entry.
- Visual progress bar for collected manga; automatic completion badge.

### Profile & settings
- Custom display name and profile photo (stored in UserDefaults).
- Collection statistics: total manga, per-status counts, total volumes owned.
- Appearance picker: System / Light / Dark (persisted in AppStorage).

### Adaptive layout
- Dedicated **iPhone** (compact) and **iPad** (regular) layouts for every screen.
- Sidebar-adaptable `TabView` on iPad; search role tab on iPhone.

---

## Architecture

The project follows **MVVM** with a **Repository** pattern and **Clean Architecture** layering.

```
┌─────────────────────────────────────────────────────────────┐
│                          Views                              │
│   ContentView · NewsView · SearchView · LibraryView         │
│   MangaDetailView · ProfileSheetView · SettingsSheetView    │
└────────────────────────┬────────────────────────────────────┘
                         │ @Environment  (@Observable VMs)
┌────────────────────────▼────────────────────────────────────┐
│                      ViewModels                             │
│  generalVM · searchVM · libraryVM · ProfileVM               │
│  PaginationController (reusable paging helper)              │
└──────────┬──────────────────────────┬───────────────────────┘
           │ NetworkRepository        │ DataContainer (@ModelActor)
┌──────────▼──────────┐  ┌───────────▼───────────────────────┐
│   Networking Layer  │  │         SwiftData Layer            │
│  NetworkInteractor  │  │  MangaCollection  @Model           │
│  URLSession ext.    │  │  CRUD via Swift predicates         │
│  URLRequest ext.    │  └───────────────────────────────────┘
│  NetworkError       │
└─────────────────────┘
```

### Key patterns

| Pattern | Where |
|---|---|
| **MVVM + @Observable** | All ViewModels use the `@Observable` macro; Views observe state change-propagation through `@Environment`. |
| **Repository** | `NetworkRepository` protocol with a real (`Network`) and mock (`NetworkTest`) implementation — enables preview/test isolation. |
| **DTO → Domain** | API responses arrive as `*DTO` structs (snake_case JSON) and are transformed to clean domain models (`Manga`, `Author`, …) via `extension` converters. |
| **@ModelActor** | `DataContainer` is a Swift actor annotated with `@ModelActor`, keeping all SwiftData mutations off the main thread. |
| **Pagination** | `PaginationController` encapsulates page counter, append logic, and filter state; shared by `generalVM` and `searchVM`. |
| **async/await** | All network and persistence calls are `async throws`, integrated with SwiftUI `.task` modifier. |

---

## Tech Stack

| Technology | Usage |
|---|---|
| **SwiftUI** | Entire UI layer |
| **SwiftData** | Local persistence (`MangaCollection` model) |
| **@Observable** | Reactive state in ViewModels (iOS 17 Observation framework) |
| **async/await** | Structured concurrency across networking and persistence |
| **URLSession** | HTTP networking with custom `getData(for:)` extension |
| **PhotosUI** | Profile photo picker |
| **AppStorage / UserDefaults** | Theme preference and profile data |

---

## Requirements

| | Minimum |
|---|---|
| iOS / iPadOS | **26** |
| Xcode | **+26** |
| Swift | **6.0** |

> The project uses strict concurrency checking and typed `throws(NetworkError)`, which require Swift 6.

---



## Screenshots

> _Screenshots will be added once the UI is finalized._

| News (iPhone) | Library (iPad) | Search (iPhone) | Detail |
|:---:|:---:|:---:|:---:|
| _placeholder_ | _placeholder_ | _placeholder_ | _placeholder_ |

---

## Project Structure

```
Tankodex/
│
├── System/
│   └── TankodexApp.swift            # @main — ModelContainer + VM injection
│
├── Views/
│   ├── ContentView.swift            # Root TabView (sidebar-adaptable)
│   ├── NewsView.swift               # Featured + recently added manga
│   ├── SearchView.swift             # Search bar + demographic filter
│   ├── LibraryView.swift            # Collection grouped by reading status
│   ├── MangaDetailView.swift        # Detail sheet + collection editor
│   └── Toolbar/
│       ├── ProfileSheetView.swift   # Avatar, username, and stats
│       └── SettingsSheetView.swift  # Theme picker
│
├── Components/
│   ├── GenreFilterButton.swift      # Capsule toggle button for genre
│   ├── News/
│   │   ├── FeaturedMangaCard.swift  # Cover card for featured section
│   │   ├── GridMangaCard.swift      # Title card for grid layout
│   │   └── MangaRow.swift           # Row with cover, meta, swipe actions
│   ├── Tags/
│   │   ├── DemographicTag.swift     # Emoji/text pill for demographics
│   │   └── GenreTag.swift           # Colored capsule for genres
│   ├── Library/
│   │   ├── LibraryCard.swift        # Expanded card (iPad)
│   │   └── LibraryRow.swift         # Compact row (iPhone)
│   └── Toolbar/
│       ├── ToolbarGeneral.swift     # Profile + settings toolbar items
│       └── StatCard.swift           # Metric card for profile stats
│
├── ViewModels/
│   ├── generalVM.swift              # State for NewsView
│   ├── searchVM.swift               # State for SearchView + filters
│   ├── libraryVM.swift              # State for LibraryView + CRUD bridge
│   ├── ProfileVM.swift              # Username and photo persistence
│   └── PaginationController/
│       └── PaginationController.swift # Reusable page-loading logic
│
├── Models/
│   ├── Model.swift                  # Manga, Author, MangaListResult, PaginationMetadata
│   ├── ModelDTO.swift               # API DTOs + DTO→Domain transformations
│   ├── Genre.swift                  # Genre enum with color
│   ├── Demographic.swift            # Demographic enum with color, emoji, icon
│   └── DataModel/
│       ├── MangaCollection.swift    # @Model — persisted collection entry
│       ├── MangaCollectionDTO.swift # Sendable DTO for concurrency contexts
│       ├── ReadingStatus.swift      # Enum: wishlist/reading/collected/completed
│       └── DataContainer.swift      # @ModelActor — SwiftData CRUD operations
│
├── Repository/
│   └── NetworkRepository.swift     # Protocol + Network + NetworkTest impls
│
└── Interface/
    ├── NetworkInteractor.swift      # Protocol with generic getJSON helper
    ├── NetworkError.swift           # Typed error enum
    ├── URL.swift                    # API base URL + endpoint builders
    ├── URLRequest.swift             # Request factory (headers, timeout)
    └── URLSession.swift             # getData extension + error mapping
```

---

## API

The app consumes a public REST API provided by the AcademiaBSD course:

```
Base URL: https://mymanga-acacademy-5607149ebe3d.herokuapp.com
```

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/list/bestMangas?page=&per=` | Paginated list of top-rated manga |
| `GET` | `/list/mangaByDemographic/{demographic}?page=&per=` | Manga filtered by demographic |
| `GET` | `/search/manga/{id}` | Single manga by ID |
| `GET` | `/search/mangasContains/{title}?page=&per=` | Manga search by partial title |

Responses use **snake_case** JSON keys (decoded with `keyDecodingStrategy: .convertFromSnakeCase`) and **ISO 8601** dates.

---

## 🔜 Roadmap

- [ ] Separación de layouts iPhone/iPad en vistas dedicadas (`ContentViewiPhone`, `ContentViewiPad`)
- [ ] Caché de imágenes con Kingfisher o URLCache configurada
- [ ] Filtros por themes y autores
- [ ] Autenticación con JWT y colección en cloud
- [ ] Widget con progreso de lectura (WidgetKit)
- [ ] StoreKit 2 para modelo freemium
- [ ] Full accessibility support (VoiceOver, Dynamic Type, contrast)

---

## 📄 License

This project was created as a final practice assignment for the **SDP-26** course at AcademiaBSD.

MIT License © 2026 [Sergio García](https://github.com/sergiogcdev)
