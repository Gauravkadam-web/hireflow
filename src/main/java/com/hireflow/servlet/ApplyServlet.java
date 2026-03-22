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
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 5 * 1024 * 1024,
        maxRequestSize    = 10 * 1024 * 1024
)
public class ApplyServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/resumes";

    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

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

        int seekerId = (int) session.getAttribute("userId");

        String jobIdParam  = req.getParameter("jobId");
        String coverLetter = req.getParameter("coverLetter");
        String resumeUrl   = req.getParameter("resumeUrl");
        String phone       = req.getParameter("phone");

        if (jobIdParam == null || jobIdParam.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/jobs");
            return;
        }

        int jobId = Integer.parseInt(jobIdParam);
        String redirectBase = req.getContextPath() + "/jobs/detail?id=" + jobId;

        if ((coverLetter == null || coverLetter.trim().isEmpty()) &&
                (resumeUrl == null || resumeUrl.trim().isEmpty())) {
            Part filePart = req.getPart("resumeFile");
            if (filePart == null || filePart.getSize() == 0) {
                res.sendRedirect(redirectBase + "&error=Please+provide+a+cover+letter+or+resume.");
                return;
            }
        }

        try {
            String savedResumeUrl = resumeUrl;

            Part filePart = req.getPart("resumeFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName    = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String safeFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                String uploadPath  = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir     = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + safeFileName);
                savedResumeUrl = req.getContextPath() + "/" + UPLOAD_DIR + "/" + safeFileName;
            }

            Application app = new Application();
            app.setJobId(jobId);
            app.setSeekerId(seekerId);
            app.setResumeUrl(savedResumeUrl);
            app.setCoverLetter(coverLetter != null ? coverLetter.trim() : "");

            boolean inserted = applicationDAO.insert(app);

            if (inserted) {
                res.sendRedirect(redirectBase + "&success=Application+submitted+successfully!");
            } else {
                res.sendRedirect(redirectBase + "&error=You+have+already+applied+for+this+job.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(redirectBase + "&error=Something+went+wrong:+" + e.getMessage().replace(" ", "+"));
        }
    }
}
