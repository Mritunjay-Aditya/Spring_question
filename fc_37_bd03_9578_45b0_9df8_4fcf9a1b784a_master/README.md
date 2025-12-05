
# Springboot Java: Patient Health Records API
In this project, virtual data related to patients is provided for many countries. (Note that all the data is artificial.) Your task is to implement several REST endpoints to handle this data.

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

Here is an example of a patient data JSON object:

```json
{
    "id": 1,
    "country": "MyCountry",
    "active": 300000,
    "death": 100000,
    "recovered": 7000
}
```

## Requirements

The application should adhere to the following API format and response codes:

`POST /patient`:
- Accepts a patient record object (without an ID) and returns status code 201.
- If the patient record object is provided with an ID, return status code 400.

`GET /patient/{id}`:
- Returns the patient record with the given ID and status code 200.
- If no patient record is found for the requested ID, return status code 404.
- If the ID is invalid, return status code 400.

`GET /patient`:
- Returns all patient records with status code 200.

There are 6 tests already written, but some are not working due to a bug in the implementation of the endpoints. Find the bugs and fix them so that all the tests pass.
