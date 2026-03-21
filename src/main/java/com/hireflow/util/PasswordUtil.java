package com.hireflow.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Cost factor 12 = ~250ms per hash
    // slow enough to stop brute force
    private static final int COST = 12;

    /** Hash a plain-text password — call on registration */
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(COST));
    }

    /** Verify input against stored hash — call on login */
    public static boolean verify(String plainPassword, String storedHash) {
        return BCrypt.checkpw(plainPassword, storedHash);
    }

    // No instances
    private PasswordUtil() {}
}