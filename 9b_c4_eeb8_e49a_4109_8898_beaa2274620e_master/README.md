## Environment:
- Java version: 17
- Maven version: 3.*
- Spring Boot version: 3.0.6

## Read-Only Files:
- src/test/*

## Data:
Sample example of JSON data object:
```json
{
  "title": "Lost in Echoes",
  "albumName": "Echoes of the Unknown",
  "releaseDate": "2021-07-15",
  "playCount": 5000
}
```

## Requirements:
The REST service must expose the endpoint music/platform/v1/tracks, enabling the management of music track records as follows: Make sure to add the business logic in TrackServiceImpl.class

POST request to music/platform/v1/tracks: Creates a new music track record. It expects a valid music track data object as its body payload, excluding the id property. The service assigns a unique long id to the added object. The response includes the created record with its unique id, and the response code is 201.

GET request to music/platform/v1/tracks: Responds with a list of all music track records and a response code of 200.

DELETE request to music/platform/v1/tracks/{trackId}: Deletes the record with the specified track id if it exists in the database.

GET request to music/platform/v1/tracks/search: Responds with music track records filtered by title. The response code is 200. It accepts query string parameter title. Records are returned based on matching title.

Your task is to ensure the project meets all test case criteria when running the provided rspec tests. The project uses H2 database by default. Start by implementing the POST request to music/platform/v1/tracks, as testing other methods requires the POST functionality to work correctly.

## Commands
- run:
```bash
mvn clean package; java -jar target/project_jar-1.0.jar
```
- install:
```bash
mvn clean install
```
- test:
```bash
mvn clean test
```
