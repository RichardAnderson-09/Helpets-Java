package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Raza {
    private int idraza;
    private String nombreRaza;

    public Raza() {}

    // Consulta filtrada por especie
    public static List<Raza> listarPorEspecie(int idEspecie) {
        List<Raza> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT idraza, nombre_raza FROM razas WHERE idespecie = ?";
        ResultSet rs = dao.ejecutarSelect(sql, idEspecie);
        
        try {
            while (rs != null && rs.next()) {
                Raza r = new Raza();
                r.setIdraza(rs.getInt("idraza"));
                r.setNombreRaza(rs.getString("nombre_raza"));
                lista.add(r);
            }
        } catch (Exception e) {
            System.err.println("Error al listar razas: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }

    // Getters y Setters
    public int getIdraza() { return idraza; }
    public void setIdraza(int idraza) { this.idraza = idraza; }
    public String getNombreRaza() { return nombreRaza; }
    public void setNombreRaza(String nombreRaza) { this.nombreRaza = nombreRaza; }
}