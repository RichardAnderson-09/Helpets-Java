package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProcesoMedico {
    private int idprocesomedico;
    private String procesomedico;
    private String descripcion;

    public ProcesoMedico() {}

    public static List<ProcesoMedico> listarProcesos() {
        List<ProcesoMedico> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        // Usamos los nombres exactos de tu tabla
        String sql = "SELECT * FROM procesosmedicos ORDER BY procesomedico ASC";
        ResultSet rs = dao.ejecutarSelect(sql);
        try {
            while (rs != null && rs.next()) {
                ProcesoMedico p = new ProcesoMedico();
                p.setIdprocesomedico(rs.getInt("idprocesomedico"));
                p.setProcesomedico(rs.getString("procesomedico"));
                p.setDescripcion(rs.getString("descripcion"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.err.println("Error listar procesos: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }

    public static String obtenerDescripcion(int id) {
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT descripcion FROM procesosmedicos WHERE idprocesomedico = ?";
        ResultSet rs = dao.ejecutarSelect(sql, id);
        try {
            if (rs != null && rs.next()) {
                return rs.getString("descripcion");
            }
        } catch (Exception e) {
            System.err.println("Error obtener descripcion: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return "";
    }

    // Getters y Setters
    public int getIdprocesomedico() { return idprocesomedico; }
    public void setIdprocesomedico(int idprocesomedico) { this.idprocesomedico = idprocesomedico; }
    public String getProcesomedico() { return procesomedico; }
    public void setProcesomedico(String procesomedico) { this.procesomedico = procesomedico; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}