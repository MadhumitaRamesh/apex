package com.apex.services;

import java.util.Arrays;
import java.util.List;

/**
 * AnalyticsService provides Sentiment Analysis and Recommendations.
 * Uses a "Bag of Words" approach for classifying reviews.
 */
public class AnalyticsService {

    private static final List<String> POSITIVE_WORDS = Arrays.asList(
        "great", "amazing", "excellent", "good", "quality", "worth", "stunning", "best"
    );

    private static final List<String> NEGATIVE_WORDS = Arrays.asList(
        "bad", "terrible", "worst", "poor", "brokern", "defective", "waste", "expensive"
    );

    /**
     * simpleSentimentAnalysis classifies a list of reviews.
     * @return A string: "Positive", "Neutral", or "Negative"
     */
    public String analyzeSentiment(List<String> reviews) {
        if (reviews == null || reviews.isEmpty()) return "No Reviews";

        int score = 0;
        for (String review : reviews) {
            String lower = review.toLowerCase();
            for (String pos : POSITIVE_WORDS) if (lower.contains(pos)) score++;
            for (String neg : NEGATIVE_WORDS) if (lower.contains(neg)) score--;
        }

        if (score > 2) return "Positive";
        if (score < -2) return "Negative";
        return "Neutral";
    }

    /**
     * getRecommendation provides a "Buy" or "Wait" signal.
     */
    public String getRecommendation(String sentiment, double currentPrice, double averagePrice) {
        if (sentiment.equals("Negative")) return "Avoid (Bad Reviews)";
        if (currentPrice < averagePrice && sentiment.equals("Positive")) return "Strong Buy!";
        if (currentPrice > averagePrice) return "Wait (Price is high)";
        
        return "Buy";
    }
}
