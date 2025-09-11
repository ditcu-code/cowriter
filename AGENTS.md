# Repository Guidelines

## Project Structure & Module Organization
- Xcode project: `cowriter.xcodeproj` (primary target: `cowriter`).
- Source: `cowriter/Sources/` → `Views/` (SwiftUI), `ViewModels/`, `Services/` (APIEndpoint, OpenAI/Deepseek, Supabase, CloudKit), `Models/`, `Data/` (Core Data), `Utilities/`.
- Resources: `cowriter/Resources/` → `Assets.xcassets`, `Info.plist`, `Localizable.strings` in `*.lproj`, `Secrets.xcconfig`.
- StoreKit configs: `SubPro.storekit`, `SwiftChatStoreKit.storekit` for IAP testing.

## Build, Test, and Development Commands
- Open in Xcode: `open cowriter.xcodeproj`
- List schemes: `xcodebuild -list -project cowriter.xcodeproj`
- Build (Debug): `xcodebuild -scheme cowriter -configuration Debug build`
- Simulator build: `xcodebuild -scheme cowriter -destination 'platform=iOS Simulator,name=iPhone 15' build`
- Tests: No XCTest target is present yet. When added (e.g., `cowriterTests`), run: `xcodebuild test -scheme cowriter -destination 'platform=iOS Simulator,name=iPhone 15'`

## Coding Style & Naming Conventions
- Swift 5+, format with Xcode defaults; 4-space indentation; 120-col soft wrap.
- Types: UpperCamelCase; functions/properties: lowerCamelCase; enum cases: lowerCamelCase.
- One primary type per file; filename matches type (e.g., `WelcomeVM.swift`).
- Organize by existing folders; UI in `Views/…`, state in `ViewModels/…`, side effects in `Services/…`.
- Localization: add keys to `Resources/<lang>.lproj/Localizable.strings` and reference via `Text("key")`.

## Testing Guidelines
- Framework: XCTest. Place tests in `cowriterTests/` (e.g., `WelcomeVMTests.swift`).
- Name tests clearly: `testFeature_case_expected()`; prefer small, focused tests.
- Prioritize `Services/` and `ViewModels/`; use dependency injection and in-memory Core Data stores.
- Aim for meaningful coverage on core logic; UI snapshot tests optional.

## Commit & Pull Request Guidelines
- Commits: imperative, concise, one logical change (e.g., “Add StoreKit configuration”, “Update project settings; bump marketing version”).
- PRs: clear description, linked issues (`#123`), screenshots for UI changes, test/verification steps, localization updates noted.
- Versioning: include marketing version bumps in a separate commit when applicable.

## Security & Configuration
- Never commit real credentials. Treat `Secrets.xcconfig` as example-only; prefer a local `Secrets.local.xcconfig` (git-ignored) to override values.
- Rotate external keys if exposure is suspected (e.g., Supabase anon key) and update configs accordingly.
