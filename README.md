# BetterGR Setup Bundle

## How to run

### 1. Run following commands

- If you want to the run entire website, run the following command:

    ```bash
    docker-compose down -v && docker-compose pull && docker-compose up -d
    ```

- If you want to run only a specific services, run the following command:

    ```bash
    docker-compose down -v && docker-compose pull && docker-compose up -d <name of service>
    ```
