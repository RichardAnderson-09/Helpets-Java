package com.helpets.config;

import java.security.MessageDigest;

public class Encriptador {
    
    // Método estático para convertir cualquier texto a Hash SHA-256
    public static String encriptarSHA256(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();

            for (int i = 0; i < hash.length; i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (Exception ex) {
            System.err.println("Error al encriptar: " + ex.getMessage());
            return null;
        }
    }
}