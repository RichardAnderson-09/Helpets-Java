package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Especie {
    private int idespecie;
    private String nombreEspecie;

    public Especie() {}

    // Método para listar todas las especies
    public static List<Especie> listarEspecies() {
        List<Especie> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT idespecie, nombre_especie FROM especies";
        ResultSet rs = dao.ejecutarSelect(sql);
        
        try {
            while (rs != null && rs.next()) {
                Especie e = new Especie();
                e.setIdespecie(rs.getInt("idespecie"));
                e.setNombreEspecie(rs.getString("nombre_especie"));
                lista.add(e);
            }
        } catch (Exception ex) {
            System.err.println("Error al listar especies: " + ex.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }

    // Getters y Setters
    public int getIdespecie() { return idespecie; }
    public void setIdespecie(int idespecie) { this.idespecie = idespecie; }
    public String getNombreEspecie() { return nombreEspecie; }
    public void setNombreEspecie(String nombreEspecie) { this.nombreEspecie = nombreEspecie; }
}