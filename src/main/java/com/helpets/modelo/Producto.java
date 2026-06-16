package com.helpets.modelo;

import com.helpets.config.ConexionBD;
import com.helpets.dao.GestorDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class Producto {
    private int idproducto;
    private String nombreProducto;
    private String descripcion;
    private String categoria;
    private int stock;

    public Producto() {}

    // Método para listar todos los productos directamente desde tu base de datos
    public static List<Producto> listarProductos() {
        List<Producto> lista = new ArrayList<>();
        GestorDAO dao = new GestorDAO();
        
        // Hacemos el SELECT a tu tabla productos, ordenándolos alfabéticamente
        String sql = "SELECT idproducto, nombre_producto, descripcion, categoria, stock FROM productos ORDER BY nombre_producto ASC";
        ResultSet rs = dao.ejecutarSelect(sql);
        
        try {
            while (rs != null && rs.next()) {
                Producto p = new Producto();
                p.setIdproducto(rs.getInt("idproducto"));
                p.setNombreProducto(rs.getString("nombre_producto"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setCategoria(rs.getString("categoria"));
                p.setStock(rs.getInt("stock"));
                
                lista.add(p);
            }
        } catch (Exception ex) {
            System.err.println("Error al listar productos de la BD: " + ex.getMessage());
        } finally {
            dao.cerrarConexion();
        }
        
        return lista;
    }

    public int registrarYObtenerId() {
        Connection con = ConexionBD.getConexion();
        int idGenerado = -1;
        // Insertamos con stock inicial en 0 y descripción vacía
        String sql = "INSERT INTO productos (nombre_producto, categoria, stock, descripcion) VALUES (?, ?, 0, '')";

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.nombreProducto);
            ps.setString(2, this.categoria);

            int filasAfectadas = ps.executeUpdate();
            if (filasAfectadas > 0) {
                try (java.sql.ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        idGenerado = rs.getInt(1); // Recuperamos el ID autogenerado
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error al registrar producto: " + e.getMessage());
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return idGenerado;
    }
    
    // Getters y Setters
    public int getIdproducto() { return idproducto; }
    public void setIdproducto(int idproducto) { this.idproducto = idproducto; }
    
    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }
    
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
}