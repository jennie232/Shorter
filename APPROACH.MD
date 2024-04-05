## Design Principles

Throughout the development process, I kept a few key design principles in mind:

1. **Modularity and Separation of Concerns**: I structured the codebase to be modular, with separate controllers handling specific responsibilities. This makes the app easier to maintain, scale, and extend.

2. **Performance Optimization**: I utilized features like caching to ensure optimal performance, even under high load.

3. **User-Centric Design**: I focused on creating a simple, intuitive interface similar to popular URL shorteners.

## URL Validation

To ensure data integrity, I validated the original URLs to assert:

- The URL can't be empty
- The scheme must be http or https
- The host can't be nil or have a length of 0
- The host must include at least one dot followed by a valid domain extension

Considering the behavior of popular URL shorteners like Bitly, I made the decision not to normalize URLs by removing trailing slashes. Also, since websites have different behavior or redirect rules regarding the absence or presence of a trailing slash, I didn't modify the original URL to avoid unintended consequences.

## Controller Organization

I divided the controllers based on the Single Responsibility Principle:

- **URLController**: Handles rendering the form and shortening the original URL
- **RedirectController**: Redirects the user to the original URL when they input the short URL
- **StatsController**: Shows all URL records and allows users to download a CSV of the data

This separation makes the codebase more modular and scalable, as it's easier to add new features to specific controllers without affecting the others.

## Performance Considerations

To optimize performance under high load, I made a few key decisions:

- I chose to update `inc_click_counts` in the context rather than the changeset to minimize overhead.
- I implemented caching to store the slug for a valid original URL with a ttl of 30 minutes to reduce database queries and improve response times.
- I used asynchronous processing for updating click counts to ensure fast redirect responses.
- I utilized the slug as an index in the database to optimize performance for lookups of short URLs.

These choices help ensure that Shorter performs well, even under heavy traffic.

## Performance Testing

To validate Shorter's performance under the specified load requirements, I conducted load testing using Apache JMeter. Here are the details of the tests:

1. New URL Form:
    - Test Plan: Set up a constant throughput timer and ran 50 threads with a 1-second interval.
    - Result: The throughput was consistently above 5 requests per second, meeting the requirement.
2. Redirect Endpoint:
    - Test Plan: Set up a constant throughput timer with a CSV dataset configuration and ran 60 threads.
    - Result: The throughput was around 35 requests per second, exceeding the requirement of 25 requests per second.

These JMeter tests demonstrate that Shorter can handle the specified traffic load for both the URL submission form and the redirect endpoint.
## User Interface Decisions

I designed Shorter's UI with user experience in mind:

- For invalid URLs, I display a generic error message with an example of the correct format, similar to popular URL shorteners like Bitly and TinyURL. I removed `Phoenix.Flash.get` since users don't need to see technical flash messages.
- If a user tries to access a non-existent short URL, they're redirected to a custom 404 page.
- The order of routes matters: putting the `/:slug` route last is crucial, otherwise `/stats` gets treated as a slug and triggers a 404.
- I ensured the pages were responsive depending on screensize. 

These UI decisions prioritize clarity and a positive user experience, aligning with Shorter's design principles.

## User Authentication and Short URL Generation

In the current implementation of Shorter, I made the decision to output the same short URL for duplicate original URLs. This approach ensures that the same original URL always maps to the same short URL, regardless of the user who created it.

However, if the app incorporates user authentication in the future, the approach would likely change. With user accounts, each logged-in user would expect to have their own set of short URLs, even if the original URLs are the same as those created by other users. In this scenario, the short URL generation would need to consider the user's identity to provide a personalized experience and enable user-specific analytics tracking.

By generating the same short URL for duplicate original URLs in the current version of Shorter, I aimed to keep the system simple and focused on the core functionality of URL shortening. As the application evolves and user-specific features are introduced, the short URL generation strategy can be adapted accordingly.

## Docker Compose Setup

I decided to use two separate Docker Compose files: one for development and one for testing. This separation allows for a cleaner and more focused setup for each environment.

The development Docker Compose file includes the necessary services and configurations for running the application during development, such as the web server and database.

On the other hand, the testing Docker Compose file is specifically tailored for running tests. It includes the required services and configurations for the testing environment, ensuring that tests are run in isolation and with the appropriate setup.

By using separate Docker Compose files, I can maintain a clear separation between development and testing environments, making it easier to manage dependencies, configurations, and resource allocation for each purpose.

## Scalability Considerations
To prepare Shorter for a bigger audience, I would need to consider the following to ensure it can handle increased traffic:
- Caching: Frequently accessed data like popular short URLs and the corresponding original URLs could be cached to provide faster responses and minimize the load on the database.
- Horizontal Scaling: Adding more instances of web servers and background workers could help Shorter distribute the heavy load across multiple machines, allowing the app to handle higher levels of concurrent requests.
