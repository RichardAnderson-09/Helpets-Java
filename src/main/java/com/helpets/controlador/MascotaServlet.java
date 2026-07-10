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
import com.helpets.modelo.Usuario;
import jakarta.servlet.http.HttpSession;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.OutputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet(name = "MascotaServlet", urlPatterns = {"/MascotaServlet"})
@MultipartConfig // ¡Esta etiqueta es la que permite leer formularios con archivos (fotos)
public class MascotaServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(MascotaServlet.class);

@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 2)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
        try {
            String accion = request.getParameter("accion");
            String idParam = request.getParameter("id");

            // 1. Interceptar acciones que vienen por parámetro URL
            if (accion != null) {
                
                // ACCIÓN EXPORTAR (No requiere parámetro 'id')
                if (accion.equals("exportar")) {
                    logger.info("Iniciando la exportación del catálogo de mascotas a Excel...");
                    
                    // Uso de try-with-resources para cerrar automáticamente el libro en memoria
                    try (Workbook workbook = new XSSFWorkbook()) {
                        List<Mascota> lista = Mascota.listarMascotas();
                        logger.info("Se recuperaron {} mascotas de la base de datos.", lista.size());
                        
                        Sheet sheet = workbook.createSheet("Mascotas Registradas");
                        
                        // Crear fila de cabeceras
                        Row headerRow = sheet.createRow(0);
                        headerRow.createCell(0).setCellValue("ID");
                        headerRow.createCell(1).setCellValue("Nombre");
                        headerRow.createCell(2).setCellValue("Especie");
                        headerRow.createCell(3).setCellValue("Raza");
                        headerRow.createCell(4).setCellValue("Sexo");
                        headerRow.createCell(5).setCellValue("Estado");

                        // Llenar datos de las mascotas
                        int rowNum = 1;
                        for (Mascota m : lista) {
                            Row row = sheet.createRow(rowNum++);
                            row.createCell(0).setCellValue(m.getIdmascota());
                            row.createCell(1).setCellValue(m.getNombre());
                            row.createCell(2).setCellValue(m.getNombreEspecie());
                            row.createCell(3).setCellValue(m.getNombreRaza());
                            // Validaciones seguras que evitan NullPointerException
                            row.createCell(4).setCellValue("M".equals(m.getSexo()) ? "Macho" : "Hembra");
                            row.createCell(5).setCellValue("1".equals(m.getDisponibilidad()) ? "Disponible" : "Adoptado");
                        }

                        logger.info("Libro de Excel estructurado correctamente. Preparando descarga...");

                        // Configurar cabeceras HTTP para la descarga de archivos binarios (.xlsx)
                        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                        response.setHeader("Content-Disposition", "attachment; filename=Reporte_Mascotas.xlsx");

                        // Transmitir el flujo de datos al navegador
                        try (OutputStream out = response.getOutputStream()) {
                            workbook.write(out);
                            logger.info("Archivo Excel enviado al navegador exitosamente.");
                        }
                        return; // Cortamos la ejecución del servlet aquí para evitar cargar el HTML/JSP
                        
                    } catch (Exception ex) {
                        logger.error("Error crítico al intentar generar o descargar el Excel: ", ex);
                        request.getSession().setAttribute("error", "No se pudo exportar el Excel. Revisa los logs.");
                        response.sendRedirect(request.getContextPath() + "/MascotaServlet");
                        return;
                    }
                }
                
                // ACCIONES QUE SÍ REQUIEREN UN ID (Eliminar / Editar)
                if (idParam != null) {
                    int id = Integer.parseInt(idParam);
                    
                    if (accion.equals("eliminar")) {
                        Mascota.eliminarMascota(id);
                        response.sendRedirect(request.getContextPath() + "/MascotaServlet");
                        return; 
                    } 
                    
                    if (accion.equals("editar")) {
                        // Guardamos la mascota temporalmente en la memoria de la sesión
                        request.getSession().setAttribute("mascotaEdit", Mascota.buscarPorId(id));
                        request.getSession().setAttribute("modoEdicion", true);
                        
                        // Redirigimos al mismo Servlet para LIMPIAR la URL del navegador (?accion=editar&id=X)
                        response.sendRedirect(request.getContextPath() + "/MascotaServlet");
                        return; 
                    }
                }
            }

            // Recuperar la mascota si venimos de la redirección limpia (Modo Edición)
            if (request.getSession().getAttribute("modoEdicion") != null) {
                // Pasamos los datos de la sesión a la petición de la página actual
                request.setAttribute("mascotaEdit", request.getSession().getAttribute("mascotaEdit"));
                request.setAttribute("modoEdicion", true);
                
                // Borramos la memoria temporal de la sesión para no quedar atrapados en bucle de edición
                request.getSession().removeAttribute("mascotaEdit");
                request.getSession().removeAttribute("modoEdicion");
            }

            // Cargar datos base y enviar a la vista normal del Dashboard
            request.setAttribute("listaMascotas", Mascota.listarMascotas());
            request.setAttribute("listaEspecies", Especie.listarEspecies());

            request.getRequestDispatcher("/admin/dashboard.jsp?view=mascotas").forward(request, response);

        } catch (Exception e) {
            logger.error("Error inesperado en el método doGet de MascotaServlet: ", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");

        if (usuarioActivo == null || (usuarioActivo.getIdrol() != 1 && usuarioActivo.getIdrol() != 2)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
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