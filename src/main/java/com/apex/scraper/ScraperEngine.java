package com.apex.scraper;

import com.apex.models.ScrapedProduct;
import com.apex.services.AnalyticsService;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.*;

public class ScraperEngine {

    private static final String USER_AGENT =
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36";
    private static final String FK_API_UA =
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 FKUA/website/42/website/Desktop";
    private static final int MAX_RESULTS = 5;

    // ------------------------------------------------------------------ //
    //  Public API
    // ------------------------------------------------------------------ //

    /** Returns a map of platform -> up to 5 relevant results. */
    public Map<String, List<ScrapedProduct>> scrapeMarketByPlatform(String query) {
        Map<String, List<ScrapedProduct>> map = new LinkedHashMap<>();

        List<ScrapedProduct> amazonList = new ArrayList<>();
        try {
            amazonList = scrapeAmazonMultiple(query);
        } catch (Exception e) {
            System.err.println("Amazon Error: " + e.getMessage());
            amazonList.add(new ScrapedProduct(
                query + " (Amazon – data unavailable)", 0.0, "Amazon",
                "https://www.amazon.in/s?k=" + encodeQuery(query)));
        }
        map.put("amazon", amazonList);

        List<ScrapedProduct> flipkartList = new ArrayList<>();
        try {
            flipkartList = scrapeFlipkartMultiple(query);
        } catch (Exception e) {
            System.err.println("Flipkart Error: " + e.getMessage());
            flipkartList.add(new ScrapedProduct(
                query + " (Flipkart – data unavailable)", 0.0, "Flipkart",
                "https://www.flipkart.com/search?q=" + encodeQuery(query)));
        }
        map.put("flipkart", flipkartList);

        return map;
    }

    /** Backward-compat flat list: [amazon#1, flipkart#1] */
    public List<ScrapedProduct> scrapeMarket(String query) {
        Map<String, List<ScrapedProduct>> m = scrapeMarketByPlatform(query);
        List<ScrapedProduct> flat = new ArrayList<>();
        List<ScrapedProduct> az = m.get("amazon");
        List<ScrapedProduct> fk = m.get("flipkart");
        flat.add(az != null && !az.isEmpty() ? az.get(0) :
                new ScrapedProduct(query + " | Amazon (Unavailable)", 0.0, "Amazon", "#"));
        flat.add(fk != null && !fk.isEmpty() ? fk.get(0) :
                new ScrapedProduct(query + " | Flipkart (Unavailable)", 0.0, "Flipkart", "#"));
        return flat;
    }

    // ------------------------------------------------------------------ //
    //  Amazon
    // ------------------------------------------------------------------ //
    private List<ScrapedProduct> scrapeAmazonMultiple(String query) throws IOException {
        String url = "https://www.amazon.in/s?k=" + encodeQuery(query);
        Document doc = Jsoup.connect(url)
                .userAgent(USER_AGENT)
                .header("Accept-Language", "en-US,en;q=0.9")
                .header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9")
                .header("Referer", "https://www.google.com/")
                .timeout(15000)
                .get();

        List<ScrapedProduct> results = new ArrayList<>();
        Elements items = doc.select("div[data-component-type='s-search-result']");
        String[] queryWords = query.toLowerCase().split("\\s+");

        for (Element item : items) {
            if (results.size() >= MAX_RESULTS) break;

            // --- Product URL: find first <a> with /dp/ in its href ---
            Element dpLink = item.selectFirst("a[href*=/dp/]");
            if (dpLink == null) continue; // skip sponsored items without real links

            String href = dpLink.attr("href");
            // Clean the URL: keep path up to /dp/ASIN
            int dpIdx = href.indexOf("/dp/");
            if (dpIdx >= 0) {
                int end = href.indexOf('/', dpIdx + 4 + 10); // skip /dp/ + ~10 char ASIN
                if (end < 0) end = href.indexOf('?', dpIdx);
                if (end > 0) href = href.substring(0, end);
            }
            String productUrl = href.startsWith("http") ? href : "https://www.amazon.in" + href;

            // --- Title: prefer img.s-image alt text (most reliable on Amazon) ---
            Element img = item.selectFirst("img.s-image");
            String title = "";
            if (img != null) {
                title = img.attr("alt").trim();
                // Strip "Sponsored Ad - " prefix
                if (title.startsWith("Sponsored Ad - ")) {
                    title = title.substring("Sponsored Ad - ".length());
                }
            }
            // Fallback: use h2 text
            if (title.isEmpty()) {
                Element h2 = item.selectFirst("h2");
                title = h2 != null ? h2.text().trim() : "";
            }
            if (title.isEmpty()) continue;

            // Relevance: title must contain at least one key query word
            if (!isRelevant(title, queryWords)) continue;

            // --- Price & MRP ---
            Element priceEl = item.selectFirst(".a-price-whole");
            if (priceEl == null) continue;
            String priceText = priceEl.text().replaceAll("[^0-9]", "").trim();
            if (priceText.isEmpty()) continue;
            double price;
            try { price = Double.parseDouble(priceText); }
            catch (NumberFormatException ex) { continue; }
            if (price <= 0) continue;

            // Extra details for accuracy
            double mrp = price;
            Element mrpEl = item.selectFirst(".a-text-price .a-offscreen");
            if (mrpEl != null) {
                String mrpText = mrpEl.text().replaceAll("[^0-9]", "").trim();
                if (!mrpText.isEmpty()) {
                    try { mrp = Double.parseDouble(mrpText); } catch (Exception e) {}
                }
            }

            double shipping = 0.0;
            Element shipEl = item.selectFirst("[aria-label*='delivery']");
            if (shipEl != null && !shipEl.text().toLowerCase().contains("free")) {
                shipping = 40.0; // Default estimate for non-free Amazon delivery
            }

            results.add(new ScrapedProduct(title, price, mrp, shipping, "Amazon", productUrl));
            System.out.println("Amazon: " + title.substring(0, Math.min(40, title.length())) + " @ ₹" + price + " (MRP: " + mrp + ")");
        }

        if (results.isEmpty()) throw new IOException("Amazon: No relevant products found.");
        System.out.println("Amazon: extracted " + results.size() + " results for: " + query);
        return results;
    }

