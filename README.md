You're right to double-check — I wrote it in a personal tone but didn’t format it exactly like a polished GitHub-style `README.md`. Here’s the **README content** now rewritten in proper Markdown for GitHub, with correct formatting and structure you'd use directly in your repo:

```markdown
# Chat Application Backend

This is the backend for a chat system I built using **Python (Flask-RESTful)** and **PostgreSQL**. It supports direct messages, threaded replies, channels within communities, user suspensions, and full-text message search. The project was built incrementally over multiple design and development sprints, with a strong focus on database design, testing, and API-first architecture.

## Tech Stack

- **Language:** Python
- **Framework:** Flask-RESTful
- **Database:** PostgreSQL
- **Testing:** unittest
- **CI/CD:** GitLab CI

## Features

### DB1 – Initial Setup

- Tables for `users`, `messages`, `suspensions`
- Message timestamps, read/unread tracking
- Global suspensions with expiration logic
- Seeded data for users like Abbott, Costello, Moe, Larry, Curly
- APIs to:
  - Fetch messages between two users
  - Count unread messages
  - Filter messages by date
- Unit tests for all functionality

### DB2 – CRUD & User Interactions

- Send messages with timestamps
- Change username (limited to once every 6 months)
- Mark messages as read
- Suspend/unsuspend users via API
- CSV import for chat logs (with data cleanup)
- All actions exposed through REST APIs

### DB3 – Communities, Channels, Mentions

- Schema for `communities`, `channels`, `memberships`
- Join/leave communities
- Channel messaging (no channel-specific membership)
- Mentions with `@username` recognition
- Per-community suspensions
- Updated unread count endpoints

### DB4 – Search & Analytics

- Full-text search using PostgreSQL `tsvector` and `tsquery`
- Search supports multi-word queries (e.g., `apples & oranges`)
- Activity analytics:
  - Avg. messages/day with >5 chars
  - Number of active users in past 30 days
- Moderator view of currently suspended users who posted in a date range
- `FUTURE.md` includes plans for:
  - Reactions (e.g., thumbs up)
  - Threaded messages

## Testing

- All API logic is test-covered using Python `unittest`
- CI pipeline runs tests on every push
- Seed data allows for consistent and repeatable test conditions
- Mocked timestamps used for suspension and message validation

## Folder Structure

```

├── src/
│   ├── api/               # REST API methods
│   ├── models/            # Schema definitions
│   ├── utils/             # Helpers like CSV import, time tools
├── tests/                 # Unit tests
├── data/                  # Seed CSV files
├── DTR.pdf                # Schema relationship diagram
├── FUTURE.md              # Future design ideas
├── requirements.txt
└── README.md

````

## Setup

```bash
# Install dependencies
pip install -r requirements.txt

# Initialize the database and seed with test data
python src/setup.py

# Run tests
python -m unittest discover tests/
````



