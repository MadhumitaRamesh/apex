package com.apex.servlets;

import com.apex.models.ScrapedProduct;
import com.apex.scraper.ScraperEngine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

/**
 * DetailsServlet — powers the "Deep Analysis" page.
 * Re-scrapes live data for the searched product and computes
 * real analytics: lowest price, highest price, average, savings,
 * verdict, and per-platform breakdowns.
 */
@WebServlet("/details")
public class DetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("query");
        if (query == null || query.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        System.out.println("Deep Analysis for: " + query);

        // 1. Scrape live data from both platforms
        ScraperEngine scraper = new ScraperEngine();
        Map<String, List<ScrapedProduct>> byPlatform = scraper.scrapeMarketByPlatform(query);

        List<ScrapedProduct> amazonResults = byPlatform.getOrDefault("amazon", new ArrayList<>());
        List<ScrapedProduct> flipkartResults = byPlatform.getOrDefault("flipkart", new ArrayList<>());

        // 2. Combine all products for analysis
        List<ScrapedProduct> allProducts = new ArrayList<>();
        allProducts.addAll(amazonResults);
        allProducts.addAll(flipkartResults);

        // 3. Compute analytics
        double lowestPrice = Double.MAX_VALUE;
        double highestPrice = 0;
        double totalPrice = 0;
        String lowestStore = "";
        String lowestProductName = "";
        String highestStore = "";
        String highestProductName = "";

        for (ScrapedProduct p : allProducts) {
            double price = p.getPrice();
            if (price <= 0) continue;
            totalPrice += price;
            if (price < lowestPrice) {
                lowestPrice = price;
                lowestStore = p.getStore();
                lowestProductName = p.getName();
            }
            if (price > highestPrice) {
                highestPrice = price;
                highestStore = p.getStore();
                highestProductName = p.getName();
            }
        }

        int validCount = 0;
        for (ScrapedProduct p : allProducts) {
            if (p.getPrice() > 0) validCount++;
        }

        double avgPrice = validCount > 0 ? totalPrice / validCount : 0;
        double savings = highestPrice - lowestPrice;
        double savingsPercent = highestPrice > 0 ? (savings / highestPrice) * 100 : 0;

        // Amazon-specific stats
        double amazonLowest = Double.MAX_VALUE;
        double amazonHighest = 0;
        for (ScrapedProduct p : amazonResults) {
            if (p.getPrice() > 0 && p.getPrice() < amazonLowest) amazonLowest = p.getPrice();
            if (p.getPrice() > amazonHighest) amazonHighest = p.getPrice();
        }
        if (amazonLowest == Double.MAX_VALUE) amazonLowest = 0;

        // Flipkart-specific stats
        double flipkartLowest = Double.MAX_VALUE;
        double flipkartHighest = 0;
        for (ScrapedProduct p : flipkartResults) {
            if (p.getPrice() > 0 && p.getPrice() < flipkartLowest) flipkartLowest = p.getPrice();
            if (p.getPrice() > flipkartHighest) flipkartHighest = p.getPrice();
        }
        if (flipkartLowest == Double.MAX_VALUE) flipkartLowest = 0;

        // 4. Determine verdict
        String verdict;
        String verdictClass;
        if (savingsPercent >= 15) {
            verdict = "Strong Buy — " + lowestStore;
            verdictClass = "success";
        } else if (savingsPercent >= 5) {
            verdict = "Good Deal — " + lowestStore;
            verdictClass = "primary";
        } else if (lowestPrice < avgPrice) {
            verdict = "Fair Price";
            verdictClass = "primary";
        } else {
            verdict = "Wait for Drop";
            verdictClass = "warning";
        }

        // 5. Which platform wins?
        String cheaperPlatform;
        double priceDiff;
        if (amazonLowest > 0 && flipkartLowest > 0) {
            if (amazonLowest < flipkartLowest) {
                cheaperPlatform = "Amazon";
                priceDiff = flipkartLowest - amazonLowest;
            } else if (flipkartLowest < amazonLowest) {
                cheaperPlatform = "Flipkart";
                priceDiff = amazonLowest - flipkartLowest;
            } else {
                cheaperPlatform = "Both Equal";
                priceDiff = 0;
            }
        } else if (amazonLowest > 0) {
            cheaperPlatform = "Amazon (only)";
            priceDiff = 0;
        } else {
            cheaperPlatform = "Flipkart (only)";
            priceDiff = 0;
        }

        // 6. Build chart data — Amazon prices and Flipkart prices as arrays
        StringBuilder amazonPricesJson = new StringBuilder("[");
        StringBuilder amazonLabelsJson = new StringBuilder("[");
        for (int i = 0; i < amazonResults.size(); i++) {
            if (i > 0) { amazonPricesJson.append(","); amazonLabelsJson.append(","); }
            amazonPricesJson.append(String.format("%.0f", amazonResults.get(i).getPrice()));
            String label = amazonResults.get(i).getName();
            // Shorten label for chart
            if (label.length() > 25) label = label.substring(0, 25) + "…";
            amazonLabelsJson.append("\"").append(label.replace("\"", "'")).append("\"");
        }
        amazonPricesJson.append("]");
        amazonLabelsJson.append("]");

        StringBuilder flipkartPricesJson = new StringBuilder("[");
        StringBuilder flipkartLabelsJson = new StringBuilder("[");
        for (int i = 0; i < flipkartResults.size(); i++) {
            if (i > 0) { flipkartPricesJson.append(","); flipkartLabelsJson.append(","); }
            flipkartPricesJson.append(String.format("%.0f", flipkartResults.get(i).getPrice()));
            String label = flipkartResults.get(i).getName();
            if (label.length() > 25) label = label.substring(0, 25) + "…";
            flipkartLabelsJson.append("\"").append(label.replace("\"", "'")).append("\"");
        }
        flipkartPricesJson.append("]");
        flipkartLabelsJson.append("]");

        // 7. Set all attributes for the JSP
        request.setAttribute("query", query);
        request.setAttribute("amazonResults", amazonResults);
        request.setAttribute("flipkartResults", flipkartResults);
        request.setAttribute("allCount", validCount);

        request.setAttribute("lowestPrice", String.format("%.0f", lowestPrice));
        request.setAttribute("highestPrice", String.format("%.0f", highestPrice));
        request.setAttribute("avgPrice", String.format("%.0f", avgPrice));
        request.setAttribute("lowestStore", lowestStore);
        request.setAttribute("lowestProductName", lowestProductName);
        request.setAttribute("highestStore", highestStore);
        request.setAttribute("highestProductName", highestProductName);
        request.setAttribute("savings", String.format("%.0f", savings));
        request.setAttribute("savingsPercent", String.format("%.1f", savingsPercent));
        request.setAttribute("verdict", verdict);
        request.setAttribute("verdictClass", verdictClass);
        request.setAttribute("cheaperPlatform", cheaperPlatform);
        request.setAttribute("priceDiff", String.format("%.0f", priceDiff));

        request.setAttribute("amazonLowest", String.format("%.0f", amazonLowest));
        request.setAttribute("amazonHighest", String.format("%.0f", amazonHighest));
        request.setAttribute("amazonCount", amazonResults.size());
        request.setAttribute("flipkartLowest", String.format("%.0f", flipkartLowest));
        request.setAttribute("flipkartHighest", String.format("%.0f", flipkartHighest));
        request.setAttribute("flipkartCount", flipkartResults.size());

        request.setAttribute("amazonPricesJson", amazonPricesJson.toString());
        request.setAttribute("amazonLabelsJson", amazonLabelsJson.toString());
        request.setAttribute("flipkartPricesJson", flipkartPricesJson.toString());
        request.setAttribute("flipkartLabelsJson", flipkartLabelsJson.toString());

        request.getRequestDispatcher("details.jsp").forward(request, response);
    }
}
