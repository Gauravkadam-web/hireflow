package com.hireflow.util;

import org.apache.commons.dbcp2.BasicDataSource;
import org.w3c.dom.Document;

import javax.sql.DataSource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Manages the DBCP2 connection pool.
 *
 * Strategy (checked in order):
 *   1. DATABASE_URL env var  — set automatically by Render PostgreSQL service
 *   2. Individual env vars   — DB_URL, DB_USERNAME, DB_PASSWORD
 *   3. WEB-INF/db-config.xml — fallback for local development
 */
public class DBConnection {

    private static DataSource dataSource;

    public static void init(String xmlFilePath) {
        try {
            // ── Priority 1: Render sets DATABASE_URL automatically ────────
            String databaseUrl = System.getenv("DATABASE_URL");
            if (databaseUrl != null && !databaseUrl.isBlank()) {
                initFromDatabaseUrl(databaseUrl);
                System.out.println("HireFlow DB pool initialized from DATABASE_URL");
                return;
            }

            // ── Priority 2: Individual env vars ───────────────────────────
            String dbUrl      = System.getenv("DB_URL");
            String dbUsername = System.getenv("DB_USERNAME");
            String dbPassword = System.getenv("DB_PASSWORD");

            if (dbUrl != null && !dbUrl.isBlank()) {
                initFromEnvVars(dbUrl, dbUsername, dbPassword);
                System.out.println("HireFlow DB pool initialized from env vars");
                return;
            }

            // ── Priority 3: Local XML config ──────────────────────────────
            initFromXml(xmlFilePath);
            System.out.println("HireFlow DB pool initialized from XML");

        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize DB connection pool", e);
        }
    }

    // ── Render: DATABASE_URL format ───────────────────────────────────────
    // Render provides: postgres://user:password@host:port/dbname
    // JDBC needs:      jdbc:postgresql://host:port/dbname
    private static void initFromDatabaseUrl(String databaseUrl) {
        // Convert postgres:// → jdbc:postgresql://
        String jdbcUrl = databaseUrl
                .replace("postgres://", "jdbc:postgresql://")
                .replace("postgresql://", "jdbc:postgresql://");

        // Extract credentials from the URL
        // Format: jdbc:postgresql://user:password@host:port/dbname
        String withoutScheme = jdbcUrl.replace("jdbc:postgresql://", "");
        String userInfo      = withoutScheme.substring(0, withoutScheme.indexOf('@'));
        String cleanUrl      = "jdbc:postgresql://" + withoutScheme.substring(withoutScheme.indexOf('@') + 1);

        String username = userInfo.contains(":") ? userInfo.split(":")[0] : userInfo;
        String password = userInfo.contains(":") ? userInfo.split(":", 2)[1] : "";

        // Render requires SSL
        cleanUrl += (cleanUrl.contains("?") ? "&" : "?") + "sslmode=require";

        buildPool(cleanUrl, username, password);
    }

    // ── Individual env vars ───────────────────────────────────────────────
    private static void initFromEnvVars(String url, String username, String password) {
        buildPool(
                url,
                username != null ? username : "",
                password != null ? password : ""
        );
    }

    // ── XML file (local development) ──────────────────────────────────────
    private static void initFromXml(String xmlFilePath) throws Exception {
        File xmlFile = new File(xmlFilePath);
        if (!xmlFile.exists()) {
            throw new RuntimeException(
                    "No DB config found. Set DATABASE_URL env var or provide " + xmlFilePath);
        }

        DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        Document doc = builder.parse(xmlFile);
        doc.getDocumentElement().normalize();

        String url      = getText(doc, "url");
        String username = getText(doc, "username");
        String password = getText(doc, "password");

        buildPool(url, username, password);
    }

    // ── Shared pool builder ───────────────────────────────────────────────
    private static void buildPool(String url, String username, String password) {
        BasicDataSource bds = new BasicDataSource();
        bds.setDriverClassName("org.postgresql.Driver");
        bds.setUrl(url);
        bds.setUsername(username);
        bds.setPassword(password);
        bds.setMaxTotal(10);
        bds.setMaxIdle(5);
        bds.setMinIdle(2);
        bds.setMaxWaitMillis(3000);
        bds.setValidationQuery("SELECT 1");
        bds.setTestOnBorrow(true);
        bds.setConnectionProperties("stringtype=unspecified");
        dataSource = bds;
    }

    // ── Public API ────────────────────────────────────────────────────────
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new IllegalStateException("DBConnection not initialized!");
        }
        return dataSource.getConnection();
    }

    // ── XML helper ────────────────────────────────────────────────────────
    private static String getText(Document doc, String tag) {
        return doc.getElementsByTagName(tag).item(0).getTextContent().trim();
    }

    private DBConnection() {}
}
