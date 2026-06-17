package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Voluntario {
    private int idhistorial; // Corregido: Según tu BD es idhistorial
    private int idpersona;
    private int idusuario;
    private String nombres;
    private String apellidos;
    private String tipodoc;
    private String nrodoc;
    private String telefono;
    private String correo;
    private String nombreusuario;
    private Date fechainicio;
    private Date fechafin;
    private String estadoVoluntario; 

    public Voluntario() {}

    // MÉTODO ESTRELLA: Aquí se crea la cuenta y el historial al mismo tiempo
    public static boolean registrarCuentaYHistorial(int idPersona, String username, String passHash, Date fechaInicio, Date fechaFin) {
        GestorDAO dao = new GestorDAO();
        
        // 1. Insertar en la tabla usuarios (Estado 'A' por defecto según BD)
        String sqlUsuario = "INSERT INTO usuarios (idpersona, idrol, nombreusuario, contraseña, estado) VALUES (?, 3, ?, ?, 'A')";
        boolean uExito = dao.ejecutarModificacion(sqlUsuario, idPersona, username, passHash);
        
        if (uExito) {
            // 2. Insertar en la tabla historialvol vinculando a la misma persona (Estado 'A')
            String sqlHistorial = "INSERT INTO historialvol (idpersona, fechainicio, fechafin, estado) VALUES (?, ?, ?, 'A')";
            boolean hExito = dao.ejecutarModificacion(sqlHistorial, idPersona, fechaInicio, fechaFin);
            dao.cerrarConexion();
            return hExito;
        }
        
        dao.cerrarConexion();
        return false;
    }

    public static List<Voluntario> listarVoluntarios() {
        List<Voluntario> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        // Corregido el campo h.idhistorial
        String sql = "SELECT h.idhistorial, p.idpersona, u.idusuario, p.nombres, p.apellidos, p.tipodoc, p.nrodoc, p.telefono, p.correo, " +
                     "u.nombreusuario, h.fechainicio, h.fechafin, h.estado AS estado_vol " +
                     "FROM historialvol h " +
                     "INNER JOIN personas p ON h.idpersona = p.idpersona " +
                     "INNER JOIN usuarios u ON p.idpersona = u.idpersona " +
                     "ORDER BY h.fechainicio DESC";
        
        ResultSet rs = dao.ejecutarSelect(sql);
        try {
            while (rs != null && rs.next()) {
                Voluntario v = new Voluntario();
                v.setIdhistorial(rs.getInt("idhistorial"));
                v.setIdpersona(rs.getInt("idpersona"));
                v.setIdusuario(rs.getInt("idusuario"));
                v.setNombres(rs.getString("nombres"));
                v.setApellidos(rs.getString("apellidos"));
                v.setTipodoc(rs.getString("tipodoc"));
                v.setNrodoc(rs.getString("nrodoc"));
                v.setTelefono(rs.getString("telefono"));
                v.setCorreo(rs.getString("correo"));
                v.setNombreusuario(rs.getString("nombreusuario"));
                v.setFechainicio(rs.getDate("fechainicio"));
                v.setFechafin(rs.getDate("fechafin"));
                v.setEstadoVoluntario(rs.getString("estado_vol"));
                lista.add(v);
            }
        } catch (Exception e) {
            System.err.println("Error listar voluntarios: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }

    // Método de Baja: Usa 'I' para inactivo y actualiza fechabaja en usuarios
    public static boolean darDeBaja(int idHistorial, int idUsuario) {
        GestorDAO dao = new GestorDAO();
        java.sql.Date fechaHoy = new java.sql.Date(System.currentTimeMillis());
        
        String sqlHistorial = "UPDATE historialvol SET estado = 'I', fechafin = ? WHERE idhistorial = ?";
        boolean hExito = dao.ejecutarModificacion(sqlHistorial, fechaHoy, idHistorial);
        
        if (hExito) {
            String sqlUsuario = "UPDATE usuarios SET estado = 'I', fechabaja = NOW() WHERE idusuario = ?";
            boolean uExito = dao.ejecutarModificacion(sqlUsuario, idUsuario);
            dao.cerrarConexion();
            return uExito;
        }
        dao.cerrarConexion();
        return false;
    }
    
        // Modificar datos personales, cuenta de usuario y contraseña (opcional)
    public static boolean actualizarDatosCompletos(int idPersona, int idUsuario, String nom, String ape, String tel, String corr, String user, String passHash) {
        GestorDAO dao = new GestorDAO();
        
        // 1. Actualizar Persona
        String sqlPersona = "UPDATE personas SET nombres=?, apellidos=?, telefono=?, correo=? WHERE idpersona=?";
        boolean pExito = dao.ejecutarModificacion(sqlPersona, nom, ape, tel, corr, idPersona);
        
        // 2. Actualizar Usuario
        boolean uExito;
        if (passHash != null && !passHash.isEmpty()) {
            String sqlUserWithPass = "UPDATE usuarios SET nombreusuario=?, contraseña=? WHERE idusuario=?";
            uExito = dao.ejecutarModificacion(sqlUserWithPass, user, passHash, idUsuario);
        } else {
            String sqlUserOnly = "UPDATE usuarios SET nombreusuario=? WHERE idusuario=?";
            uExito = dao.ejecutarModificacion(sqlUserOnly, user, idUsuario);
        }
        
        dao.cerrarConexion();
        return pExito && uExito;
    }

    // Getters y Setters
    public int getIdhistorial() { return idhistorial; }
    public void setIdhistorial(int idhistorial) { this.idhistorial = idhistorial; }
    public int getIdpersona() { return idpersona; }
    public void setIdpersona(int idpersona) { this.idpersona = idpersona; }
    public int getIdusuario() { return idusuario; }
    public void setIdusuario(int idusuario) { this.idusuario = idusuario; }
    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }
    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }
    public String getTipodoc() { return tipodoc; }
    public void setTipodoc(String tipodoc) { this.tipodoc = tipodoc; }
    public String getNrodoc() { return nrodoc; }
    public void setNrodoc(String nrodoc) { this.nrodoc = nrodoc; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    public String getNombreusuario() { return nombreusuario; }
    public void setNombreusuario(String nombreusuario) { this.nombreusuario = nombreusuario; }
    public Date getFechainicio() { return fechainicio; }
    public void setFechainicio(Date fechainicio) { this.fechainicio = fechainicio; }
    public Date getFechafin() { return fechafin; }
    public void setFechafin(Date fechafin) { this.fechafin = fechafin; }
    public String getEstadoVoluntario() { return estadoVoluntario; }
    public void setEstadoVoluntario(String estadoVoluntario) { this.estadoVoluntario = estadoVoluntario; }
}