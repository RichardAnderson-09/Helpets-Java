<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="col-auto col-md-3 col-xl-2 px-sm-2 px-0 bg-dark min-vh-100">
    <div class="d-flex flex-column align-items-center align-items-sm-start px-3 pt-2 text-white">
        
        <a href="${pageContext.request.contextPath}/ResumenServlet" class="d-flex align-items-center pb-3 mb-md-0 me-md-auto text-white text-decoration-none mt-3">
            <span class="fs-4 d-none d-sm-inline fw-bold"><i class="fs-5 bi-tencent-qq"></i> HELPETS</span>
        </a>
        <hr class="w-100 text-secondary">
        
        <ul class="nav nav-pills flex-column mb-sm-auto mb-0 align-items-center align-items-sm-start w-100" id="menu">
            
            <c:if test="${sessionScope.usuarioActivo.idrol == 1 || sessionScope.usuarioActivo.idrol == 2 || sessionScope.usuarioActivo.idrol == 3}">
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/ResumenServlet" class="nav-link text-white">
                        <i class="fs-5 bi-speedometer2"></i> <span class="ms-1 d-none d-sm-inline">Resumen</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${sessionScope.usuarioActivo.idrol == 1 || sessionScope.usuarioActivo.idrol == 2}">
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/MascotaServlet" class="nav-link text-white">
                        <i class="fs-5 bi-tencent-qq"></i> <span class="ms-1 d-none d-sm-inline">Mascotas</span>
                    </a>
                </li>
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/AdopcionServlet" class="nav-link text-white">
                        <i class="fs-5 bi-person-lines-fill"></i> <span class="ms-1 d-none d-sm-inline">Adopciones</span>
                    </a>
                </li>
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/DonacionServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-cash-coin"></i> <span class="ms-1 d-none d-sm-inline">Donaciones</span>
                    </a>
                </li>
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/CompraServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-cart3"></i> <span class="ms-1 d-none d-sm-inline">Compras</span>
                    </a>
                </li>
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/InventarioServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-box-seam"></i> <span class="ms-1 d-none d-sm-inline">Inventario</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${sessionScope.usuarioActivo.idrol == 1 || sessionScope.usuarioActivo.idrol == 3}">
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/VeterinariaServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-heart-pulse"></i> <span class="ms-1 d-none d-sm-inline">Veterinaria</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${sessionScope.usuarioActivo.idrol == 1}">
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/VoluntarioServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-people-fill"></i> <span class="ms-1 d-none d-sm-inline">Voluntarios</span>
                    </a>
                </li>
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/UsuarioServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-person-badge-fill"></i> <span class="ms-1 d-none d-sm-inline">Usuarios</span>
                    </a>
                </li>
            </c:if>
            
            <c:if test="${sessionScope.usuarioActivo.idrol == 1 || sessionScope.usuarioActivo.idrol == 4}">
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/CatalogoMascotasServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-grid"></i> <span class="ms-1 d-none d-sm-inline">Catálogo Mascotas</span>
                    </a>
                </li>
            </c:if>
                
            <c:if test="${sessionScope.usuarioActivo.idrol == 1 || sessionScope.usuarioActivo.idrol == 4}">
                <li class="nav-item w-100 mb-2">
                    <a href="${pageContext.request.contextPath}/AporteMonetarioServlet" class="nav-link text-white">
                        <i class="fs-5 bi bi-piggy-bank"></i> <span class="ms-1 d-none d-sm-inline">Hacer Donación</span>
                    </a>
                </li>
            </c:if>

        </ul>
        
        <hr class="w-100 text-secondary">
        <div class="pb-4">
            <a href="${pageContext.request.contextPath}/LoginServlet?accion=logout" class="text-white text-decoration-none">
                <i class="fs-5 bi-box-arrow-left"></i> <span class="d-none d-sm-inline">Cerrar Sesión</span>
            </a>
        </div>
        
    </div>
</div>