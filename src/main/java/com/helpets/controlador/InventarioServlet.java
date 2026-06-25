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
        
        // 1. Obtener la lista de productos (para llenar la tabla y el ComboBox de la vista)
        // Llama al método que ya tienes en Producto.java
        List<Producto> productos = Producto.listarProductos();
        request.setAttribute("listaProductos", productos);
        
        // 2. Obtener el historial completo de los movimientos (Kardex)
        List<MovimientoInventario> movimientos = MovimientoInventario.listarMovimientos();
        request.setAttribute("listaMovimientos", movimientos);
        
        // 3. Enviar todo a la vista dividida
        request.getRequestDispatcher("/admin/dashboard.jsp?view=inventario").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Capturar los parámetros enviados por el formulario del JSP
        int idProducto = Integer.parseInt(request.getParameter("idproducto"));
        String tipoOperacion = request.getParameter("tipooperacion");
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        
        // Obtener el ID del usuario de la sesión actual
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        int idUsuario = (usuarioLogueado != null) ? usuarioLogueado.getIdusuario() : 1; 

        // Llenar el modelo con los datos
        MovimientoInventario mov = new MovimientoInventario();
        mov.setIdproducto(idProducto);
        mov.setIdusuario(idUsuario);
        mov.setTipooperacion(tipoOperacion);
        mov.setCantidad(cantidad);

        // Llamar al modelo para que se guarde en base de datos y actualice el stock
        boolean exito = mov.registrarMovimiento();

        // Evaluar resultado y enviar mensaje de retroalimentación
        if (exito) {
            session.setAttribute("mensaje", "Movimiento de inventario procesado correctamente.");
        } else {
            session.setAttribute("error", "Hubo un problema al registrar la operación.");
        }

        // Redireccionar utilizando PRG (Post/Redirect/Get) para evitar re-envíos
        response.sendRedirect(request.getContextPath() + "/CompraServlet");
    }
}