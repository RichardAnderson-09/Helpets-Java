package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

    // variables añadidas para el listado del módulo
    private String tipodoc;
    private String nrodoc;
    private String telefono;
    private String correo;
    
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

    // Método para REGISTRAR la cuenta
    public static boolean registrarCuenta(int idPersona, int idRol, String username, String passHash) {
        GestorDAO dao = new GestorDAO();
        String sql = "INSERT INTO usuarios (idpersona, idrol, nombreusuario, contraseña, estado) VALUES (?, ?, ?, ?, 'A')";
        boolean exito = dao.ejecutarModificacion(sql, idPersona, idRol, username, passHash);
        dao.cerrarConexion();
        return exito;
    }

    // Método para LISTAR (Excluyendo a los voluntarios, idrol = 2)
    public static List<Usuario> listarUsuariosNoVoluntarios() {
        List<Usuario> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        
        String sql = "SELECT u.idusuario, p.idpersona, u.idrol, p.nombres, p.apellidos, p.tipodoc, p.nrodoc, p.telefono, p.correo, " +
                     "u.nombreusuario, u.estado, r.rol " +
                     "FROM usuarios u " +
                     "INNER JOIN personas p ON u.idpersona = p.idpersona " +
                     "INNER JOIN roles r ON u.idrol = r.idrol " +
                     "WHERE u.idrol != 2 " +
                     "ORDER BY u.fecharegistro DESC";
                     
        ResultSet rs = dao.ejecutarSelect(sql);
        try {
            while (rs != null && rs.next()) {
                Usuario u = new Usuario();
                u.setIdusuario(rs.getInt("idusuario"));
                u.setIdpersona(rs.getInt("idpersona"));
                u.setIdrol(rs.getInt("idrol"));
                u.setNombresPersona(rs.getString("nombres"));
                u.setApellidosPersona(rs.getString("apellidos"));
                u.setTipodoc(rs.getString("tipodoc"));
                u.setNrodoc(rs.getString("nrodoc"));
                u.setTelefono(rs.getString("telefono"));
                u.setCorreo(rs.getString("correo"));
                u.setNombreusuario(rs.getString("nombreusuario"));
                u.setEstado(rs.getString("estado"));
                u.setNombreRol(rs.getString("rol"));
                lista.add(u);
            }
        } catch (Exception e) {
            System.err.println("Error listar usuarios: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }

    // Método para EDITAR (Persona y Usuario)
    public static boolean actualizarDatosCompletos(int idPersona, int idUsuario, int idRol, String nom, String ape, String tel, String corr, String user, String passHash) {
        GestorDAO dao = new GestorDAO();
        
        String sqlPersona = "UPDATE personas SET nombres=?, apellidos=?, telefono=?, correo=? WHERE idpersona=?";
        boolean pExito = dao.ejecutarModificacion(sqlPersona, nom, ape, tel, corr, idPersona);
        
        boolean uExito;
        if (passHash != null && !passHash.isEmpty()) {
            String sqlUserWithPass = "UPDATE usuarios SET idrol=?, nombreusuario=?, contraseña=? WHERE idusuario=?";
            uExito = dao.ejecutarModificacion(sqlUserWithPass, idRol, user, passHash, idUsuario);
        } else {
            String sqlUserOnly = "UPDATE usuarios SET idrol=?, nombreusuario=? WHERE idusuario=?";
            uExito = dao.ejecutarModificacion(sqlUserOnly, idRol, user, idUsuario);
        }
        
        dao.cerrarConexion();
        return pExito && uExito;
    }

    // Método para DAR DE BAJA
    public static boolean darDeBaja(int idUsuario) {
        GestorDAO dao = new GestorDAO();
        String sqlUsuario = "UPDATE usuarios SET estado = 'I', fechabaja = NOW() WHERE idusuario = ?";
        boolean exito = dao.ejecutarModificacion(sqlUsuario, idUsuario);
        dao.cerrarConexion();
        return exito;
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
    public String getTipodoc() { return tipodoc; }
    public void setTipodoc(String tipodoc) { this.tipodoc = tipodoc; }
    public String getNrodoc() { return nrodoc; }
    public void setNrodoc(String nrodoc) { this.nrodoc = nrodoc; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
}