package com.hackerrank.configstyles.xmlbased;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;

@Configuration
@ImportResource({"classpath*:xml_based_configuration.xml"})
public class XmlBasedConfiguration {
}
