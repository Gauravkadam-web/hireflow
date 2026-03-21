package com.hireflow.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();

        // Load XML config from WEB-INF at runtime
        String path = ctx.getRealPath("/WEB-INF/db-config.xml");

        System.out.println("Loading config from: " + path);
        DBConnection.init(path);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("HireFlow shutting down.");
    }
}