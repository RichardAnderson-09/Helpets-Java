package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Departamento {
    private String iddepartamento;
    private String departamento;

    public Departamento() {}

    // Getters y Setters
    public String getIddepartamento() { return iddepartamento; }
    public void setIddepartamento(String iddepartamento) { this.iddepartamento = iddepartamento; }
    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }

    // Método para obtener todos los departamentos
    public static List<Departamento> listarDepartamentos() {
        List<Departamento> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO(); // Instanciamos tu GestorDAO existente
        String sql = "SELECT iddepartamento, departamento FROM departamentos";
        ResultSet rs = dao.ejecutarSelect(sql);
        try {
            while (rs != null && rs.next()) {
                Departamento d = new Departamento();
                d.setIddepartamento(rs.getString("iddepartamento"));
                d.setDepartamento(rs.getString("departamento"));
                lista.add(d);
            }
        } catch (Exception e) {
            System.err.println("Error al listar departamentos: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }
}