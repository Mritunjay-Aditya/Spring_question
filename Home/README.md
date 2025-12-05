# Springboot Java: Home API
In this project, virtual data related to homes is provided for many areas. (Note that all the data is artificial.) Your task is to implement several REST endpoints to handle this data.

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

Here is an example of a home data JSON object:

```json
{
  "id": 1,
  "area": 36.1189,
  "price": 86.6892,
  "city": "Noida"
}
```

## Requirements

The application should adhere to the following API format and response codes:

`POST /api/home`:
- Accepts a home object without an ID and returns status code 201 on creation.
- If the home object is provided with an ID, status code 400 is returned.
- It is secured by HTTP basic authentification, where the username and password are "admin" and "admin".

`GET /api/home/{id}`:
- Returns the home entry with the given ID and status code 200.
- Returns status code 404 if the requested home does not exist.
- Returns status code 400 if the requested home ID is invalid.
- This should be publicly accessible and should not require HTTP basic authentication.

`GET /api/home`:
- Returns all the home entries with status code 200.
- It is secured by HTTP basic auth, where the username and password are "admin" and "admin".

There are 5 tests already written, but some don't work due to bugs in the implementation of the HTTP basic security configuration. Find the bugs and fix them so that all the tests pass.
