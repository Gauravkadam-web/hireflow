package com.hireflow.servlet;

import com.hireflow.dao.JobDAO;
import com.hireflow.model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/apply/form")
public class ApplyFormServlet extends HttpServlet {

    private JobDAO jobDAO;

    @Override
    public void init() {
        jobDAO = new JobDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"seeker".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/jobs");
            return;
        }

        String idParam = req.getParameter("jobId");
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

            String companyName = job.getCompanyName();
            String jobInitial  = (companyName != null && !companyName.isEmpty())
                    ? String.valueOf(companyName.charAt(0)).toUpperCase() : "?";

            req.setAttribute("job",        job);
            req.setAttribute("jobInitial", jobInitial);
            req.setAttribute("error",      req.getParameter("error"));

            req.getRequestDispatcher("/WEB-INF/views/applyForm.jsp").forward(req, res);

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/jobs");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
