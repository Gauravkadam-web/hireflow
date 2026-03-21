package com.hireflow.servlet;

import com.hireflow.dao.ApplicationDAO;
import com.hireflow.model.Application;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/apply")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,       // 1 MB — buffer before writing to disk
        maxFileSize       = 5 * 1024 * 1024,   // 5 MB — max single file
        maxRequestSize    = 10 * 1024 * 1024   // 10 MB — max total request
)
public class ApplyServlet extends HttpServlet {

    // Upload folder relative to webapp root — create this folder in your project
    private static final String UPLOAD_DIR = "uploads/resumes";

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ── Auth guard ────────────────────────────────
        HttpSession session = req.getSession(false);
        if (session == null ||
                session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"seeker".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/jobs");
            return;
        }

        int seekerId = (int) session.getAttribute("userId");

        // ── Read form fields ──────────────────────────
        String jobIdParam   = req.getParameter("jobId");
        String coverLetter  = req.getParameter("coverLetter");
        String resumeUrl    = req.getParameter("resumeUrl");
        String phone        = req.getParameter("phone");

        if (jobIdParam == null || jobIdParam.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/jobs");
            return;
        }

        int jobId = Integer.parseInt(jobIdParam);
        String redirectBase = req.getContextPath()
                + "/jobs/detail?id=" + jobId;

        // ── Validation ────────────────────────────────
        if ((coverLetter == null || coverLetter.trim().isEmpty()) &&
                (resumeUrl == null || resumeUrl.trim().isEmpty())) {
            Part filePart = req.getPart("resumeFile");
            if (filePart == null || filePart.getSize() == 0) {
                res.sendRedirect(redirectBase +
                        "&error=Please+provide+a+cover+letter+or+resume.");
                return;
            }
        }

        try {
            // ── Handle file upload ────────────────────
            String savedResumeUrl = resumeUrl; // default to URL if provided

            Part filePart = req.getPart("resumeFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(
                                filePart.getSubmittedFileName()).getFileName()
                        .toString();

                // Sanitize filename
                String safeFileName = System.currentTimeMillis()
                        + "_" + fileName.replaceAll("[^a-zA-Z0-9._-]", "_");

                // Save to webapp/uploads/resumes/
                String uploadPath = getServletContext()
                        .getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + safeFileName);
                savedResumeUrl = req.getContextPath()
                        + "/" + UPLOAD_DIR + "/" + safeFileName;
            }

            // ── Update phone if provided ──────────────
            if (phone != null && !phone.trim().isEmpty()) {
                // Store phone on user record if you want — optional
                // userDAO.updatePhone(seekerId, phone.trim());
            }

            // ── Build and insert application ──────────
            Application app = new Application();
            app.setJobId(jobId);
            app.setSeekerId(seekerId);
            app.setResumeUrl(savedResumeUrl);
            app.setCoverLetter(
                    coverLetter != null ? coverLetter.trim() : "");

            boolean inserted = applicationDAO.insert(app);

            if (inserted) {
                res.sendRedirect(redirectBase +
                        "&success=Application+submitted+successfully!");
            } else {
                res.sendRedirect(redirectBase +
                        "&error=You+have+already+applied+for+this+job.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(redirectBase +
                    "&error=Something+went+wrong:+" +
                    e.getMessage().replace(" ", "+"));
        }
    }
}
