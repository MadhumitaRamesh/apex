package com.apex.services;

import java.util.ArrayList;
import java.util.List;

/**
 * AlertService handles price drop subscriptions.
 */
public class AlertService {

    private List<String> alerts = new ArrayList<>();

    public void setAlert(String email, String product, double targetPrice) {
        String alertInfo = String.format("Alert set for %s: %s at ₹%.2f", email, product, targetPrice);
        alerts.add(alertInfo);
        System.out.println(alertInfo);
    }
}
