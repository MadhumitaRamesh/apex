package com.apex.filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getServletPath();

        // Pages that don't require authentication
        boolean isPublicPage = path.endsWith("login.jsp") || 
                               path.endsWith("admin_login.jsp") || 
                               path.endsWith("register.jsp") || 
                               path.equals("/auth") ||
                               path.startsWith("/css/") || 
                               path.startsWith("/js/") || 
                               path.startsWith("/images/");

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        String userRole = (session != null) ? (String) session.getAttribute("role") : null;

        // Admin page protection (excluding the login page itself)
        boolean isAdminPage = path.startsWith("/admin_") && !path.endsWith("admin_login.jsp");
        boolean isAdmin = "admin".equals(userRole);

        if (isAdminPage && !isAdmin) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        if (isLoggedIn || isPublicPage) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        }
    }

    @Override
    public void destroy() {}
}
