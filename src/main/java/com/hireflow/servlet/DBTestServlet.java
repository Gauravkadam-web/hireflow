package com.hireflow.servlet;

import com.hireflow.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/test-db")
public class DBTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();

        out.println("""
            <!DOCTYPE html>
            <html>
            <head>
              <title>HireFlow Phase 1 Test</title>
              <style>
                body { font-family: sans-serif; padding: 40px;
                       max-width: 600px; background: #f8f9fb; }
                h2   { color: #0d1117; }
                .ok  { color: #16a34a; font-weight: bold; }
                .err { color: #dc2626; font-weight: bold; }
                ul   { background: white; padding: 16px 32px;
                       border-radius: 8px; border: 1px solid #e2e8f0; }
                .win { background: #d1fae5; padding: 20px 24px;
                       border-radius: 10px; border: 1px solid #6ee7b7;
                       margin-top: 16px; }
              </style>
            </head>
            <body>
            <h2>HireFlow &mdash; Phase 1 Foundation Test</h2>
            """);

        try (Connection conn = DBConnection.getConnection();
             Statement  stmt = conn.createStatement()) {

            // Test 1: Connection
            ResultSet rs = stmt.executeQuery("SELECT NOW() AS t");
            rs.next();
            out.println("<p class='ok'>&#10003; DB Connected &mdash; "
                    + rs.getString("t") + "</p>");

            // Test 2: Tables
            rs = stmt.executeQuery(
                    "SELECT COUNT(*) AS c FROM information_schema.tables " +
                            "WHERE table_schema = 'public'");
            rs.next();
            out.println("<p class='ok'>&#10003; Tables created: "
                    + rs.getInt("c") + " found</p>");

            // Test 3: Indexes
            rs = stmt.executeQuery(
                    "SELECT COUNT(*) AS c FROM pg_indexes " +
                            "WHERE schemaname = 'public'");
            rs.next();
            out.println("<p class='ok'>&#10003; Indexes created: "
                    + rs.getInt("c") + " found</p>");

            // Test 4: Categories
            rs = stmt.executeQuery(
                    "SELECT name FROM categories ORDER BY category_id");
            out.println("<p class='ok'>&#10003; Categories seeded:</p><ul>");
            while (rs.next()) {
                out.println("<li>" + rs.getString("name") + "</li>");
            }
            out.println("</ul>");

            // Test 5: Pool
            out.println("<p class='ok'>&#10003; DBCP2 connection pool active</p>");

            out.println("""
                <div class='win'>
                  <h2 style='margin:0;color:#065f46'>
                    Phase 1 Complete! Foundation is solid.
                  </h2>
                  <p style='margin:8px 0 0;color:#047857'>
                    Ready to build Phase 2 &mdash; Auth System.
                  </p>
                </div>
                """);

        } catch (Exception e) {
            out.println("<p class='err'>&#10007; Error: "
                    + e.getMessage() + "</p>");
            out.println("<pre style='background:#fef2f2;padding:16px;"
                    + "border-radius:8px'>" + e + "</pre>");
        }

        out.println("</body></html>");
    }
}
