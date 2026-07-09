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

public class Compra {
    // Campos de la tabla compras
    private int idcompra;
    private int idusuario;
    private Date fechacompra;
    private String nota;
    
    // Campos de detalle_compra
    private int idproducto;
    private int cantidad;
    private double precioUnitario;
    
    // Campos extra para la vista (Dashboard)
    private String nombreUsuario; // Quien registró la compra
    private String nombreProducto;
    private double total; // cantidad * precioUnitario

    public Compra() {}

    // Método Maestro-Detalle con actualización de Inventario
    public boolean registrarCompra() {
        Connection con = ConexionBD.getConexion();
        boolean exito = false;
        
        try {
            con.setAutoCommit(false); // Iniciamos transacción
            
            // Insertar Cabecera de Compra
            String sqlCompra = "INSERT INTO compras (idusuario, fechacompra, nota) VALUES (?, ?, ?)";
            PreparedStatement psCompra = con.prepareStatement(sqlCompra, Statement.RETURN_GENERATED_KEYS);
            psCompra.setInt(1, this.idusuario);
            psCompra.setDate(2, this.fechacompra);
            psCompra.setString(3, this.nota);
            psCompra.executeUpdate();
            
            ResultSet rs = psCompra.getGeneratedKeys();
            int idCompraGenerado = 0;
            if (rs.next()) {
                idCompraGenerado = rs.getInt(1);
            }
            
            if (idCompraGenerado > 0) {
                // Insertar Detalle de Compra
                String sqlDetalle = "INSERT INTO detalle_compra (idcompra, idproducto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
                PreparedStatement psDetalle = con.prepareStatement(sqlDetalle);
                psDetalle.setInt(1, idCompraGenerado);
                psDetalle.setInt(2, this.idproducto);
                psDetalle.setInt(3, this.cantidad);
                psDetalle.setDouble(4, this.precioUnitario);
                psDetalle.executeUpdate();
                
                // Registrar el Movimiento en el Kardex/Inventario (E = Entrada)
                String sqlMovimiento = "INSERT INTO movimientos_inventario (idproducto, idusuario, tipooperacion, cantidad) VALUES (?, ?, 'E', ?)";
                PreparedStatement psMov = con.prepareStatement(sqlMovimiento);
                psMov.setInt(1, this.idproducto);
                psMov.setInt(2, this.idusuario);
                psMov.setInt(3, this.cantidad);
                psMov.executeUpdate();
                
                // Actualizar Stock Real en la tabla Productos
                String sqlStock = "UPDATE productos SET stock = stock + ? WHERE idproducto = ?";
                PreparedStatement psStock = con.prepareStatement(sqlStock);
                psStock.setInt(1, this.cantidad);
                psStock.setInt(2, this.idproducto);
                psStock.executeUpdate();
                
                con.commit(); // Confirmamos los 4 pasos
                exito = true;
            } else {
                con.rollback();
            }
            
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            System.err.println("Error en registro de compra: " + e.getMessage());
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return exito;
    }

    // Listar compras para la tabla HTML
    public static List<Compra> listarCompras() {
        List<Compra> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        
        String sql = "SELECT c.idcompra, u.nombreusuario, c.fechacompra, c.nota, " +
                     "p.nombre_producto, dc.cantidad, dc.precio_unitario " +
                     "FROM compras c " +
                     "INNER JOIN usuarios u ON c.idusuario = u.idusuario " +
                     "INNER JOIN detalle_compra dc ON c.idcompra = dc.idcompra " +
                     "INNER JOIN productos p ON dc.idproducto = p.idproducto " +
                     "ORDER BY c.fechacompra DESC";
                     
        ResultSet rs = dao.ejecutarSelect(sql);
        
        try {
            while (rs != null && rs.next()) {
                Compra c = new Compra();
                c.setIdcompra(rs.getInt("idcompra"));
                c.setNombreUsuario(rs.getString("nombreusuario"));
                c.setFechacompra(rs.getDate("fechacompra"));
                c.setNota(rs.getString("nota"));
                c.setNombreProducto(rs.getString("nombre_producto"));
                c.setCantidad(rs.getInt("cantidad"));
                c.setPrecioUnitario(rs.getDouble("precio_unitario"));
                c.setTotal(c.getCantidad() * c.getPrecioUnitario()); // Calculamos el total
                lista.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error al listar compras: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        return lista;
    }

    // --- GETTERS Y SETTERS ---
    public int getIdcompra() { return idcompra; }
    public void setIdcompra(int idcompra) { this.idcompra = idcompra; }
    public int getIdusuario() { return idusuario; }
    public void setIdusuario(int idusuario) { this.idusuario = idusuario; }
    public Date getFechacompra() { return fechacompra; }
    public void setFechacompra(Date fechacompra) { this.fechacompra = fechacompra; }
    public String getNota() { return nota; }
    public void setNota(String nota) { this.nota = nota; }
    public int getIdproducto() { return idproducto; }
    public void setIdproducto(int idproducto) { this.idproducto = idproducto; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }
    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }
    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
}