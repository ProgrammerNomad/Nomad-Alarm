---
layout: default
title: Master Blueprint
parent: Developer
nav_order: 10
permalink: /MASTER_BLUEPRINT/
---
# Nomad Alarm – Complete Project Summary (Master Blueprint)

---

# Project Information

**Project Name**
> Nomad Alarm

**Package Name**
```text
com.nomad.alarm
```

**Developer**
> ProgrammerNomad

**Platform**
* Android (v1)
* iOS (scaffold - buildable on device; App Store deferred)

**License**
* MIT License (Recommended)

**Price**
* 100% Free Forever

---

# Mission

A privacy-first location alarm that wakes users before reaching any destination.

Works for:
* Train
* Bus
* Metro
* Car
* Bike
* Walking
* Flight
* Ferry
* Hiking
* Taxi

* No ads.
* No subscriptions.
* No login.
* No tracking.
* Offline first.

---

# Core Philosophy

* Free forever
* Privacy first
* Offline first
* Open Source
* Lightweight
* Battery Efficient
* Beautiful UI
* Material 3
* Fast
* Reliable

---

# Target Users

* Train passengers
* Daily commuters
* Travelers
* Students
* Office workers
* Delivery drivers
* Tourists
* Pilots
* Bus passengers
* Elderly users

---

# Problems Solved

* People sleep in trains.
* People miss stations.
* People miss bus stops.
* People forget destinations.
* People don't know arrival time.

Nomad Alarm solves all of these.

---

# Technology Stack

## Framework
* Flutter

## Language
* Dart

## State Management
* Riverpod

## Routing
* go_router

## Local Database
* Isar

## Maps
* **Default:** flutter_map, OpenStreetMap
* **Optional:** Google Maps (BYO API), HERE Maps, Mapbox

## Search
* **Default:** Nominatim
* **Optional:** Google Places, HERE, Pelias, Photon

## Routing
* **Default:** OSRM
* **Optional:** Google Directions, GraphHopper, Valhalla

## Notifications
* `flutter_local_notifications`

## Background Service
* `flutter_background_service`

## Permissions
* `permission_handler`

## GPS
* `geolocator`

## Voice
* `flutter_tts`

## Local Storage
* `shared_preferences`

## Logging
* `logger`

## Dependency Injection
* Riverpod

---

# App Features

## Location Alarm
* Unlimited alarms
* Distance alarm
* Arrival alarm
* Departure alarm
* Radius alarm
* ETA alarm
* Speed alarm
* Geofence alarm
* Repeat alarm
* One-time alarm

## Search
* Search
* Station
* Airport
* Metro
* Bus Stop
* Hotel
* Restaurant
* Hospital
* School
* Landmark
* Coordinates
* Plus Codes

## Maps
* OpenStreetMap
* Google (optional)
* Satellite
* Terrain
* Dark
* Compass
* Current Location
* Traffic (Google)

## Alarm
* Voice
* Vibration
* Flashlight
* Full Volume
* Repeat
* Custom ringtone
* Music
* Bluetooth
* Smart Watch

## Voice
* English
* Hindi
* Auto language
* Custom message

## Smart Detection
* Tunnel
* GPS Lost
* Battery Low
* Internet Lost
* Destination Passed
* Train Stopped

## Travel Modes
* Train
* Bus
* Metro
* Car
* Walking
* Cycling
* Auto Detect

## History
* Trips
* Alarms
* Missed
* Completed
* Distance
* Time

## Favorites
* Home
* Office
* College
* Gym
* Airport
* Hotel
* Custom

## Widgets
* Small
* Medium
* Large

## Notification
* Persistent
* Countdown
* ETA
* Cancel
* Pause
* Map

## Lock Screen
* Distance
* ETA
* Destination
* Dismiss

## Quick Tile
* Create Alarm
* Cancel Alarm

## Share
* Import destination
* Google Maps
* Organic Maps
* Browser
* `geo:` URI scheme

## Backup
* Export
* Import
* JSON
* Optional Google Drive

## Privacy
* No login
* No ads
* No analytics
* No cloud
* Offline
* Local storage only

---

# Screens

* Splash
* Welcome
* Permissions
* Home
* Search
* Map
* Alarm Config
* Active Alarm
* Navigation
* Alarm Ring
* History
* Trips
* Saved Places
* Favorites
* Recent
* Settings
* Map Settings
* Google API
* Alarm Settings
* Battery
* Permission Center
* Privacy
* About
* Debug
* Widgets

---

# Folder Structure

```text
lib/
  core/
  features/
  shared/
  services/
  models/
  providers/
  widgets/
  theme/
  main.dart
```

---

# Features Module

```text
home/
alarm/
map/
search/
history/
trip/
settings/
permission/
privacy/
about/
```

---

# Services

* Location Service
* Alarm Service
* Notification Service
* Speech Service
* Battery Service
* Permission Service
* Map Service
* Search Service
* Route Service
* Settings Service
* Backup Service

---

# Models

