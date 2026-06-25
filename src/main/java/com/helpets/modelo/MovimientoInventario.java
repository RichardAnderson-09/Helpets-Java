package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class MovimientoInventario {
    private int idmovimiento;
    private int idproducto;
    private int idusuario;
    private String tipooperacion;
    private int cantidad;
    private Timestamp fecharegistro;
    
    // Atributos adicionales para la vista de la tabla (JOIN)
    private String nombreProducto;
    private String nombreUsuario;

    public MovimientoInventario() {}

    // Método para REGISTRAR el movimiento y actualizar el stock en cascada
    public boolean registrarMovimiento() {
        GestorDAO dao = new GestorDAO();
        
        // 1. Guardar el movimiento en el historial (Kardex)
        String sqlInsert = "INSERT INTO movimientos_inventario (idproducto, idusuario, tipooperacion, cantidad) VALUES (?, ?, ?, ?)";
        boolean exitoMov = dao.ejecutarModificacion(sqlInsert, this.idproducto, this.idusuario, this.tipooperacion, this.cantidad);
        
        // 2. Si se guardó correctamente, impactamos el stock de la tabla productos
        if (exitoMov) {
            String sqlUpdateStock = "";
            if (this.tipooperacion.equals("E")) {
                sqlUpdateStock = "UPDATE productos SET stock = stock + ? WHERE idproducto = ?";
            } else {
                sqlUpdateStock = "UPDATE productos SET stock = stock - ? WHERE idproducto = ?";
            }
            dao.ejecutarModificacion(sqlUpdateStock, this.cantidad, this.idproducto);
        }
        
        dao.cerrarConexion();
        return exitoMov;
    }

    // Método para LISTAR todos los movimientos con datos extra (para el modal)
    public static List<MovimientoInventario> listarMovimientos() {
        List<MovimientoInventario> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        
        String sql = "SELECT mi.*, p.nombre_producto, u.nombreusuario " +
                     "FROM movimientos_inventario mi " +
                     "INNER JOIN productos p ON mi.idproducto = p.idproducto " +
                     "INNER JOIN usuarios u ON mi.idusuario = u.idusuario " +
                     "ORDER BY mi.fecharegistro DESC";
                     
        ResultSet rs = dao.ejecutarSelect(sql);
        
        try {
            while (rs != null && rs.next()) {
                MovimientoInventario mov = new MovimientoInventario();
                mov.setIdmovimiento(rs.getInt("idmovimiento"));
                mov.setIdproducto(rs.getInt("idproducto"));
                mov.setIdusuario(rs.getInt("idusuario"));
                mov.setTipooperacion(rs.getString("tipooperacion"));
                mov.setCantidad(rs.getInt("cantidad"));
                mov.setFecharegistro(rs.getTimestamp("fecharegistro"));
                
                mov.setNombreProducto(rs.getString("nombre_producto"));
                mov.setNombreUsuario(rs.getString("nombreusuario"));
                
                lista.add(mov);
            }
        } catch (Exception e) {
            System.err.println("Error al listar movimientos de inventario: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }

    // --- GETTERS Y SETTERS ---
    public int getIdmovimiento() { return idmovimiento; }
    public void setIdmovimiento(int idmovimiento) { this.idmovimiento = idmovimiento; }
    
    public int getIdproducto() { return idproducto; }
    public void setIdproducto(int idproducto) { this.idproducto = idproducto; }
    
    public int getIdusuario() { return idusuario; }
    public void setIdusuario(int idusuario) { this.idusuario = idusuario; }
    
    public String getTipooperacion() { return tipooperacion; }
    public void setTipooperacion(String tipooperacion) { this.tipooperacion = tipooperacion; }
    
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    
    public Timestamp getFecharegistro() { return fecharegistro; }
    public void setFecharegistro(Timestamp fecharegistro) { this.fecharegistro = fecharegistro; }
    
    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }
    
    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }
}