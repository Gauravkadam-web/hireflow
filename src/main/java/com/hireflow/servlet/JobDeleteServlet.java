package com.hireflow.servlet;

import com.hireflow.dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/jobs/delete")
public class JobDeleteServlet extends HttpServlet {

    private JobDAO jobDAO;

    @Override
    public void init() {
        jobDAO = new JobDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"employer".equals(role) && !"admin".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int employerId  = (int) session.getAttribute("userId");
        String jobIdStr = req.getParameter("jobId");
        String redirect = req.getContextPath() + "/dashboard/employer";

        if (jobIdStr == null || jobIdStr.isEmpty()) {
            res.sendRedirect(redirect + "?error=Invalid+job+ID.");
            return;
        }

        try {
            int jobId       = Integer.parseInt(jobIdStr);
            boolean deleted = jobDAO.deleteJob(jobId, employerId);

            if (deleted) {
                res.sendRedirect(redirect + "?success=Job+deleted+successfully.");
            } else {
                res.sendRedirect(redirect + "?error=Could+not+delete+job.+It+may+not+exist+or+belong+to+you.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(redirect + "?error=Something+went+wrong.");
        }
    }
}
