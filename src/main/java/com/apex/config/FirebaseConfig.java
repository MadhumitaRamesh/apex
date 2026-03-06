package com.apex.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.io.InputStream;

@WebListener
public class FirebaseConfig implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("Initializing Apex Firebase Backend...");
            
            // Path to your service account key file inside WEB-INF
            InputStream serviceAccount = sce.getServletContext()
                    .getResourceAsStream("/WEB-INF/serviceAccountKey.json");

            if (serviceAccount == null) {
                System.err.println("Firebase setup FAILED: serviceAccountKey.json not found in WEB-INF.");
                System.err.println("Please download your key from Firebase Console and place it in src/main/webapp/WEB-INF/");
                return;
            }

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .setDatabaseUrl("https://apex-price-scout-default-rtdb.asia-southeast1.firebasedatabase.app/")
                    .build();

            FirebaseApp.initializeApp(options);
            System.out.println("Firebase Realtime Database successfully initialized!");
            
        } catch (Exception e) {
            System.err.println("Firebase Initialization Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Apex Server stopping...");
    }
}
