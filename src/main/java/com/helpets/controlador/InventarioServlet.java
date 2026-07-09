package com.helpets.controlador;

import com.helpets.modelo.MovimientoInventario;
import com.helpets.modelo.Producto;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "InventarioServlet", urlPatterns = {"/InventarioServlet"})
public class InventarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Obtener la lista de productos (para llenar la tabla y el ComboBox de la vista)
        // Llama al método que ya existe en Producto.java
        List<Producto> productos = Producto.listarProductos();
        request.setAttribute("listaProductos", productos);
        
        // Obtener el historial completo de los movimientos (Kardex)
        List<MovimientoInventario> movimientos = MovimientoInventario.listarMovimientos();
        request.setAttribute("listaMovimientos", movimientos);
        
        // Enviar todo a la vista dividida
        request.getRequestDispatcher("/admin/dashboard.jsp?view=inventario").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            String accion = request.getParameter("accion");
            
            if ("registrar".equals(accion)) {
                int idProducto = Integer.parseInt(request.getParameter("idproducto"));
                String tipoOperacion = request.getParameter("tipooperacion");
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                
                //HttpSession session = request.getSession();
                Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
                int idUsuario = (usuarioLogueado != null) ? usuarioLogueado.getIdusuario() : 1; 

                MovimientoInventario mov = new MovimientoInventario();
                mov.setIdproducto(idProducto);
                mov.setIdusuario(idUsuario);
                mov.setTipooperacion(tipoOperacion);
                mov.setCantidad(cantidad);

                boolean exito = mov.registrarMovimiento();

                if (exito) {
                    session.setAttribute("mensaje", "Movimiento de inventario procesado correctamente.");
                } else {
                    session.setAttribute("error", "Hubo un problema al registrar la operación.");
                }
            }
        } catch (Exception e) {
            System.err.println("Error al procesar inventario: " + e.getMessage());
        }

        // Redirección al servlet correcto
        response.sendRedirect(request.getContextPath() + "/InventarioServlet");
    }
}