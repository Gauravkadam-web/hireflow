package com.hireflow.servlet;

import com.hireflow.dao.CategoryDAO;
import com.hireflow.dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private JobDAO      jobDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        jobDAO      = new JobDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("categories",   categoryDAO.getAll());
            req.setAttribute("featuredJobs", jobDAO.getFeaturedJobs(4));
            req.setAttribute("totalJobs",    jobDAO.countActiveJobs());

            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("userId") != null) {
                String name = (String) session.getAttribute("userName");
                req.setAttribute("userInitials", buildInitials(name));
            } else {
                req.setAttribute("userInitials", "");
            }

        } catch (Exception e) {
            throw new ServletException("HomeServlet data load failed: " + e.getMessage(), e);
        }

        req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, res);
    }

    private String buildInitials(String fullName) {
        if (fullName == null || fullName.isBlank()) return "";
        String[] parts = fullName.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        sb.append(Character.toUpperCase(parts[0].charAt(0)));
        if (parts.length > 1)
            sb.append(Character.toUpperCase(parts[parts.length - 1].charAt(0)));
        return sb.toString();
    }
}
