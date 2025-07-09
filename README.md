# Chat Application Backend

This is a full-featured backend for a chat system built using **Python (Flask-RESTful)** and **PostgreSQL**. The project has evolved from raw SQL-based data management to a RESTful API architecture. It includes community channels, direct messaging, user suspensions, authentication, full-text search, and analytics.

## Tech Stack

- **Language:** Python 3.9
- **Framework:** Flask, Flask-RESTful
- **Database:** PostgreSQL 14
- **Testing:** Python `unittest`, `requests`
- **CI/CD:** GitLab CI
- **Security:** SHA-512 password hashing, session-based auth

## Features

### DB Phase (Schema & Core Logic)

- Tables for `users`, `messages`, `suspensions`, `communities`, `channels`, `memberships`
- Unread/read tracking and timestamps
- Direct messaging + community-based channel messaging
- Per-community suspensions and message validation
- Mentions via `@username`
- Full-text search with PostgreSQL `tsvector`
- Analytics APIs for activity summary
- Test data with users like Abbott, Costello, Moe, Larry, Curly, Paul, DrMarvin, Bob

### REST1 – Basic RESTful APIs

- `GET /users`: List all users
- `GET /communities`: List all communities and their channels
- `GET /channel/<id>`: All messages in a specific channel
- `GET /messages/search`: Filter messages by string, date, or size
- All responses in JSON
- DB setup triggered from the API server (not test code)
- Tested with HTTP requests and validated with expected return sizes and content

### REST2 – CRUD + Authentication

- `POST /users`: Add a new user
- `PUT /users/<id>`: Update user info
- `DELETE /users/<id>`: Remove user
- `POST /login`: Authenticate and receive session key
- `POST /logout`: Invalidate session
- `POST /dm`: Send direct message (requires auth)
- `GET /dm?user=...&max=...`: Fetch recent DMs (requires auth)
- Passwords hashed with SHA-512
- Session keys generated securely with Python `secrets`
- Auth enforced via HTTP headers
- Edge-case tests: login failures, duplicate users, bad auth keys

## Testing

- HTTP-based tests using Python `requests`
- Unit tests for all endpoints, success + failure cases
- Mocked timestamps and pre-seeded database for consistent testing
- All tests integrated into GitLab CI pipeline

## Folder Structure

```
├── src/
│   ├── api/               # REST API routes and logic
│   ├── models/            # DB schema definitions
│   ├── utils/             # Helpers: auth, CSV import, time utils
├── tests/                 # HTTP-based API tests
├── data/                  # Test CSV data
├── DTR.pdf                # Schema relationships
├── FUTURE.md              # Planned features: Reactions, Threads
├── requirements.txt
└── README.md
```

## Setup

```bash
# Install dependencies
pip install -r requirements.txt

# Start the server (this loads the DB schema)
python src/app.py

# Run HTTP-based tests
python -m unittest discover tests/
```

## Future Plans (from FUTURE.md)

- **Reactions**: Add likes/thumbs-up to messages
- **Threaded Conversations**: Allow replying to specific messages within a channel
- Changes to message schema and new API endpoints will be required

