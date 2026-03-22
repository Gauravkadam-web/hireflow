package com.hireflow.util;

import com.hireflow.dao.JobDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class AppStartupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("HireFlow scheduler starting...");

        // Run immediately on startup (DB pool already initialized by AppInitListener)
        scheduler = Executors.newSingleThreadScheduledExecutor();

        scheduler.scheduleAtFixedRate(() -> {
            try {
                JobDAO jobDAO = new JobDAO();
                int expired = jobDAO.expireOldJobs();
                System.out.println("Auto-expiry: " + expired + " job(s) expired.");
            } catch (Exception e) {
                System.err.println("Auto-expiry error: " + e.getMessage());
            }
        }, 0, 24, TimeUnit.HOURS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) scheduler.shutdownNow();
        System.out.println("HireFlow shut down cleanly.");
    }
}