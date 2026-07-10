package com.helpets.controlador;

import com.helpets.modelo.Mascota;
import com.helpets.modelo.Departamento;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(name = "IndexServlet", urlPatterns = {"/inicio"})
public class IndexServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Consumimos el método que ya esta en el modelo Mascota
            request.setAttribute("listaCatalogo", Mascota.listarCatalogoDisponibles());
            request.setAttribute("listaDepartamentos", Departamento.listarDepartamentos());
        } catch (Exception e) {
            System.err.println("Error al cargar las mascotas en el index: " + e.getMessage());
        }

        // Enviamos la petición con la data cargada hacia el index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}