package com.apex.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String productName = request.getParameter("product");
        String store = request.getParameter("store");
        String price = request.getParameter("price");
        String itemId = request.getParameter("itemId");

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("user");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String userId = userEmail.replace(".", "_");
            com.google.firebase.database.DatabaseReference hubRef = 
                com.google.firebase.database.FirebaseDatabase.getInstance().getReference("hub").child(userId);
            
            java.util.concurrent.CompletableFuture<Void> future = new java.util.concurrent.CompletableFuture<>();

            if ("remove".equals(action) && itemId != null) {
                hubRef.child(itemId).removeValue((error, ref) -> {
                    if (error != null) future.completeExceptionally(error.toException());
                    else future.complete(null);
                });
                future.get(5, java.util.concurrent.TimeUnit.SECONDS);
                System.out.println("Item removed from Hub: " + itemId);
            } else if (productName != null && price != null) {
                String newId = hubRef.push().getKey();
                java.util.Map<String, Object> itemData = new java.util.HashMap<>();
                itemData.put("name", productName);
                itemData.put("store", store != null ? store : "Unknown");
                itemData.put("price", price);
                itemData.put("timestamp", java.time.Instant.now().toString());

                hubRef.child(newId).setValue(itemData, (error, ref) -> {
                    if (error != null) future.completeExceptionally(error.toException());
                    else future.complete(null);
                });
                future.get(5, java.util.concurrent.TimeUnit.SECONDS);
                System.out.println("Item persisted to Firebase Hub for " + userEmail + ": " + productName);
            }
        } catch (Exception e) {
            System.err.println("Error processing hub action: " + e.getMessage());
        }
        
        response.sendRedirect("dashboard.jsp");
    }
}
