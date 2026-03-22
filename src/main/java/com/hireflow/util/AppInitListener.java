package com.hireflow.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("=== HireFlow starting ===");
            String xmlPath = sce.getServletContext().getRealPath("/WEB-INF/db-config.xml");
            System.out.println("=== XML path: " + xmlPath);
            System.out.println("=== DATABASE_URL set: " + (System.getenv("DATABASE_URL") != null));
            DBConnection.init(xmlPath);
            System.out.println("=== HireFlow DB pool ready ===");
        } catch (Throwable t) {
            System.err.println("=== HireFlow STARTUP FAILED: " + t.getMessage());
            t.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== HireFlow shutting down ===");
    }
}