package com.hireflow.servlet;

import com.hireflow.dao.ApplicationDAO;
import com.hireflow.dao.JobDAO;
import com.hireflow.model.Application;
import com.hireflow.model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard/seeker")
public class SeekerDashServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final JobDAO         jobDAO         = new JobDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Guard: must be logged in as seeker
        if (session == null ||
                session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"seeker".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/dashboard/employer");
            return;
        }

        int seekerId = (int) session.getAttribute("userId");

        try {
            // Fetch this seeker's applications (with job + company info)
            List<Application> applications =
                    applicationDAO.getBySeeker(seekerId);

            // Stats
            long totalApplied  = applications.size();
            long underReview   = applications.stream()
                    .filter(a -> "reviewed".equals(a.getStatus())).count();
            long hired         = applications.stream()
                    .filter(a -> "hired".equals(a.getStatus())).count();
            long rejected      = applications.stream()
                    .filter(a -> "rejected".equals(a.getStatus())).count();

            // Recommended jobs — latest 6 active jobs (page 1, size 6)
            List<Job> recommendedJobs =
                    jobDAO.searchJobs("", "", 0, 1, 6);

            // Set attributes for JSP
            req.setAttribute("applications",   applications);
            req.setAttribute("totalApplied",   totalApplied);
            req.setAttribute("underReview",    underReview);
            req.setAttribute("hired",          hired);
            req.setAttribute("rejected",       rejected);
            req.setAttribute("recommendedJobs", recommendedJobs);

            // Avatar initial — derived here to avoid fn: taglib in JSP
            String userName = (String) session.getAttribute("userName");
            String userInitial = (userName != null && !userName.isEmpty())
                    ? String.valueOf(userName.charAt(0)).toUpperCase() : "?";
            req.setAttribute("userInitial", userInitial);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error",
                    "Could not load dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher(
                        "/WEB-INF/views/seekerDashboard.jsp")
                .forward(req, res);
    }
}
