package com.helpets.dao;

import com.helpets.config.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class GestorDAO {
    private Connection conexion;

    public GestorDAO() {
        // Al instanciar el DAO, obtenemos la conexión única
        this.conexion = ConexionBD.getConexion();
    }

    // Método genérico para consultas SELECT
    public ResultSet ejecutarSelect(String sql, Object... params) {
        try {
            PreparedStatement ps = conexion.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            return ps.executeQuery();
        } catch (SQLException e) {
            System.err.println("Error en SELECT: " + e.getMessage());
            return null;
        }
    }

    // Método genérico para INSERT, UPDATE, DELETE
    public boolean ejecutarModificacion(String sql, Object... params) {
       try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        }catch (SQLException e) {
            System.err.println("Error en modificación: " + e.getMessage());
            return false;
        }
    }
    
    // Método para liberar recursos
    public void cerrarConexion() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar conexión: " + e.getMessage());
        }
    }
}