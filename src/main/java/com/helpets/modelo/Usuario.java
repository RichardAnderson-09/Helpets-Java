package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;

public class Usuario {
    private int idusuario;
    private int idpersona;
    private int idrol;
    private String nombreusuario;
    private String estado;
    
    // Variables adicionales para la vista (Dashboard)
    private String nombresPersona;
    private String apellidosPersona;
    private String nombreRol;

    public Usuario() {}

    // Método principal para validar credenciales
    public static Usuario validarLogin(String username, String passwordHash) {
        GestorDAO dao = new GestorDAO();
        // INNER JOIN para traer los datos del usuario, sus nombres reales y su rol
        String sql = "SELECT u.idusuario, u.idpersona, u.idrol, u.nombreusuario, u.estado, " +
                     "p.nombres, p.apellidos, r.rol " +
                     "FROM usuarios u " +
                     "INNER JOIN personas p ON u.idpersona = p.idpersona " +
                     "INNER JOIN roles r ON u.idrol = r.idrol " +
                     "WHERE u.nombreusuario = ? AND u.contraseña = ? AND u.estado = 'A'";
                     
        ResultSet rs = dao.ejecutarSelect(sql, username, passwordHash);
        
        try {
            if (rs != null && rs.next()) {
                Usuario u = new Usuario();
                u.setIdusuario(rs.getInt("idusuario"));
                u.setIdpersona(rs.getInt("idpersona"));
                u.setIdrol(rs.getInt("idrol"));
                u.setNombreusuario(rs.getString("nombreusuario"));
                u.setEstado(rs.getString("estado"));
                
                // Datos cruzados de las otras tablas
                u.setNombresPersona(rs.getString("nombres"));
                u.setApellidosPersona(rs.getString("apellidos"));
                u.setNombreRol(rs.getString("rol"));
                return u; // Retorna el objeto lleno si existe
            }
        } catch (Exception e) {
            System.err.println("Error en Login: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return null; // Retorna null si no coincide el usuario o la contraseña
    }

    // Getters y Setters
    public int getIdusuario() { return idusuario; }
    public void setIdusuario(int idusuario) { this.idusuario = idusuario; }
    public int getIdpersona() { return idpersona; }
    public void setIdpersona(int idpersona) { this.idpersona = idpersona; }
    public int getIdrol() { return idrol; }
    public void setIdrol(int idrol) { this.idrol = idrol; }
    public String getNombreusuario() { return nombreusuario; }
    public void setNombreusuario(String nombreusuario) { this.nombreusuario = nombreusuario; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getNombresPersona() { return nombresPersona; }
    public void setNombresPersona(String nombresPersona) { this.nombresPersona = nombresPersona; }
    public String getApellidosPersona() { return apellidosPersona; }
    public void setApellidosPersona(String apellidosPersona) { this.apellidosPersona = apellidosPersona; }
    public String getNombreRol() { return nombreRol; }
    public void setNombreRol(String nombreRol) { this.nombreRol = nombreRol; }
}