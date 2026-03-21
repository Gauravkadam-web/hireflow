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
        System.out.println("HireFlow starting up...");

        JobDAO jobDAO = new JobDAO();

        // Run immediately on startup
        try {
            int expired = jobDAO.expireOldJobs();
            System.out.println(
                    "Auto-expiry: " + expired + " job(s) expired on startup.");
        } catch (Exception e) {
            System.err.println("Auto-expiry startup error: " + e.getMessage());
        }

        // Then run every 24 hours
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(() -> {
            try {
                int expired = jobDAO.expireOldJobs();
                System.out.println(
                        "Auto-expiry: " + expired + " job(s) expired.");
            } catch (Exception e) {
                System.err.println(
                        "Auto-expiry scheduled error: " + e.getMessage());
            }
        }, 24, 24, TimeUnit.HOURS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
        System.out.println("HireFlow shut down cleanly.");
    }
}
