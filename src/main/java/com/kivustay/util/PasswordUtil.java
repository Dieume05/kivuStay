package com.kivustay.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    private static final int ITERATIONS = 120000;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;

    // Generate a secure password hash
    public static String hashPassword(String password)
            throws NoSuchAlgorithmException, InvalidKeySpecException {

        byte[] salt = new byte[SALT_LENGTH];

        SecureRandom random = new SecureRandom();
        random.nextBytes(salt);

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                ITERATIONS,
                KEY_LENGTH
        );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        byte[] hash = factory.generateSecret(spec).getEncoded();

        spec.clearPassword();

        return "pbkdf2$" + ITERATIONS + "$"
                + Base64.getEncoder().encodeToString(salt) + "$"
                + Base64.getEncoder().encodeToString(hash);
    }

    // Verify a password against its stored hash
    public static boolean verifyPassword(
            String password, String storedHash)
            throws NoSuchAlgorithmException, InvalidKeySpecException {

        String[] parts = storedHash.split("\\$");

        if (parts.length != 4 || !parts[0].equals("pbkdf2")) {
            return false;
        }

        int iterations = Integer.parseInt(parts[1]);

        if (iterations < 10000 || iterations > 1000000) {
            return false;
        }

        byte[] salt = Base64.getDecoder().decode(parts[2]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[3]);

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                iterations,
                expectedHash.length * 8
        );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        byte[] actualHash = factory.generateSecret(spec).getEncoded();

        spec.clearPassword();

        return java.security.MessageDigest.isEqual(
                expectedHash, actualHash
        );
    }
}