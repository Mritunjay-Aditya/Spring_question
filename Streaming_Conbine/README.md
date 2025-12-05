## Environment
- Java version: 17
- Maven version: 3.*
- Spring Boot version: 3.2.2

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
<details open>
<summary>Example of sample Entity models:</summary>

Example of `Artist` data JSON Object:
```json
{
  "id": 1,
  "artistName": "Alex Doe",
  "bio": "Alex Doe is a popular artist...",
  "genre": "Pop",
  "origin": "USA",
  "formedYear": "2000",
  "socialLink": "https://www.alexdoe.com",
  "image": "https://www.alexdoe.com/image.jpg",
  "tracksProduced": [
    {
      "id": 1,
      "title": "Track 1",
      "albumName": "Album 1",
      "releaseDate": "2022-01-01",
      "duration": "3:30",
      "genre": "Pop",
      "description": "This is a description of Track 1",
      "playCount": 1000,
      "fileUrl": "https://www.alexdoe.com/track1.mp3",
      "coverImage": "https://www.alexdoe.com/track1.jpg"
    }
  ]
}
```

Example of `Playlist` data JSON Object:
```json
{
  "id": 1,
  "name": "My Playlist",
  "description": "This is my favorite playlist",
  "tracks": [
    {
      "id": 1,
      "name": "Track 1",
      "duration": "3:45",
      "artist": {
        "id": 1,
        "name": "Artist 1"
      }
    },
    {
      "id": 2,
      "name": "Track 2",
      "duration": "4:30",
      "artist": {
        "id": 2,
        "name": "Artist 2"
      }
    }
  ]
}
```
Example of track data JSON Object:
```json
{
  "id": 1,
  "title": "Track 1",
  "albumName": "Album 1",
  "releaseDate": "2022-01-01",
  "duration": "3:30",
  "genre": "Pop",
  "description": "This is a description of Track 1",
  "playCount": 1000,
  "fileUrl": "https://www.alexdoe.com/track1.mp3",
  "coverImage": "https://www.alexdoe.com/track1.jpg",
  "artist": {
    "id": 1,
    "artistName": "Alex Doe",
    "bio": "Alex Doe is a popular artist...",
    "genre": "Pop",
    "origin": "USA",
    "formedYear": "2000",
    "socialLink": "https://www.alexdoe.com",
    "image": "https://www.alexdoe.com/image.jpg"
  }
}
```
</details>

## Requirements

This project is a practical assessment designed to evaluate your understanding and skills in working with RESTful APIs using Spring Boot. You are required to implement the following APIs:

### ArtistController

The REST service must expose the `/music/platform/v1/artists` endpoint, which allows for managing the collection of artists records in the following way:

**POST** request to `/music/platform/v1/artists`:

- Create a new artist
- Accepts a JSON body with `artistName`, `bio`, `genre`, `origin`, `formedYear`, `socialLink`, and `image` fields
- Returns the created artist record with a `201 Created` status

**GET** request to `/music/platform/v1/artists`:

- Get all artists.
- Returns a list of artist records with a `200 OK` status

**GET** request to `/music/platform/v1/artists/{artistId}`:

- Get an artist by ID.
- If the artist record exists, return the record with a `200 OK` status
- If the artist record does not exist, return a `404 Not Found` status

**PUT** request to `/music/platform/v1/artists/{artistId}`:
- Update an artist by ID.
- Accepts a JSON body with `artistName`, `bio`, `genre`, `origin`, `formedYear`, `socialLink`, and `image` fields
- Returns the updated artist record with a `200 OK` status

**DELETE** request to `/music/platform/v1/artists/{artistId}`:

- Delete an artist by ID.
- If the artist record exists, return a `204 No Content` status

### PlayListController

The REST service must expose the `/music/platform/v1/playlists` endpoint, which allows for managing the collection of PlayLists records in the following way:

**POST** request to `/music/platform/v1/playlists`:

- Create a new playlist.
- Accepts a JSON body with `name`, `description`, and `tracks` fields
- Returns the created playlist record with a `201 Created` status

