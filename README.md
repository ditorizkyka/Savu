# Savu — Developer Code of Conduct & Coding Guidelines

> **Purpose**: Ensure every contributor writes consistent, debuggable, and merge-friendly code.

---

## 1. Architecture (MVVM)

```
savuapp/
├── savuappApp.swift       → App entry point, ModelContainer setup
├── Models/                → SwiftData @Model classes
├── Views/                 → SwiftUI Views (screens + reusable components)
├── ViewModels/            → @Observable ViewModels (business logic)
└── Assets.xcassets/       → Images, colors, app icon
```

### Rules

- **Models** → SwiftData `@Model` classes. One file per model.
- **ViewModels** → `@Observable` classes. Receive `ModelContext` via init. Contain all business logic.
- **Views** → SwiftUI structs. Bind to ViewModel state. Call ViewModel methods. No business logic.
- Views create ViewModels using `@Environment(\.modelContext)`.

---

## 2. Naming Conventions

| Element         | Convention           | Example                 |
| --------------- | -------------------- | ----------------------- |
| Files           | PascalCase           | `NotesViewModel.swift`  |
| Types/Protocols | PascalCase           | `Note`                  |
| Variables/Funcs | camelCase            | `loadNotes()`           |
| Constants       | camelCase            | `let maxRetryCount = 3` |
| ViewModels      | `{Feature}ViewModel` | `NotesViewModel`        |
| Views           | `{Feature}View`      | `NotesView`             |
| Models          | Singular noun        | `Note`, `Category`      |

---

## 3. File Organization Within a Swift File

```swift
// MARK: - Imports
import SwiftUI

// MARK: - Protocol (if applicable)

// MARK: - Main Type Declaration
struct/class/enum ...

// MARK: - Properties (stored, then computed)

// MARK: - Initializer

// MARK: - Public Methods

// MARK: - Private Methods

// MARK: - Extensions

// MARK: - Preview (Views only)
```

---

## 4. MVVM Rules

### Views

- **No business logic** in Views. Views only bind to ViewModel properties and call ViewModel methods.
- Use `@State` only for **local UI state** (e.g., sheet presented, text field focus).
- Use `@Environment(\.modelContext)` to get `ModelContext` and pass it to ViewModels.

### ViewModels

- Must use `@Observable` macro.
- Expose **`private(set)`** for state the View reads.
- Expose **methods** for actions the View triggers.
- Receive `ModelContext` via `init` — keeps them testable.
- Name state clearly: `notes`, `isLoading`, `errorMessage`.

### Models

- SwiftData `@Model` classes in `Models/`.
- One file per model.
- Include `createdAt` and `lastModifiedAt` timestamps.

---

## 5. Storage Rules (Offline-Only)

1. **Local SwiftData is the single source of truth.** No network layer.
2. `ModelContainer` is set up once in `savuappApp.swift` via `.modelContainer(for:)`.
3. ViewModels receive `ModelContext` and perform all CRUD.
4. Data flow: User action → ViewModel method → ModelContext → ViewModel reloads state.

---

## 6. Error Handling

- Never force-unwrap optionals outside of previews.
- ViewModels catch errors and set `errorMessage: String?` for the View to display.
- Views show errors via `.alert()` bound to `errorMessage`.

---

## 7. Git & Branching Rules

| Branch           | Purpose                            |
| ---------------- | ---------------------------------- |
| `main`           | Production-ready, always buildable |
| `develop`        | Integration branch                 |
| `feature/{name}` | New feature work                   |
| `bugfix/{name}`  | Bug fixes                          |
| `hotfix/{name}`  | Urgent production fixes            |

### Commit Message Format

```
type(scope): short description

[optional body]
```

**Types**: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`

**Examples**:

```
feat(notes): add create note functionality
fix(storage): resolve crash on empty model context
refactor(di): simplify dependency injection setup
```

### Pull Request Rules

- PRs must target `develop` (never push directly to `main`).
- Every PR needs at least **1 reviewer approval**.
- PR title follows the same commit message format.
- Squash-merge to keep history clean.
- Delete feature branch after merge.

---

## 8. Code Quality Standards

- **No warnings allowed** — treat warnings as errors.
- **No `print()` in production code** — use `os.Logger` or remove before merging.
- **No magic numbers/strings** — use constants or enums.
- **No massive files** — if a file exceeds ~300 lines, split it.
- **No deep nesting** — use guard/early return to flatten logic.
- Mark TODOs with your name: `// TODO: (yourname) - description`.

---

## 9. Testing Expectations

- Every ViewModel should have unit tests.
- Use in-memory `ModelContainer` for test isolation.
- Test file naming: `{ClassName}Tests.swift`.

---

## 10. Accessibility

- Every interactive element needs an `.accessibilityLabel()`.
- Support Dynamic Type — avoid hard-coded font sizes.
- Test with VoiceOver periodically.

---

## 11. Performance

- Use `FetchDescriptor` with sort/predicate — avoid fetching everything.
- Use `LazyVStack` / `LazyHStack` for large lists.
- Prefer `.task {}` for async work (auto-cancelled on disappear).

---

_Last updated: March 2026_
