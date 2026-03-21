package com.hireflow.util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class CsrfFilter implements Filter {

    // These POST endpoints are exempt from CSRF check
    private static final Set<String> EXEMPT = Set.of(
            "/login",
            "/register"
    );

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Only check POST requests
        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String path = req.getServletPath();

            if (!EXEMPT.contains(path) &&
                    !CsrfUtil.isValid(req)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Invalid or missing CSRF token.");
                return;
            }
        }

        // Inject CSRF token into every request so JSPs can access it
        CsrfUtil.getToken(req); // ensures token exists in session
        req.setAttribute(CsrfUtil.TOKEN_KEY,
                CsrfUtil.getToken(req));

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}