* Alarm
* Location
* Favorite
* Trip
* History
* Settings
* Route
* SearchResult
* MapProvider
* Notification

---

# Database

* Alarms
* Trips
* Favorites
* History
* Settings
* RecentSearches
* Logs

---

# Theme

* Material 3
* Material You
* Dark
* Light
* Dynamic Color

---

# Colors

* Blue
* Green
* Orange
* Purple
* Red
* User selectable

---

# Typography

* Inter
* Manrope
* Roboto

---

# Icons

* Material Symbols or Huge Icons

---

# Navigation

* Bottom Navigation:
  * Home
  * Trips
  * History
  * Settings

---

# Home Screen

* Current Location
* Search
* Recent
* Favorites
* Current Alarm
* Create Alarm

---

# Search Screen

* Search bar
* Suggestions
* Voice Search
* Map
* Recent
* Favorites

---

# Map Screen

* Current Location
* Layers
* Compass
* Zoom
* Drop Pin
* Save

---

# Alarm Screen

* Distance
* ETA
* Voice
* Vibration
* Flashlight
* Repeat
* Save

---

# Active Alarm

* Live Distance
* ETA
* Speed
* Accuracy
* Cancel
* Pause
* Map

---

# Alarm Trigger

* Voice
* Alarm
* Flashlight
* Dismiss
* Snooze
* Emergency

---

# Settings

* Appearance
* Maps
* Alarm
* Battery
* Permissions
* Privacy
* About

---

# Permissions

* Location
* Background Location
* Notifications
* Exact Alarm
* Battery Optimization
* Foreground Service

---

# Android Features

* Foreground Service
* Exact Alarm
* Background Location
* Boot Receiver
* Notification Channel
* Widgets
* Dynamic Colors
* Material You

---

# Optional APIs

* Google Maps
* Google Places
* Google Directions
* *User enters own keys. No keys stored on your server.*

---

# App Settings

* Map Provider
* Search Provider
* Routing Provider
* Voice
* Units
* Theme
* Language
* Battery
* Notifications

---

# Languages

* English
* Hindi
* Spanish
* French
* German
* Japanese
* Chinese
* Arabic
* Russian
* Portuguese
* *Community translations later.*

---

# Accessibility

* Large Text
* TalkBack
* High Contrast theme (v3.1 - `accessibilityHighContrast`)
* Color Blind (not implemented)
* Voice Commands (voice search mic v3.1; no hands-free commands)

---

# Security

* Encrypted local database
* Encrypted API keys
* Android Keystore
* No telemetry
* No ads SDK
* No tracking SDK

---

# Shipped in v2.x–v3.1 (formerly future)

* Wear OS complication module (v3.1)
* Android Auto read-only navigation template (v3.1)
* AI ETA Prediction (on-device heuristics)
* Group Travel + Family Sharing (local JSON bundles)
* Cloud Backup (optional HTTPS upload)
* Apple Maps (iOS)
* Offline Maps Download
* Voice search (v3.1)

# Still future

* Smart Watch full interactive app
* Live Activities (iOS)
* Custom Plugins
* Google Drive cloud backup
* Color blind mode

---

# Repository

```text
nomad-alarm/
  android/
  ios/
  assets/
  docs/
  lib/
  packages/
  test/
  .github/
```

---

# GitHub

* Issues
* Discussions
* Wiki
* Projects
* Releases
* Contributors

---

# Documentation

* README
* CONTRIBUTING
* CHANGELOG
* LICENSE
* CODE_OF_CONDUCT
* SECURITY
* ROADMAP
* ARCHITECTURE

---

# CI/CD

* GitHub Actions: Jekyll docs site deploy (`.github/workflows/pages.yml`)
* Flutter analyze, tests, and release AAB/APK: local only ([LOCAL_BUILD.md](LOCAL_BUILD.md), [RELEASE_QA_SIGNOFF.md](RELEASE_QA_SIGNOFF.md))

---

# Testing

* Unit Tests
* Widget Tests
* Integration Tests
* Manual Testing
* GPS Simulation
* Battery Tests

---

# Performance Goals

* App launch: under 2 seconds
* Idle battery drain: under 1% per hour while monitoring
* APK size: under 30 MB (without offline maps)
* RAM usage: under 150 MB during active tracking
* Cold GPS fix handling with graceful fallback
* Smooth 60 FPS UI

---

# Release Roadmap

## v1.0
* Core location alarms
* Map search
* Background tracking
* Notifications
* History
* Settings

## v1.5
* Widgets
* Favorite trips
* Route import
* Backup/Restore

## v2.0
* Multiple map providers
* BYO Google APIs
* Offline map downloads

## v3.0–v3.1
* Smart ETA, group/family sharing, voice search
* Wear OS complication, Android Auto template
* High contrast, ar/he RTL, docs site + Play prep

---

## Guiding Principle

> The goal isn't to create the app with the most features-it's to create the **most reliable location alarm**. Every feature should support that mission, keep the app fast, protect user privacy, and work without requiring accounts, subscriptions, or your own backend infrastructure.