    // ------------------------------------------------------------------ //
    //  Flipkart (Rome API)
    // ------------------------------------------------------------------ //
    private List<ScrapedProduct> scrapeFlipkartMultiple(String query) throws IOException {
        String url = "https://2.rome.api.flipkart.com/api/4/page/fetch";
        String payload = String.format(
            "{\"pageUri\":\"/search?q=%s\",\"pageContext\":{\"fetchSeoData\":true},\"requestContext\":{\"type\":\"BROWSE_PAGE\"}}",
            encodeQuery(query));

        String jsonResponse = Jsoup.connect(url)
                .userAgent(FK_API_UA)
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .header("Referer", "https://www.flipkart.com/")
                .requestBody(payload)
                .ignoreContentType(true)
                .method(org.jsoup.Connection.Method.POST)
                .timeout(15000)
                .execute()
                .body();

        JSONObject root = new JSONObject(jsonResponse);
        if (!root.has("RESPONSE")) throw new IOException("Missing RESPONSE");
        JSONObject responseObj = root.getJSONObject("RESPONSE");
        if (!responseObj.has("slots")) throw new IOException("Missing slots");

        JSONArray slots = responseObj.getJSONArray("slots");
        List<ScrapedProduct> results = new ArrayList<>();
        String[] queryWords = query.toLowerCase().split("\\s+");

        for (int i = 0; i < slots.length() && results.size() < MAX_RESULTS; i++) {
            JSONObject slot = slots.getJSONObject(i);
            if (!slot.has("widget") || slot.isNull("widget")) continue;
            JSONObject widget = slot.getJSONObject("widget");
            if (!widget.has("data") || widget.isNull("data")) continue;
            JSONObject widgetData = widget.getJSONObject("data");
            if (!widgetData.has("products")) continue;

            JSONArray fkProducts = widgetData.getJSONArray("products");
            for (int j = 0; j < fkProducts.length() && results.size() < MAX_RESULTS; j++) {
                try {
                    JSONObject productItem = fkProducts.getJSONObject(j);
                    if (!productItem.has("productInfo")) continue;
                    JSONObject value = productItem.getJSONObject("productInfo").getJSONObject("value");

                    String title = value.getJSONObject("titles").getString("title");
                    if (!isRelevant(title, queryWords)) continue;

                    JSONObject pricing = value.getJSONObject("pricing");
                    double price = Double.parseDouble(pricing.getJSONObject("finalPrice").get("decimalValue").toString());
                    if (price <= 0) continue;

                    double mrp = price;
                    if (pricing.has("mrp")) {
                        mrp = Double.parseDouble(pricing.getJSONObject("mrp").get("decimalValue").toString());
                    }

                    double shipping = 0.0;
                    if (pricing.has("shippingCharge") && !pricing.isNull("shippingCharge")) {
                        shipping = Double.parseDouble(pricing.getJSONObject("shippingCharge").optString("decimalValue", "0"));
                    }

                    // Use smartUrl for a real deep-link to the product
                    String productUrl = value.optString("smartUrl", "");
                    if (productUrl.isEmpty()) {
                        String pid = value.optString("id", "");
                        productUrl = pid.isEmpty() ? "https://www.flipkart.com/search?q=" + encodeQuery(query)
                                                    : "https://www.flipkart.com/p/p/" + pid;
                    }

                    results.add(new ScrapedProduct(title, price, mrp, shipping, "Flipkart", productUrl));
                    System.out.println("Flipkart: " + title.substring(0, Math.min(40, title.length())) + " @ ₹" + price + " (MRP: " + mrp + ")");
                } catch (Exception e) {
                    System.err.println("Skipping Flipkart item: " + e.getMessage());
                }
            }
        }

        if (results.isEmpty()) throw new IOException("Flipkart: No relevant products found.");
        System.out.println("Flipkart: extracted " + results.size() + " results for: " + query);
        return results;
    }

    // ------------------------------------------------------------------ //
    //  Helpers
    // ------------------------------------------------------------------ //

    /**
     * Returns true if the title contains at least one significant word from the query.
     * Ignores common stop words.
     */
    private static final Set<String> STOP_WORDS = new HashSet<>(Arrays.asList(
        "a","an","the","for","with","in","of","and","or","to","on","at","by","from",
        "128","256","512","gb","tb","inch","pro","max","mini","plus","lite","se"
    ));

    private boolean isRelevant(String title, String[] queryWords) {
        String lowerTitle = title.toLowerCase();
        for (String word : queryWords) {
            if (word.length() <= 2 || STOP_WORDS.contains(word)) continue;
            if (lowerTitle.contains(word)) return true;
        }
        return false;
    }

    private String encodeQuery(String query) {
        return query.replace(" ", "+");
    }
}
