package com.hireflow.servlet;

import com.hireflow.dao.JobDAO;
import com.hireflow.dao.CategoryDAO;
import com.hireflow.model.Job;
import com.hireflow.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/jobs/create")
public class JobPostServlet extends HttpServlet {

    private final JobDAO      jobDAO      = new JobDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    // ── GET → show post job form ──────────────────────
    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"employer".equals(role) && !"admin".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/dashboard/seeker");
            return;
        }

        try {
            List<Category> categories = categoryDAO.getAll();
            req.setAttribute("categories", categories);
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher(
                "/WEB-INF/views/postJob.jsp").forward(req, res);
    }

    // ── POST → create job ─────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"employer".equals(role) && !"admin".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/dashboard/seeker");
            return;
        }

        int employerId = (int) session.getAttribute("userId");

        // Read form fields
        String title       = req.getParameter("title");
        String description = req.getParameter("description");
        String location    = req.getParameter("location");
        String jobType     = req.getParameter("jobType");
        String categoryStr = req.getParameter("categoryId");
        String salaryMinStr = req.getParameter("salaryMin");
        String salaryMaxStr = req.getParameter("salaryMax");

        // Validate required fields
        if (title == null || title.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                location == null || location.trim().isEmpty()) {
            try {
                List<Category> categories = categoryDAO.getAll();
                req.setAttribute("categories", categories);
            } catch (Exception ex) { ex.printStackTrace(); }

            req.setAttribute("error", "Title, description and location are required.");
            req.setAttribute("formData", req.getParameterMap());
            req.getRequestDispatcher(
                    "/WEB-INF/views/postJob.jsp").forward(req, res);
            return;
        }

        try {
            Job job = new Job();
            job.setEmployerId(employerId);
            job.setTitle(title.trim());
            job.setDescription(description.trim());
            job.setLocation(location.trim());
            job.setJobType(jobType != null ? jobType : "Full-time");

            if (categoryStr != null && !categoryStr.isEmpty()) {
                job.setCategoryId(Integer.parseInt(categoryStr));
            }

            if (salaryMinStr != null && !salaryMinStr.trim().isEmpty()) {
                job.setSalaryMin(new BigDecimal(salaryMinStr.trim()));
            }
            if (salaryMaxStr != null && !salaryMaxStr.trim().isEmpty()) {
                job.setSalaryMax(new BigDecimal(salaryMaxStr.trim()));
            }

            boolean inserted = jobDAO.insertJob(job);

            if (inserted) {
                res.sendRedirect(req.getContextPath() +
                        "/dashboard/employer?success=Job+posted+successfully!+It+will+be+reviewed+shortly.");
            } else {
                res.sendRedirect(req.getContextPath() +
                        "/dashboard/employer?error=Failed+to+post+job.+Please+try+again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() +
                    "/dashboard/employer?error=Something+went+wrong:+" +
                    e.getMessage().replace(" ", "+"));
        }
    }
}
