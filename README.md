# NexStudy

NexStudy is an AI-powered study companion for students. This Flutter MVP ships with a polished mobile UI, clean architecture, BLoC state management, PDF upload and viewing, AI-inspired analysis tabs, quiz generation, flashcards, and lecture chat.

## Features

- Email-style sign in and registration experience backed by a mock-friendly auth layer.
- Upload PDF lectures and extract their text locally.
- Generate student-friendly summary, key points, steps, quiz questions, and flashcards.
- Chat with the lecture content using a contextual study assistant flow.
- Ready-to-swap Firebase and API repository abstractions.

## Stack

- Flutter stable
- `flutter_bloc`
- Firebase packages wired behind repository interfaces
- `dio`
- `file_picker`
- `syncfusion_flutter_pdfviewer`

## Notes

- The current MVP runs with mock-first services so it works without Firebase or API credentials.
- To enable live services later, update [`lib/src/core/config/app_config.dart`](lib/src/core/config/app_config.dart) and provide Firebase configuration plus your AI backend.
