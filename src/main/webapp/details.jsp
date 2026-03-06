<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Analysis — ${query} | Apex</title>
                <meta name="description" content="Deep price analytics and market intelligence for ${query}.">
                <link rel="stylesheet" href="css/styles.css?v=2.0">
                <style>
                    .metrics-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                        gap: 1rem;
                        margin-bottom: 2rem;
                    }

                    .metric-card {
                        background: #fff;
                        border: 1px solid #e2e8f0;
                        border-radius: 12px;
                        padding: 1.1rem 1.2rem;
                        text-align: center;
                    }

                    .metric-label {
                        font-size: 0.72rem;
                        color: #94a3b8;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.4rem;
                    }

                    .metric-value {
                        font-size: 1.35rem;
                        font-weight: 700;
                        color: #1e293b;
                    }

                    .metric-value.success {
                        color: #16a34a;
                    }

                    .metric-value.danger {
                        color: #dc2626;
                    }

                    .metric-value.primary {
                        color: #6366f1;
                    }

                    .metric-value.warning {
                        color: #d97706;
                    }

                    .metric-sub {
                        font-size: 0.7rem;
                        color: #94a3b8;
                        margin-top: 0.25rem;
                    }

                    .analysis-cards {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 1.25rem;
                        margin-top: 1.5rem;
                    }

                    .analysis-card {
                        background: #fff;
                        border: 1px solid #e2e8f0;
                        border-radius: 12px;
                        padding: 1.2rem 1.3rem;
                    }

                    .analysis-card h3 {
                        font-size: 0.85rem;
                        font-weight: 700;
                        color: #1e293b;
                        margin: 0 0 0.6rem 0;
                    }

                    .analysis-card p {
                        font-size: 0.8rem;
                        color: #64748b;
                        line-height: 1.6;
                        margin: 0;
                    }

                    .platform-compare {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 1.25rem;
                        margin-top: 1.5rem;
                    }

                    .platform-box {
                        background: #fff;
                        border: 1px solid #e2e8f0;
                        border-radius: 12px;
                        padding: 1.2rem;
                    }

                    .platform-box h3 {
                        font-size: 0.82rem;
                        font-weight: 700;
                        margin: 0 0 0.75rem 0;
                    }

                    .platform-box h3.amazon-color {
                        color: #e47911;
                    }

                    .platform-box h3.flipkart-color {
                        color: #4f46e5;
                    }

                    .platform-stat {
                        display: flex;
                        justify-content: space-between;
                        padding: 0.4rem 0;
                        border-bottom: 1px solid #f1f5f9;
                        font-size: 0.8rem;
                    }

                    .platform-stat:last-child {
                        border-bottom: none;
                    }

                    .platform-stat .label {
                        color: #94a3b8;
                    }

                    .platform-stat .value {
                        font-weight: 600;
                        color: #1e293b;
                    }

                    .chart-container {
                        background: #fff;
                        border: 1px solid #e2e8f0;
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    .chart-title {
                        font-size: 0.85rem;
                        font-weight: 700;
                        color: #1e293b;
                        margin: 0 0 1rem 0;
                    }

                    .back-link {
                        font-size: 0.8rem;
                        color: #64748b;
                        text-decoration: none;
                        margin-bottom: 0.75rem;
                        display: inline-block;
                    }

                    .back-link:hover {
                        color: #2563eb;
                    }

                    .product-list {
                        margin-top: 1.5rem;
                    }

                    .product-row {
                        display: grid;
                        grid-template-columns: 2rem 1fr auto auto;
                        align-items: center;
                        gap: 0.75rem;
                        padding: 0.6rem 0;
                        border-bottom: 1px solid #f1f5f9;
                        font-size: 0.8rem;
                    }

                    .product-row:last-child {
                        border-bottom: none;
                    }

                    .product-rank {
                        width: 22px;
                        height: 22px;
                        border-radius: 50%;
                        background: #f1f5f9;
                        color: #64748b;
                        font-size: 0.65rem;
                        font-weight: 700;
                        text-align: center;
                        line-height: 22px;
                    }

                    .product-rank.best {
                        background: #dcfce7;
                        color: #16a34a;
                    }

                    .product-name {
                        color: #1e293b;
                        font-weight: 500;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .product-store {
                        font-size: 0.7rem;
                        color: #94a3b8;
                        white-space: nowrap;
                    }

                    .product-price {
                        font-weight: 700;
                        color: #1e293b;
                        white-space: nowrap;
                    }

                    @media (max-width: 700px) {
                        .metrics-grid {
                            grid-template-columns: 1fr 1fr;
                        }

                        .analysis-cards {
                            grid-template-columns: 1fr;
                        }

                        .platform-compare {
                            grid-template-columns: 1fr;
                        }
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/navbar.jsp" />

                <div class="page-wrapper">
                    <div class="page-header">
                        <a href="search?query=${query}" class="back-link">&#8592; Back to Results</a>
                        <p class="page-label">Deep Analysis</p>
                        <h1 class="page-title">${query}</h1>
                        <p class="page-subtitle">
                            Live market comparison across ${amazonCount} Amazon + ${flipkartCount} Flipkart listings
                            (${allCount} total)
                        </p>
                    </div>

                    <%-- ════ PRICE CONFIGURATION BAR (Deep Analysis) ════ --%>
                        <div class="price-config-bar"
                            style="max-width: 900px; margin: 0 auto 2rem auto; background: #f8fafc; padding: 1rem 1.5rem; border-radius: 12px; border: 1px solid #e2e8f0; display: flex; align-items: center; justify-content: space-between; gap: 1rem; flex-wrap: wrap;">
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <span style="font-size: 0.85rem; font-weight: 700; color: #475569;">Analysis
                                    Mode:</span>
                                <span id="price-mode-label"
                                    style="font-size: 0.8rem; color: #64748b; background: #fff; padding: 0.2rem 0.6rem; border-radius: 4px; border: 1px solid #cbd5e1;">Base
                                    Price</span>
                            </div>
                            <div style="display: flex; gap: 1.5rem; flex-wrap: wrap;">
                                <label
                                    style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer; font-size: 0.85rem; font-weight: 600; color: #1e293b;">
                                    <input type="checkbox" id="toggle-gst" onchange="updateDeepAnalysis()"
                                        style="width: 16px; height: 16px;">
                                    Include GST (18%)
                                </label>
                                <label
                                    style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer; font-size: 0.85rem; font-weight: 600; color: #1e293b;">
                                    <input type="checkbox" id="toggle-shipping" onchange="updateDeepAnalysis()"
                                        style="width: 16px; height: 16px;">
                                    Include Shipping
                                </label>
                            </div>
                        </div>

                        <script>
                            function updateDeepAnalysis() {
                                const inclGst = document.getElementById('toggle-gst').checked;
                                const inclShip = document.getElementById('toggle-shipping').checked;
                                const modeLabel = document.getElementById('price-mode-label');

                                if (inclGst && inclShip) modeLabel.innerText = "Total (GST + Ship)";
                                else if (inclGst) modeLabel.innerText = "Incl. GST";
                                else if (inclShip) modeLabel.innerText = "Incl. Shipping";
                                else modeLabel.innerText = "Base Price";

                                let minP = Infinity, maxP = 0, totalP = 0, count = 0;
                                let amzMin = Infinity, amzMax = 0, flkMin = Infinity, flkMax = 0;

                                document.querySelectorAll('.product-row').forEach(row => {
                                    const base = parseFloat(row.dataset.base);
                                    const ship = parseFloat(row.dataset.shipping);
                                    let current = base;
                                    if (inclGst) current += (base * 0.18);
                                    if (inclShip) current += ship;

                                    row.querySelector('.product-price-value').innerText = Math.round(current).toLocaleString('en-IN');

                                    if (current > 0) {
                                        if (current < minP) minP = current;
                                        if (current > maxP) maxP = current;
                                        totalP += current;
                                        count++;

                                        if (row.classList.contains('amazon-row')) {
                                            if (current < amzMin) amzMin = current;
                                            if (current > amzMax) amzMax = current;
                                        } else if (row.classList.contains('flipkart-row')) {
                                            if (current < flkMin) flkMin = current;
                                            if (current > flkMax) flkMax = current;
                                        }
                                    }
                                });

                                if (count > 0) {
                                    document.getElementById('metric-low').innerText = "₹" + Math.round(minP).toLocaleString('en-IN');
                                    document.getElementById('metric-high').innerText = "₹" + Math.round(maxP).toLocaleString('en-IN');
                                    document.getElementById('metric-avg').innerText = "₹" + Math.round(totalP / count).toLocaleString('en-IN');
                                    document.getElementById('metric-savings').innerText = "₹" + Math.round(maxP - minP).toLocaleString('en-IN');

                                    if (amzMin !== Infinity) {
                                        document.getElementById('amazon-low').innerText = "₹" + Math.round(amzMin).toLocaleString('en-IN');
                                        document.getElementById('amazon-high').innerText = "₹" + Math.round(amzMax).toLocaleString('en-IN');
                                    }
                                    if (flkMin !== Infinity) {
                                        document.getElementById('flipkart-low').innerText = "₹" + Math.round(flkMin).toLocaleString('en-IN');
                                        document.getElementById('flipkart-high').innerText = "₹" + Math.round(flkMax).toLocaleString('en-IN');
                                    }
                                }
                            }
                        </script>

                        <div style="max-width: 900px; margin: 0 auto;">

                            <%-- ════ KEY METRICS ════ --%>
                                <div class="metrics-grid">
                                    <div class="metric-card">
                                        <div class="metric-label">Lowest Price</div>
                                        <div id="metric-low" class="metric-value success">₹
                                            <fmt:formatNumber value="${lowestPrice}" groupingUsed="true" />
                                        </div>
                                        <div class="metric-sub">${lowestStore}</div>
                                    </div>
                                    <div class="metric-card">
                                        <div class="metric-label">Highest Price</div>
                                        <div id="metric-high" class="metric-value danger">₹
                                            <fmt:formatNumber value="${highestPrice}" groupingUsed="true" />
                                        </div>
                                        <div class="metric-sub">${highestStore}</div>
                                    </div>
                                    <div class="metric-card">
                                        <div class="metric-label">Average Price</div>
                                        <div id="metric-avg" class="metric-value">₹
                                            <fmt:formatNumber value="${avgPrice}" groupingUsed="true" />
                                        </div>
                                        <div class="metric-sub">${allCount} listings</div>
                                    </div>
                                    <div class="metric-card">
                                        <div class="metric-label">Max Savings</div>
                                        <div id="metric-savings" class="metric-value primary">₹
                                            <fmt:formatNumber value="${savings}" groupingUsed="true" />
                                        </div>
                                        <div class="metric-sub">${savingsPercent}% off highest</div>
                                    </div>
                                </div>

                                <%-- ════ VERDICT ════ --%>
                                    <div class="analysis-cards">
                                        <div class="analysis-card">
                                            <h3>🎯 Apex Verdict</h3>
                                            <p style="font-size: 1.1rem; font-weight: 700;" class="${verdictClass}">
                                                ${verdict}
                                            </p>
                                            <p style="margin-top: 0.5rem;">
                                                <c:choose>
                                                    <c:when test="${priceDiff > 0}">
                                                        <strong>${cheaperPlatform}</strong> offers the best deal, saving
                                                        you
                                                        <strong>₹${priceDiff}</strong> compared to the other platform.
                                                    </c:when>
                                                    <c:otherwise>
                                                        Both platforms are offering similar pricing for this product.
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="analysis-card">
                                            <h3>📊 Market Summary</h3>
                                            <p>
                                                Across <strong>${allCount}</strong> live listings, prices range from
                                                <strong>₹${lowestPrice}</strong> to <strong>₹${highestPrice}</strong>.
                                                The best value is <em>${lowestProductName}</em> on ${lowestStore}.
                                            </p>
                                        </div>
                                    </div>

                                    <%-- ════ PLATFORM COMPARISON ════ --%>
                                        <div class="platform-compare">
                                            <div class="platform-box">
                                                <h3 class="amazon-color">🟠 Amazon.in</h3>
                                                <div class="platform-stat">
                                                    <span class="label">Listings Found</span>
                                                    <span class="value">${amazonCount}</span>
                                                </div>
                                                <div class="platform-stat">
                                                    <span class="label">Lowest Price</span>
                                                    <span id="amazon-low" class="value" style="color:#16a34a;">₹
                                                        <fmt:formatNumber value="${amazonLowest}" groupingUsed="true" />
                                                    </span>
                                                </div>
                                                <div class="platform-stat">
                                                    <span class="label">Highest Price</span>
                                                    <span id="amazon-high" class="value">₹
                                                        <fmt:formatNumber value="${amazonHighest}"
                                                            groupingUsed="true" />
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="platform-box">
                                                <h3 class="flipkart-color">🔵 Flipkart</h3>
                                                <div class="platform-stat">
                                                    <span class="label">Listings Found</span>
                                                    <span class="value">${flipkartCount}</span>
                                                </div>
                                                <div class="platform-stat">
                                                    <span class="label">Lowest Price</span>
                                                    <span id="flipkart-low" class="value" style="color:#16a34a;">₹
                                                        <fmt:formatNumber value="${flipkartLowest}"
                                                            groupingUsed="true" />
                                                    </span>
                                                </div>
                                                <div class="platform-stat">
                                                    <span class="label">Highest Price</span>
                                                    <span id="flipkart-high" class="value">₹
                                                        <fmt:formatNumber value="${flipkartHighest}"
                                                            groupingUsed="true" />
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <%-- ════ PRICE CHART ════ --%>
                                            <div class="chart-container" style="margin-top: 1.5rem;">
                                                <h3 class="chart-title">Price Comparison Chart — All Listings</h3>
                                                <canvas id="detailChart" height="200"></canvas>
                                            </div>

                                            <%-- ════ ALL PRODUCTS RANKED ════ --%>
                                                <div class="chart-container">
                                                    <h3 class="chart-title">All Products — Ranked by Price (Low → High)
                                                    </h3>
                                                    <div class="product-list">
                                                        <c:forEach var="p" items="${amazonResults}" varStatus="s">
                                                            <c:set var="allProducts"
                                                                value="${allProducts}${p.price}|${p.name}|${p.store}|${p.url}|||" />
                                                        </c:forEach>
                                                        <%-- Amazon products --%>
                                                            <c:forEach var="p" items="${amazonResults}" varStatus="s">
                                                                <div class="product-row amazon-row"
                                                                    data-base="${p.price}"
                                                                    data-shipping="${p.shipping}">
                                                                    <span class="product-rank">A${s.index + 1}</span>
                                                                    <div style="flex: 1; min-width: 0;">
                                                                        <div class="product-name" title="${p.name}">
                                                                            ${p.name}</div>
                                                                        <div
                                                                            style="display: flex; gap: 0.5rem; font-size: 0.65rem; color: #94a3b8; margin-top: 2px;">
                                                                            <span>Amazon.in</span>
                                                                            <c:if test="${p.mrp > p.price}">
                                                                                <span
                                                                                    style="text-decoration: line-through;">₹
                                                                                    <fmt:formatNumber value="${p.mrp}"
                                                                                        groupingUsed="true" />
                                                                                </span>
                                                                                <span
                                                                                    style="color: #16a34a; font-weight: 700;">${p.getSavingsPercentage()}%
                                                                                    OFF</span>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                    <span class="product-price">₹<span
                                                                            class="product-price-value">
                                                                            <fmt:formatNumber value="${p.price}"
                                                                                type="number" groupingUsed="true"
                                                                                maxFractionDigits="0" />
                                                                        </span></span>
                                                                </div>
                                                            </c:forEach>
                                                            <%-- Flipkart products --%>
                                                                <c:forEach var="p" items="${flipkartResults}"
                                                                    varStatus="s">
                                                                    <div class="product-row flipkart-row"
                                                                        data-base="${p.price}"
                                                                        data-shipping="${p.shipping}">
                                                                        <span class="product-rank">F${s.index +
                                                                            1}</span>
                                                                        <div style="flex: 1; min-width: 0;">
                                                                            <div class="product-name" title="${p.name}">
                                                                                ${p.name}</div>
                                                                            <div
                                                                                style="display: flex; gap: 0.5rem; font-size: 0.65rem; color: #94a3b8; margin-top: 2px;">
                                                                                <span>Flipkart</span>
                                                                                <c:if test="${p.mrp > p.price}">
                                                                                    <span
                                                                                        style="text-decoration: line-through;">₹
                                                                                        <fmt:formatNumber
                                                                                            value="${p.mrp}"
                                                                                            groupingUsed="true" />
                                                                                    </span>
                                                                                    <span
                                                                                        style="color: #16a34a; font-weight: 700;">${p.getSavingsPercentage()}%
                                                                                        OFF</span>
                                                                                </c:if>
                                                                            </div>
                                                                        </div>
                                                                        <span class="product-price">₹<span
                                                                                class="product-price-value">
                                                                                <fmt:formatNumber value="${p.price}"
                                                                                    type="number" groupingUsed="true"
                                                                                    maxFractionDigits="0" />
                                                                            </span></span>
                                                                    </div>
                                                                </c:forEach>
                                                    </div>
                                                </div>

                        </div>

                        <footer class="page-footer">
                            <p>&copy; 2026 Apex Analytics &bull; Live data from Amazon.in &amp; Flipkart</p>
                        </footer>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    const ctx = document.getElementById('detailChart').getContext('2d');

                    const amazonPrices = ${ amazonPricesJson };
                    const amazonLabels = ${ amazonLabelsJson };
                    const flipkartPrices = ${ flipkartPricesJson };
                    const flipkartLabels = ${ flipkartLabelsJson };

                    // Build unified labels: A1, A2... F1, F2...
                    const labels = [];
                    amazonLabels.forEach((l, i) => labels.push('A' + (i + 1)));
                    flipkartLabels.forEach((l, i) => labels.push('F' + (i + 1)));

                    const allPrices = [...amazonPrices, ...flipkartPrices];

                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [
                                {
                                    label: 'Amazon',
                                    data: amazonPrices.concat(new Array(flipkartPrices.length).fill(null)),
                                    backgroundColor: 'rgba(228, 121, 17, 0.75)',
                                    borderColor: '#e47911',
                                    borderWidth: 1,
                                    borderRadius: 6
                                },
                                {
                                    label: 'Flipkart',
                                    data: new Array(amazonPrices.length).fill(null).concat(flipkartPrices),
                                    backgroundColor: 'rgba(79, 70, 229, 0.75)',
                                    borderColor: '#4f46e5',
                                    borderWidth: 1,
                                    borderRadius: 6
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    position: 'top',
                                    labels: { font: { size: 11 }, usePointStyle: true, pointStyle: 'circle' }
                                },
                                tooltip: {
                                    callbacks: {
                                        title: function (items) {
                                            const idx = items[0].dataIndex;
                                            if (idx < amazonLabels.length) return amazonLabels[idx];
                                            return flipkartLabels[idx - amazonLabels.length];
                                        },
                                        label: function (item) {
                                            return '₹' + item.raw.toLocaleString('en-IN');
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    border: { display: false },
                                    grid: { color: '#f1f5f9' },
                                    ticks: {
                                        color: '#94a3b8',
                                        font: { size: 11 },
                                        callback: function (v) { return '₹' + v.toLocaleString('en-IN'); }
                                    }
                                },
                                x: {
                                    border: { display: false },
                                    grid: { display: false },
                                    ticks: { color: '#94a3b8', font: { size: 11 } }
                                }
                            }
                        }
                    });
                </script>
            </body>

            </html>