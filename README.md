# Greeting App – Tết Greeting Toolkit

Manage your entire Lunar New Year outreach workflow in one Flutter app: import contacts in bulk, organize them by relationship, design bespoke greeting cards, and share or call right from the canvas while keeping statuses in sync offline.

## Table of Contents

1. [Feature Highlights](#feature-highlights)
2. [App Architecture](#app-architecture)
3. [Tech Stack](#tech-stack)
4. [Getting Started](#getting-started)
5. [Project Structure](#project-structure)
6. [Development Workflow](#development-workflow)
7. [Feature Walkthrough](#feature-walkthrough)
8. [Troubleshooting](#troubleshooting)
9. [Roadmap](#roadmap)

## Feature Highlights

### 1. Smart contact ingestion
- Pulls the device address book with `flutter_contacts`, normalizes phone numbers, and hides entries that already live in SQLite (see [lib/viewmodels/contact/contact_import_view_model.dart](lib/viewmodels/contact/contact_import_view_model.dart)).
- Batch-import contacts with a single relationship tag (Gia đình, Sếp, Bạn bè, Đồng nghiệp) so they immediately land in the right segment.
- Permission gate guides the user when Contacts access is still pending.

### 2. Relationship-first contact hub
- Tết-themed list UI ([lib/views/contact_list_screen.dart](lib/views/contact_list_screen.dart)) with sticky filters for both greeting status (Chưa gửi, Đã gọi, Đã nhắn) and relationship segments powered by [lib/core/widgets/contact_filter_drawer.dart](lib/core/widgets/contact_filter_drawer.dart).
- Inline actions let you refresh, edit a contact’s relationship, or delete the record without leaving the screen.
- Status chips reflect the outreach stage and automatically update when you call or share a card from the detail view.

### 3. Greeting card design studio
- Canvas ([lib/core/widgets/greeting_card_canvas.dart](lib/core/widgets/greeting_card_canvas.dart)) supports background swaps, draggable/resizable stickers, and styled calligraphy text using custom fonts declared in [pubspec.yaml](pubspec.yaml).
- Editor tools ([lib/core/widgets/edit_tools.dart](lib/core/widgets/edit_tools.dart)) offer color pickers, AI-ready suggestion slots, and sticker controls (scale, rotation, reset, delete).
- Uses `screenshot`, `gal`, and `share_plus` through [lib/data/repositories/impl/greeting_export_repository_impl.dart](lib/data/repositories/impl/greeting_export_repository_impl.dart) to capture, save, and share cards at 3× pixel density.

### 4. Follow-up automation
- Call recipients via `url_launcher` straight from the footer ([lib/core/widgets/contact_footer.dart](lib/core/widgets/contact_footer.dart)) and instantly mark the interaction as Đã gọi.
- Sharing a card prompts to update the status to Đã nhắn so the list stays trustworthy.

### 5. Offline-first data layer
- Contacts live entirely on-device inside `sqflite` tables configured in [lib/data/local/app_database.dart](lib/data/local/app_database.dart); no network is required once the app launches.
- Repository interfaces (e.g., [lib/data/repositories/contact_repository.dart](lib/data/repositories/contact_repository.dart)) decouple storage from UI, making it easy to swap implementations or add remote sync later.

## App Architecture

Provider-driven MVVM keeps UI reactive and the data layer testable:

```
Flutter Views → ViewModels (ChangeNotifier) → Repositories → DAO → SQLite
```

- Dependency injection is centralized in [lib/core/app_providers.dart](lib/core/app_providers.dart) via `Provider`/`MultiProvider`.
- ViewModels inside [lib/viewmodels](lib/viewmodels) expose intent-specific APIs (`loadAll()`, `applyFilters()`, `exportAndShare()`), keeping widget trees lean.
- Repositories in [lib/data/repositories](lib/data/repositories) delegate to DAO classes (currently [lib/data/local/daos/contact_dao.dart](lib/data/local/daos/contact_dao.dart)) to keep SQL out of the UI layer.
- The theming layer in [lib/core/theme](lib/core/theme) defines a reusable Tet color system plus a reusable app bar gradient.

## Tech Stack

| Category | Packages / Tools |
| --- | --- |
| UI & State | Flutter (Material 3), Provider |
| Persistence | sqflite, path_provider |
| Contacts & Device APIs | flutter_contacts, url_launcher, image_picker |
| Media & Sharing | screenshot, gal, share_plus |
| Utilities | uuid, path, google_generative_ai (reserved for future smart suggestions) |

## Getting Started

1. **Prerequisites**
	- Flutter SDK ≥ 3.10 (matches the `environment` constraint).
	- Xcode 15 / Android Studio Iguana with platform SDK 34.
	- A device or emulator with contact and storage permissions enabled.
2. **Install dependencies**
	```bash
	flutter pub get
	```
3. **Run the app**
	```bash
	flutter run
	```
4. **Hot reload** during development with `r` in the running terminal.

> **Note:** Android requires CONTACTS and READ/WRITE_EXTERNAL_STORAGE permissions. iOS needs the corresponding usage descriptions in `Info.plist`. Update [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) or `Runner/Info.plist` if you customize permission copy.

## Project Structure

```
lib/
├─ core/                  # Theme, provider wiring, shared widgets
├─ data/
│  ├─ domain/             # Plain models (Contact, StickerItem)
│  ├─ local/              # SQLite database + DAO
│  └─ repositories/       # Abstract + concrete repositories
├─ viewmodels/            # Contact + greeting card ChangeNotifiers
└─ views/                 # Screens (splash, list, import, detail)
assets/
├─ background/
├─ fonts/                 # ThuPhap, UVNSangSong calligraphy sets
├─ logo/
└─ stickers/
```

## Development Workflow

- **Code style**: Flutter lints (see `analysis_options.yaml`). Run `flutter analyze` before committing.
- **Testing**: Execute widget tests (currently [test/widget_test.dart](test/widget_test.dart)) with `flutter test` and extend as you add features.
- **Hot reload friendly state**: ViewModels avoid async work in constructors; initialization happens inside `initState` (e.g., `ContactListScreen.initState`) for predictability.
- **Assets**: When adding new stickers or backgrounds, register them under the existing `flutter.assets` list in [pubspec.yaml](pubspec.yaml).

## Feature Walkthrough

| Screen | Description |
| --- | --- |
| Splash | Full-screen hero image with calligraphy headline before transitioning to the list ([lib/views/splash_screen/splash_creen.dart](lib/views/splash_screen/splash_creen.dart)). |
| Contact List | Filterable index of imported contacts with edit/delete/status chips and entry points to import or design cards. |
| Contact Import | Loads phone contacts, filters out previously imported numbers, and bulk-tags them into relationship cohorts. |
| Greeting Detail | Full design surface with canvas, editor tools, sticker picker, save/share, and follow-up CTA. |

## Troubleshooting

- **Contacts permission denied**: Use the in-app “Cấp quyền truy cập” button or re-enable permissions from system settings before retrying the import flow.
- **Gallery save fails**: Ensure the `MANAGE_EXTERNAL_STORAGE` (Android 11+) or Photo Library usage string (iOS) are set; `gal` will throw silently otherwise.
- **Card capture shows sticker outlines**: The ViewModel temporarily deselects stickers before capturing, but if you still see borders, increase the delay in `exportAndSave` or avoid interacting with stickers mid-export.
- **Hot reload loses providers**: Keep `MyApp` stateless and let `MultiProvider` rebuild; avoid caching `BuildContext` in long-lived services.

## Roadmap

1. Plug the `google_generative_ai` client into the message suggestion popup for context-aware greetings.
2. Persist sticker arrangements per contact so you can revisit drafts.
3. Add analytics on outreach coverage (e.g., % of Gia đình already contacted).
4. Ship localization toggles (vi-VN / en-US) using `flutter_localizations`.

---

Happy Tết and happy coding!
#   g r e e t i n g - a p p  
 