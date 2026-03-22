package com.hireflow.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("HireFlow starting - initializing DB pool...");

        // Try XML path first, fall back to null (forces env var usage)
        String xmlPath = sce.getServletContext().getRealPath("/WEB-INF/db-config.xml");
        System.out.println("DB config path: " + xmlPath);

        DBConnection.init(xmlPath);
        System.out.println("HireFlow DB pool ready.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("HireFlow shutting down.");
    }
}