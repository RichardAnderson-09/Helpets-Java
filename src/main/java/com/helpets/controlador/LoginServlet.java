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
        
        // 1. Capturar lo que ingresa el usuario en el HTML
        // IMPORTANTE: Asegúrate que tus <input> en login.jsp tengan name="usuario" y name="password"
        String userParam = request.getParameter("usuario");
        String passParam = request.getParameter("password");
        
        
        // USO DE APACHE COMMONS: Verifica si es nulo, vacío o solo espacios
        if (StringUtils.isBlank(userParam) || StringUtils.isBlank(passParam)) {
            request.setAttribute("error", "Los campos no pueden estar vacíos.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return; // Cortamos la ejecución
        }
        
        
        // 2. Encriptar la contraseña a SHA-256 para que coincida con la base de datos
        String hashPassword = Encriptador.encriptarSHA256(passParam);
        
        // 3. Validar con la base de datos
        Usuario usuarioLogueado = Usuario.validarLogin(userParam, hashPassword);
        
        if (usuarioLogueado != null) {
            // CREDENCIALES CORRECTAS
            // Creamos la sesión y guardamos el objeto del usuario completo
            HttpSession session = request.getSession();
            session.setAttribute("usuarioActivo", usuarioLogueado);
            
            // Redirigimos al Dashboard Principal
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else {
            // CREDENCIALES INCORRECTAS
            // Mandamos un mensaje de error y recargamos el login
            request.setAttribute("error", "Usuario o contraseña incorrectos.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
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
            
            // Redirigimos al index principal
            response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        }
    }
}