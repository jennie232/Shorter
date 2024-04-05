# Shorter 
[![codecov](https://codecov.io/gh/jennie232/Shorter/graph/badge.svg?token=BGRB3SVK0V)](https://codecov.io/gh/jennie232/Shorter) 

Shorter is a URL shortener application built with Elixir and Phoenix. It provides a simple interface for users to convert long URLs into short links. The app also includes a stats page where users can view a table showcasing the original and shortened URLs as well as the number of clicks each short URL has received; this data can be exported as a CSV file.



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
    cd Shorter
    ```

2. Docker
    ```bash
    # builds and runs the application via docker-compose
    docker-compose build
    docker-compose up

    # access the application on the browser at `http://localhost:4000`
    
    # stops the app and removes the containers
    docker-compose down

    # builds and runs the test environment
    docker-compose -f docker-compose.test.yml build
    docker-compose -f docker-compose.test.yml run --rm app
    
    # stops the test environment and removes the containers
    docker-compose -f docker-compose.test.yml down
    ```
### Usage
1. Navigate to `http://localhost:4000` in your browser
2. Insert a long URL into the input field and click the button
3. The app will display the shortened URL along with the original URL below the input if successful.
4. Navigating to the shortened URL will redirect you to the original long URL
5. Visit http://localhost:4000/stats to view a table of shortened URLs, their original URLs, and click counts
6. Click "Download CSV" on the stats page to download the statistics data


## CI/CD
This project includes a GitHub Actions workflow for continuous integration and continuous deployment (CI/CD). The workflow (found in [.github/workflows/ci.yml](.github/workflows/ci.yml)) is triggered on pushes and pull requests to the `main` branch.

The workflow performs the following steps:

1. Sets up the services (Postgres) for testing
2. Checks out the code and sets up the Elixir environment
3. Builds the Docker container for the test environment
4. Fetches dependences and compiles the app
5. Runs migrations to set up the test database
6. Executes the tests with code coverage
7. Uploads coverage reports to Codecov for analysis

## Approach
For a detailed explanation of the approach and design decisions made in this project, please refer to the [APPROACH.MD](/APPROACH.MD) file.<br /><br />


#### Updated Frontend
** 04/05/24: I've made updates to the frontend, which are available on the `updated-shorter` branch. These changes aim to improve user experience. (I may also update some backend logic in the very near future). If you're interested, please run the following command after cloning the repo:
 ```bash
git checkout updated-shorter
 ```
** 04/04/24: I've made updates to increasing the click count logic, where it now runs asynchronously. The changes have now been merged to the main branch!! Please refer to the main branch for the most recent changes.
