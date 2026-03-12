package com.apex.servlets;

import com.google.firebase.database.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

import jakarta.servlet.ServletConfig;

@WebServlet({"/admin", "/admin_dashboard", "/system_logs"})
public class AdminServlet extends HttpServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        seedSampleActivitiesIfEmpty();
    }

    private void seedSampleActivitiesIfEmpty() {
        try {
            DatabaseReference ref = FirebaseDatabase.getInstance().getReference("activities");
            CompletableFuture<Boolean> future = new CompletableFuture<>();
            ref.addListenerForSingleValueEvent(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot snapshot) {
                    if (!snapshot.exists() || snapshot.getChildrenCount() == 0) {
                        String[][] samples = {
                            {"system@apex.tech", "System",       "SYSTEM_BOOT",   "Apex server started — all services online"},
                            {"admin@apex.tech",  "Super Admin",  "LOGIN",         "User logged in with role: admin"},
                            {"alice@apex.tech",  "Alice Chen",   "LOGIN",         "User logged in with role: user"},
                            {"admin@apex.tech",  "Super Admin",  "PROVISION_ADMIN","Created new admin account for Bob Nguyen <bob@apex.tech>"},
                            {"bob@apex.tech",    "Bob Nguyen",   "LOGIN",         "User logged in with role: admin"},
                            {"admin@apex.tech",  "Super Admin",  "RESTRICT_USER", "Set user [carol_at_apex_tech] status to restricted"},
                            {"alice@apex.tech",  "Alice Chen",   "LOGOUT",        "User session ended"},
                            {"admin@apex.tech",  "Super Admin",  "PROMOTE_USER",  "Promoted user [dave_at_apex_tech] to admin role"},
                            {"dave@apex.tech",   "Dave Kim",     "LOGIN",         "User logged in with role: admin"},
                            {"system@apex.tech", "System",       "SCRAPER_RUN",   "Price scraper completed — 142 products updated"},
                            {"bob@apex.tech",    "Bob Nguyen",   "DELETE_USER",   "Permanently deleted user account [spam_at_test_com]"},
                            {"dave@apex.tech",   "Dave Kim",     "LOGOUT",        "User session ended"},
                            {"admin@apex.tech",  "Super Admin",  "ACTIVATE_USER", "Set user [carol_at_apex_tech] status to active"},
                            {"carol@apex.tech",  "Carol Lopez",  "LOGIN",         "User logged in with role: user"},
                            {"system@apex.tech", "System",       "ALERT_SENT",    "Price drop alert dispatched — 7 users notified"}
                        };
                        LocalDateTime base = LocalDateTime.now();
                        for (int i = samples.length - 1; i >= 0; i--) {
                            String key = ref.push().getKey();
                            Map<String, Object> act = new HashMap<>();
                            act.put("email",     samples[i][0]);
                            act.put("name",      samples[i][1]);
                            act.put("action",    samples[i][2]);
                            act.put("details",   samples[i][3]);
                            act.put("timestamp", base.minusHours((long)(samples.length - 1 - i) * 5).toString());
                            ref.child(key).setValueAsync(act);
                        }
                    }
                    future.complete(true);
                }
                @Override
                public void onCancelled(DatabaseError error) { future.complete(false); }
            });
            future.get(8, TimeUnit.SECONDS);
        } catch (Exception e) {
            System.err.println("AdminServlet seed skipped: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        String uri = request.getRequestURI();

        if (!"admin".equals(role)) {
            response.sendRedirect("admin_login.jsp?error=access_denied");
            return;
        }

        if (uri.endsWith("/system_logs")) {
            loadActivities(request, 50); // Fetch more for the logs page
            request.getRequestDispatcher("system_logs.jsp").forward(request, response);
        } else {
            // Default dashboard load
            loadUsers(request);
            loadActivities(request, 10);
            loadAnalytics(request);
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (!"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if ("restrict".equals(action)) {
            toggleUserStatus(request, response);
        } else if ("promote".equals(action)) {
            promoteUser(request, response);
        } else if ("provision".equals(action)) {
            provisionAdmin(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        }
    }

    // ─── Data Loaders ───────────────────────────────────────────────────────

    private void loadUsers(HttpServletRequest request) {
        try {
            DatabaseReference usersRef = FirebaseDatabase.getInstance().getReference("users");
            CompletableFuture<List<Map<String, Object>>> future = new CompletableFuture<>();

            usersRef.addListenerForSingleValueEvent(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot snapshot) {
                    List<Map<String, Object>> users = new ArrayList<>();
                    for (DataSnapshot snap : snapshot.getChildren()) {
                        @SuppressWarnings("unchecked")
                        Map<String, Object> u = (Map<String, Object>) snap.getValue();
                        if (u != null) {
                            u.put("_id", snap.getKey());
                            users.add(u);
                        }
                    }
                    future.complete(users);
                }

                @Override
                public void onCancelled(DatabaseError error) {
                    future.complete(new ArrayList<>());
                }
            });

            request.setAttribute("userList", future.get(8, TimeUnit.SECONDS));
        } catch (Exception e) {
            request.setAttribute("userList", new ArrayList<>());
            System.err.println("Error loading users: " + e.getMessage());
        }
    }

    private void loadActivities(HttpServletRequest request, int limit) {
        try {
            DatabaseReference ref = FirebaseDatabase.getInstance().getReference("activities");
            CompletableFuture<List<Map<String, Object>>> future = new CompletableFuture<>();

            ref.limitToLast(limit).addListenerForSingleValueEvent(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot snapshot) {
                    List<Map<String, Object>> list = new ArrayList<>();
                    for (DataSnapshot ds : snapshot.getChildren()) {
                        @SuppressWarnings("unchecked")
                        Map<String, Object> activity = (Map<String, Object>) ds.getValue();
                        if (activity != null) list.add(0, activity); // Newest first
                    }
                    future.complete(list);
                }

                @Override
                public void onCancelled(DatabaseError error) {
                    future.complete(new ArrayList<>());
                }
            });

            request.setAttribute("activities", future.get(5, TimeUnit.SECONDS));
        } catch (Exception e) {
            request.setAttribute("activities", new ArrayList<>());
            System.err.println("Error loading activities: " + e.getMessage());
        }
    }

    private void loadAnalytics(HttpServletRequest request) {
        try {
            DatabaseReference ref = FirebaseDatabase.getInstance().getReference("priceHistory");
            CompletableFuture<Map<String, Integer>> future = new CompletableFuture<>();

            ref.addListenerForSingleValueEvent(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot snapshot) {
                    Map<String, Integer> counts = new HashMap<>();
                    for (DataSnapshot ds : snapshot.getChildren()) {
                        String product = ds.child("productName").getValue(String.class);
                        if (product != null) {
                            counts.put(product, counts.getOrDefault(product, 0) + 1);
                        }
                    }
                    future.complete(counts);
                }

                @Override
                public void onCancelled(DatabaseError error) {
                    future.complete(new HashMap<>());
                }
            });

            request.setAttribute("analytics", future.get(5, TimeUnit.SECONDS));
        } catch (Exception e) {
            request.setAttribute("analytics", new HashMap<>());
            System.err.println("Error loading analytics: " + e.getMessage());
        }
    }

    // ─── POST Actions ────────────────────────────────────────────────────────

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("userId");
        String currentStatus = request.getParameter("currentStatus");
        boolean isRestricted = "restricted".equals(currentStatus);
        String newStatus = isRestricted ? "active" : "restricted";

        DatabaseReference userRef = FirebaseDatabase.getInstance().getReference("users").child(userId);
        userRef.child("status").setValueAsync(newStatus);

        HttpSession session = request.getSession();
        String adminName = (String) session.getAttribute("userName");
        String adminEmail = (String) session.getAttribute("user");
        logActivity(adminEmail, adminName != null ? adminName : "Admin",
                isRestricted ? "ACTIVATE_USER" : "RESTRICT_USER",
                "Set user [" + userId + "] status to " + newStatus);

        response.sendRedirect("admin_dashboard?success=status_updated");
    }

    private void promoteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("userId");
        DatabaseReference userRef = FirebaseDatabase.getInstance().getReference("users").child(userId);
        userRef.child("role").setValueAsync("admin");

        HttpSession session = request.getSession();
        String adminName = (String) session.getAttribute("userName");
        String adminEmail = (String) session.getAttribute("user");
        logActivity(adminEmail, adminName != null ? adminName : "Admin",
                "PROMOTE_USER", "Promoted user [" + userId + "] to admin role");

        response.sendRedirect("admin_dashboard?success=user_promoted");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("userId");
        DatabaseReference userRef = FirebaseDatabase.getInstance().getReference("users").child(userId);
        userRef.removeValueAsync();

        HttpSession session = request.getSession();
        String adminName = (String) session.getAttribute("userName");
        String adminEmail = (String) session.getAttribute("user");
        logActivity(adminEmail, adminName != null ? adminName : "Admin",
                "DELETE_USER", "Permanently deleted user account [" + userId + "]");

        response.sendRedirect("admin_dashboard?success=user_deleted");
    }

    private void provisionAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        if (email == null || name == null || password == null) {
            response.sendRedirect("admin_dashboard?error=missing_fields");
            return;
        }

        String userId = email.replace(".", "_").replace("@", "_at_");
        DatabaseReference usersRef = FirebaseDatabase.getInstance().getReference("users").child(userId);

        Map<String, Object> adminData = new HashMap<>();
        adminData.put("name", name);
        adminData.put("email", email);
        adminData.put("password", password);
        adminData.put("role", "admin");
        adminData.put("status", "active");
        adminData.put("createdAt", LocalDateTime.now().toString());

        usersRef.setValueAsync(adminData);

        HttpSession session = request.getSession();
        String adminName = (String) session.getAttribute("userName");
        String adminEmail = (String) session.getAttribute("user");
        logActivity(adminEmail, adminName != null ? adminName : "Admin",
                "PROVISION_ADMIN", "Created new admin account for " + name + " <" + email + ">");

        response.sendRedirect("admin_dashboard?success=admin_provisioned");
    }

    // ─── Static Utility ──────────────────────────────────────────────────────

    public static void logActivity(String email, String name, String action, String details) {
        try {
            DatabaseReference ref = FirebaseDatabase.getInstance().getReference("activities");
            String key = ref.push().getKey();
            Map<String, Object> activity = new HashMap<>();
            activity.put("email", email);
            activity.put("name", name);
            activity.put("action", action);
            activity.put("details", details);
            activity.put("timestamp", LocalDateTime.now().toString());
            ref.child(key).setValueAsync(activity);
        } catch (Exception e) {
            System.err.println("Failed to log activity: " + e.getMessage());
        }
    }
}
