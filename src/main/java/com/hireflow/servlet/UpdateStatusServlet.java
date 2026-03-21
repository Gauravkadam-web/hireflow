package com.hireflow.servlet;

import com.hireflow.dao.ApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebServlet("/application/status")
public class UpdateStatusServlet extends HttpServlet {

    private static final Set<String> VALID_STATUSES =
            Set.of("applied", "reviewed", "hired", "rejected");

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Guard: employer or admin only
        if (session == null ||
                session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"employer".equals(role) && !"admin".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String appIdStr = req.getParameter("applicationId");
        String status   = req.getParameter("status");
        String redirect = req.getContextPath() + "/dashboard/employer";

        // Validate inputs
        if (appIdStr == null || status == null ||
                !VALID_STATUSES.contains(status)) {
            res.sendRedirect(redirect +
                    "?error=Invalid+status+update+request.");
            return;
        }

        try {
            int applicationId = Integer.parseInt(appIdStr);
            boolean updated = applicationDAO.updateStatus(
                    applicationId, status);

            if (updated) {
                res.sendRedirect(redirect +
                        "?success=Application+status+updated+to+" + status + ".");
            } else {
                res.sendRedirect(redirect +
                        "?error=Could+not+update+status.+Application+not+found.");
            }

        } catch (NumberFormatException e) {
            res.sendRedirect(redirect + "?error=Invalid+application+ID.");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(redirect +
                    "?error=Something+went+wrong:+" +
                    e.getMessage().replace(" ", "+"));
        }
    }
}