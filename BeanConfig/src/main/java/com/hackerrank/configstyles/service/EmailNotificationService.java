package com.hackerrank.configstyles.service;


public class EmailNotificationService implements NotificationService {
    private String serviceName;

    public EmailNotificationService(String serviceName) {
        this.serviceName = serviceName;
    }

    public ServiceResponse sendNotification(String notification) {
        return new ServiceResponse(serviceName, notification);
    }

}
