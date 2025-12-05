package com.hackerrank.configstyles.service;

public class ServiceResponse {
    private String serviceName;
    private String notification;

    public ServiceResponse(String serviceName, String notification) {
        this.serviceName = serviceName;
        this.notification = notification;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getNotification() {
        return notification;
    }

    public void setNotification(String notification) {
        this.notification = notification;
    }

    @Override
    public String toString() {
        return "{" +
                "\"serviceName\":\"" + serviceName + '\"' +
                ", \"notification\":\"" + notification + '\"' +
                '}';
    }
}
