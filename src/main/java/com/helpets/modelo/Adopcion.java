package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.Date;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Adopcion {
    private int idadopcion;
    private int idmascota;
    private int idpersona;
    private int idusuario;
    private Date fechaadopcion;
    private String estado_solicitud;
    private String comentarios;

    // Variables extras para mostrar en la tabla (JOIN)
    private String nombreMascota;
    private String nombreAdoptante;
    private String telefonoAdoptante;

    public Adopcion() {}

    public boolean registrarAdopcion() {
        GestorDAO dao = new GestorDAO();
        String sql = "INSERT INTO adopciones (idmascota, idpersona, idusuario, fechaadopcion, estado_solicitud, comentarios) VALUES (?, ?, ?, ?, ?, ?)";
        boolean exito = dao.ejecutarModificacion(sql, this.idmascota, this.idpersona, this.idusuario, this.fechaadopcion, this.estado_solicitud, this.comentarios);
        
        // Si el estado es 'Aprobado' (A), actualizamos la mascota a NO disponible (0)
        if (exito && "A".equals(this.estado_solicitud)) {
            String sqlUpdate = "UPDATE mascotas SET disponibilidad = '0' WHERE idmascota = ?";
            dao.ejecutarModificacion(sqlUpdate, this.idmascota);
        }
        
        dao.cerrarConexion();
        return exito;
    }

    public static List<Adopcion> listarAdopciones() {
        List<Adopcion> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        // Agregué 'a.comentarios' en la primera línea del SELECT
        String sql = "SELECT a.idadopcion, a.fechaadopcion, a.estado_solicitud, a.comentarios, " +
                     "m.nombre AS nombreMascota, CONCAT(p.nombres, ' ', p.apellidos) AS nombreAdoptante, p.telefono " +
                     "FROM adopciones a " +
                     "INNER JOIN mascotas m ON a.idmascota = m.idmascota " +
                     "INNER JOIN personas p ON a.idpersona = p.idpersona " +
                     "ORDER BY a.fechaadopcion DESC";
        ResultSet rs = dao.ejecutarSelect(sql);
        try {
            while (rs != null && rs.next()) {
                Adopcion a = new Adopcion();
                a.setIdadopcion(rs.getInt("idadopcion"));
                a.setFechaadopcion(rs.getDate("fechaadopcion"));
                a.setEstado_solicitud(rs.getString("estado_solicitud"));
                
                // ¡Esta es la línea clave que faltaba! Atrapa el comentario de la BD.
                String coment = rs.getString("comentarios");
                a.setComentarios(coment != null ? coment : ""); // Si es nulo, lo deja vacío para no imprimir "null"
                
                a.setNombreMascota(rs.getString("nombreMascota"));
                a.setNombreAdoptante(rs.getString("nombreAdoptante"));
                a.setTelefonoAdoptante(rs.getString("telefono"));
                lista.add(a);
            }
        } catch (Exception e) {
            System.err.println("Error listar adopciones: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }

    // Método para cambiar de estado y actualizar comentarios
    public boolean actualizarEstado() {
        GestorDAO dao = new GestorDAO();
        String sql = "UPDATE adopciones SET estado_solicitud = ?, comentarios = ? WHERE idadopcion = ?";
        boolean exito = dao.ejecutarModificacion(sql, this.estado_solicitud, this.comentarios, this.idadopcion);
        
        // Si el estado es 'Aprobado', actualizamos la mascota a NO disponible (0)
        if (exito && "A".equals(this.estado_solicitud)) {
            String sqlMascota = "UPDATE mascotas SET disponibilidad = '0' WHERE idmascota = (SELECT idmascota FROM adopciones WHERE idadopcion = ?)";
            dao.ejecutarModificacion(sqlMascota, this.idadopcion);
        }
        
        dao.cerrarConexion();
        return exito;
    }
    
    // Getters y Setters
    public int getIdadopcion() { return idadopcion; }
    public void setIdadopcion(int idadopcion) { this.idadopcion = idadopcion; }
    public int getIdmascota() { return idmascota; }
    public void setIdmascota(int idmascota) { this.idmascota = idmascota; }
    public int getIdpersona() { return idpersona; }
    public void setIdpersona(int idpersona) { this.idpersona = idpersona; }
    public int getIdusuario() { return idusuario; }
    public void setIdusuario(int idusuario) { this.idusuario = idusuario; }
    public Date getFechaadopcion() { return fechaadopcion; }
    public void setFechaadopcion(Date fechaadopcion) { this.fechaadopcion = fechaadopcion; }
    public String getEstado_solicitud() { return estado_solicitud; }
    public void setEstado_solicitud(String estado_solicitud) { this.estado_solicitud = estado_solicitud; }
    public String getComentarios() { return comentarios; }
    public void setComentarios(String comentarios) { this.comentarios = comentarios; }
    public String getNombreMascota() { return nombreMascota; }
    public void setNombreMascota(String nombreMascota) { this.nombreMascota = nombreMascota; }
    public String getNombreAdoptante() { return nombreAdoptante; }
    public void setNombreAdoptante(String nombreAdoptante) { this.nombreAdoptante = nombreAdoptante; }
    public String getTelefonoAdoptante() { return telefonoAdoptante; }
    public void setTelefonoAdoptante(String telefonoAdoptante) { this.telefonoAdoptante = telefonoAdoptante; }
}