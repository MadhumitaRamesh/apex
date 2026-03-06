<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Apex | Professional Price Intelligence</title>
        <meta name="description"
            content="Scout every store in real-time. Compare prices, analyze sentiment, and make data-driven buying decisions with Apex.">
        <link rel="stylesheet" href="css/styles.css?v=2.0">
    </head>

    <body>
        <jsp:include page="includes/navbar.jsp" />

        <div class="page-wrapper">
            <!-- Hero Section -->
            <section class="hero-section">
                <h1 class="hero-title">
                    Market Intelligence<br>
                    <span class="accent">Simplified.</span>
                </h1>
                <p class="hero-subtitle">
                    Scout every store in real-time. Compare prices, analyze sentiment, and make
                    data-driven buying decisions — all in one place.
                </p>

                <form action="search" method="GET">
                    <div class="search-bar">
                        <input type="text" name="query" placeholder="Search any product — e.g. Sony WH-1000XM5..."
                            required autofocus>
                        <button type="submit" class="btn btn-primary btn-lg">Search</button>
                    </div>
                    <div class="search-options">
                        <label>
                            <input type="checkbox" name="includeShipping" value="true">
                            Include Estimated Shipping
                        </label>
                        <label>
                            <input type="checkbox" name="includeTax" value="true">
                            Include GST
                        </label>
                    </div>
                </form>
            </section>

            <!-- Features Grid -->
            <section>
                <p class="section-meta"
                    style="font-size:0.75rem;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;color:var(--text-muted);margin-bottom:1.5rem;">
                    What powers Apex
                </p>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-value">50+</div>
                        <div class="feature-label">Retailers Scanned</div>
                        <p class="feature-desc">Scanning live data feeds from global and local marketplaces in
                            real-time.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-value">Jsoup</div>
                        <div class="feature-label">Extraction Engine</div>
                        <p class="feature-desc">Direct HTML parsing for zero-latency, accurate market data extraction.
                        </p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-value">AI</div>
                        <div class="feature-label">Trust Score</div>
                        <p class="feature-desc">Dynamic sentiment analysis across thousands of verified buyer reviews.
                        </p>
                    </div>
                </div>
            </section>

            <footer class="page-footer">
                <p>&copy; 2026 Apex Intelligence &bull; Built with Advanced Java &amp; Semantic Architecture</p>
            </footer>
        </div>
    </body>

    </html>