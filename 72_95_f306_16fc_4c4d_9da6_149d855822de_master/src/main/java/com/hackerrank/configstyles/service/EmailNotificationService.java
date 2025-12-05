package com.hackerrank.configstyles.service;

import org.springframework.stereotype.Service;

@Service
public class EmailNotificationService implements NotificationService {
    private String serviceName="EMAIL_SERVICE";
    
    public EmailNotificationService() {}

    public EmailNotificationService(String serviceName) {
        this.serviceName = serviceName;
    }

    public ServiceResponse sendNotification(String notification) {
        return new ServiceResponse(serviceName, notification);
    }

}
