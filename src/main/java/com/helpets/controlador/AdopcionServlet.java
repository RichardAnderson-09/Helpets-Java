package com.helpets.controlador;

import com.helpets.modelo.Adopcion;
import com.helpets.modelo.Especie;
import com.helpets.modelo.Mascota;
import com.helpets.modelo.Persona;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet(name = "AdopcionServlet", urlPatterns = {"/AdopcionServlet"})
public class AdopcionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");

        // AJAX: Buscador de Personas
        if ("buscarPersona".equals(accion)) {
            String tipodoc = request.getParameter("tipodoc");
            String nrodoc = request.getParameter("nrodoc");
            Persona p = Persona.buscarPorDocumento(tipodoc, nrodoc);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (p != null) {
                String fecha = p.getFechanac() != null ? p.getFechanac().toString() : "";
                String telf = p.getTelefono() != null ? p.getTelefono() : "";
                String correo = p.getCorreo() != null ? p.getCorreo() : "";
                
                String json = String.format("{\"encontrado\":true, \"nombres\":\"%s\", \"apellidos\":\"%s\", \"fechanac\":\"%s\", \"telefono\":\"%s\", \"correo\":\"%s\"}", 
                                            p.getNombres(), p.getApellidos(), fecha, telf, correo);
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{\"encontrado\":false}");
            }
            return;
        }

        // AJAX: Filtrar Mascotas por Especie
        if ("cargarMascotas".equals(accion)) {
            String idEspecieStr = request.getParameter("idespecie");
            response.setContentType("text/html;charset=UTF-8");
            
            if (idEspecieStr != null && !idEspecieStr.isEmpty()) {
                int idEspecie = Integer.parseInt(idEspecieStr);
                List<Mascota> mascotas = Mascota.listarMascotasDisponiblesPorEspecie(idEspecie);
                
                response.getWriter().write("<option value=''>Seleccione o busque una mascota...</option>");
                for (Mascota m : mascotas) {
                    response.getWriter().write("<option value='" + m.getIdmascota() + "'>" + m.getNombre() + "</option>");
                }
            } else {
                response.getWriter().write("<option value=''>Primero seleccione especie...</option>");
            }
            return;
        }

        // (Cargar Vistas
        request.setAttribute("listaAdopciones", Adopcion.listarAdopciones());
        request.setAttribute("listaEspecies", Especie.listarEspecies()); // Añadimos las especies
        
        request.getRequestDispatcher("/admin/dashboard.jsp?view=adopciones").forward(request, response);
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
                // Armamos el objeto Persona con los datos del formulario
                Persona p = new Persona();
                p.setTipodoc(request.getParameter("tipodoc"));
                p.setNrodoc(request.getParameter("nrodoc"));
                p.setNombres(request.getParameter("nombres"));
                p.setApellidos(request.getParameter("apellidos"));
                p.setTelefono(request.getParameter("telefono"));
                p.setCorreo(request.getParameter("correo"));
                p.setIddistrito(request.getParameter("iddistrito"));
                String fechaNacStr = request.getParameter("fechanac");
                if(fechaNacStr != null && !fechaNacStr.isEmpty()){
                    p.setFechanac(java.sql.Date.valueOf(fechaNacStr));
                }
                
                // Procesamos la Persona y rescatamos su ID
                int idPersona = p.registrarYObtenerId();
                
                if (idPersona != -1) {
                    // Armamos la Adopción
                    Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioActivo");
                    
                    Adopcion a = new Adopcion();
                    a.setIdmascota(Integer.parseInt(request.getParameter("idmascota")));
                    a.setIdpersona(idPersona); 
                    a.setIdusuario(usuarioLogueado.getIdusuario()); // ID de quien registra la acción
                    a.setFechaadopcion(java.sql.Date.valueOf(request.getParameter("fechaadopcion")));
                    a.setEstado_solicitud(request.getParameter("estado_solicitud"));
                    a.setComentarios(request.getParameter("comentarios"));
                    
                    // Guardamos la adopción
                    a.registrarAdopcion();
                }
            }
                
            // Bloque para capturar la actualización de estado
            if ("actualizarEstado".equals(accion)) {
                Adopcion a = new Adopcion();
                a.setIdadopcion(Integer.parseInt(request.getParameter("idadopcion")));
                a.setEstado_solicitud(request.getParameter("estado_solicitud"));
                a.setComentarios(request.getParameter("comentarios"));
                
                a.actualizarEstado();
            }
            
        } catch (Exception e) {
            System.err.println("Error al procesar adopción: " + e.getMessage());
        }
        
        // Redirigimos en limpio para evitar reenvío de formulario
        response.sendRedirect(request.getContextPath() + "/AdopcionServlet");
    }
}