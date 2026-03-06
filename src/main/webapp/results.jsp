<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Results for "${query}" | Apex</title>
                <meta name="description" content="Compare prices for ${query} across Amazon and Flipkart.">
                <link rel="stylesheet" href="css/styles.css?v=2.0">
                <style>
                    /* ── Platform section ─────────────────────────────── */
                    .platform-block {
                        margin-bottom: 2.5rem;
                    }

                    .platform-bar {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        margin-bottom: 1rem;
                        padding-bottom: 0.6rem;
                        border-bottom: 2px solid #f1f5f9;
                    }

                    .platform-tag {
                        font-weight: 700;
                        font-size: 0.82rem;
                        padding: 0.28rem 0.9rem;
                        border-radius: 999px;
                        color: #fff;
                        letter-spacing: 0.03em;
                    }

                    .tag-amazon {
                        background: #e47911;
                    }

                    .tag-flipkart {
                        background: #4f46e5;
                    }

                    .platform-count {
                        font-size: 0.79rem;
                        color: #94a3b8;
                    }

                    /* ── Product card ─────────────────────────────────── */
                    .pcard {
                        display: grid;
                        grid-template-columns: 2rem 1fr auto;
                        align-items: center;
                        gap: 1rem;
                        background: #fff;
                        border: 1px solid #e2e8f0;
                        border-radius: 12px;
                        padding: 0.9rem 1.1rem;
                        margin-bottom: 0.65rem;
                        transition: box-shadow 0.18s, border-color 0.18s;
                        min-width: 0;
                    }

                    .pcard:hover {
                        box-shadow: 0 4px 20px rgba(99, 102, 241, 0.09);
                        border-color: #c7d2fe;
                    }

                    /* rank badge */
                    .rank {
                        width: 26px;
                        height: 26px;
                        border-radius: 50%;
                        background: #f1f5f9;
                        color: #64748b;
                        font-size: 0.7rem;
                        font-weight: 700;
                        text-align: center;
                        line-height: 26px;
                        flex-shrink: 0;
                    }

                    .rank.gold {
                        background: #fef3c7;
                        color: #b45309;
                    }

                    /* title */
                    .pcard-title {
                        font-size: 0.875rem;
                        font-weight: 600;
                        color: #1e293b;
                        margin: 0 0 0.18rem 0;
                        /* allow wrapping — no truncation */
                        line-height: 1.4;
                    }

                    .pcard-sub {
                        font-size: 0.73rem;
                        color: #94a3b8;
                    }

                    /* right column — price + actions stacked */
                    .pcard-right {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;
                        gap: 0.45rem;
                        flex-shrink: 0;
                    }

                    .pcard-price {
                        font-size: 1.05rem;
                        font-weight: 700;
                        color: #1e293b;
                        white-space: nowrap;
                    }

                    .pcard-actions {
                        display: flex;
                        gap: 0.4rem;
                    }

                    .btn-s {
                        font-size: 0.73rem;
                        font-weight: 600;
                        padding: 0.28rem 0.65rem;
                        border-radius: 6px;
                        text-decoration: none;
                        border: 1px solid transparent;
                        transition: background 0.14s;
                        white-space: nowrap;
                    }

                    .btn-blue {
                        background: #6366f1;
                        color: #fff;
                    }

                    .btn-blue:hover {
                        background: #4f46e5;
                    }

                    .btn-ghost {
                        background: transparent;
                        color: #64748b;
                        border-color: #e2e8f0;
                    }

                    .btn-ghost:hover {
                        background: #f8fafc;
                    }

                    .no-results {
                        color: #94a3b8;
                        font-size: 0.875rem;
                        padding: 0.5rem 0;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/navbar.jsp" />

                <div class="page-wrapper">
                    <div class="page-header">
                        <p class="page-label">Market Comparison</p>
                        <h1 class="page-title">Results for <span class="text-primary-color">"${query}"</span></h1>
                        <p class="page-subtitle">
                            ${amazonResults.size()} Amazon listing(s) &nbsp;·&nbsp;
                            ${flipkartResults.size()} Flipkart listing(s)
                        </p>
                    </div>

                    <%-- ════ PRICE CONFIGURATION BAR ════ --%>
                        <div class="price-config-bar"
                            style="max-width: 860px; margin: 0 auto 2rem auto; background: #f8fafc; padding: 1rem 1.5rem; border-radius: 12px; border: 1px solid #e2e8f0; display: flex; align-items: center; justify-content: space-between; gap: 1rem; flex-wrap: wrap;">
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <span style="font-size: 0.85rem; font-weight: 700; color: #475569;">Price View:</span>
                                <span id="price-mode-label"
                                    style="font-size: 0.8rem; color: #64748b; background: #fff; padding: 0.2rem 0.6rem; border-radius: 4px; border: 1px solid #cbd5e1;">Base
                                    Price (Excl. Tax)</span>
                            </div>
                            <div style="display: flex; gap: 1.5rem; flex-wrap: wrap;">
                                <label
                                    style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer; font-size: 0.85rem; font-weight: 600; color: #1e293b;">
                                    <input type="checkbox" id="toggle-gst" onchange="updateAllPrices()"
                                        style="width: 16px; height: 16px;">
                                    Include GST (18%)
                                </label>
                                <label
                                    style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer; font-size: 0.85rem; font-weight: 600; color: #1e293b;">
                                    <input type="checkbox" id="toggle-shipping" onchange="updateAllPrices()"
                                        style="width: 16px; height: 16px;">
                                    Estimated Shipping
                                </label>
                            </div>
                        </div>

                        <script>
                            function updateAllPrices() {
                                const inclGst = document.getElementById('toggle-gst').checked;
                                const inclShip = document.getElementById('toggle-shipping').checked;
                                const modeLabel = document.getElementById('price-mode-label');

                                // Update label
                                if (inclGst && inclShip) modeLabel.innerText = "Total (Incl. GST & Shipping)";
                                else if (inclGst) modeLabel.innerText = "Incl. GST (18%)";
                                else if (inclShip) modeLabel.innerText = "Incl. Shipping";
                                else modeLabel.innerText = "Base Price (Excl. Tax)";

                                // Update all price elements
                                document.querySelectorAll('.pcard').forEach(card => {
                                    const basePrice = parseFloat(card.dataset.base);
                                    const shipping = parseFloat(card.dataset.shipping);
                                    let displayPrice = basePrice;

                                    if (inclGst) displayPrice += (basePrice * 0.18);
                                    if (inclShip) displayPrice += shipping;

                                    card.querySelector('.pcard-price-value').innerText = Math.round(displayPrice).toLocaleString('en-IN');

                                    // Show/hide breakdown hints
                                    const breakdown = card.querySelector('.price-breakdown');
                                    if (inclGst || inclShip) {
                                        breakdown.style.display = 'block';
                                        let hints = [];
                                        if (inclGst) hints.push("+18% GST");
                                        if (inclShip && shipping > 0) hints.push("+₹" + shipping + " Ship");
                                        breakdown.innerText = hints.join(" ");
                                    } else {
                                        breakdown.style.display = 'none';
                                    }
                                });
                            }
                        </script>

                        <%-- Full-width single column (no sidebar) so cards never overflow --%>
                            <div style="max-width: 860px; margin: 0 auto;">

                                <%-- ════ AMAZON ════ --%>
                                    <div class="platform-block">
                                        <div class="platform-bar">
                                            <span class="platform-tag tag-amazon">amazon.in</span>
                                            <span class="platform-count">${amazonResults.size()} result(s)</span>
                                        </div>

                                        <c:choose>
                                            <c:when test="${not empty amazonResults}">
                                                <c:forEach var="p" items="${amazonResults}" varStatus="s">
                                                    <div class="pcard" data-base="${p.price}"
                                                        data-shipping="${p.shipping}">
                                                        <span class="rank ${s.index == 0 ? 'gold' : ''}">${s.index +
                                                            1}</span>
                                                        <div>
                                                            <p class="pcard-title">${p.name}</p>
                                                            <div
                                                                style="display: flex; align-items: center; gap: 0.6rem; margin-top: 0.3rem;">
                                                                <span class="pcard-sub">Amazon.in</span>
                                                                <c:if test="${p.mrp > p.price}">
                                                                    <span
                                                                        style="font-size: 0.7rem; color: #94a3b8; text-decoration: line-through;">₹
                                                                        <fmt:formatNumber value="${p.mrp}"
                                                                            groupingUsed="true" />
                                                                    </span>
                                                                    <span
                                                                        style="font-size: 0.7rem; color: #16a34a; font-weight: 700;">${p.getSavingsPercentage()}%
                                                                        OFF</span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                        <div class="pcard-right">
                                                            <span class="pcard-price">
                                                                ₹<span class="pcard-price-value">
                                                                    <fmt:formatNumber value="${p.price}" type="number"
                                                                        groupingUsed="true" maxFractionDigits="0" />
                                                                </span>
                                                            </span>
                                                            <span class="price-breakdown"
                                                                style="font-size: 0.65rem; color: #64748b; margin-top: -0.3rem; display: none;"></span>
                                                            <div class="pcard-actions">
                                                                <c:url var="saveUrl" value="cart">
                                                                    <c:param name="action" value="add" />
                                                                    <c:param name="product" value="${p.name}" />
                                                                    <c:param name="price" value="${p.price}" />
                                                                    <c:param name="store" value="Amazon" />
                                                                </c:url>
                                                                <a href="${saveUrl}" class="btn-s btn-blue">+ Hub</a>
                                                                <a href="${p.url}" target="_blank"
                                                                    class="btn-s btn-ghost">View ↗</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="no-results">No Amazon results matched your query.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <%-- ════ FLIPKART ════ --%>
                                        <div class="platform-block">
                                            <div class="platform-bar">
                                                <span class="platform-tag tag-flipkart">Flipkart</span>
                                                <span class="platform-count">${flipkartResults.size()} result(s)</span>
                                            </div>

                                            <c:choose>
                                                <c:when test="${not empty flipkartResults}">
                                                    <c:forEach var="p" items="${flipkartResults}" varStatus="s">
                                                        <div class="pcard" data-base="${p.price}"
                                                            data-shipping="${p.shipping}">
                                                            <span class="rank ${s.index == 0 ? 'gold' : ''}">${s.index +
                                                                1}</span>
                                                            <div>
                                                                <p class="pcard-title">${p.name}</p>
                                                                <div
                                                                    style="display: flex; align-items: center; gap: 0.6rem; margin-top: 0.3rem;">
                                                                    <span class="pcard-sub">Flipkart.com</span>
                                                                    <c:if test="${p.mrp > p.price}">
                                                                        <span
                                                                            style="font-size: 0.7rem; color: #94a3b8; text-decoration: line-through;">₹
                                                                            <fmt:formatNumber value="${p.mrp}"
                                                                                groupingUsed="true" />
                                                                        </span>
                                                                        <span
                                                                            style="font-size: 0.7rem; color: #16a34a; font-weight: 700;">${p.getSavingsPercentage()}%
                                                                            OFF</span>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <div class="pcard-right">
                                                                <span class="pcard-price">
                                                                    ₹<span class="pcard-price-value">
                                                                        <fmt:formatNumber value="${p.price}"
                                                                            type="number" groupingUsed="true"
                                                                            maxFractionDigits="0" />
                                                                    </span>
                                                                </span>
                                                                <span class="price-breakdown"
                                                                    style="font-size: 0.65rem; color: #64748b; margin-top: -0.3rem; display: none;"></span>
                                                                <div class="pcard-actions">
                                                                    <c:url var="fkSave" value="cart">
                                                                        <c:param name="action" value="add" />
                                                                        <c:param name="product" value="${p.name}" />
                                                                        <c:param name="price" value="${p.price}" />
                                                                        <c:param name="store" value="Flipkart" />
                                                                    </c:url>
                                                                    <a href="${fkSave}" class="btn-s btn-blue">+ Hub</a>
                                                                    <a href="${p.url}" target="_blank"
                                                                        class="btn-s btn-ghost">View ↗</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="no-results">No Flipkart results matched your query.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <%-- Deep Analysis link --%>
                                            <div style="text-align:right; margin-bottom: 2rem;">
                                                <c:url var="detailsUrl" value="details">
                                                    <c:param name="query" value="${query}" />
                                                </c:url>
                                                <a href="${detailsUrl}" class="btn-s btn-ghost">Deep Analysis →</a>
                                            </div>

                            </div><%-- end max-width wrapper --%>

                                <footer class="page-footer">
                                    <p>&copy; 2026 Apex &bull; Live data via Amazon.in &amp; Flipkart Rome API</p>
                                </footer>
                </div>

            </body>

            </html>