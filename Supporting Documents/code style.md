# Code Style

For things not mentioned in this document, the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines apply.

## 1. General

### 1.1. Language

All comments, identifiers, issues, etc. should be written in English.

### 1.2. Line length

Lines in non-documentation files should be at most 80 chars wide.

Exceptions:

- hard-coded URLs (e.g., in comments)
- TODO comments should stay on a single line, so that tools can read & report the full message

Put calls in a single line if they are simple and fit:

```dart
return Container(color: Colors.pink, child: myChild);
```

Wrap if there are more than two named parameters, they get longer or more complicated:

```dart
return Container(
  color: context.theme.primaryColor,
  padding: EdgeInsets.symmetric(horizontal: 16),
  child: myChild,
);
```

### 1.3. `import`

Imports of packages and other modules are absolute (`import 'package:flutter/material.dart'`, `import 'package:sudokuSolver/app/module.dart'`), whereas imports of files in the same module are relative (`import '../utils.dart'`).

## 2. Naming

### 2.1. Private

Use private functions/classes if they are only used locally.

Avoid double underscores (`__DatePickerState`) that usually come from widget templates with a private class. (Typing `stful` and expanding the suggested template for a stateful widget with the name `_DatePicker` results in a `__DatePickerState`.)

## 3. Ordering

### 3.1. General

Top down → define helper classes & methods below their usage.

Why? The name of helper methods should convey their function so you don't need to view their contents to get an initial understanding of the class.

### 3.2. Category over type

Prefer grouping related functions/fields/variables based on their functionality, not on their type.

### 3.3. `State`

- `initState`
- `didUpdateWidget`
- `didChangeDependencies`
- `deactivate`
- `dispose`
- `build`

## 4. Classes

### 4.1. General

Prefer marking classes with `@immutable` where possible (and not already implied by a parent class).

### 4.2. Constructors

#### 4.2.1. `const`

Prefer marking constructors with `const` where possible.

#### 4.2.2. Non-nullable arguments

Use `@required` & `assert(value != null)` for non-nullable fields (which is the default).

## 5. Functions

### 5.1. Long functions

While we don't enforce a strict line limit, prefer splitting long functions (starting at roughly 20–40 lines) into smaller functions.

Prefer creating separate (private) classes for complex widgets for both readability and performance.

### 5.2. Required vs. positional vs. named arguments

Prefer using named arguments for functions with multiple arguments. Using required arguments is acceptable:

- when the function accepts few (≈ 1–3), non-boolean, arguments
- for the first argument if it is the core of that function/constructor (e.g., a `CarWidget` taking a `Car`)

### 5.3. Anonymous functions

Use a tear-off (`names.forEach(print)` instead of `names.forEach((name) => print(name))`) when possible. Otherwise, use the arrow notation (`() => ...`) for short statements that fit on a single line. Use an explicit body (`() {...}`) for longer statements or if that statement contains an inner anonymous function (`() { transformStuff(() => ...); }`).

#### 5.3.1. Extension methods

Prefer using extension methods instead of global functions for utility functions (to not clutter the global namespace).

### 5.4. Future & `await`

Prefer using `await`/`async` instead of `myFuture.then((value) => ...)`.

### 5.5. Lists

Prefer using a list literal with the spread operator and collection if/for instead of `list.map(...).toList()`, especially for `children`/`slivers`-parameters of widgets and for map-functions longer than one line.
