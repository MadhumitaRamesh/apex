<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <header class="navbar">
        <div class="navbar-inner">
            <div style="display:flex;align-items:center;gap:2rem;">
                <a href="index.jsp" class="navbar-brand">
                    APEX<span class="brand-dot"></span>
                </a>
                <ul class="navbar-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="dashboard.jsp">My Hub</a></li>
                </ul>
            </div>

            <div class="navbar-actions">
                <% if (session.getAttribute("user") !=null) { %>
                    <span class="navbar-user" style="margin-right:1rem; color:#64748b; font-size:0.9rem;">
                        Hi, <strong>
                            <%= session.getAttribute("userName") %>
                        </strong>
                    </span>
                    <a href="auth?action=logout" class="btn btn-ghost">Sign Out</a>
                    <% } else { %>
                        <a href="login.jsp" class="btn btn-ghost">Sign In</a>
                        <a href="register.jsp" class="btn btn-primary">Get Started</a>
                        <% } %>
            </div>
        </div>
    </header>