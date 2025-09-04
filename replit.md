# RegistrationBot

## Overview

RegistrationBot is a Flask-based web application that provides an AI chatbot interface for user registration and interaction. The application features a dark-themed interface with Bootstrap styling and integrates a custom bot system for processing user messages and handling registration workflows. The bot serves as an intelligent assistant to guide users through registration processes and respond to queries.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

**Web Framework**: Built on Flask with a traditional MVC architecture pattern. The application uses server-side rendering with Jinja2 templates and provides both synchronous page rendering and asynchronous JSON API endpoints for chat functionality.

**Frontend Architecture**: The user interface is built with Bootstrap 5 using a dark theme specifically designed for Replit environments. The frontend implements a responsive design with separate sections for chat interaction and user registration. JavaScript handles real-time chat interactions through AJAX calls to the backend API.

**Bot System**: The core bot functionality is modularized in a separate `Bot` class that processes user messages and generates appropriate responses. The bot is designed to handle both general chat interactions and specific registration-related commands.

**Session Management**: The application uses Flask's built-in session management with a configurable secret key that can be set via environment variables for production deployments.

**Error Handling**: Comprehensive error handling is implemented with proper logging for debugging purposes. The system gracefully handles exceptions in chat processing and provides user-friendly error messages.

**Routing Architecture**: The application follows RESTful principles with separate routes for different functionalities:
- GET `/` for the main interface
- POST `/chat` for processing chat messages (returns JSON)
- GET/POST `/register` for handling user registration

## External Dependencies

**Frontend Libraries**:
- Bootstrap 5 with Replit's custom dark theme for styling
- Font Awesome 6.4.0 for iconography
- Native JavaScript for AJAX interactions (no external JS frameworks)

**Python Dependencies**:
- Flask web framework for the core application
- Standard Python logging module for error tracking and debugging

**Environment Configuration**:
- SESSION_SECRET environment variable for Flask session security
- Development fallback configurations for local testing

The application is designed to be lightweight with minimal external dependencies, making it suitable for deployment on Replit or similar cloud platforms.