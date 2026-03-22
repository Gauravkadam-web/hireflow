package com.hireflow.servlet;

import com.hireflow.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

@WebServlet("/diag")
public class DiagServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = res.getWriter();

        out.println("=== HireFlow Diagnostics ===");
        out.println();

        // 1. Env vars
        String dbUrl = System.getenv("DATABASE_URL");
        out.println("DATABASE_URL set: " + (dbUrl != null));
        if (dbUrl != null) {
            out.println("DATABASE_URL starts with: " + dbUrl.substring(0, Math.min(30, dbUrl.length())) + "...");
        }

        // 2. XML path
        String xmlPath = getServletContext().getRealPath("/WEB-INF/db-config.xml");
        out.println("XML path: " + xmlPath);
        out.println("XML exists: " + (xmlPath != null && new java.io.File(xmlPath).exists()));

        // 3. DB connection test
        out.println();
        out.println("Testing DB connection...");
        try {
            Connection conn = DBConnection.getConnection();
            out.println("DB connection: SUCCESS");
            conn.close();
        } catch (Exception e) {
            out.println("DB connection: FAILED");
            out.println("Error: " + e.getMessage());
            out.println();
            out.println("Attempting to init DB pool now...");
            try {
                DBConnection.init(xmlPath);
                Connection conn = DBConnection.getConnection();
                out.println("DB init + connection: SUCCESS");
                conn.close();
            } catch (Exception e2) {
                out.println("DB init failed: " + e2.getMessage());
                e2.printStackTrace(out);
            }
        }

        out.println();
        out.println("=== End Diagnostics ===");
    }
}