package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Mascota {
    private int idmascota;
    private int idraza;
    private String nombre;
    private Date fecharescate;
    private String disponibilidad;
    private String foto;
    private String vive;
    private String sexo;
    
    // Atributos adicionales para la vista de la tabla
    private String nombreRaza;
    private String nombreEspecie;

    public Mascota() {}

    // Método para REGISTRAR (INSERT)
    public boolean registrarMascota() {
        GestorDAO dao = new GestorDAO();
        String sql = "INSERT INTO mascotas (idraza, nombre, fecharescate, disponibilidad, foto, vive, sexo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        boolean exito = dao.ejecutarModificacion(sql, this.idraza, this.nombre, this.fecharescate, this.disponibilidad, this.foto, this.vive, this.sexo);
        dao.cerrarConexion();
        return exito;
    }

    // Método para LISTAR (SELECT con JOINs de Especie y Raza)
    public static List<Mascota> listarMascotas() {
        List<Mascota> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT m.*, r.nombre_raza, e.nombre_especie " +
                     "FROM mascotas m " +
                     "INNER JOIN razas r ON m.idraza = r.idraza " +
                     "INNER JOIN especies e ON r.idespecie = e.idespecie "+
                     "ORDER BY m.idmascota asc"; 
        ResultSet rs = dao.ejecutarSelect(sql);
        
        try {
            while (rs != null && rs.next()) {
                Mascota m = new Mascota();
                m.setIdmascota(rs.getInt("idmascota"));
                m.setIdraza(rs.getInt("idraza"));
                m.setNombre(rs.getString("nombre"));
                m.setFecharescate(rs.getDate("fecharescate"));
                m.setDisponibilidad(rs.getString("disponibilidad"));
                m.setFoto(rs.getString("foto"));
                m.setVive(rs.getString("vive"));
                m.setSexo(rs.getString("sexo"));
                m.setNombreRaza(rs.getString("nombre_raza"));
                m.setNombreEspecie(rs.getString("nombre_especie"));
                lista.add(m);
            }
        } catch (Exception e) {
            System.err.println("Error al listar mascotas: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }
    
    // Método para BUSCAR una sola mascota por su ID (para cargar el formulario de edición)
    public static Mascota buscarPorId(int id) {
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT m.*, e.nombre_especie, r.nombre_raza " +
                     "FROM mascotas m " +
                     "INNER JOIN razas r ON m.idraza = r.idraza " +
                     "INNER JOIN especies e ON r.idespecie = e.idespecie " +
                     "WHERE m.idmascota = ?";  
        
        java.sql.ResultSet rs = dao.ejecutarSelect(sql, id);
        try {
            if (rs != null && rs.next()) {
                Mascota m = new Mascota();
                m.setIdmascota(rs.getInt("idmascota"));
                m.setIdraza(rs.getInt("idraza"));
                m.setNombre(rs.getString("nombre"));
                m.setNombreEspecie(rs.getString("nombre_especie"));
                m.setNombreRaza(rs.getString("nombre_raza"));
                m.setFecharescate(rs.getDate("fecharescate"));
                m.setDisponibilidad(rs.getString("disponibilidad"));
                m.setFoto(rs.getString("foto"));
                m.setVive(rs.getString("vive"));
                m.setSexo(rs.getString("sexo"));
                return m;
            }
        } catch (Exception e) {
            System.err.println("Error al buscar mascota por ID: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return null;
    }

    // Método para ACTUALIZAR (UPDATE)
    public boolean actualizarMascota() {
        GestorDAO dao = new GestorDAO();
        String sql = "UPDATE mascotas SET idraza=?, nombre=?, fecharescate=?, disponibilidad=?, foto=?, sexo=? WHERE idmascota=?";
        boolean exito = dao.ejecutarModificacion(sql, this.idraza, this.nombre, this.fecharescate, this.disponibilidad, this.foto, this.sexo, this.idmascota);
        dao.cerrarConexion();
        return exito;
    }

    // Método para ELIMINAR (DELETE)
    public static boolean eliminarMascota(int id) {
        GestorDAO dao = new GestorDAO();
        String sql = "DELETE FROM mascotas WHERE idmascota = ?";
        boolean exito = dao.ejecutarModificacion(sql, id);
        dao.cerrarConexion();
        return exito;
    }
    
    // Método exclusivo para el selector de Adopciones (Solo mascotas disponibles)
    public static List<Mascota> listarMascotasDisponibles() {
        List<Mascota> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT m.idmascota, m.nombre, e.nombre_especie " +
                     "FROM mascotas m " +
                     "INNER JOIN razas r ON m.idraza = r.idraza " +
                     "INNER JOIN especies e ON r.idespecie = e.idespecie " +
                     "WHERE m.disponibilidad = '1' ORDER BY m.nombre ASC"; 
        ResultSet rs = dao.ejecutarSelect(sql);
        try {
            while (rs != null && rs.next()) {
                Mascota m = new Mascota();
                m.setIdmascota(rs.getInt("idmascota"));
                m.setNombre(rs.getString("nombre"));
                m.setNombreEspecie(rs.getString("nombre_especie"));
                lista.add(m);
            }
        } catch (Exception e) {
            System.err.println("Error en mascotas disponibles: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }
    
    // Método para el AJAX de adopciones (filtrar por especie)
    public static List<Mascota> listarMascotasDisponiblesPorEspecie(int idEspecie) {
        List<Mascota> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        String sql = "SELECT m.idmascota, m.nombre, e.nombre_especie " +
                     "FROM mascotas m " +
                     "INNER JOIN razas r ON m.idraza = r.idraza " +
                     "INNER JOIN especies e ON r.idespecie = e.idespecie " +
                     "WHERE m.disponibilidad = '1' AND e.idespecie = ? " +
                     "ORDER BY m.nombre ASC"; 
        java.sql.ResultSet rs = dao.ejecutarSelect(sql, idEspecie);
        try {
            while (rs != null && rs.next()) {
                Mascota m = new Mascota();
                m.setIdmascota(rs.getInt("idmascota"));
                m.setNombre(rs.getString("nombre"));
                m.setNombreEspecie(rs.getString("nombre_especie"));
                lista.add(m);
            }
        } catch (Exception e) {
            System.err.println("Error mascotas por especie: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }

    // Método para Dar de Baja (Fallecimiento)
    public static boolean darDeBaja(int idmascota) {
        GestorDAO dao = new GestorDAO();
        // Cambia vive a 'N' y lo saca de la disponibilidad de adopción
        String sql = "UPDATE mascotas SET vive = 'N', disponibilidad = '0' WHERE idmascota = ?";
        boolean exito = dao.ejecutarModificacion(sql, idmascota);
        dao.cerrarConexion();
        return exito;
    }    
    
    // Método para el Catálogo del Usuario Común
    public static List<Mascota> listarCatalogoDisponibles() {
        List<Mascota> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        // Solo traemos mascotas disponibles (1) y vivas (S)
        String sql = "SELECT m.*, r.nombre_raza, e.nombre_especie " +
                     "FROM mascotas m " +
                     "INNER JOIN razas r ON m.idraza = r.idraza " +
                     "INNER JOIN especies e ON r.idespecie = e.idespecie " +
                     "WHERE m.disponibilidad = '1' AND m.vive = 'S' " +
                     "ORDER BY m.fecharescate DESC"; 
                     
        java.sql.ResultSet rs = dao.ejecutarSelect(sql);
        try {
            while (rs != null && rs.next()) {
                Mascota m = new Mascota();
                m.setIdmascota(rs.getInt("idmascota"));
                m.setNombre(rs.getString("nombre"));
                m.setFoto(rs.getString("foto"));
                m.setSexo(rs.getString("sexo"));
                m.setNombreRaza(rs.getString("nombre_raza"));
                m.setNombreEspecie(rs.getString("nombre_especie"));
                m.setFecharescate(rs.getDate("fecharescate"));
                lista.add(m);
            }
        } catch (Exception e) {
            System.err.println("Error en catálogo mascotas: " + e.getMessage());
        } finally { dao.cerrarConexion(); }
        return lista;
    }
    
    // --- GETTERS Y SETTERS ---
    public int getIdmascota() { return idmascota; }
    public void setIdmascota(int idmascota) { this.idmascota = idmascota; }
    public int getIdraza() { return idraza; }
    public void setIdraza(int idraza) { this.idraza = idraza; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public Date getFecharescate() { return fecharescate; }
    public void setFecharescate(Date fecharescate) { this.fecharescate = fecharescate; }
    public String getDisponibilidad() { return disponibilidad; }
    public void setDisponibilidad(String disponibilidad) { this.disponibilidad = disponibilidad; }
    public String getFoto() { return foto; }
    public void setFoto(String foto) { this.foto = foto; }
    public String getVive() { return vive; }
    public void setVive(String vive) { this.vive = vive; }
    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }
    public String getNombreRaza() { return nombreRaza; }
    public void setNombreRaza(String nombreRaza) { this.nombreRaza = nombreRaza; }
    public String getNombreEspecie() { return nombreEspecie; }
    public void setNombreEspecie(String nombreEspecie) { this.nombreEspecie = nombreEspecie; }
}