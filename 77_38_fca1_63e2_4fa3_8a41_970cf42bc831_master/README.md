# Springboot Java: Vehicle API
In this project, virtual data related to vehicles is provided for many countries. (Note that all the data is artificial.) Your task is to implement several REST endpoints to handle this data.

## Environment
- Java version: 17
- Maven version: 3.*
- Spring Boot version: 3.0.6E

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

Here is an example of a vehicle data JSON object:

```json
{
    "id": 1,
    "brand": "suzuki",
    "type": "hatchback",
    "cc": 1200,
    "color": "red"
}
```

## Requirements

The application should adhere to the following API format and response codes:

`POST /api/vehicle`:
- Accepts a vehicle object without an ID and returns status code 201 on creation.
- If the vehicle object is provided with an ID, status code 400 is returned.

`GET /api/vehicle/{id}`:
- Returns the vehicle entry with the given ID and status code 200.
- Returns status code 404 if the requested vehicle does not exist.
- Returns status code 400 if the requested vehicle ID is invalid.

`GET /api/vehicle`:
- Returns all the vehicle entries with status code 200.

There are 6 tests already written, but some don't work due to bugs in the implementation of the endpoints. Find the bugs and fix them so that all tests pass.
