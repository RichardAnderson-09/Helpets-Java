package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.Timestamp;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class HistorialMedico {
    private int idhistorial;
    private int idmascota;
    private int idproceso;
    private String descripcion;
    private Timestamp fechaatencion; // Usamos Timestamp porque en la BD es DATETIME
    private double peso;
    
    // Campo extra para la vista (JOIN)
    private String nombreProceso;

    public HistorialMedico() {}

    public boolean registrarHistorial() {
        GestorDAO dao = new GestorDAO();
        String sql = "INSERT INTO historialmedicos (idmascota, idproceso, descripcion, fechaatencion, peso) VALUES (?, ?, ?, ?, ?)";
        boolean exito = dao.ejecutarModificacion(sql, this.idmascota, this.idproceso, this.descripcion, this.fechaatencion, this.peso);
        dao.cerrarConexion();
        return exito;
    }

    public static List<HistorialMedico> listarPorMascota(int idMascota) {
        List<HistorialMedico> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT h.*, p.procesomedico FROM historialmedicos h " +
                     "INNER JOIN procesosmedicos p ON h.idproceso = p.idprocesomedico " +
                     "WHERE h.idmascota = ? ORDER BY h.fechaatencion DESC";
        ResultSet rs = dao.ejecutarSelect(sql, idMascota);
        try {
            while (rs != null && rs.next()) {
                HistorialMedico h = new HistorialMedico();
                h.setIdhistorial(rs.getInt("idhistorial"));
                h.setIdmascota(rs.getInt("idmascota"));
                h.setIdproceso(rs.getInt("idproceso"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setFechaatencion(rs.getTimestamp("fechaatencion"));
                h.setPeso(rs.getDouble("peso"));
                h.setNombreProceso(rs.getString("procesomedico"));
                lista.add(h);
            }
        } catch (Exception e) {
            System.err.println("Error listar historial: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }

    // Getters y Setters
    public int getIdhistorial() { return idhistorial; }
    public void setIdhistorial(int idhistorial) { this.idhistorial = idhistorial; }
    public int getIdmascota() { return idmascota; }
    public void setIdmascota(int idmascota) { this.idmascota = idmascota; }
    public int getIdproceso() { return idproceso; }
    public void setIdproceso(int idproceso) { this.idproceso = idproceso; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public Timestamp getFechaatencion() { return fechaatencion; }
    public void setFechaatencion(Timestamp fechaatencion) { this.fechaatencion = fechaatencion; }
    public double getPeso() { return peso; }
    public void setPeso(double peso) { this.peso = peso; }
    public String getNombreProceso() { return nombreProceso; }
    public void setNombreProceso(String nombreProceso) { this.nombreProceso = nombreProceso; }
}