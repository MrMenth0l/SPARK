# SPARK

SPARK is a calm, premium creativity studio for engineers, founders, finance-minded builders, and ambitious thinkers who want to strengthen originality, insight, and creative intention in the AI era.

It is not a productivity app pretending to be creative, and it is not an inspiration feed pretending to be useful. SPARK is designed to help users receive better sparks, capture fragile thoughts quickly, and develop those thoughts into meaningful ideas.

## What It Does

SPARK centers on four core workflows:

- Discover high-signal creative sparks
- Capture raw ideas through text, voice, or sketch
- Shape ideas with lightweight development assistance
- Revisit unfinished thoughts before they disappear

The product is intentionally designed to feel spacious, high-signal, emotionally intelligent, and easy to use without interrupting a forming thought.

## Key Features

- Home, Discover, and Library navigation
- Full-screen capture flow for writing, voice, and sketch input
- Idea detail views for developing captured thoughts
- Onboarding that personalizes the experience around interests and creative intent
- Local persistence with SwiftData
- Service-oriented architecture with repositories, view models, and domain models
- A calm visual system built around reusable theme tokens and shared components

## Project Structure

- `SPARK/App` contains app shell, navigation, theming, and dependency wiring
- `SPARK/Core` contains domain models, services, repositories, persistence, and utilities
- `SPARK/Features` contains feature-specific views, view models, and reusable UI components
- `SPARK/Resources` contains sample data used by the app
- `SPARKTests` contains unit tests, mocks, and test support helpers

## Requirements

- Xcode 17 or later
- iOS Simulator support for the configured deployment target
- A valid Apple development signing setup if you want to run on device

## Getting Started

1. Open `SPARK.xcodeproj` in Xcode.
2. Select the `SPARK` scheme.
3. Run the app on an iPhone simulator or device.

## Testing

Run the test suite from Xcode, or use:

```bash
xcodebuild test -scheme SPARK -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Design Philosophy

SPARK is built around a simple product doctrine:

- Creativity should feel more possible, not more demanding
- The interface must never interrupt a forming thought
- The app should encourage consumption, expression, and development in that order

## Status

This repository contains the current SPARK application foundation, feature implementation, and test suite.
