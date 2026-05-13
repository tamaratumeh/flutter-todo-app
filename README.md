# Todo App - Flutter Project

## Introduction
This project aims to develop a simple Todo Application using Flutter connected to a PHP API and MySQL database.

The application allows users to:
- Add tasks
- Edit tasks
- Delete tasks
- Manage task completion

The project is based on:
- Provider state management
- REST API communication
- JSON data conversion

---

# Project Objectives

The main objectives of this project are:

- Learn Flutter application development
- Understand API and database integration
- Apply CRUD operations
- Use Provider for state management
- Work with JSON data
- Design a clean and organized UI

---

# Technologies Used

- Flutter
- Dart
- Provider
- HTTP Package
- PHP
- MySQL
- REST API
- JSON

---

# Project Components

## 1. Task Model

A `Task` model was created to represent task data.

### Includes:
- Task ID
- Task title
- Completion status
- Creation date

### Methods:
- `fromJson()`
- `toJson()`
- `copyWith()`

---

## 2. State Management (Task Provider)

Provider was used for state management and automatic UI updates.

### Responsibilities:
- Fetching tasks
- Adding tasks
- Editing tasks
- Deleting tasks
- Toggling task status
- Error handling

### App States:
- Loading
- Success
- Error

---

## 3. API Service

An `ApiService` class was created to communicate with the backend.

### HTTP Methods Used:
- `GET`
- `POST`
- `PUT`
- `PATCH`
- `DELETE`

JSON is used for data exchange between Flutter and PHP API.

---

## 4. User Interface (UI)

The application contains a simple and modern UI.

### Screens & Features:
- Home screen
- Task list
- Add task dialog
- Edit task dialog
- Statistics cards
- Error messages
- Empty state screen

### UI Enhancements:
- Google Fonts
- Simple animations
- Material Design

---

# Database and PHP API

PHP was used to build a REST API connected to a MySQL database.

The backend handles all CRUD operations for tasks.

Data is exchanged using JSON format.

---

# Application Workflow

1. Fetch tasks on startup
2. Add new tasks
3. Edit existing tasks
4. Mark tasks as completed
5. Delete tasks
6. Update UI automatically using Provider

---

# Project Features

- Clean UI design
- Easy to use
- Efficient state management
- Real API integration
- Organized file structure

---

# Conclusion

This project helped improve understanding of:

- Flutter application development
- PHP & MySQL backend integration
- State management using Provider
- JSON handling
- REST API communication

The project provided practical experience in building full-stack mobile applications.
