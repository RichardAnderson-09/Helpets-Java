package com.helpets.controlador;

import com.helpets.config.Encriptador;
import com.helpets.modelo.Persona;
import com.helpets.modelo.Usuario;
import com.helpets.modelo.Voluntario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VoluntarioServlet", urlPatterns = {"/VoluntarioServlet"})
public class VoluntarioServlet extends HttpServlet {

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

        // Reutilización del buscador AJAX de personas
        if ("buscarPersona".equals(accion)) {
            String tipodoc = request.getParameter("tipodoc");
            String nrodoc = request.getParameter("nrodoc");
            Persona p = Persona.buscarPorDocumento(tipodoc, nrodoc);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (p != null) {
                String fecha = p.getFechanac() != null ? p.getFechanac().toString() : "";
                String json = String.format("{\"encontrado\":true, \"nombres\":\"%s\", \"apellidos\":\"%s\", \"fechanac\":\"%s\", \"telefono\":\"%s\", \"correo\":\"%s\"}", 
                                            p.getNombres(), p.getApellidos(), fecha, p.getTelefono() != null ? p.getTelefono() : "", p.getCorreo() != null ? p.getCorreo() : "");
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{\"encontrado\":false}");
            }
            return;
        }

        // Acción Dar de Baja
        if ("darDeBaja".equals(accion)) {
            int idHistorial = Integer.parseInt(request.getParameter("idhistorialvol"));
            int idUsuario = Integer.parseInt(request.getParameter("idusuario"));
            Voluntario.darDeBaja(idHistorial, idUsuario);
            response.sendRedirect(request.getContextPath() + "/VoluntarioServlet");
            return;
        }

        // Flujo normal de carga
        request.setAttribute("listaVoluntarios", Voluntario.listarVoluntarios());
        request.getRequestDispatcher("/admin/dashboard.jsp?view=voluntarios").forward(request, response);
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
        
        String accion = request.getParameter("accion");
        
        try {
            if ("registrar".equals(accion)) {
                // 1. Registrar u obtener Persona existente
                Persona p = new Persona();
                p.setTipodoc(request.getParameter("tipodoc"));
                p.setNrodoc(request.getParameter("nrodoc"));
                p.setNombres(request.getParameter("nombres"));
                p.setApellidos(request.getParameter("apellidos"));
                p.setTelefono(request.getParameter("telefono"));
                p.setCorreo(request.getParameter("correo"));
                p.setIddistrito("010101"); // Código de distrito por defecto
                
                String fechaNac = request.getParameter("fechanac");
                if (fechaNac != null && !fechaNac.isEmpty()) {
                    p.setFechanac(java.sql.Date.valueOf(fechaNac));
                }
                
                int idPersona = p.registrarYObtenerId();
                
                if (idPersona != -1) {
                    // 2. Cuentas e Historial
                    String user = request.getParameter("nombreusuario");
                    String pass = request.getParameter("contraseña");
                    String hashPass = Encriptador.encriptarSHA256(pass);
                    
                    java.sql.Date fInicio = java.sql.Date.valueOf(request.getParameter("fechainicio"));
                    String fFinStr = request.getParameter("fechafin");
                    java.sql.Date fFin = (fFinStr != null && !fFinStr.isEmpty()) ? java.sql.Date.valueOf(fFinStr) : null;
                    
                    Voluntario.registrarCuentaYHistorial(idPersona, user, hashPass, fInicio, fFin);
                }
            }
            
            if ("registrar".equals(accion)) {
                // 1. Obtenemos datos de la Persona
                Persona p = new Persona();
                p.setTipodoc(request.getParameter("tipodoc"));
                p.setNrodoc(request.getParameter("nrodoc"));
                p.setNombres(request.getParameter("nombres"));
                p.setApellidos(request.getParameter("apellidos"));
                p.setTelefono(request.getParameter("telefono"));
                p.setCorreo(request.getParameter("correo"));
                p.setIddistrito("010101"); // Reemplazar según tu lógica
                
                String fechaNac = request.getParameter("fechanac");
                if (fechaNac != null && !fechaNac.isEmpty()) {
                    p.setFechanac(java.sql.Date.valueOf(fechaNac));
                }
                
                // AQUÍ OCURRE LA MAGIA: Guardamos la persona y obtenemos su ID
                int idPersonaGenerado = p.registrarYObtenerId(); 
                
                if (idPersonaGenerado != -1) {
                    // 2. Extraemos los datos de las fechas de inicio para el historial
                    String user = request.getParameter("nombreusuario");
                    String pass = request.getParameter("contraseña");
                    String hashPass = Encriptador.encriptarSHA256(pass);
                    
                    java.sql.Date fInicio = java.sql.Date.valueOf(request.getParameter("fechainicio"));
                    String fFinStr = request.getParameter("fechafin");
                    java.sql.Date fFin = (fFinStr != null && !fFinStr.isEmpty()) ? java.sql.Date.valueOf(fFinStr) : null;
                    
                    // 3. Enviamos el ID de la persona y la fecha de inicio para guardar en historialvol
                    Voluntario.registrarCuentaYHistorial(idPersonaGenerado, user, hashPass, fInicio, fFin);
                }
            }
            
            if ("editar".equals(accion)) {
                int idPersona = Integer.parseInt(request.getParameter("idpersona"));
                int idUsuario = Integer.parseInt(request.getParameter("idusuario"));
                String nom = request.getParameter("nombres");
                String ape = request.getParameter("apellidos");
                String tel = request.getParameter("telefono");
                String corr = request.getParameter("correo");
                String user = request.getParameter("nombreusuario");
                String pass = request.getParameter("contraseña");
                
                String hashPass = (pass != null && !pass.trim().isEmpty()) ? Encriptador.encriptarSHA256(pass) : null;
                
                Voluntario.actualizarDatosCompletos(idPersona, idUsuario, nom, ape, tel, corr, user, hashPass);
            }
            
        } catch (Exception e) {
            System.err.println("Error procesando módulo voluntarios: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/VoluntarioServlet");
    }
}