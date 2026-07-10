package com.helpets.controlador;

import com.helpets.modelo.Provincia;
import com.helpets.modelo.Distrito;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UbigeoServlet", urlPatterns = {"/UbigeoServlet"})
public class UbigeoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configuramos la cabecera para devolver explícitamente JSON en UTF-8
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String accion = request.getParameter("accion");
        StringBuilder json = new StringBuilder("[");

        if ("provincias".equals(accion)) {
            String iddep = request.getParameter("iddepartamento");
            if (iddep != null && !iddep.isEmpty()) {
                List<Provincia> lista = Provincia.listarPorDepartamento(iddep);
                for (int i = 0; i < lista.size(); i++) {
                    Provincia p = lista.get(i);
                    json.append(String.format("{\"id\":\"%s\",\"nombre\":\"%s\"}", p.getIdprovincia(), p.getProvincia()));
                    if (i < lista.size() - 1) {
                        json.append(",");
                    }
                }
            }
        } else if ("distritos".equals(accion)) {
            String idprov = request.getParameter("idprovincia");
            if (idprov != null && !idprov.isEmpty()) {
                List<Distrito> lista = Distrito.listarPorProvincia(idprov);
                for (int i = 0; i < lista.size(); i++) {
                    Distrito d = lista.get(i);
                    json.append(String.format("{\"id\":\"%s\",\"nombre\":\"%s\"}", d.getIddistrito(), d.getDistrito()));
                    if (i < lista.size() - 1) {
                        json.append(",");
                    }
                }
            }
        }

        json.append("]");
        out.print(json.toString());
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}