<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Hub | Apex</title>
        <meta name="description" content="Your saved market intelligence and scouted products in one place.">
        <link rel="stylesheet" href="css/styles.css?v=2.0">
    </head>

    <body>
        <jsp:include page="includes/navbar.jsp" />

        <div class="page-wrapper">
            <div class="page-header">
                <p class="page-label">Personal Repository</p>
                <h1 class="page-title">Intelligence Hub</h1>
                <p class="page-subtitle">Your saved products and market insights.</p>
            </div>

            <div class="page-grid">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <p class="sidebar-title">Scout Profile</p>
                    <div class="stat-item">
                        <div class="stat-label">Name</div>
                        <div class="stat-value">${userName != null ? userName : 'Guest Scout'}</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-label">Plan</div>
                        <div class="stat-value primary">Premium</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-label">Scrapers</div>
                        <div class="stat-value">Real-time</div>
                    </div>

                    <p class="sidebar-title" style="margin-top:2rem;">Quick Actions</p>
                    <nav class="quick-links">
                        <a href="index.jsp" class="link-primary">+ Search New Product</a>
                        <a href="settings.jsp">Manage Alerts & Settings</a>
                    </nav>
                </aside>

                <!-- Main Content -->
                <div class="content-area">
                    <div class="section-header">
                        <h2 class="section-title">Your Saved Products</h2>
                    </div>

                    <% String userEmail=(String) session.getAttribute("user"); if (userEmail !=null) { String
                        userId=userEmail.replace(".", "_" ); com.google.firebase.database.DatabaseReference
                        hubRef=com.google.firebase.database.FirebaseDatabase.getInstance().getReference("hub").child(userId);
                        java.util.concurrent.CompletableFuture<java.util.List<java.util.Map<String, Object>>> future =
                        new java.util.concurrent.CompletableFuture<>();

                            hubRef.addListenerForSingleValueEvent(new com.google.firebase.database.ValueEventListener()
                            {
                            @Override
                            public void onDataChange(com.google.firebase.database.DataSnapshot snapshot) {
                            java.util.List<java.util.Map<String, Object>> items = new java.util.ArrayList<>();
                                    for (com.google.firebase.database.DataSnapshot itemSnap : snapshot.getChildren()) {
                                    java.util.Map<String, Object> val = (java.util.Map<String, Object>)
                                            itemSnap.getValue();
                                            if (val != null) {
                                            val.put("_key", itemSnap.getKey());
                                            items.add(val);
                                            }
                                            }
                                            future.complete(items);
                                            }
                                            @Override
                                            public void onCancelled(com.google.firebase.database.DatabaseError error) {
                                            future.completeExceptionally(error.toException());
                                            }
                                            });

                                            try {
                                            java.util.List<java.util.Map<String, Object>> savedItems = future.get(5,
                                                java.util.concurrent.TimeUnit.SECONDS);
                                                if (!savedItems.isEmpty()) {
                                                for (java.util.Map<String, Object> item : savedItems) {
                                                    String name = (String) item.get("name");
                                                    String price = (String) item.get("price");
                                                    String store = (String) item.get("store");
                                                    String itemKey = (String) item.get("_key");
                                                    %>
                                                    <div class="product-card">
                                                        <div class="product-card-inner">
                                                            <div class="product-info">
                                                                <span class="badge badge-saved">Saved Item</span>
                                                                <p class="product-name">
                                                                    <%= name %>
                                                                </p>
                                                                <p class="product-desc">Scouted from <%= store %> &bull;
                                                                        Synchronized via Firebase.</p>
                                                            </div>
                                                            <div class="product-price-block">
                                                                <div class="product-price text-success">₹<%= price %>
                                                                </div>
                                                                <div class="product-price-tag best">Tracked</div>
                                                            </div>
                                                        </div>
                                                        <div class="product-card-actions">
                                                            <a href="cart?action=remove&itemId=<%= itemKey %>"
                                                                class="btn-danger-ghost">Remove from Hub</a>
                                                        </div>
                                                    </div>
                                                    <% } } else { %>
                                                        <div class="card-empty">
                                                            <p>No products saved yet. Start scouting to track prices.
                                                            </p>
                                                            <a href="index.jsp" class="btn btn-primary">Search a
                                                                Product</a>
                                                        </div>
                                                        <% } } catch (Exception e) { %>
                                                            <div class="alert alert-error">Error loading hub items: <%=
                                                                    e.getMessage() %>
                                                            </div>
                                                            <% } } else { %>
                                                                <div class="card-empty">
                                                                    <p>Please <a href="login.jsp">sign in</a> to view
                                                                        your
                                                                        saved products.</p>
                                                                </div>
                                                                <% } %>
                </div>
            </div>

            <footer class="page-footer">
                <p>&copy; 2026 Apex Platform &bull; Professional Market Scouting Module</p>
            </footer>
        </div>
    </body>

    </html>