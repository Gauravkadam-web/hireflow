package com.hireflow.servlet;

import com.hireflow.dao.ApplicationDAO;
import com.hireflow.dao.JobDAO;
import com.hireflow.model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;

@WebServlet("/jobs/detail")
public class JobDetailServlet extends HttpServlet {

    private JobDAO         jobDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        jobDAO         = new JobDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/jobs");
            return;
        }

        try {
            int jobId = Integer.parseInt(idParam);
            Job job   = jobDAO.getJobById(jobId);

            if (job == null) {
                res.sendError(HttpServletResponse.SC_NOT_FOUND, "Job not found.");
                return;
            }

            HttpSession session      = req.getSession(false);
            boolean alreadyApplied  = false;
            boolean isSeeker        = false;

            if (session != null && session.getAttribute("userId") != null) {
                String role = (String) session.getAttribute("userRole");
                isSeeker = "seeker".equals(role);
                if (isSeeker) {
                    int seekerId = (int) session.getAttribute("userId");
                    alreadyApplied = applicationDAO.hasApplied(seekerId, jobId);
                }
            }

            req.setAttribute("job",            job);
            req.setAttribute("alreadyApplied", alreadyApplied);
            req.setAttribute("isSeeker",       isSeeker);

            if (job.getSkills() != null && job.getSkills().length > 0) {
                req.setAttribute("jobSkills", Arrays.asList(job.getSkills()));
            }

            String companyName = job.getCompanyName();
            String jobInitial  = (companyName != null && !companyName.isEmpty())
                    ? String.valueOf(companyName.charAt(0)).toUpperCase() : "?";
            req.setAttribute("jobInitial", jobInitial);

            if (session != null && session.getAttribute("userId") != null) {
                String name = (String) session.getAttribute("userName");
                req.setAttribute("userInitials", buildInitials(name));
            } else {
                req.setAttribute("userInitials", "");
            }

            if (job.getPostedAt() != null) {
                req.setAttribute("postedAtDate",
                        java.util.Date.from(job.getPostedAt().atZone(java.time.ZoneId.systemDefault()).toInstant()));
            }
            if (job.getExpiresAt() != null) {
                req.setAttribute("expiresAtDate",
                        java.util.Date.from(job.getExpiresAt().atZone(java.time.ZoneId.systemDefault()).toInstant()));
            }

            req.setAttribute("success", req.getParameter("success"));
            req.setAttribute("error",   req.getParameter("error"));

            req.getRequestDispatcher("/WEB-INF/views/jobDetail.jsp").forward(req, res);

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/jobs");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
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
