package com.hireflow.servlet;

import com.hireflow.dao.JobDAO;
import com.hireflow.dao.UserDAO;
import com.hireflow.dao.ApplicationDAO;
import com.hireflow.model.Job;
import com.hireflow.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/panel")
public class AdminServlet extends HttpServlet {

    private final JobDAO         jobDAO         = new JobDAO();
    private final UserDAO        userDAO        = new UserDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Guard: admin only
        if (session == null ||
                session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"admin".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Admin access only.");
            return;
        }

        try {
            // Platform stats
            int totalUsers        = userDAO.countAll();
            int totalJobs         = jobDAO.countAllJobs();
            int totalActive       = jobDAO.countActiveJobs();
            int totalApplications = applicationDAO.countAll();

            // Pending jobs awaiting approval
            List<Job>  pendingJobs = jobDAO.getByStatus("pending");

            // All users
            List<User> allUsers    = userDAO.getAll();

            // Admin initial
            String userName     = (String) session.getAttribute("userName");
            String adminInitial = (userName != null && !userName.isEmpty())
                    ? String.valueOf(userName.charAt(0)).toUpperCase() : "A";

            req.setAttribute("totalUsers",        totalUsers);
            req.setAttribute("totalJobs",         totalJobs);
            req.setAttribute("totalActive",       totalActive);
            req.setAttribute("totalApplications", totalApplications);
            req.setAttribute("pendingJobs",       pendingJobs);
            req.setAttribute("allUsers",          allUsers);
            req.setAttribute("adminInitial",      adminInitial);
            req.setAttribute("success", req.getParameter("success"));
            req.setAttribute("error",   req.getParameter("error"));

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error",
                    "Could not load admin panel: " + e.getMessage());
        }

        req.getRequestDispatcher(
                "/WEB-INF/views/adminPanel.jsp").forward(req, res);
    }
}
