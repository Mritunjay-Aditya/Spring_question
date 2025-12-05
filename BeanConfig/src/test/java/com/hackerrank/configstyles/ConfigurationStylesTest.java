package com.hackerrank.configstyles;

import com.hackerrank.configstyles.javabased.JavaBasedConfiguration;
import com.hackerrank.configstyles.service.NotificationService;
import com.hackerrank.configstyles.service.ServiceResponse;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.Random;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class ConfigurationStylesTest {
    @Autowired
    ApplicationContext context;

    @Test
    public void testJavaBasedConfiguration() {
        ApplicationContext javaContext = new AnnotationConfigApplicationContext(JavaBasedConfiguration.class);

        assertEquals(2, javaContext.getBeansOfType(NotificationService.class).size());

        Random random = new Random(1);
        String notification = String.valueOf(random.nextInt(Integer.MAX_VALUE));

        NotificationService notificationService = (NotificationService) javaContext.getBean("smsNotificationService");
        ServiceResponse response = notificationService.sendNotification(notification);

        assertEquals("SMS_SERVICE", response.getServiceName());
        assertEquals(notification, response.getNotification());

        notificationService = (NotificationService) javaContext.getBean("callNotificationService");
        notification = String.valueOf(random.nextInt(Integer.MAX_VALUE));

        response = notificationService.sendNotification(notification);
        assertEquals("CALL_SERVICE", response.getServiceName());
        assertEquals(notification, response.getNotification());
    }

    @Test
    public void testXmlBasedConfiguration() {
        ClassPathXmlApplicationContext xmlContext = new ClassPathXmlApplicationContext("xml_based_bean_configuration.xml");

        assertEquals(1, xmlContext.getBeansOfType(NotificationService.class).size());

        Random random = new Random(1);
        String notification = String.valueOf(random.nextInt(Integer.MAX_VALUE));

        NotificationService notificationService = (NotificationService) xmlContext.getBean("thirdPartyNotificationService");
        ServiceResponse response = notificationService.sendNotification(notification);

        assertEquals("THIRD_PARTY_SERVICE", response.getServiceName());
        assertEquals(notification, response.getNotification());
    }


    @Test
    public void testAnnotationBasedConfiguration() {
        Random random = new Random(1);
        String notification = String.valueOf(random.nextInt(Integer.MAX_VALUE));

        NotificationService notificationService = (NotificationService) context.getBean("emailNotificationService");
        ServiceResponse response = notificationService.sendNotification(notification);

        assertEquals("EMAIL_SERVICE", response.getServiceName());
        assertEquals(notification, response.getNotification());
    }
}
