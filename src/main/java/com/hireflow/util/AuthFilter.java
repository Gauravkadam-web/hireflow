package com.hireflow.util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebFilter("/")
public class AuthFilter implements Filter {

    // These URLs are accessible WITHOUT login
    private static final Set<String> PUBLIC_URLS = Set.of(
            "/login",
            "/register",
            "/home",
            "/jobs",
            "/jobs/detail",
            "/test-db"
    );

    // URL prefixes accessible without login
    private static final Set<String> PUBLIC_PREFIXES = Set.of(
            "/static/",
            "/uploads/"
    );

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();
        String ctx  = req.getContextPath();

        // Allow public URLs through
        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check session
        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null
                && session.getAttribute("userId") != null;

        if (!loggedIn) {
            res.sendRedirect(ctx + "/login");
            return;
        }

        // Role-based protection
        String role = (String) session.getAttribute("userRole");

        if (path.startsWith("/admin") && !"admin".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Access denied.");
            return;
        }

        if (path.startsWith("/dashboard/employer")
                && !"employer".equals(role)
                && !"admin".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Employer access only.");
            return;
        }

        // All good — continue
        chain.doFilter(request, response);
    }

    private boolean isPublic(String path) {
        if (PUBLIC_URLS.contains(path)) return true;
        for (String prefix : PUBLIC_PREFIXES) {
            if (path.startsWith(prefix)) return true;
        }
        return false;
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}