**GET** request to `/music/platform/v1/playlists/{artistId}`:

- Get a playlist by ID.
- If the playlist record exists, return the record with a `200 OK` status
- If the playlist record does not exist, return a `404 Not Found` status

**DELETE** request to `/music/platform/v1/playlists/{artistId}`:

- Delete a playlist by ID.
- If the playlist record exists, return a `204 No Content` status

### TrackController

The REST service must expose the `/music/platform/v1/tracks` endpoint, which allows for managing the collection of Tracks records in the following way:

**POST** request to `/music/platform/v1/tracks`:

- Create a new track.
- Accepts a JSON body with `title`, `albumName`, `releaseDate`, `duration`, `genre`, `description`, `playCount`, `fileUrl`, `coverImage`, and `artist` fields
- Returns the created track record with a `201 Created` status

**GET** request to `/music/platform/v1/tracks`:

- Get all tracks.
- Returns a list of track records with a `200 OK` status

**GET** request to `/music/platform/v1/tracks/{trackId}`:

- Get a track by ID.
- If the track record exists, return the record with a `200 OK` status
- If the track record does not exist, return a `404 Not Found` status

**PUT** request to `/music/platform/v1/tracks/{trackId}`:

- Update a track by ID.
- Accepts a JSON body with `title`, `albumName`, `releaseDate`, `duration`, `genre`, `description`, `playCount`, `fileUrl`, `coverImage`, and `artist` fields
- Returns the updated track record with a `200 OK` status
- If the track record does not exist, return a `404 Not Found` status

**DELETE** request to `/music/platform/v1/tracks/{trackId}`:

- Delete a track by ID.
- If the track record exists, return a `204 No Content` status
- If the track record does not exist, return a `404 Not Found` status

Your task is to complete the given project so that it passes all the test cases when running the provided unit tests. The project by default supports the use of the H2 database.

## Sample Request & Response
<details><summary>Expand to view details on sample request and response for each endpoint.</summary>

### POST request to `/music/platform/v1/artists`:
Request data JSON Object:
```json
{
  "artistName": "Alex Doe",
  "bio": "Alex Doe is a popular artist...",
  "genre": "Pop",
  "origin": "USA",
  "formedYear": "2000",
  "socialLink": "https://www.alexdoe.com",
  "image": "https://www.alexdoe.com/image.jpg"
}
```

Response JSON Object:
```json
{
  "id": 1,
  "artistName": "Alex Doe",
  "bio": "Alex Doe is a popular artist...",
  "genre": "Pop",
  "origin": "USA",
  "formedYear": "2000",
  "socialLink": "https://www.alexdoe.com",
  "image": "https://www.alexdoe.com/image.jpg"
}
```

### GET request to `/music/platform/v1/artists`:
Response JSON Object:
```json
[
  {
    "id": 1,
    "artistName": "Alex Doe",
    "bio": "Alex Doe is a popular artist...",
    "genre": "Pop",
    "origin": "USA",
    "formedYear": "2000",
    "socialLink": "https://www.alexdoe.com",
    "image": "https://www.alexdoe.com/image.jpg"
  }
]
```

### GET request to `/music/platform/v1/artists/{artistId}`:
Response JSON Object:
```json
{
  "id": 1,
  "artistName": "Alex Doe",
  "bio": "Alex Doe is a popular artist...",
  "genre": "Pop",
  "origin": "USA",
  "formedYear": "2000",
  "socialLink": "https://www.alexdoe.com",
  "image": "https://www.alexdoe.com/image.jpg"
}
```

### PUT request to `/music/platform/v1/artists/{artistId}`:
Request data JSON Object:
```json
{
  "artistName": "Alex Doe",
  "bio": "Alex Doe is a popular artist...",
  "genre": "Pop",
  "origin": "USA",
  "formedYear": "2000",
  "socialLink": "https://www.alexdoe.com",
  "image": "https://www.alexdoe.com/image.jpg"
}
```
Response JSON Object:
```json
{
  "id": 1,
  "artistName": "Alex Doe",
  "bio": "Alex Doe is a popular artist...",
  "genre": "Pop",
  "origin": "USA",
  "formedYear": "2000",
  "socialLink": "https://www.alexdoe.com",
  "image": "https://www.alexdoe.com/image.jpg"
}
```

