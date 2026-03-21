package com.hireflow.util;

import org.apache.commons.dbcp2.BasicDataSource;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.sql.DataSource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {

    private static DataSource dataSource;

    public static void init(String xmlFilePath) {
        try {
            // Parse the XML file
            File xmlFile = new File(xmlFilePath);
            DocumentBuilder builder =
                    DocumentBuilderFactory.newInstance()
                            .newDocumentBuilder();
            Document doc = builder.parse(xmlFile);
            doc.getDocumentElement().normalize();

            // Read values from XML tags
            String url      = getText(doc, "url");
            String username = getText(doc, "username");
            String password = getText(doc, "password");
            String driver   = getText(doc, "driver");
            int maxTotal    = getInt(doc, "maxTotal", 10);
            int maxIdle     = getInt(doc, "maxIdle",  5);
            int minIdle     = getInt(doc, "minIdle",  2);
            long maxWait    = getLong(doc, "maxWaitMillis", 3000);

            // Build connection pool
            BasicDataSource bds = new BasicDataSource();
            bds.setDriverClassName(driver);
            bds.setUrl(url);
            bds.setUsername(username);
            bds.setPassword(password);
            bds.setMaxTotal(maxTotal);
            bds.setMaxIdle(maxIdle);
            bds.setMinIdle(minIdle);
            bds.setMaxWaitMillis(maxWait);
            bds.setValidationQuery("SELECT 1");
            bds.setTestOnBorrow(true);
            bds.setConnectionProperties("stringtype=unspecified");

            dataSource = bds;
            System.out.println(
                    "HireFlow DB pool initialized from XML");

        } catch (Exception e) {
            throw new RuntimeException(
                    "Failed to init DB from: " + xmlFilePath, e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new IllegalStateException(
                    "DBConnection not initialized!");
        }
        return dataSource.getConnection();
    }

    // ── XML Helpers ───────────────────────────────────

    private static String getText(Document doc, String tag) {
        return doc.getElementsByTagName(tag)
                .item(0)
                .getTextContent()
                .trim();
    }

    private static int getInt(Document doc, String tag,
                              int defaultVal) {
        try {
            return Integer.parseInt(getText(doc, tag));
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private static long getLong(Document doc, String tag,
                                long defaultVal) {
        try {
            return Long.parseLong(getText(doc, tag));
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private DBConnection() {}
}