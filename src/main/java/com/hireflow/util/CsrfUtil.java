package com.hireflow.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.UUID;

public class CsrfUtil {

    public static final String TOKEN_KEY = "csrfToken";

    // ── Get existing token or generate new one ────────
    public static String getToken(HttpServletRequest req) {
        HttpSession session = req.getSession();
        String token = (String) session.getAttribute(TOKEN_KEY);
        if (token == null) {
            token = UUID.randomUUID().toString();
            session.setAttribute(TOKEN_KEY, token);
        }
        return token;
    }

    // ── Validate token from POST request ──────────────
    public static boolean isValid(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute(TOKEN_KEY);
        String requestToken = req.getParameter(TOKEN_KEY);

        return sessionToken != null &&
                sessionToken.equals(requestToken);
    }

    private CsrfUtil() {}
}
