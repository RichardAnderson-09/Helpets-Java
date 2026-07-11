package com.helpets.controlador;

import com.helpets.config.Encriptador;
import com.helpets.modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.lang3.StringUtils;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Capturar lo que ingresa el usuario en el HTML
        String userParam = request.getParameter("usuario");
        String passParam = request.getParameter("password");
        
        
        // USO DE APACHE COMMONS: Verifica si es nulo, vacío o solo espacios
        if (StringUtils.isBlank(userParam) || StringUtils.isBlank(passParam)) {
            request.setAttribute("error", "Los campos no pueden estar vacíos.");
            request.getRequestDispatcher("/inicio").forward(request, response);
            return; // Cortamos la ejecución
        }
        
        
        // Encriptar la contraseña a SHA-256 para que coincida con la base de datos
        String hashPassword = Encriptador.encriptarSHA256(passParam);
        
        // Validar con la base de datos
        Usuario usuarioLogueado = Usuario.validarLogin(userParam, hashPassword);
        
        if (usuarioLogueado != null) {
            // CREDENCIALES CORRECTAS
            HttpSession session = request.getSession();
            session.setAttribute("usuarioActivo", usuarioLogueado);
            
            // REDIRECCIÓN DINÁMICA POR ROLES AL SERVLET CORRECTO
            int rol = usuarioLogueado.getIdrol();
            
            if (rol == 1 || rol == 2) {
                // Admin o Voluntario van al Resumen general
                response.sendRedirect(request.getContextPath() + "/ResumenServlet");
            } else if (rol == 4) {
                // Usuario común va directo a su vista permitida
                response.sendRedirect(request.getContextPath() + "/CatalogoMascotasServlet"); 
            } else if (rol == 3) {
                // Veterinario van a la vista permitida
                response.sendRedirect(request.getContextPath() + "/VeterinariaServlet");
            } else {
                // Por seguridad, si el rol no es reconocido
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/inicio");
            }
        } else {
            // CREDENCIALES INCORRECTAS
            // Mandamos un mensaje de error y recargamos el login
            request.getSession().setAttribute("error", "Usuario o contraseña incorrectos.");
            response.sendRedirect(request.getContextPath() + "/inicio");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Este bloque sirve para CERRAR SESIÓN
        String accion = request.getParameter("accion");
        
        if ("logout".equals(accion)) {
            HttpSession session = request.getSession();
            session.invalidate(); // Destruye por completo la sesión en el servidor
            response.sendRedirect(request.getContextPath() + "/inicio");
        } else {
            // Si el sistema expulsa al usuario hacia aquí por GET por falta de sesión,
            // lo mandamos a la página principal para evitar que la vista quede en blanco.
            response.sendRedirect(request.getContextPath() + "/inicio");
        }
    }
}