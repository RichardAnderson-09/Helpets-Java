package com.helpets.controlador;

import com.helpets.config.ConexionBD;
import com.helpets.config.MetricsFilter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet(name = "MetricsServlet", urlPatterns = {"/metrics"})
public class MetricsServlet extends HttpServlet {

    private static final long START_TIME = System.currentTimeMillis();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain; version=0.0.4; charset=utf-8");

        long uptimeSeconds = (System.currentTimeMillis() - START_TIME) / 1000;
        long usedMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        int dbStatus = verificarBaseDatos();
        long requestsTotal = MetricsFilter.getHttpRequestsTotal();
        long errorsTotal = MetricsFilter.getHttpErrorsTotal();
        long durationTotal = MetricsFilter.getHttpDurationTotalMs();
        double avgDuration = requestsTotal > 0 ? (double) durationTotal / requestsTotal : 0;

        String metrics = ""
                + "# HELP helpets_app_uptime_seconds Tiempo de actividad de la aplicacion en segundos\n"
                + "# TYPE helpets_app_uptime_seconds gauge\n"
                + "helpets_app_uptime_seconds " + uptimeSeconds + "\n\n"

                + "# HELP helpets_jvm_memory_used_bytes Memoria usada por la JVM\n"
                + "# TYPE helpets_jvm_memory_used_bytes gauge\n"
                + "helpets_jvm_memory_used_bytes " + usedMemory + "\n\n"

                + "# HELP helpets_db_status Estado de conexion a base de datos: 1 disponible, 0 error\n"
                + "# TYPE helpets_db_status gauge\n"
                + "helpets_db_status " + dbStatus + "\n"
                
                + "# HELP helpets_http_requests_total Total de peticiones HTTP recibidas\n"
                + "# TYPE helpets_http_requests_total counter\n"
                + "helpets_http_requests_total " + requestsTotal + "\n\n"

                + "# HELP helpets_http_errors_total Total de respuestas HTTP con codigo 4xx o 5xx\n"
                + "# TYPE helpets_http_errors_total counter\n"
                + "helpets_http_errors_total " + errorsTotal + "\n\n"

                + "# HELP helpets_http_request_duration_avg_ms Duracion promedio de peticiones HTTP en milisegundos\n"
                + "# TYPE helpets_http_request_duration_avg_ms gauge\n"
                + "helpets_http_request_duration_avg_ms " + avgDuration + "\n\n";

        response.getWriter().write(metrics);
    }

    private int verificarBaseDatos() {
        try (Connection connection = ConexionBD.getConexion()) {
            return connection != null && !connection.isClosed() ? 1 : 0;
        } catch (Exception e) {
            return 0;
        }
    }
}