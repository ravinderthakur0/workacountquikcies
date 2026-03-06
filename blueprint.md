# Project Blueprint

## Overview

This is a Flutter application that provides audio playback functionality. It includes a basic UI and a background audio service.

## Style, Design, and Features

* **Hive for local storage:** The app uses Hive for local data storage.
* **Audio Service:** The app uses the `audio_service` package for background audio playback and notifications.
* **Permissions:** The app requests notification and battery optimization permissions.

## Current Fixes

* **Hive Initialization:** Corrected Hive initialization to use the temporary directory, which is more stable on Android.
* **Audio Handler Implementation:** Implemented a complete audio handler with `play`, `pause`, and `stop` functionality to prevent crashes from an empty implementation.
* **Dependency Upgrades:** Upgraded all project dependencies to their latest major versions to ensure stability and access to the latest features.
* **ProGuard Rules:** Added ProGuard rules to prevent the `AudioService` class from being removed during the build process, which was causing a `ClassNotFoundException` at runtime. This has been applied to both `release` and `debug` builds to ensure the app runs correctly in all configurations.
