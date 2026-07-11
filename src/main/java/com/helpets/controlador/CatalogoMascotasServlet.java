package com.helpets.controlador;

import com.helpets.modelo.Adopcion;
import com.helpets.modelo.Mascota;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CatalogoMascotasServlet", urlPatterns = {"/CatalogoMascotasServlet"})
public class CatalogoMascotasServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        // Seguridad: Solo Admin (1) o Usuario Común (4)
        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 4)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }

        // Enviamos la lista de mascotas con fotos
        request.setAttribute("listaCatalogo", Mascota.listarCatalogoDisponibles());
        request.getRequestDispatcher("/admin/dashboard.jsp?view=catalogo").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String accion = request.getParameter("accion");
            HttpSession session = request.getSession();
            Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");
            
            if ("solicitarAdopcion".equals(accion)) {
                int idMascota = Integer.parseInt(request.getParameter("idmascota"));
                
                // Generamos la adopción usando los propios datos del usuario logueado
                Adopcion a = new Adopcion();
                a.setIdmascota(idMascota);
                a.setIdpersona(usuarioActivo.getIdpersona()); // El adoptante es él mismo
                a.setIdusuario(usuarioActivo.getIdusuario()); // Él mismo registra la acción
                a.setFechaadopcion(new java.sql.Date(System.currentTimeMillis())); // Fecha actual
                a.setEstado_solicitud("P"); // P = Pendiente (Para que lo evalúe el refugio)
                a.setComentarios("Solicitud generada automáticamente desde el catálogo web del usuario.");
                
                boolean exito = a.registrarAdopcion();
                
                if(exito) {
                    session.setAttribute("mensaje", "¡Solicitud enviada con éxito! Nos comunicaremos contigo muy pronto.");
                } else {
                    session.setAttribute("error", "Hubo un problema al procesar tu solicitud. Intenta de nuevo.");
                }
            }
        } catch (Exception e) {
            System.err.println("Error procesando solicitud de adopción web: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/CatalogoMascotasServlet");
    }
}