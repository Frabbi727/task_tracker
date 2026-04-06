# Task Tracker

A simple Flutter task tracker app built with `GetX`, local persistence, API-based status filters, and light/dark theme support.

## Architecture Overview

This project uses a simple `GetX + MVVM` style structure.

- `page` = UI layer
- `controller` = screen logic and state handling
- `repository` = data access layer
- `model` = data object
- `binding` = dependency injection for each page

For this project:

- `TaskListPage` shows tasks and filters
- `AddTaskPage` handles add/edit form flow
- `TaskDetailsPage` handles view, delete, and status update
- repositories are shared because all task pages use the same local storage and API data

This is a simplified MVVM approach designed to be easy to understand for exams and small projects.

## Folder Structure

```text
lib/
  main.dart
  app/
    app.dart
    bindings/
      initial_binding.dart
    controllers/
      theme_controller.dart
    routes/
      app_pages.dart
      app_routes.dart

  core/
    constants/
      storage_keys.dart
    models/
      task_model.dart
      status_response.dart
      status_response.g.dart
    network/
      api_client.dart
      api_endpoints.dart

  features/
    add_task/
      add_task_binding.dart
      add_task_controller.dart
      add_task_page.dart
    task_details/
      task_details_binding.dart
      task_details_controller.dart
      task_details_page.dart
    task_list/
      task_list_binding.dart
      task_list_controller.dart
      task_list_page.dart
    repositories/
      task_repository.dart
      status_repository.dart

  utils/
    widgets/
      task_card.dart
      task_filter_section.dart
```

## How MVVM Is Used

- Views:
  Flutter pages inside `features/..._page.dart`
- ViewModels:
  GetX controllers inside each feature folder
- Models:
  Data classes in `core/models`
- Data layer:
  Repositories in `features/repositories`

Example:

- `AddTaskPage` is the View
- `AddTaskController` is the ViewModel
- `TaskRepository` handles local task storage
- `TaskModel` defines the task data structure

## SOLID Principles In This Project

This project follows some SOLID ideas, but in a simple form.

- Single Responsibility Principle:
  pages, controllers, repositories, and models have separate jobs
- Dependency Injection:
  GetX bindings provide dependencies instead of creating everything inside widgets
- Separation of Concerns:
  UI, business logic, and data access are separated


## Features

- Task list
- Add task
- Edit task
- Task details
- Delete confirmation
- Search
- Status filter from API
- Local persistence with `get_storage`
- Light and dark theme toggle

## How To Run

```bash
flutter pub get
flutter run
```

## How To Test

Run all tests:

```bash
flutter test
```

Run analyzer:

```bash
flutter analyze
```

Run code generation for `json_serializable` files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Future Improvements

- add more unit tests for controllers and repositories
- replace raw status strings with stronger typed constants or enums
- add better API error handling and failure models
- add a settings page for theme and preferences
- add a service layer if business logic grows
