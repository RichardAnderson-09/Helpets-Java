package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;

public class Persona {
    private String tipodoc;
    private String nrodoc;
    private String nombres;
    private String apellidos;
    private String telefono;
    private String correo;
    private String iddistrito;
    private java.sql.Date fechanac;

    public Persona() {}

    // Este método es clave: Inserta a la persona si no existe, y devuelve su ID generado.
    public int registrarYObtenerId() {
        GestorDAO dao = new GestorDAO();
        
        // Verificamos si la persona ya existe en el sistema por su DNI
        String sqlCheck = "SELECT idpersona FROM personas WHERE tipodoc = ? AND nrodoc = ?";
        ResultSet rs = dao.ejecutarSelect(sqlCheck, this.tipodoc, this.nrodoc);
        try {
            if (rs != null && rs.next()) {
                int id = rs.getInt("idpersona");
                dao.cerrarConexion();
                return id; // Si existe, devolvemos su ID sin insertar nada
            }
        } catch(Exception e) {}

        // Si no existe, lo insertamos
        String sqlInsert = "INSERT INTO personas (nombres, apellidos, fechanac, tipodoc, nrodoc, telefono, correo, iddistrito) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        boolean exito = dao.ejecutarModificacion(sqlInsert, this.nombres, this.apellidos, this.fechanac, this.tipodoc, this.nrodoc, this.telefono, this.correo, this.iddistrito);
        
        // Rescatamos el ID recién creado
        if (exito) {
            rs = dao.ejecutarSelect(sqlCheck, this.tipodoc, this.nrodoc);
            try {
                if (rs != null && rs.next()) {
                    int id = rs.getInt("idpersona");
                    dao.cerrarConexion();
                    return id;
                }
            } catch(Exception e) {}
        }
        dao.cerrarConexion();
        return -1; // Retorna -1 si hubo un error grave
    }
    
    // Método para el buscador AJAX
    public static Persona buscarPorDocumento(String tipodoc, String nrodoc) {
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT * FROM personas WHERE tipodoc = ? AND nrodoc = ?";
        ResultSet rs = dao.ejecutarSelect(sql, tipodoc, nrodoc);
        try {
            if (rs != null && rs.next()) {
                Persona p = new Persona();
                p.setNombres(rs.getString("nombres"));
                p.setApellidos(rs.getString("apellidos"));
                p.setFechanac(rs.getDate("fechanac"));
                p.setTelefono(rs.getString("telefono"));
                p.setCorreo(rs.getString("correo"));
                return p;
            }
        } catch (Exception e) {
            System.err.println("Error al buscar persona: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return null;
    }

    // Getters y Setters
    public String getTipodoc() { return tipodoc; }
    public void setTipodoc(String tipodoc) { this.tipodoc = tipodoc; }
    public String getNrodoc() { return nrodoc; }
    public void setNrodoc(String nrodoc) { this.nrodoc = nrodoc; }
    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }
    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    public String getIddistrito() { return iddistrito; }
    public void setIddistrito(String iddistrito) { this.iddistrito = iddistrito; }
    public java.sql.Date getFechanac() { return fechanac; }
public void setFechanac(java.sql.Date fechanac) { this.fechanac = fechanac; }
}