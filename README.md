# 🛍️ Daraz Clone — Flutter

A production-ready e-commerce app clone built with Flutter & GetX, featuring a clean scroll architecture, tabbed product browsing, pull-to-refresh, and live product search.

---

## 📸 Screenshots

> _Add your screenshots here after running the app._

| Home Screen | Product Detail | Search | Pull-to-refresh |
|:-----------:|:--------------:|:------:| :--------------:
| https://drive.google.com/file/d/1gqurt0OvDGFugv1xXnigrb7Vs5My8NzQ/view?usp=sharing | https://drive.google.com/file/d/1n8tA_eiPcbEfNApO1R_6JDWP4E3aopsN/view?usp=sharing| https://drive.google.com/file/d/1FlX3yHishFPwMEIAa96RZpgesiUJoYT6/view?usp=sharing |  https://drive.google.com/file/d/1lcapTb5RXMZ7RSBsUmqg-XrzdVk9kQZ1/view?usp=sharing |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- An Android emulator, iOS simulator, or physical device

### Run Instructions

```bash
# 1. Clone the repository
git clone https://github.com/your-username/daraz-clone.git
cd daraz-clone

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

> **Tip:** Use `flutter run --release` for a performance build.

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| [`get`](https://pub.dev/packages/get) | State management, navigation, dependency injection |
| [`http`](https://pub.dev/packages/http) | REST API calls to FakeStore API |
| [`custom_refresh_indicator`](https://pub.dev/packages/custom_refresh_indicator) | Daraz-style pull-to-refresh animation |

---

## 🏗️ Project Structure

```
lib/
├── core/
│   └── colors/
│       └── app_colors.dart          # App-wide color constants
├── feature/
│   ├── auth/
│   │   └── view/
│   │       └── login_screen.dart    # Login screen
│   └── home/
│       ├── controller/
│       │   ├── home_controller.dart          # Tab, product, search logic
│       │   └── description_controller.dart   # Product detail logic
│       ├── model/
│       │   ├── product_model.dart            # Product list model
│       │   └── product_description_model.dart
│       ├── view/
│       │   ├── home_screen.dart              # Main tabbed home screen
│       │   └── product_description_screen.dart
│       └── widget/
│           ├── product_card_widget.dart      # Grid card + SliverGrid
│           ├── shimmer_loader.dart           # Loading skeleton
│           └── product_description_shimmer.dart
└── main.dart
```

---

## 🧱 Scroll Architecture

This is the most critical design decision in the app. Here is a full breakdown.

### The Problem

The screen needs three scroll behaviours to coexist without conflict:

1. A **collapsible header** (search bar + flash sale banner) that scrolls away.
2. A **sticky TabBar** that pins at the top once the header is gone.
3. **Per-tab independent vertical scrolling** for each product grid.
4. **Horizontal swipe** to switch between tabs.

Naively nesting a `PageView` inside a `ListView` causes gesture conflicts — Flutter's gesture arena cannot determine whether a drag belongs to the horizontal swipe or the vertical scroll.

### The Solution: `NestedScrollView` + `TabBarView`

```
Scaffold
├── bottomNavigationBar: _WelcomeCard
└── body: SafeArea
    └── Obx (isLoading / error / ready)
        └── NestedScrollView                   ← outer vertical scroll
            ├── headerSliverBuilder
            │   ├── SliverOverlapAbsorber
            │   │   └── SearchBar + FlashSaleBanner   (collapses)
            │   └── SliverPersistentHeader (pinned)
            │       └── TabBar                 ← sticky tab selector
            └── body: TabBarView               ← horizontal swipe owner
                └── _TabBody × N
                    └── Builder                ← required for context
                        └── CustomRefreshIndicator
                            └── CustomScrollView   ← inner vertical scroll
                                ├── SliverOverlapInjector
                                └── ProductSliverGrid
