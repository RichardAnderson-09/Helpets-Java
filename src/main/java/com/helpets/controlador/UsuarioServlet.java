package com.helpets.controlador;

import com.helpets.config.Encriptador;
import com.helpets.modelo.Persona;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        // Buscador AJAX de personas (Reutilizado)
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
            int idUsuario = Integer.parseInt(request.getParameter("idusuario"));
            Usuario.darDeBaja(idUsuario);
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
            return;
        }

        // Flujo normal de carga
        request.setAttribute("listaUsuarios", Usuario.listarUsuariosNoVoluntarios());
        request.getRequestDispatcher("/admin/dashboard.jsp?view=usuarios").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        try {
            if ("registrar".equals(accion)) {
                Persona p = new Persona();
                p.setTipodoc(request.getParameter("tipodoc"));
                p.setNrodoc(request.getParameter("nrodoc"));
                p.setNombres(request.getParameter("nombres"));
                p.setApellidos(request.getParameter("apellidos"));
                p.setTelefono(request.getParameter("telefono"));
                p.setCorreo(request.getParameter("correo"));
                p.setIddistrito("010101"); 
                
                String fechaNac = request.getParameter("fechanac");
                if (fechaNac != null && !fechaNac.isEmpty()) {
                    p.setFechanac(java.sql.Date.valueOf(fechaNac));
                }
                
                int idPersonaGenerado = p.registrarYObtenerId(); 
                
                if (idPersonaGenerado != -1) {
                    int idRol = Integer.parseInt(request.getParameter("idrol"));
                    String user = request.getParameter("nombreusuario");
                    String pass = request.getParameter("contraseña");
                    String hashPass = Encriptador.encriptarSHA256(pass);
                    
                    Usuario.registrarCuenta(idPersonaGenerado, idRol, user, hashPass);
                }
            }
            
            if ("editar".equals(accion)) {
                int idPersona = Integer.parseInt(request.getParameter("idpersona"));
                int idUsuario = Integer.parseInt(request.getParameter("idusuario"));
                int idRol = Integer.parseInt(request.getParameter("idrol"));
                String nom = request.getParameter("nombres");
                String ape = request.getParameter("apellidos");
                String tel = request.getParameter("telefono");
                String corr = request.getParameter("correo");
                String user = request.getParameter("nombreusuario");
                String pass = request.getParameter("contraseña");
                
                String hashPass = (pass != null && !pass.trim().isEmpty()) ? Encriptador.encriptarSHA256(pass) : null;
                
                Usuario.actualizarDatosCompletos(idPersona, idUsuario, idRol, nom, ape, tel, corr, user, hashPass);
            }
            
        } catch (Exception e) {
            System.err.println("Error procesando módulo usuarios: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
    }
}