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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String phone    = req.getParameter("phone");
        String role     = req.getParameter("role");

        String error = validate(fullName, email, password, role);
        if (error != null) {
            req.setAttribute("error", error);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                req.setAttribute("error", "An account with this email already exists.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
                return;
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPasswordHash(PasswordUtil.hash(password));
            user.setRole(role);
            user.setPhone(phone != null ? phone.trim() : null);

            boolean saved = userDAO.insertUser(user);

            if (saved) {
                User created = userDAO.findByEmail(email.trim().toLowerCase());
                HttpSession session = req.getSession();
                session.setAttribute("userId",   created.getUserId());
                session.setAttribute("userRole", created.getRole());
                session.setAttribute("userName", created.getFullName());
                redirectByRole(res, req, created.getRole());
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
        }
    }

    private String validate(String fullName, String email, String password, String role) {
        if (fullName == null || fullName.trim().isEmpty()) return "Full name is required.";
        if (email == null || !email.contains("@")) return "Please enter a valid email address.";
        if (password == null || password.length() < 6) return "Password must be at least 6 characters.";
        if (role == null || (!role.equals("seeker") && !role.equals("employer"))) return "Please select a valid role.";
        return null;
    }

    static void redirectByRole(HttpServletResponse res, HttpServletRequest req, String role) throws IOException {
        String ctx = req.getContextPath();
        switch (role) {
            case "employer" -> res.sendRedirect(ctx + "/dashboard/employer");
            case "admin"    -> res.sendRedirect(ctx + "/admin/panel");
            default         -> res.sendRedirect(ctx + "/dashboard/seeker");
        }
    }
}
