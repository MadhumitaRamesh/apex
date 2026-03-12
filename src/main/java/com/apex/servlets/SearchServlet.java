package com.apex.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("query");
        boolean includeShipping = "true".equals(request.getParameter("includeShipping"));
        boolean includeTax = "true".equals(request.getParameter("includeTax"));

        if (query == null || query.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        System.out.println("Processing search for: " + query);

        // 1. Save search to Firebase price history (async, non-blocking)
        try {
            com.google.firebase.database.DatabaseReference ref =
                    com.google.firebase.database.FirebaseDatabase.getInstance().getReference("priceHistory");
            String key = ref.push().getKey();
            java.util.Map<String, Object> data = new java.util.HashMap<>();
            data.put("productName", query);
            data.put("date", java.time.LocalDateTime.now().toString());
            ref.child(key).setValueAsync(data);

            // Log activity
            jakarta.servlet.http.HttpSession session = request.getSession();
            String userEmail = (String) session.getAttribute("user");
            String userName = (String) session.getAttribute("userName");
            if (userEmail != null) {
                AdminServlet.logActivity(userEmail, userName, "Search", "Searched for: " + query);
            }
        } catch (Exception e) {
            System.err.println("Firebase RTDB Error: " + e.getMessage());
        }

        // 2. Scrape Amazon & Flipkart for multiple results each
        com.apex.scraper.ScraperEngine scraper = new com.apex.scraper.ScraperEngine();
        Map<String, List<com.apex.models.ScrapedProduct>> byPlatform =
                scraper.scrapeMarketByPlatform(query);

        List<com.apex.models.ScrapedProduct> amazonResults = byPlatform.get("amazon");
        List<com.apex.models.ScrapedProduct> flipkartResults = byPlatform.get("flipkart");

        // 3. Apply shipping/tax adjustments if requested
        if (includeShipping || includeTax) {
            com.apex.services.PricingService pricingService = new com.apex.services.PricingService();
            for (com.apex.models.ScrapedProduct p : amazonResults) {
                p.setPrice(pricingService.calculateTrueCost(p.getPrice(), includeShipping, includeTax));
            }
            for (com.apex.models.ScrapedProduct p : flipkartResults) {
                p.setPrice(pricingService.calculateTrueCost(p.getPrice(), includeShipping, includeTax));
            }
        }

        System.out.println("Amazon results: " + amazonResults.size() + " | Flipkart results: " + flipkartResults.size());

        // 4. Pass data to results.jsp
        request.setAttribute("query", query);
        request.setAttribute("amazonResults", amazonResults);
        request.setAttribute("flipkartResults", flipkartResults);

        // Keep legacy single-result attrs for details.jsp compatibility
        if (!amazonResults.isEmpty()) {
            request.setAttribute("amazonResult", amazonResults.get(0).getName());
            request.setAttribute("amazonPrice", String.format("%.2f", amazonResults.get(0).getPrice()));
        }
        if (!flipkartResults.isEmpty()) {
            request.setAttribute("flipkartResult", flipkartResults.get(0).getName());
            request.setAttribute("flipkartPrice", String.format("%.2f", flipkartResults.get(0).getPrice()));
        }

        request.getRequestDispatcher("results.jsp").forward(request, response);
    }
}
