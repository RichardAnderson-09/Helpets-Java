package com.helpets.controlador;

import com.helpets.modelo.Donacion;
import com.helpets.modelo.Persona;
import com.helpets.modelo.Producto;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DonacionServlet", urlPatterns = {"/DonacionServlet"})
public class DonacionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // 1. Cargar las listas desde la base de datos para mostrarlas en la vista
        request.setAttribute("listaDonaciones", Donacion.listarDonaciones());
        request.setAttribute("listaProductos", Producto.listarProductos());
        
        // 2. Redirigir al Dashboard apuntando a la vista de donaciones
        request.getRequestDispatcher("/admin/dashboard.jsp?view=donaciones").forward(request, response);
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
                    // Respondemos éxito con los datos del nuevo producto
                    String json = String.format("{\"exito\":true, \"idproducto\":%d, \"nombre\":\"%s\", \"categoria\":\"%s\"}", 
                            idNuevo, nombre, categoria);
                    response.getWriter().write(json);
                } else {
                    response.getWriter().write("{\"exito\":false}");
                }
                return; // Cortamos la ejecución para que no intente redirigir
            }
            
            if ("registrar".equals(accion)) {
                // 1. Armamos el objeto Persona (El Donante)
                Persona p = new Persona();
                p.setTipodoc(request.getParameter("tipodoc"));
                p.setNrodoc(request.getParameter("nrodoc"));
                p.setNombres(request.getParameter("nombres"));
                p.setApellidos(request.getParameter("apellidos"));
                p.setTelefono(request.getParameter("telefono"));
                p.setCorreo(request.getParameter("correo"));
                
                // Nota: Usamos un código de distrito por defecto si no lo pides en el formulario
                p.setIddistrito("010101"); 
                
                // Procesamos al donante y rescatamos su ID (Lo insertará si es nuevo)
                int idPersona = p.registrarYObtenerId();
                
                if (idPersona != -1) {
                    // 2. Recuperamos quién está registrando la donación (El empleado/admin)
                    Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioActivo");
                    
                    // 3. Armamos la Donación y el Detalle
                    Donacion d = new Donacion();
                    d.setIdusuario(usuarioLogueado.getIdusuario()); // Quien registra en el sistema
                    d.setIdpersona(idPersona); // El donante
                    d.setFechadonacion(java.sql.Date.valueOf(request.getParameter("fechadonacion")));
                    
                    // Datos del detalle material (Producto y cantidad)
                    d.setIdproducto(Integer.parseInt(request.getParameter("idproducto")));
                    d.setCantidad(Integer.parseInt(request.getParameter("cantidad")));
                    
                    // 4. Ejecutamos la transacción Maestro-Detalle
                    d.registrarDonacionMaterial();
                }
            }
            
        } catch (Exception e) {
            // En el futuro puedes cambiar esto por tu Logback (logger.error)
            System.err.println("Error al procesar el formulario de donación: " + e.getMessage());
        }
        
        // 5. Redirigir nuevamente usando el patrón PRG (Post-Redirect-Get) para limpiar la URL
        response.sendRedirect(request.getContextPath() + "/DonacionServlet");
    }
}