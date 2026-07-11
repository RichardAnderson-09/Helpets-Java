package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Provincia {
    private String idprovincia;
    private String provincia;
    private String iddepartamento;

    public Provincia() {}

    // Getters y Setters
    public String getIdprovincia() { return idprovincia; }
    public void setIdprovincia(String idprovincia) { this.idprovincia = idprovincia; }
    public String getProvincia() { return provincia; }
    public void setProvincia(String provincia) { this.provincia = provincia; }
    public String getIddepartamento() { return iddepartamento; }
    public void setIddepartamento(String iddepartamento) { this.iddepartamento = iddepartamento; }

    // Método para filtrar provincias por Departamento
    public static List<Provincia> listarPorDepartamento(String iddep) {
        List<Provincia> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT idprovincia, provincia FROM provincias WHERE iddepartamento = ?";
        ResultSet rs = dao.ejecutarSelect(sql, iddep);
        try {
            while (rs != null && rs.next()) {
                Provincia p = new Provincia();
                p.setIdprovincia(rs.getString("idprovincia"));
                p.setProvincia(rs.getString("provincia"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.err.println("Error al listar provincias: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }
}