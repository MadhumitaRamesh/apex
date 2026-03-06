package com.apex.servlets;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if ("register".equals(action)) {
            handleRegister(request, response, email, password);
        } else if ("login".equals(action)) {
            handleLogin(request, response, email, password);
        } else if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect("login.jsp");
        } else if ("update".equals(action)) {
            handleUpdate(request, response, email, password);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, String email, String password) 
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        String currentUser = (String) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.equals(email)) {
             response.sendRedirect("login.jsp");
             return;
        }

        String newName = request.getParameter("name");
        DatabaseReference userRef = FirebaseDatabase.getInstance().getReference("users").child(email.replace(".", "_"));

        Map<String, Object> updates = new HashMap<>();
        if (newName != null && !newName.trim().isEmpty()) updates.put("name", newName);
        if (password != null && !password.trim().isEmpty()) updates.put("password", password);

        if (updates.isEmpty()) {
            response.sendRedirect("settings.jsp?error=no_changes");
            return;
        }

        CompletableFuture<Void> future = new CompletableFuture<>();
        userRef.updateChildren(updates, (error, ref) -> {
            if (error == null) {
                if (newName != null) session.setAttribute("userName", newName);
                try {
                    response.sendRedirect("settings.jsp?success=updated");
                } catch (IOException e) {
                    future.completeExceptionally(e);
                }
            } else {
                try {
                    response.sendRedirect("settings.jsp?error=db_error");
                } catch (IOException e) {
                    future.completeExceptionally(e);
                }
            }
            future.complete(null);
        });

        try {
            future.get();
        } catch (Exception e) {
            response.sendError(500, "Update Error: " + e.getMessage());
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, String email, String password) 
            throws IOException, ServletException {
        String name = request.getParameter("name");
        
        DatabaseReference usersRef = FirebaseDatabase.getInstance().getReference("users");
        String userId = email.replace(".", "_"); // Firebase keys can't contain dots

        CompletableFuture<Void> future = new CompletableFuture<>();
        
        usersRef.child(userId).addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                if (snapshot.exists()) {
                    request.setAttribute("error", "Email already registered. Please sign in.");
                    try {
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                    } catch (Exception e) {
                        future.completeExceptionally(e);
                    }
                    future.complete(null);
                } else {
                    Map<String, Object> user = new HashMap<>();
                    user.put("name", name);
                    user.put("email", email);
                    user.put("password", password); // In a real app, use hashing!

                    usersRef.child(userId).setValue(user, (error, ref) -> {
                        if (error == null) {
                            try {
                                response.sendRedirect("login.jsp?success=registered");
                            } catch (IOException e) {
                                future.completeExceptionally(e);
                            }
                        } else {
                            request.setAttribute("error", "Registration failed. Try again.");
                            try {
                                request.getRequestDispatcher("register.jsp").forward(request, response);
                            } catch (Exception e) {
                                future.completeExceptionally(e);
                            }
                        }
                        future.complete(null);
                    });
                }
            }

            @Override
            public void onCancelled(DatabaseError error) {
                future.completeExceptionally(error.toException());
            }
        });

        try {
            future.get();
        } catch (Exception e) {
            response.sendError(500, "Database Error: " + e.getMessage());
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, String email, String password) 
            throws IOException, ServletException {
        DatabaseReference usersRef = FirebaseDatabase.getInstance().getReference("users");
        String userId = email.replace(".", "_");

        CompletableFuture<Void> future = new CompletableFuture<>();

        usersRef.child(userId).addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                if (snapshot.exists()) {
                    String storedPassword = snapshot.child("password").getValue(String.class);
                    if (password.equals(storedPassword)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("user", email);
                        session.setAttribute("userName", snapshot.child("name").getValue(String.class));
                        try {
                            response.sendRedirect("index.jsp");
                        } catch (IOException e) {
                            future.completeExceptionally(e);
                        }
                    } else {
                        request.setAttribute("error", "Invalid email or password.");
                        try {
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        } catch (Exception e) {
                            future.completeExceptionally(e);
                        }
                    }
                } else {
                    request.setAttribute("error", "Email not found. Please sign up first.");
                    try {
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    } catch (Exception e) {
                        future.completeExceptionally(e);
                    }
                }
                future.complete(null);
            }

            @Override
            public void onCancelled(DatabaseError error) {
                future.completeExceptionally(error.toException());
            }
        });

        try {
            future.get();
        } catch (Exception e) {
            response.sendError(500, "Database Error: " + e.getMessage());
        }
    }
}
