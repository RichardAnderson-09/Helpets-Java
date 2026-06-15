package com.helpets.controlador;

import com.helpets.modelo.Mascota;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import com.helpets.modelo.Especie;

@WebServlet(name = "MascotaServlet", urlPatterns = {"/MascotaServlet"})
@MultipartConfig // ¡Esta etiqueta es la que permite leer formularios con archivos (fotos)!
public class MascotaServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String accion = request.getParameter("accion");
            String idParam = request.getParameter("id");

            // 1. Interceptar acciones (Editar / Eliminar)
            if (accion != null && idParam != null) {
                int id = Integer.parseInt(idParam);

                if (accion.equals("eliminar")) {
                    Mascota.eliminarMascota(id);
                    response.sendRedirect(request.getContextPath() + "/MascotaServlet");
                    return; 
                } 
                if (accion.equals("editar")) {
                    // Guardamos la mascota temporalmente en la "memoria" de la sesión
                    request.getSession().setAttribute("mascotaEdit", Mascota.buscarPorId(id));
                    request.getSession().setAttribute("modoEdicion", true);
                    
                    // Redirigimos al mismo Servlet para LIMPIAR la URL del navegador
                    response.sendRedirect(request.getContextPath() + "/MascotaServlet");
                    return; // Cortamos el flujo para forzar la redirección
                }
            }

            // 2. Recuperar la mascota si venimos de la redirección limpia
            if (request.getSession().getAttribute("modoEdicion") != null) {
                // Pasamos los datos de la memoria a la petición actual de la página
                request.setAttribute("mascotaEdit", request.getSession().getAttribute("mascotaEdit"));
                request.setAttribute("modoEdicion", true);
                
                // Borramos la memoria temporal para no quedarnos atascados en modo edición
                request.getSession().removeAttribute("mascotaEdit");
                request.getSession().removeAttribute("modoEdicion");
            }

            // 3. Cargar datos base y enviar al Dashboard normal
            request.setAttribute("listaMascotas", Mascota.listarMascotas());
            request.setAttribute("listaEspecies", Especie.listarEspecies());

            request.getRequestDispatcher("/admin/dashboard.jsp?view=mascotas").forward(request, response);

        } catch (Exception e) {
            System.err.println("ERROR EN DOGET: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Detectar si es edición o nuevo registro
            String idMascotaStr = request.getParameter("idmascota");
            
            int idRaza = Integer.parseInt(request.getParameter("idraza"));
            String nombre = request.getParameter("nombre");
            String fechaRescateStr = request.getParameter("fecharescate");
            String disponibilidad = request.getParameter("disponibilidad");
            String sexo = request.getParameter("sexo");
            
            // Procesar foto
            String nombreFoto = "default.jpg";
            Part filePart = request.getPart("foto");
            if (filePart != null && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                nombreFoto = filePart.getSubmittedFileName();
                String rutaCarpeta = request.getServletContext().getRealPath("assets/img");
                java.io.File carpeta = new java.io.File(rutaCarpeta);
                if (!carpeta.exists()) carpeta.mkdirs();
                filePart.write(rutaCarpeta + java.io.File.separator + nombreFoto);
            } else if (idMascotaStr != null && !idMascotaStr.isEmpty()) {
                // Si es edición y no subió foto nueva, mantiene la foto que ya tenía
                nombreFoto = request.getParameter("fotoActual");
            }

            // Armar el objeto
            Mascota m = new Mascota();
            m.setIdraza(idRaza);
            m.setNombre(nombre);
            m.setFecharescate(java.sql.Date.valueOf(fechaRescateStr));
            m.setDisponibilidad(disponibilidad);
            m.setSexo(sexo);
            m.setFoto(nombreFoto);
            m.setVive("S");

            if (idMascotaStr != null && !idMascotaStr.isEmpty()) {
                // MODO EDICIÓN
                m.setIdmascota(Integer.parseInt(idMascotaStr));
                m.actualizarMascota();
            } else {
                // MODO NUEVO REGISTRO
                m.registrarMascota();
            }
            
        } catch (Exception e) {
            System.err.println("Error en el procesamiento del formulario: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/MascotaServlet");
    }
}