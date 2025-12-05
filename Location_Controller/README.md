# Springboot Java: Location API
In this project, data is provided for many countries with API endpoints for fetching specific information. (Note that all the data is artificial.) Your task is to implement several REST endpoints to handle this data.

## Environment
- Java version: 17
- Maven version: 3.*
- Spring Boot version: 3.0.6

## Read-Only Files
- src/test/*

## Commands
- run: 
```bash
mvn clean spring-boot:run
```
- install: 
```bash
mvn clean install
```
- test: 
```bash
mvn clean test
```

## Sample Data

Here is an example of a location data JSON object:

```json
{
    "id": 1,
    "lat": 36.1189,
    "lon": -86.6892,
    "temperature": [17.3, 16.8, 16.4, 16.0, 15.6, 15.3, 15.0, 14.9, 15.8, 18.0, 20.2, 22.3, 23.8, 24.9, 25.5, 25.7, 24.9, 23.0, 21.7, 20.8, 29.9, 29.2, 28.6, 28.1]
}
```

## Requirements

The application should adhere to the following API format and response codes:

`POST /api/location`:
- Accepts a location object without an ID and returns status code 201 on creation.
- If the location object is provided with an ID, status code 400 is returned.

`GET/api/location/{id}`:
- Returns the location entry with the given ID and status code 200.
- Returns status code 404 if the requested location doesn't exist.
- Returns status code 400 if the requested location ID is invalid.

`GET /api/location`:
- Returns all the location entries with status code 200.

There are 5 tests already written, but some don't work due to bugs in the implementation of the endpoints. Find the bugs and fix them so that all the tests pass.
