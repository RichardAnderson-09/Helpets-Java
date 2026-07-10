package com.helpets.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ConexionBD {
    private static final Logger logger = LoggerFactory.getLogger(ConexionBD.class);
    // 1. Configuracion de credenciales
    private static final String URL = requireEnv("DB_URL");
    private static final String USUARIO = requireEnv("DB_USER");
    private static final String PASSWORD = requireEnv("DB_PASSWORD");

    private static String requireEnv(String nombre) {
        String valor = System.getenv(nombre);

        if (valor == null || valor.isBlank()) {
            throw new IllegalStateException("Falta configurar la variable de entorno: " + nombre);
        }

        return valor;
    }
    
    // 2. Método para obtener la conexión
    public static Connection getConexion() {
        Connection conexion = null;
        try {
            // Cargar el Driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establecer la conexión
            conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
            logger.info("¡Conexión exitosa!");
            
        } catch (ClassNotFoundException e) {
            logger.error("Error: Faltan las librerías del Driver de MySQL.", e);
        } catch (SQLException e) {
            logger.error("Error de conexión.", e);
        }
        
        return conexion;
    }
}