### DELETE request to `/music/platform/v1/artists/{artistId}`:
No response data, returns a `204 No Content` status

### POST request to `/music/platform/v1/playlists`:
Request data JSON Object:
```json
{
  "name": "My Playlist",
  "description": "This is my favorite playlist"
}
```

Response JSON Object:
```json
{
  "id": 1,
  "name": "My Playlist",
  "description": "This is my favorite playlist"
}
```

### GET request to `/music/platform/v1/playlists/{playlistId}`:

Response JSON Object:
```json
{
  "id": 1,
  "name": "My Playlist",
  "description": "This is my favorite playlist"
}
```

### DELETE request to `/music/platform/v1/playlists/{playlistId}`:
No response data, returns a `204 No Content` status

### POST request to `/music/platform/v1/tracks`:

Request data JSON Object:
```json
{
  "title": "Track 1",
  "albumName": "Album 1",
  "releaseDate": "2022-01-01",
  "duration": "3:30",
  "genre": "Pop",
  "description": "This is a description of Track 1",
  "playCount": 1000,
  "fileUrl": "https://www.alexdoe.com/track1.mp3",
  "coverImage": "https://www.alexdoe.com/track1.jpg"
}
```

Response JSON Object:
```json
{
  "id": 1,
  "title": "Track 1",
  "albumName": "Album 1",
  "releaseDate": "2022-01-01",
  "duration": "3:30",
  "genre": "Pop",
  "description": "This is a description of Track 1",
  "playCount": 1000,
  "fileUrl": "https://www.alexdoe.com/track1.mp3",
  "coverImage": "https://www.alexdoe.com/track1.jpg"
}
```

### GET request to `/music/platform/v1/tracks`:

Response JSON Object:
```json
[
  {
    "id": 1,
    "title": "Track 1",
    "albumName": "Album 1",
    "releaseDate": "2022-01-01",
    "duration": "3:30",
    "genre": "Pop",
    "description": "This is a description of Track 1",
    "playCount": 1000,
    "fileUrl": "https://www.alexdoe.com/track1.mp3",
    "coverImage": "https://www.alexdoe.com/track1.jpg"
  }
]
```

### GET request to `/music/platform/v1/tracks/{trackId}`:

Response JSON Object:
```json
{
  "id": 1,
  "title": "Track 1",
  "albumName": "Album 1",
  "releaseDate": "2022-01-01",
  "duration": "3:30",
  "genre": "Pop",
  "description": "This is a description of Track 1",
  "playCount": 1000,
  "fileUrl": "https://www.alexdoe.com/track1.mp3",
  "coverImage": "https://www.alexdoe.com/track1.jpg"
}
```

### PUT request to `/music/platform/v1/tracks/{trackId}`:

Request data JSON Object:
```json
{
  "title": "Track 1",
  "albumName": "Album 1",
  "releaseDate": "2022-01-01",
  "duration": "3:30",
  "genre": "Pop",
  "description": "This is a description of Track 1",
  "playCount": 1000,
  "fileUrl": "https://www.alexdoe.com/track1.mp3",
  "coverImage": "https://www.alexdoe.com/track1.jpg"
}
```

Response JSON Object:
```json
{
  "id": 1,
  "title": "Track 1",
  "albumName": "Album 1",
  "releaseDate": "2022-01-01",
  "duration": "3:30",
  "genre": "Pop",
  "description": "This is a description of Track 1",
  "playCount": 1000,
  "fileUrl": "https://www.alexdoe.com/track1.mp3",
  "coverImage": "https://www.alexdoe.com/track1.jpg"
}
```

### DELETE request to `/music/platform/v1/tracks/{trackId}`:

No response data, returns a `204 No Content` status.
</details>
