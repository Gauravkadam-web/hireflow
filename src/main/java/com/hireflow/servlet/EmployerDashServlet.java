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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard/employer")
public class EmployerDashServlet extends HttpServlet {

    private final JobDAO         jobDAO         = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Guard: must be logged in as employer
        if (session == null ||
                session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"employer".equals(role) && !"admin".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/dashboard/seeker");
            return;
        }

        int employerId = (int) session.getAttribute("userId");

        try {
            // Fetch all jobs by this employer
            List<Job> jobs = jobDAO.getJobsByEmployer(employerId);

            // Fetch applicants for each job — map jobId → list
            Map<Integer, List<Application>> applicantsMap =
                    new LinkedHashMap<>();
            int totalApplicants = 0;
            int totalActive     = 0;
            int totalHired      = 0;

            for (Job job : jobs) {
                List<Application> apps =
                        applicationDAO.getByJob(job.getJobId());
                applicantsMap.put(job.getJobId(), apps);
                totalApplicants += apps.size();
                if ("active".equals(job.getStatus())) totalActive++;
                totalHired += apps.stream()
                        .filter(a -> "hired".equals(a.getStatus()))
                        .count();
            }

            // Compute employer initial for avatar
            String userName      = (String) session.getAttribute("userName");
            String employerInitial = (userName != null && !userName.isEmpty())
                    ? String.valueOf(userName.charAt(0)).toUpperCase() : "?";

            req.setAttribute("jobs",            jobs);
            req.setAttribute("applicantsMap",   applicantsMap);
            req.setAttribute("totalJobs",       jobs.size());
            req.setAttribute("totalActive",     totalActive);
            req.setAttribute("totalApplicants", totalApplicants);
            req.setAttribute("totalHired",      totalHired);
            req.setAttribute("employerInitial", employerInitial);
            req.setAttribute("success", req.getParameter("success"));
            req.setAttribute("error",   req.getParameter("error"));

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error",
                    "Could not load dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher(
                        "/WEB-INF/views/employerDashboard.jsp")
                .forward(req, res);
    }
}
