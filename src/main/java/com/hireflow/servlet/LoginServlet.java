package com.hireflow.servlet;

import com.hireflow.dao.UserDAO;
import com.hireflow.model.User;
import com.hireflow.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ── GET → show login form ─────────────────────────
    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        // If already logged in redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null &&
                session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("userRole");
            RegisterServlet.redirectByRole(res, req, role);
            return;
        }

        req.getRequestDispatcher(
                "/WEB-INF/views/login.jsp").forward(req, res);
    }

    // ── POST → process login ──────────────────────────
    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        // Basic validation
        if (email == null || email.isEmpty() ||
                password == null || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp").forward(req, res);
            return;
        }

        try {
            // Find user by email
            User user = userDAO.findByEmail(
                    email.trim().toLowerCase());

            // Verify password
            if (user == null ||
                    !PasswordUtil.verify(password, user.getPasswordHash())) {
                req.setAttribute("error",
                        "Invalid email or password.");
                req.getRequestDispatcher(
                        "/WEB-INF/views/login.jsp").forward(req, res);
                return;
            }

            // Create session
            HttpSession session = req.getSession();
            session.setAttribute("userId",   user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect based on role
            RegisterServlet.redirectByRole(res, req, user.getRole());

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error",
                    "Something went wrong: " + e.getMessage());
            req.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp").forward(req, res);
        }
    }
}