## Environment:
- Java version: 17
- Maven version: 3.*
- Spring Boot version: 3.0.6

## Read-Only Files:
- src/test/*

Implement a simple REST API to manage a collection of music playlist data.  

Each PlayList is a JSON entry with the following keys:
- id: the unique ID of the event (Long).
- name: name of the play list (String).
- tracksCount: initial number of tracks in the play list (Integer).


Here is an example of a PlayList JSON object:
```json
{
   "name": "Henry1s list",
   "tracksCount": 10
}
```

An implementation of the PlayList model is provided. Implement a REST service that exposes the v1/playlists endpoints, which allows for managing the collection of PlayList records in the following way:

`POST` request to `/v1/playlists` :
* Create a new playlist data record.
* The response code is 201, and the response body is the created record, including its unique id.


`GET` request to `/v1/playlists`:
* The response code is 200.
* The response body is a list of matching records, ordered by their ids in increasing order.


`GET` request to `/v1/playlists/{playListId}`:
* Return a record with the given id and status code 200.
* If there is no record with the given id, the response code is null.


`DELETE` request to `/v1/playlists/{playListId}`:request to :
* Delete the record with the given id and return status code 204.

Complete the project so that it passes all the test cases when running the provided unit tests. The project, by default, supports the use of the H2 database.

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
