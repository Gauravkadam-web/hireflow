package com.hireflow.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); // destroy session
        }

        // Redirect to login with message
        res.sendRedirect(req.getContextPath()
                + "/login?success=You+have+been+logged+out");
    }
}