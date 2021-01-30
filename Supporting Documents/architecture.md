# Architecture

The app consists of multiple so-called modules. Our main modules correspond to the direct subfolders of `flutter/lib/`.

Existing/planned modules:

- `app`: Provides common things for other modules (like brand variables, utility methods, etc.), defines the main application widget & main screen, and combines all other modules via its routing.
- `auth`: contains sign-in/-out pages and the `AuthService` managing the current user
- `feed`: retrieves & displays the main content stream
- `favorites`*
- `explore`*
- `profile`*
- `settings`
- `messenger`*
- `content`: Contains submodules per main type of content. Each submodule has data classes, can access these contents from Firestore, and can convert them into declarative descriptions that can e.g. be converted to info cards.
  - `congrats`*
  - `company`*
  - `job`
  - `job_field`*
  - `job_offer`*
  - `external_offer`*
  - `ranking`*
  - `topic`*
  - `user`
  - `quiz`*

> Modules with an asterisk (*) are not yet implemented, but planned for the future.

## Modules

Structure of `my_module`:

- `my_module`
  - `module.dart`:
    - exports everything that is required by other modules
    - declares all routes as a final variable (`myModuleRoutes`)
    - may contain initialization code (`initMyModule()`)
  - `cubit.dart`: contains `MyModuleCubit` and `MyModuleState`s
  - `widgets`:
    - `my_widget.dart`: contains `MyWidget` and helpers
  - `pages`:
    - `my_first.dart`: contains `MyFirstPage` and helpers
    - `my_complex`: create a folder for complex pages (e.g., tabbed ones)
      - `page.dart`: contains `MyComplexPage`
      - `tab_first.dart`: contains `FirstTab` and helpers
      - `tab_second.dart`: contains `SecondTab` and helpers
      - `utils.dart`: contains utilities used by multiple files in this page
  - `utils.dart`: contains utilities used throughout this module
  - `submodule_one`
  - `submodule_two`

> helpers: optional, local (private) utility methods/classes/etc.

If a single file gets too complex for routes, the `Cubit`, a widget, a page, etc., you can create a folder with the same name and split the original file into different files. An example of that is `MyComplexPage` in the file tree above.

## Persistence

We use different kinds of persistence for different kinds of data:

- Firestore: Stores our main entities and is also cached locally.
- Shared Preferences: Configuration data like local settings.

---

**Next read**: [Internationalization and Localization](i18n-l10n.md)
