package com.helpets.controlador;

import com.helpets.modelo.Donacion;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AporteMonetarioServlet", urlPatterns = {"/AporteMonetarioServlet"})
public class AporteMonetarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        // Seguridad: Solo permitimos al Administrador (1) y Usuario Común (4)
        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 4)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/admin/dashboard.jsp?view=aporte").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");
            String accion = request.getParameter("accion");
            
            if ("donar".equals(accion)) {
                double monto = Double.parseDouble(request.getParameter("monto"));
                
                Donacion d = new Donacion();
                // El usuario logueado es el mismo que registra y el que dona
                d.setIdusuario(usuarioActivo.getIdusuario());
                d.setIdpersona(usuarioActivo.getIdpersona());
                d.setMonto(monto);
                
                boolean exito = d.registrarDonacionMonetaria();
                
                if (exito) {
                    session.setAttribute("mensaje", "¡Muchas gracias por tu generosidad! Tu aporte de S/ " + monto + " ha sido registrado con éxito.");
                } else {
                    session.setAttribute("error", "Hubo un problema procesando tu aporte. Inténtalo nuevamente.");
                }
            }
        } catch (Exception e) {
            System.err.println("Error procesando aporte web: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/AporteMonetarioServlet");
    }
}