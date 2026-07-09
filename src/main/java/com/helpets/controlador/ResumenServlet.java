package com.helpets.controlador;

import com.helpets.modelo.ResumenDashboard;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ResumenServlet", urlPatterns = {"/ResumenServlet"})
public class ResumenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        // Seguridad: Solo permitimos el acceso a personal (Roles 1, 2 y 3).
        // El usuario común (Rol 4) no debería ver este panel administrativo.
        if (usuarioActivo == null || usuarioActivo.getIdrol() == 4) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Instanciar el modelo y realizar las consultas a la base de datos
            ResumenDashboard dashboard = new ResumenDashboard();
            dashboard.cargarEstadisticas();

            // Enviar el objeto resultante a la vista (resumen.jsp)
            request.setAttribute("resumen", dashboard);

        } catch (Exception e) {
            System.err.println("Error en ResumenServlet: " + e.getMessage());
        }

        // Redirigir al contenedor principal indicando que cargue la vista de resumen
        request.getRequestDispatcher("/admin/dashboard.jsp?view=resumen").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // En este módulo solo mostramos información, por lo que si llega un POST lo mandamos al GET
        doGet(request, response);
    }
}