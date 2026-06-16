package com.helpets.modelo;

import com.helpets.config.ConexionBD;
import com.helpets.dao.GestorDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class Donacion {
    // Campos de la tabla donaciones
    private int iddonacion;
    private int idusuario;
    private int idpersona;
    private Date fechadonacion;
    private String tipodonacion;
    private double monto;
    
    // Campos para la tabla detalle_donacion (Asumimos 1 producto por donación en este formulario)
    private int idproducto;
    private int cantidad;
    
    // Campos extra para mostrar en la tabla de la vista (JOINs)
    private String nombreDonante;
    private String telefonoDonante;
    private String nombreProducto;

    public Donacion() {}

    // 1. Método Maestro-Detalle para registrar la donación material
    public boolean registrarDonacionMaterial() {
        Connection con = ConexionBD.getConexion();
        boolean exito = false;
        
        try {
            // Iniciamos la transacción manual (evita que se guarde a medias si hay error)
            con.setAutoCommit(false);
            
            // PASO 1: Insertar la Donación (Cabecera)
            String sqlDonacion = "INSERT INTO donaciones (idusuario, idpersona, fechadonacion, tipodonacion) VALUES (?, ?, ?, ?)";
            PreparedStatement psDonacion = con.prepareStatement(sqlDonacion, Statement.RETURN_GENERATED_KEYS);
            psDonacion.setInt(1, this.idusuario);
            psDonacion.setInt(2, this.idpersona);
            psDonacion.setDate(3, this.fechadonacion);
            psDonacion.setString(4, "MATERIAL");
            psDonacion.executeUpdate();
            
            // Rescatamos el ID de la donación recién creada
            ResultSet rs = psDonacion.getGeneratedKeys();
            int idDonacionGenerado = 0;
            if (rs.next()) {
                idDonacionGenerado = rs.getInt(1);
            }
            
            if (idDonacionGenerado > 0) {
                // PASO 2: Insertar el Detalle de la donación
                String sqlDetalle = "INSERT INTO detalle_donacion (iddonacion, idproducto, cantidad) VALUES (?, ?, ?)";
                PreparedStatement psDetalle = con.prepareStatement(sqlDetalle);
                psDetalle.setInt(1, idDonacionGenerado);
                psDetalle.setInt(2, this.idproducto);
                psDetalle.setInt(3, this.cantidad);
                psDetalle.executeUpdate();
                
                // PASO 3: Actualizar el Stock del Producto sumando la cantidad donada
                String sqlStock = "UPDATE productos SET stock = stock + ? WHERE idproducto = ?";
                PreparedStatement psStock = con.prepareStatement(sqlStock);
                psStock.setInt(1, this.cantidad);
                psStock.setInt(2, this.idproducto);
                psStock.executeUpdate();
                
                // Si los 3 pasos salen bien, confirmamos la transacción
                con.commit();
                exito = true;
            } else {
                // Si falló obtener el ID, deshacemos todo
                con.rollback(); 
            }
            
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            System.err.println("Error en transacción Donación Maestro-Detalle: " + e.getMessage());
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return exito;
    }

    // 2. Método para listar el historial de donaciones en la tabla del Dashboard
    public static List<Donacion> listarDonaciones() {
        List<Donacion> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        
        // INNER JOIN para juntar las 4 tablas (donaciones, personas, detalle_donacion, productos)
        String sql = "SELECT d.iddonacion, CONCAT(p.nombres, ' ', p.apellidos) AS donante, p.telefono, " +
                    "d.fechadonacion, d.tipodonacion, prod.nombre_producto, dd.cantidad, dd.monto " +
                    "FROM donaciones d " +
                    "INNER JOIN personas p ON d.idpersona = p.idpersona " +
                    "INNER JOIN detalle_donacion dd ON d.iddonacion = dd.iddonacion " +
                    "INNER JOIN productos prod ON dd.idproducto = prod.idproducto " +
                    "ORDER BY d.fechadonacion DESC";
                     
        ResultSet rs = dao.ejecutarSelect(sql);
        
        try {
            while (rs != null && rs.next()) {
                Donacion d = new Donacion();
                d.setIddonacion(rs.getInt("iddonacion"));
                d.setNombreDonante(rs.getString("donante"));
                d.setTelefonoDonante(rs.getString("telefono"));
                d.setFechadonacion(rs.getDate("fechadonacion"));
                d.setTipodonacion(rs.getString("tipodonacion"));
                d.setNombreProducto(rs.getString("nombre_producto"));
                d.setCantidad(rs.getInt("cantidad"));
                d.setMonto(rs.getDouble("Monto"));
                lista.add(d);
            }
        } catch (Exception e) {
            System.err.println("Error listar donaciones: " + e.getMessage());
        } finally { 
            dao.cerrarConexion(); 
        }
        return lista;
    }

    // --- GETTERS Y SETTERS ---
    public int getIddonacion() { return iddonacion; }
    public void setIddonacion(int iddonacion) { this.iddonacion = iddonacion; }
    
    public int getIdusuario() { return idusuario; }
    public void setIdusuario(int idusuario) { this.idusuario = idusuario; }
    
    public int getIdpersona() { return idpersona; }
    public void setIdpersona(int idpersona) { this.idpersona = idpersona; }
    
    public Date getFechadonacion() { return fechadonacion; }
    public void setFechadonacion(Date fechadonacion) { this.fechadonacion = fechadonacion; }
    
    public String getTipodonacion() { return tipodonacion; }
    public void setTipodonacion(String tipodonacion) { this.tipodonacion = tipodonacion; }
    
    public int getIdproducto() { return idproducto; }
    public void setIdproducto(int idproducto) { this.idproducto = idproducto; }
    
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    
    public String getNombreDonante() { return nombreDonante; }
    public void setNombreDonante(String nombreDonante) { this.nombreDonante = nombreDonante; }
    
    public String getTelefonoDonante() { return telefonoDonante; }
    public void setTelefonoDonante(String telefonoDonante) { this.telefonoDonante = telefonoDonante; }
    
    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

    public double getMonto() { return monto; }
    public void setMonto(double monto) { this.monto = monto; }
}