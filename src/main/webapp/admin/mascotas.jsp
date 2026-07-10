<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Gestión de Mascotas</h2>
        <p class="text-muted">Administra el catálogo de animales del refugio.</p>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/MascotaServlet?accion=exportar" class="btn btn-success shadow-sm me-2">
            <i class="bi bi-file-earmark-excel"></i> Exportar a Excel
        </a>
    
        <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#modalMascota">
            <i class="bi bi-plus-circle"></i> Registrar Mascota
        </button>
    </div>
</div>

<!-- Listado de mascota -->
<div class="card shadow-sm border-0">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Especie</th>
                        <th>Raza</th>
                        <th>Sexo</th>
                        <th>Estado Adopción</th>
                        <th>Foto</th>
                        <th class="text-center">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${listaMascotas}">
                    <tr>
                        <td>#${m.idmascota}</td>
                        <td>${m.nombre}</td>
                        <td>${m.nombreEspecie} </td>
                        <td>${m.nombreRaza}</td>
                        <td>${m.sexo == 'M' ? 'Macho' : 'Hembra'}</td>
                        <td>
                            <span class="badge ${m.disponibilidad == '1' ? 'bg-success' : 'bg-secondary'}">
                                ${m.disponibilidad == '1' ? 'Disponible' : 'Adoptado'}
                            </span>
                        </td>
                        <td>
                            <img src="${pageContext.request.contextPath}/assets/img/${m.foto}" 
                                 alt="Foto de ${m.nombre}"
                                 class="foto-miniatura">
                        </td>
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/MascotaServlet?accion=editar&id=${m.idmascota}" class="btn btn-sm btn-outline-primary me-1" title="Editar">
                                <i class="bi bi-pencil-square"></i>
                            </a>

                            <button type="button" class="btn btn-sm btn-outline-danger" title="Eliminar" onclick="confirmarEliminacion(${m.idmascota})">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Registrar Mascota -->
<div class="modal fade" id="modalMascota" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="bi bi-plus-circle"></i> Registrar Mascota
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <form id="formRegistroMascota" action="${pageContext.request.contextPath}/MascotaServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="idmascota" value="${mascotaEdit.idmascota}">
                <input type="hidden" name="fotoActual" value="${mascotaEdit.foto}">
                <div class="modal-body">

                    <div class="row g-3">
                        
                        <!-- Especie -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Especie:</label>
                            <select id="especieSelect" class="form-control" onchange="cargarRazas()" required>
                                <option value="">Seleccione una especie</option>
                                <c:forEach var="e" items="${listaEspecies}">
                                    <option value="${e.idespecie}">${e.nombreEspecie}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Raza -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Raza:</label>
                            <select name="idraza" id="razaSelect" class="form-control" required>
                            <c:choose>
                                <c:when test="${not empty mascotaEdit}">
                                    <option value="${mascotaEdit.idraza}">Mantener raza actual</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="">Primero seleccione una especie</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                        </div>

                        <!-- Nombre -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Nombre</label>
                            <input type="text" name="nombre" class="form-control" value="${mascotaEdit.nombre}" required>
                        </div>

                        <!-- Fecha rescate -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Fecha de rescate</label>
                            <input type="date" name="fecharescate" class="form-control" value="${mascotaEdit.fecharescate}" required>
                        </div>

                        <!-- Disponibilidad -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Disponibilidad</label>
                            <select name="disponibilidad" class="form-select" required>
                                <option value="1" ${mascotaEdit.disponibilidad == '1' ? 'selected' : ''}>Disponible</option>
                                <option value="0" ${mascotaEdit.disponibilidad == '0' ? 'selected' : ''}>No Disponible</option>
                            </select>
                        </div>

                        <!-- Sexo -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Sexo</label>
                            <select name="sexo" class="form-select" required>
                                <option value="">Seleccione</option>
                                <option value="H" ${mascotaEdit.sexo == 'H' ? 'selected' : ''}>Hembra</option>
                                <option value="M" ${mascotaEdit.sexo == 'M' ? 'selected' : ''}>Macho</option>
                            </select>
                        </div>

                        <!-- Foto -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Foto</label>
                            <input 
                                type="file" 
                                name="foto" 
                                class="form-control"
                                accept="image/*">
                        </div>

                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancelar
                    </button>

                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save"></i> Guardar
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>

<script>
    function cargarRazas() {
        // Obtenemos los selectores
        var idEspecie = document.getElementById("especieSelect").value;
        var razaSelect = document.getElementById("razaSelect");

        // Si regresa a la opción vacía, limpiamos el de razas
        if (idEspecie === "") {
            razaSelect.innerHTML = "<option value=''>Primero seleccione una especie</option>";
            return;
        }

        // Petición AJAX al Servlet
        fetch("${pageContext.request.contextPath}/RazaServlet?idespecie=" + idEspecie)
            .then(response => response.text())
            .then(html => {
                // Rellenamos el select de razas con lo que respondió el Servlet
                razaSelect.innerHTML = html;
            })
            .catch(error => console.error('Error al cargar razas:', error));
    }
    
    
    document.getElementById("formRegistroMascota").addEventListener("submit", function(event) {
        // El navegador ya validó los campos vacíos gracias a los 'required'.
        // Ahora lanzamos la pregunta:
        var confirmacion = confirm("¿Estás seguro de registrar esta nueva mascota en el sistema?");
        
        // Si el usuario cancela, detenemos el envío al Servlet
        if (!confirmacion) {
            event.preventDefault();
        }
    });

    // Confirmación antes de ELIMINAR
    function confirmarEliminacion(idMascota) {
        var confirmacion = confirm("¿Estás seguro de eliminar este registro? Esta acción no se puede deshacer.");
        
        if (confirmacion) {
            // Si acepta, redirigimos al Servlet mandando la acción de eliminar y el ID
            window.location.href = "${pageContext.request.contextPath}/MascotaServlet?accion=eliminar&id=" + idMascota;
        }
    }
    
    // Espera a que la página cargue y abre el modal
   <c:if test="${not empty mascotaEdit}">
        window.addEventListener('DOMContentLoaded', function() {
            var modalElement = document.getElementById('modalMascota');
            var modalRegistro = bootstrap.Modal.getOrCreateInstance(modalElement);
            modalRegistro.show();
        });
    </c:if>
</script>

<style>
    /* Estilo de la miniatura normal */
    .foto-miniatura {
        width: 45px;
        height: 45px;
        object-fit: cover; /* Evita que la foto se estire o deforme */
        border-radius: 8px; /* Bordes ligeramente redondeados */
        transition: transform 0.3s ease; /* Hace que el zoom sea suave */
        cursor: zoom-in;
    }

    /* Efecto al pasar el mouse por encima */
    .foto-miniatura:hover {
        transform: scale(3.5); /* Aumenta el tamaño 3.5 veces */
        position: relative;
        z-index: 1050; /* Lo pone por encima de todos los demás elementos de la tabla */
        box-shadow: 0 4px 15px rgba(0,0,0,0.3); /* Pequeña sombra 3D */
    }
</style>