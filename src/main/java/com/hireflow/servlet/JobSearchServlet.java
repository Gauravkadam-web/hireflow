package com.hireflow.servlet;

import com.hireflow.dao.CategoryDAO;
import com.hireflow.dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/jobs")
public class JobSearchServlet extends HttpServlet {

    private JobDAO      jobDAO;
    private CategoryDAO categoryDAO;

    private static final int PAGE_SIZE = 10;

    @Override
    public void init() {
        jobDAO      = new JobDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String keyword   = req.getParameter("keyword");
        String location  = req.getParameter("location");
        String catParam  = req.getParameter("category");
        String pageParam = req.getParameter("page");

        int categoryId = 0;
        try { categoryId = Integer.parseInt(catParam); } catch (Exception ignored) {}

        int page = 1;
        try { page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
        if (page < 1) page = 1;

        try {
            List jobs = jobDAO.searchJobs(keyword, location, categoryId, page, PAGE_SIZE);

            req.setAttribute("jobs",       jobs);
            req.setAttribute("categories", categoryDAO.getAll());
            req.setAttribute("keyword",    keyword);
            req.setAttribute("location",   location);
            req.setAttribute("categoryId", categoryId);
            req.setAttribute("page",       page);
            req.setAttribute("pageSize",   PAGE_SIZE);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Search failed: " + e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/jobList.jsp").forward(req, res);
    }
}
