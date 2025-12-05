# Springboot Java: Sales API
In this project, data is given regarding various sales. (Note that all data is artificial.) Your task is to implement several REST endpoints to handle this data.

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

Here is an example of a sale data JSON object:

```json
{
  "id": 1,
  "productName": "product1",
  "customerEmail": "cust@gmail.com",
  "sellingPrice": 200,
  "buyingPrice": 100
}
```

## Requirements

The application should adhere to the following API format and response codes:

`POST /sale`:
- Accepts a sale object and returns status code 201 if the object is valid.
- All the properties are validated using the following rules:
  - _productName_ cannot be empty. If empty, return status code 400 and the message "Product name is mandatory".
  - _customerEmail_ should be a valid email. If invalid, return status code 400 and the message "Invalid customer email".
  - _sellingPrice_ should be a positive integer. If invalid, return status code 400 and the message "Value should not be negative".
  - _buyingPrice_ should be a positive integer. If invalid, return status code 400 and the message "Value should not be negative".

`GET /sale/{id}`:
- Returns the sale entry with the given ID and status code 200.

`GET /sale`:
- Returns all the sale entries with status code 200.

There are 4 tests already written, but some don't work due to bugs in the implementation of the endpoints. Find the bugs and fix them so that all the tests pass.
