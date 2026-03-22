package com.hireflow.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("HireFlow starting — initializing DB pool...");
        String xmlPath = sce.getServletContext().getRealPath("/WEB-INF/db-config.xml");
        DBConnection.init(xmlPath);
        System.out.println("HireFlow DB pool ready.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("HireFlow shutting down.");
    }
}