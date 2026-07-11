package com.helpets.modelo;

import com.helpets.dao.GestorDAO;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

public class ResumenDashboard {
    // KPI's Generales
    private int solicitudesPendientes;
    private int adopcionesConcretadas; 
    
    // Mapa dinámico para las especies 
    private Map<String, Integer> disponiblesPorEspecie;
    
    // Datos para Chart.js
    private String mesesIngresos; 
    private String datosIngresos; 
    private String labelsEstados;
    private String datosEstados;

    public ResumenDashboard() {
        disponiblesPorEspecie = new LinkedHashMap<>();
    }

    public void cargarEstadisticas() {
        GestorDAO dao = new GestorDAO();
        try {
            // 1. Mascotas Disponibles Agrupadas por Especie 
            String sqlEspecies = "SELECT e.nombre_especie, COUNT(m.idmascota) as total " +
                                 "FROM mascotas m " +
                                 "INNER JOIN razas r ON m.idraza = r.idraza " +
                                 "INNER JOIN especies e ON r.idespecie = e.idespecie " +
                                 "WHERE m.disponibilidad = '1' AND m.vive = 'S' " +
                                 "GROUP BY e.nombre_especie";
            ResultSet rs1 = dao.ejecutarSelect(sqlEspecies);
            while (rs1 != null && rs1.next()) {
                disponiblesPorEspecie.put(rs1.getString("nombre_especie"), rs1.getInt("total"));
            }

            // Solicitudes Pendientes (estado_solicitud = 'P')
            String sqlAdopPendientes = "SELECT COUNT(*) AS total FROM adopciones WHERE estado_solicitud = 'P'";
            ResultSet rs2 = dao.ejecutarSelect(sqlAdopPendientes);
            if (rs2 != null && rs2.next()) this.solicitudesPendientes = rs2.getInt("total");

            // Adopciones Concretadas (estado_solicitud = 'A')
            String sqlAdopAprobadas = "SELECT COUNT(*) AS total FROM adopciones WHERE estado_solicitud = 'A'";
            ResultSet rs3 = dao.ejecutarSelect(sqlAdopAprobadas);
            if (rs3 != null && rs3.next()) this.adopcionesConcretadas = rs3.getInt("total");

            // 4. Gráfico 1: Ingresos de mascotas por mes usando 'fecharescate'
            String sqlIngresos = "SELECT MONTH(fecharescate) as mes, COUNT(*) as cantidad " +
                                 "FROM mascotas WHERE YEAR(fecharescate) = YEAR(CURDATE()) " +
                                 "GROUP BY MONTH(fecharescate) ORDER BY mes";
            ResultSet rs4 = dao.ejecutarSelect(sqlIngresos);
            StringBuilder mesesStr = new StringBuilder();
            StringBuilder datosStr = new StringBuilder();
            String[] nombresMeses = {"", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"};
            
            while(rs4 != null && rs4.next()) {
                if(mesesStr.length() > 0) { mesesStr.append(","); datosStr.append(","); }
                mesesStr.append("'").append(nombresMeses[rs4.getInt("mes")]).append("'");
                datosStr.append(rs4.getInt("cantidad"));
            }
            this.mesesIngresos = mesesStr.length() > 0 ? mesesStr.toString() : "'Sin Datos'";
            this.datosIngresos = datosStr.length() > 0 ? datosStr.toString() : "0";

            // Gráfico 2: Distribución por Estados Reales
            // Calculamos el estado basado en 'disponibilidad' y 'vive'
            String sqlEstados = "SELECT " +
                                "CASE " +
                                "   WHEN vive = 'N' THEN 'Fallecidos' " +
                                "   WHEN disponibilidad = '1' THEN 'Disponibles' " +
                                "   WHEN disponibilidad = '0' THEN 'Adoptados' " +
                                "END AS estado_real, " +
                                "COUNT(*) as cantidad " +
                                "FROM mascotas GROUP BY estado_real";
            ResultSet rs5 = dao.ejecutarSelect(sqlEstados);
            StringBuilder lblEstados = new StringBuilder();
            StringBuilder datEstados = new StringBuilder();
            
            while(rs5 != null && rs5.next()){
                if(lblEstados.length() > 0) { lblEstados.append(","); datEstados.append(","); }
                lblEstados.append("'").append(rs5.getString("estado_real")).append("'");
                datEstados.append(rs5.getInt("cantidad"));
            }
            this.labelsEstados = lblEstados.length() > 0 ? lblEstados.toString() : "'Sin Datos'";
            this.datosEstados = datEstados.length() > 0 ? datEstados.toString() : "0";

        } catch (Exception e) {
            System.err.println("Error al cargar dashboard: " + e.getMessage());
        } finally {
            dao.cerrarConexion();
        }
    }

    // Getters
    public int getSolicitudesPendientes() { return solicitudesPendientes; }
    public int getAdopcionesConcretadas() { return adopcionesConcretadas; }
    public Map<String, Integer> getDisponiblesPorEspecie() { return disponiblesPorEspecie; }
    public String getMesesIngresos() { return mesesIngresos; }
    public String getDatosIngresos() { return datosIngresos; }
    public String getLabelsEstados() { return labelsEstados; }
    public String getDatosEstados() { return datosEstados; }
}