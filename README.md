# TaskTrackFlow

A task manager built with Ruby on Rails 8. Tasks can be private, unlisted or public, are written in Markdown, and can be shared by link. It runs on my own Linux server, deployed with Docker and Kamal.

**Live:** https://tasktrackflow.com

## Features

- **Accounts.** Email and password sign-up with Devise, plus **Sign in with Google** (OmniAuth). Users pick a username, and can change it in settings.
- **Email verification.** New accounts are sent a 4-digit code by email (through Resend) to confirm their address.
- **Tasks.** Each task has a title, a description, a Markdown body, a priority, a due date and a status. Your task list is sorted by due date and searchable.
- **Visibility.** Each task is *public* (listed in the public feed), *unlisted* (visible to anyone with the link) or *private* (only you). Task IDs are random UUIDs, so unlisted links can't be guessed.
- **Safe Markdown.** Bodies are rendered with Commonmarker and then sanitised, so user-written HTML can't run scripts on the page.
- **Public feed** of everyone's public tasks, with search.
- Light and dark themes, and a docs page.

## Tech

| | |
| --- | --- |
| Backend | Ruby 3.3.4, Rails 8, SQLite, Solid Queue |
| Front end | Hotwire (Turbo and Stimulus), importmap, ERB |
| Auth | Devise, OmniAuth Google OAuth 2 |
| Email | Action Mailer over SMTP with Resend, on its own verified subdomain |
| Deployment | Docker, Kamal 2, kamal-proxy with Let's Encrypt HTTPS, images on GitHub Container Registry |
| Hosting | My own headless Ubuntu server |
| CI | GitHub Actions: Brakeman security scan, importmap audit, RuboCop, tests |

## How it's deployed

The app moved off Heroku in October 2026. It now runs as a Docker container on an Ubuntu server I set up from scratch (static IP, SSH key-only login, router port forwarding). Kamal builds the image, pushes it to GitHub Container Registry and swaps the running container with no downtime. kamal-proxy serves `tasktrackflow.com` and `www.tasktrackflow.com` and handles the HTTPS certificates. The SQLite database lives in a Docker volume, so it survives each deploy.

Secrets (Rails master key, Google OAuth credentials, registry token) are passed in by Kamal at deploy time and are never committed.

## Running locally

```bash
bundle install
bin/rails db:prepare
bin/dev            # http://localhost:3000
```

Google sign-in needs `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` in your environment.

Run the checks that CI runs:

```bash
bin/rails test
bin/brakeman
bin/rubocop
```

## Roadmap

- [ ] Comments and replies on tasks (in progress on a branch)
- [ ] Sign in with GitHub
- [ ] Filters on the task list
- [ ] Wider test coverage, built up feature by feature
- [ ] [WorkLog](https://github.com/NiceWorkLad/WorkLog): a companion JSON API for logging work against tasks
