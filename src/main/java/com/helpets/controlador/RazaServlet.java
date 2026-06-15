package com.helpets.controlador;

import com.helpets.modelo.Raza;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RazaServlet", urlPatterns = {"/RazaServlet"})
public class RazaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configuramos la respuesta para que sea texto HTML
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la especie seleccionada
        String especieParam = request.getParameter("idespecie");
        
        try (PrintWriter out = response.getWriter()) {
            if (especieParam != null && !especieParam.isEmpty()) {
                int idEspecie = Integer.parseInt(especieParam);
                List<Raza> razas = Raza.listarPorEspecie(idEspecie);
                
                // Imprimimos las opciones dinámicas
                out.println("<option value=''>Seleccione una raza</option>");
                for (Raza r : razas) {
                    out.println("<option value='" + r.getIdraza() + "'>" + r.getNombreRaza() + "</option>");
                }
            } else {
                out.println("<option value=''>Primero seleccione una especie</option>");
            }
        }
    }
}