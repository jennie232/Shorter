# Shorter

Shorter is a URL shortener application built with Elixir and Phoenix. It allows users to input a long URL to create a shortened one. The app also shows a table of all short URLs that were created along with a clicks count.



## Development

### Prerequisites
- Homebrew
- Docker
    ```bash
    brew install docker
    ```
- Docker Compose
    ```bash
    brew install docker-compose
    ```

### Getting Started
1. Clone the repository and navigate to the app
    ```bash
    git clone https://github.com/jennie232/Shorter.git
    cd shorter
    ```

2. Docker
    ```bash
    # build and run the application via docker-compose
    docker-compose build
    docker-compose up

    # access the application on the browser at `http://localhost:4000`

    # build and run the tests
    docker-compose -f docker-compose.test.yml build
    docker-compose -f docker-compose.test.yml run --rm app mix test
    ```

## CI/CD
This project includes a GitHub Actions workflow for continuous integration and continuous deployment (CI/CD). The workflow (found in [.github/workflows/ci.yml](.github/workflows/ci.yml)) is triggered on pushes and pull requests to the `main` branch.

The workflow performs the following steps:

1. Builds the Docker container for the test environment
2. Runs the database migrations
3. Executes the tests

## Approach

For a detailed explanation of the approach and design decisions made in this project, please refer to the [APPROACH.md](APPROACH.md) file.
