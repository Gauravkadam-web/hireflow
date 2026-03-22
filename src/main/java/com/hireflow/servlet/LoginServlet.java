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

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("userRole");
            RegisterServlet.redirectByRole(res, req, role);
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
            return;
        }

        try {
            User user = userDAO.findByEmail(email.trim().toLowerCase());

            if (user == null || !PasswordUtil.verify(password, user.getPasswordHash())) {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
                return;
            }

            HttpSession session = req.getSession();
            session.setAttribute("userId",   user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60);

            RegisterServlet.redirectByRole(res, req, user.getRole());

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
        }
    }
}
