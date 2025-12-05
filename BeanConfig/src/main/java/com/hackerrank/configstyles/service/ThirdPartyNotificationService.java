package com.hackerrank.configstyles.service;

public class ThirdPartyNotificationService implements NotificationService {
    private String serviceName;

    public ThirdPartyNotificationService(String serviceName) {
        this.serviceName = serviceName;
    }

    public ServiceResponse sendNotification(String notification) {
        return new ServiceResponse(serviceName, notification);
    }

}
