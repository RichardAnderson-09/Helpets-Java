package com.helpets.controlador;

import com.helpets.modelo.HistorialMedico;
import com.helpets.modelo.Mascota;
import com.helpets.modelo.ProcesoMedico;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VeterinariaServlet", urlPatterns = {"/VeterinariaServlet"})
public class VeterinariaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 3)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
        String accion = request.getParameter("accion");

        // AJAX para autocompletar la descripción del proceso
        if ("obtenerDescripcion".equals(accion)) {
            int idprocesomedico = Integer.parseInt(request.getParameter("idprocesomedico"));
            String descripcion = ProcesoMedico.obtenerDescripcion(idprocesomedico);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(descripcion);
            return;
        }
        
        // Dar de baja mascota
        if ("darDeBaja".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("idmascota"));
            Mascota.darDeBaja(id);
            response.sendRedirect(request.getContextPath() + "/VeterinariaServlet");
            return;
        }

        // Cargar vista principal y detalle si se seleccionó una mascota
        String idMascotaStr = request.getParameter("idmascota");
        if (idMascotaStr != null && !idMascotaStr.isEmpty()) {
            int idMascota = Integer.parseInt(idMascotaStr);
            request.setAttribute("mascotaSeleccionada", Mascota.buscarPorId(idMascota));
            request.setAttribute("listaHistorial", HistorialMedico.listarPorMascota(idMascota));
        }

        request.setAttribute("listaMascotas", Mascota.listarMascotas());
        request.setAttribute("listaProcesos", ProcesoMedico.listarProcesos());

        request.getRequestDispatcher("/admin/dashboard.jsp?view=veterinaria").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 3)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if ("registrarHistorial".equals(accion)) {
            HistorialMedico h = new HistorialMedico();
            int idMascota = Integer.parseInt(request.getParameter("idmascota"));
            
            h.setIdmascota(idMascota);
            h.setIdproceso(Integer.parseInt(request.getParameter("idproceso")));
            h.setDescripcion(request.getParameter("descripcion"));
            h.setPeso(Double.parseDouble(request.getParameter("peso")));
            
            // Tratamiento para el input datetime-local de HTML5
            String fechaHTML = request.getParameter("fechaatencion");
            if (fechaHTML != null && !fechaHTML.isEmpty()) {
                // Se reemplaza la 'T' de HTML5 por un espacio y se añaden los segundos
                h.setFechaatencion(java.sql.Timestamp.valueOf(fechaHTML.replace("T", " ") + ":00"));
            }
            
            h.registrarHistorial();
            
            response.sendRedirect(request.getContextPath() + "/VeterinariaServlet?idmascota=" + idMascota);
        }
    }
}