package com.helpets.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    
    // 1. Configura tus credenciales (Asegúrate de que el nombre de la BD coincida con el tuyo)
    //private static final String URL = "jdbc:mysql://localhost:3306/helpets_database?useSSL=false&serverTimezone=UTC";
    private static final String URL = "jdbc:mysql://localhost:3306/helpets_database?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    
    private static final String USUARIO = "root"; 
    private static final String PASSWORD = "123456"; 

    // 2. Método para obtener la conexión
    public static Connection getConexion() {
        Connection conexion = null;
        try {
            // Cargar el Driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establecer la conexión
            conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
            System.out.println("¡Conexión exitosa!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("Error: Faltan las librerías del Driver de MySQL.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error de conexión.");
            e.printStackTrace();
        }
        
        return conexion;
    }
}

