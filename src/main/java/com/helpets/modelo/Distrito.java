package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Distrito {
    private String iddistrito;
    private String distrito;
    private String idprovincia;

    public Distrito() {}

    // Getters y Setters
    public String getIddistrito() { return iddistrito; }
    public void setIddistrito(String iddistrito) { this.iddistrito = iddistrito; }
    public String getDistrito() { return distrito; }
    public void setDistrito(String distrito) { this.distrito = distrito; }
    public String getIdprovincia() { return idprovincia; }
    public void setIdprovincia(String idprovincia) { this.idprovincia = idprovincia; }

    // Método para filtrar distritos por Provincia
    public static List<Distrito> listarPorProvincia(String idprov) {
        List<Distrito> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT iddistrito, distrito FROM distritos WHERE idprovincia = ?";
        ResultSet rs = dao.ejecutarSelect(sql, idprov);
        try {
            while (rs != null && rs.next()) {
                Distrito d = new Distrito();
                d.setIddistrito(rs.getString("iddistrito"));
                d.setDistrito(rs.getString("distrito"));
                lista.add(d);
            }
        } catch (Exception e) {
            System.err.println("Error al listar distritos: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }
}