<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // 1. Evitar que el navegador guarde la página en su memoria caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // 2. Validar que la sesión del usuario exista
    if (session.getAttribute("usuarioActivo") == null) {
        // Si no hay un usuario logueado en la memoria, lo pateamos al inicio
        response.sendRedirect("../index.jsp");
        return; // Detiene la carga del resto del HTML
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Panel de Administración - Helpets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            
            <jsp:include page="components/sidebar.jsp" />
            
            <div class="col py-4 px-4 bg-light min-vh-100">
                
                <c:choose>
                    <c:when test="${param.view eq 'mascotas'}">
                        <jsp:include page="mascotas.jsp" />
                    </c:when>
                    
                    <c:when test="${param.view eq 'adopciones'}">
                        <jsp:include page="adopciones.jsp" />
                    </c:when>
                    
                    <c:when test="${param.view eq 'donaciones'}">
                        <jsp:include page="donaciones.jsp" />
                    </c:when>
                    
                    <c:when test="${param.view eq 'compras'}">
                        <jsp:include page="compras.jsp" />
                    </c:when>
                    
                     <c:when test="${param.view eq 'veterinaria'}">
                        <jsp:include page="veterinaria.jsp" />
                    </c:when>
                    
                    <c:when test="${param.view eq 'voluntarios'}">
                        <jsp:include page="voluntarios.jsp" />
                    </c:when>
                    
                    <c:otherwise>
                        <jsp:include page="resumen.jsp" />
                    </c:otherwise>
                </c:choose>
                
            </div>
            
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>