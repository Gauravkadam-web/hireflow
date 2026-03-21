package com.hireflow.servlet;

import com.hireflow.dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebServlet("/admin/job/status")
public class JobApproveServlet extends HttpServlet {

    private static final Set<String> VALID =
            Set.of("active", "closed", "expired");

    private final JobDAO jobDAO = new JobDAO();

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String redirect = req.getContextPath() + "/admin/panel";

        // Admin only
        if (session == null ||
                !"admin".equals(session.getAttribute("userRole"))) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String jobIdStr = req.getParameter("jobId");
        String status   = req.getParameter("status");

        if (jobIdStr == null || status == null ||
                !VALID.contains(status)) {
            res.sendRedirect(redirect + "?error=Invalid+request.");
            return;
        }

        try {
            int jobId   = Integer.parseInt(jobIdStr);
            boolean ok  = jobDAO.updateJobStatus(jobId, status);

            if (ok) {
                String msg = "active".equals(status)
                        ? "Job+approved+and+is+now+live."
                        : "Job+rejected+successfully.";
                res.sendRedirect(redirect + "?success=" + msg);
            } else {
                res.sendRedirect(redirect +
                        "?error=Could+not+update+job+status.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(redirect +
                    "?error=Something+went+wrong:+" +
                    e.getMessage().replace(" ", "+"));
        }
    }
}