```

---

### 1. Horizontal Swipe — `TabBarView`

`TabBarView` is the **sole owner** of horizontal swipe gestures.

- It internally wraps a `PageView`, which claims horizontal drag gestures from Flutter's gesture arena before any vertical recogniser can.
- Both the `TabBar` header and `TabBarView` share one `TabController` (created in `HomeController` using `GetSingleTickerProviderStateMixin`).
- Tapping a tab label and swiping the body both drive the same controller — they are always in sync.
- No custom `GestureDetector` is needed for swiping.

---

### 2. Vertical Scroll — `NestedScrollView` + `CustomScrollView`

| Layer | Widget | Responsibility |
|---|---|---|
| **Outer** | `NestedScrollView` | Scrolls the collapsible header off-screen |
| **Sticky** | `SliverPersistentHeader` | Pins the `TabBar` — never scrolls away |
| **Inner** | `CustomScrollView` (one per tab) | Scrolls the product grid independently per tab |

`NestedScrollView` coordinates the outer and inner scroll controllers automatically, forwarding scroll energy between them depending on remaining header extent.

#### The Absorber / Injector Bridge

```dart
// In headerSliverBuilder — records overlap pixels
SliverOverlapAbsorber(
  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  sliver: SliverToBoxAdapter(child: /* SearchBar + Banner */),
)

// In each tab's CustomScrollView — injects that padding
SliverOverlapInjector(
  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(innerContext),
)
```

Without this pair, the first product card would be hidden behind the pinned `TabBar`.

#### Why `Builder` is Required

```dart
// _TabBody wraps its content in Builder so that:
Builder(
  builder: (innerContext) {  // <-- descendant of NestedScrollView
    // innerContext is used here, NOT the outer context
    SliverOverlapInjector(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(innerContext),
    )
  }
)
```

`sliverOverlapAbsorberHandleFor` requires a `BuildContext` that is a **descendant** of `NestedScrollView`. Without `Builder`, Flutter throws an assertion error at runtime.

#### Per-Tab Scroll Position Memory

```dart
CustomScrollView(
  key: PageStorageKey<int>(tabIndex), // Flutter remembers scroll offset per tab
  physics: const AlwaysScrollableScrollPhysics(), // enables pull-to-refresh on short lists
)
```

---

### 3. Trade-offs & Limitations

| Issue | Detail |
|---|---|
| **Diagonal drags** | Flutter's gesture arena lets the horizontal (PageView) and vertical (ScrollView) recognisers compete. Diagonal drags may feel slightly sluggish — inherent platform limitation. |
| **`TabController` recreation** | If the number of product categories changes after a refresh, `TabController` must be disposed and rebuilt. The guard in `HomeController` minimises visible flicker, but a brief re-render is possible. |
| **Pull-to-refresh offset** | `Transform.translate` shifts the list down visually during pull. This can clip the bottom of short lists. An `EdgeInsets` animation approach is cleaner but more verbose. |
| **Full `NestedScrollView` rebuild on search** | `Obx` wraps the entire `NestedScrollView`, so every keystroke triggers a full rebuild. Scoping `Obx` to only the `ProductSliverGrid` would be more efficient at scale. |
| **Client-side search only** | `getProductsForTab()` filters `allProducts` in memory. For large catalogues this should be a debounced API call. |

---

## 🔌 API

This app uses the free [FakeStore API](https://fakestoreapi.com/).

| Endpoint | Usage |
|---|---|
| `GET /products` | Fetch all products for the home grid |
| `GET /products/:id` | Fetch single product for the detail screen |

---

## ✨ Features

- [x] Tabbed product browsing (auto-generated from API categories)
- [x] Collapsible header with sticky tab bar
- [x] Horizontal swipe to switch tabs
- [x] Independent per-tab vertical scroll with position memory
- [x] Custom Daraz-style pull-to-refresh animation
- [x] Live client-side search with clear button
- [x] Product detail screen
- [x] Shimmer loading skeletons
- [x] Error state handling

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

---

