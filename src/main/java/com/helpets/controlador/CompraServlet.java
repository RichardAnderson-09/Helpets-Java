package com.helpets.controlador;

import com.helpets.modelo.Compra;
import com.helpets.modelo.Producto;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CompraServlet", urlPatterns = {"/CompraServlet"})
public class CompraServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        request.setAttribute("listaCompras", Compra.listarCompras());
        // Reutilizamos el modelo Producto que ya creamos antes
        request.setAttribute("listaProductos", Producto.listarProductos()); 
        
        request.getRequestDispatcher("/admin/dashboard.jsp?view=compras").forward(request, response);
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

            // ACCIÓN AJAX PARA CREAR PRODUCTOS DESDE EL MODAL EN COMPRAS
            if ("registrarProducto".equals(accion)) {
                String nombre = request.getParameter("nombre_producto");
                String categoria = request.getParameter("categoria");

                Producto prod = new Producto();
                prod.setNombreProducto(nombre);
                prod.setCategoria(categoria);

                int idNuevo = prod.registrarYObtenerId();

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                if (idNuevo != -1) {
                    // Respondemos éxito con los datos del nuevo producto (Stock inicial 0)
                    String json = String.format("{\"exito\":true, \"idproducto\":%d, \"nombre\":\"%s\", \"categoria\":\"%s\", \"stock\":0}", 
                            idNuevo, nombre, categoria);
                    response.getWriter().write(json);
                } else {
                    response.getWriter().write("{\"exito\":false}");
                }
                return; // Cortamos la ejecución para no redirigir
            }

            // LÓGICA NORMAL DE REGISTRO DE COMPRAS
            if ("registrar".equals(accion)) {
                Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioActivo");

                Compra c = new Compra();
                c.setIdusuario(usuarioLogueado.getIdusuario());
                c.setFechacompra(java.sql.Date.valueOf(request.getParameter("fechacompra")));
                c.setNota(request.getParameter("nota"));

                c.setIdproducto(Integer.parseInt(request.getParameter("idproducto")));
                c.setCantidad(Integer.parseInt(request.getParameter("cantidad")));
                c.setPrecioUnitario(Double.parseDouble(request.getParameter("precio_unitario")));

                c.registrarCompra();
            }
        } catch (Exception e) {
            System.err.println("Error al procesar compra: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/CompraServlet");
    }
      
}