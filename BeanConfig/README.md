## Environment:
- Java version: 17
- Maven version: 3.*
- Spring Boot version: 3.0.6

## Read-Only Files:
- src/test/*

## Requirements:
Spring Boot allows you to configure application beans using Java, XML, or annotation. In this project, there are a few classes that are used for sending notifications. Your task is to use all 3 types of configuration styles (i.e., XML, Java, and annotation) to define the beans so that those beans can be loaded into Spring Boot Application Context.

Candidate bean classes are given as follows:

|SN|Bean name|Bean class|Constructor args|
|---|---|---|---|
|1|	smsNotificationService|	SmsNotificationService.java|	SMS_SERVICE|
|2|	callNotificationService|	CallNotificationService.java|	CALL_SERVICE|
|3|	emailNotificationService|	EmailNotificationService.java|	EMAIL_SERVICE|
|4|	thirdPartyNotificationService|	ThirdPartyNotificationService.java|	THIRD_PARTY_SERVICE|

Configuration classes are given as follows:

* `JavaBasedConfiguration.java`:  This contains the beans defined using Java.
* `XmlBasedConfiguration.java`: This contains the beans defined on the xml_based_bean_configuration.xml.
* `xml_based_bean_configuration.xml`: The XML configuration file that contains the bean definitions.
* `App.java`: The starting point of the application where you can define beans using annotations.


You must do the following:

1. Define beans #1 and #2 using Java-based configuration.

2. Define bean #3 using annotation-based configuration.

3. Define bean #4 using XML-based configuration.

Your task is to complete the given project according to the given requirements so that it passes all the test cases when running the provided unit tests.

## Commands
- run: 
```bash
mvn clean package -DskipTests && java -jar target/SpringBootConfigurationStyles-1.0.jar
```
- install: 
```bash
mvn clean install
```
- test: 
```bash
mvn clean test
```
