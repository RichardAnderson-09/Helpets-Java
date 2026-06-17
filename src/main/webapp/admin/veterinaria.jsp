<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Módulo de Veterinaria</h2>
        <p class="text-muted">Control de historias clínicas y procedimientos médicos de las mascotas.</p>
    </div>
</div>

<div class="row g-4">
    
    <div class="col-lg-5">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-info text-white fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-search"></i> Catálogo de Pacientes</span>
            </div>
            <div class="card-body bg-light">
                <div class="mb-3">
                    <input type="text" id="buscadorMascotas" class="form-control" placeholder="Buscar por nombre, especie o raza..." onkeyup="filtrarTablaMascotas()">
                </div>
                
                <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                    <table class="table table-hover align-middle bg-white" id="tablaMascotas">
                        <thead class="table-light sticky-top">
                            <tr>
                                <th>Mascota</th>
                                <th>Detalles</th>
                                <th class="text-center">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${listaMascotas}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/assets/img/${m.foto}" class="rounded-circle me-2" style="width: 40px; height: 40px; object-fit: cover;">
                                            <div>
                                                <div class="fw-bold ${m.vive == 'N' ? 'text-decoration-line-through text-muted' : 'text-dark'}">${m.nombre}</div>
                                                <small class="text-muted">Rescate: ${m.fecharescate}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary">${m.nombreEspecie}</span><br>
                                        <small class="text-muted">${m.nombreRaza}</small>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/VeterinariaServlet?idmascota=${m.idmascota}" class="btn btn-sm btn-outline-info" title="Ver Historia Clínica">
                                            <i class="bi bi-journal-medical"></i>
                                        </a>
                                        <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modalHistorial" onclick="prepararModalHistorial(${m.idmascota}, '${m.nombre}')" title="Añadir Procedimiento" ${m.vive == 'N' ? 'disabled' : ''}>
                                            <i class="bi bi-plus-lg"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-7">
        <c:choose>
            <c:when test="${not empty mascotaSeleccionada}">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-clipboard2-pulse"></i> Historia Clínica: ${mascotaSeleccionada.nombre}</span>
                        <c:if test="${mascotaSeleccionada.vive != 'N'}">
                            <button class="btn btn-sm btn-danger fw-bold" onclick="confirmarBaja(${mascotaSeleccionada.idmascota}, '${mascotaSeleccionada.nombre}')">
                                <i class="bi bi-heartbreak"></i> Dar de Baja (Fallecimiento)
                            </button>
                        </c:if>
                        <c:if test="${mascotaSeleccionada.vive == 'N'}">
                            <span class="badge bg-danger fs-6"><i class="bi bi-exclamation-triangle"></i> PACIENTE FALLECIDO</span>
                        </c:if>
                    </div>
                    
                    <div class="card-body">
                        <div class="row mb-4 bg-light p-3 rounded">
                            <div class="col-auto">
                                <img src="${pageContext.request.contextPath}/assets/img/${mascotaSeleccionada.foto}" class="rounded shadow" style="width: 120px; height: 120px; object-fit: cover;">
                            </div>
                            <div class="col">
                                <h4 class="fw-bold text-primary mb-1">${mascotaSeleccionada.nombre}</h4>
                                <p class="mb-1"><strong>Especie/Raza:</strong> ${mascotaSeleccionada.nombreEspecie} / ${mascotaSeleccionada.nombreRaza}</p>
                                <p class="mb-1"><strong>Sexo:</strong> ${mascotaSeleccionada.sexo == 'M' ? 'Macho' : 'Hembra'}</p>
                                <p class="mb-0"><strong>Fecha de Ingreso:</strong> ${mascotaSeleccionada.fecharescate}</p>
                            </div>
                        </div>

                        <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">Historial de Intervenciones y Procesos</h6>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Fecha y Hora</th>
                                        <th>Procedimiento</th>
                                        <th>Peso</th>
                                        <th>Observaciones Médicas</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="h" items="${listaHistorial}">
                                        <tr>
                                            <td class="fw-bold text-muted">${h.fechaatencion}</td>
                                            <td><span class="badge bg-info text-dark">${h.nombreProceso}</span></td>
                                            <td>${h.peso} kg</td>
                                            <td>${h.descripcion}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty listaHistorial}">
                                        <tr>
                                            <td colspan="3" class="text-center py-4 text-muted">
                                                <i class="bi bi-folder-x fs-2 d-block mb-2"></i>
                                                No hay registros médicos para esta mascota.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="card shadow-sm border-0 h-100 bg-light d-flex justify-content-center align-items-center text-center p-5">
                    <div class="text-muted">
                        <i class="bi bi-file-medical display-1 text-secondary opacity-50"></i>
                        <h4 class="mt-3 fw-bold">Ningún Paciente Seleccionado</h4>
                        <p>Haz clic en el botón de "Historia Clínica" de un animal en la tabla izquierda para visualizar sus registros médicos.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div class="modal fade" id="modalHistorial" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle"></i> Nuevo Procedimiento Médico</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/VeterinariaServlet" method="POST">
                <div class="modal-body bg-light">
                    <input type="hidden" name="accion" value="registrarHistorial">
                    <input type="hidden" id="modalIdMascota" name="idmascota">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Paciente</label>
                        <input type="text" id="modalNombreMascota" class="form-control" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Tipo de Proceso / Vacuna</label>
                        <select id="idproceso" name="idproceso" class="form-select" onchange="cargarDescripcionProceso()" required>
                            <option value="">Seleccione el procedimiento...</option>
                            <c:forEach var="p" items="${listaProcesos}">
                                <option value="${p.idprocesomedico}">${p.procesomedico}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Instrucción Médica (Referencia)</label>
                        <textarea id="descripcionProceso" class="form-control bg-white text-primary fw-semibold" rows="2" readonly placeholder="La descripción del proceso aparecerá aquí automáticamente..."></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold text-dark">Fecha y Hora de Atención</label>
                            <input type="datetime-local" name="fechaatencion" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold text-dark">Peso del Paciente (kg)</label>
                            <input type="number" step="0.01" name="peso" class="form-control" placeholder="Ej. 12.50" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Observaciones / Tratamiento Aplicado</label>
                        <textarea name="descripcion" class="form-control" rows="3" required placeholder="Ej: Se administró la dosis completa."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-info text-white fw-bold">Guardar Registro Médico</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Petición AJAX para traer la instrucción no editable
    function cargarDescripcionProceso() {
        var idprocesomedico = document.getElementById("idproceso").value; // Mantenemos el ID del select
        var txtDescripcion = document.getElementById("descripcionProceso");
        
        if(idprocesomedico === "") {
            txtDescripcion.value = "";
            return;
        }

        // Modificada la ruta del fetch para enviar idprocesomedico
        fetch("${pageContext.request.contextPath}/VeterinariaServlet?accion=obtenerDescripcion&idprocesomedico=" + idprocesomedico)
            .then(response => response.text())
            .then(descripcion => {
                txtDescripcion.value = descripcion;
            })
            .catch(error => console.error("Error al obtener descripción:", error));
    }
    
    // Filtro rápido de la tabla HTML
    function filtrarTablaMascotas() {
        var input = document.getElementById("buscadorMascotas").value.toLowerCase();
        var filas = document.querySelectorAll("#tablaMascotas tbody tr");
        
        filas.forEach(function(fila) {
            var textoFila = fila.innerText.toLowerCase();
            if (textoFila.includes(input)) {
                fila.style.display = "";
            } else {
                fila.style.display = "none";
            }
        });
    }

    // Preparar el modal inyectando el ID y Nombre
    function prepararModalHistorial(idMascota, nombreMascota) {
        document.getElementById("modalIdMascota").value = idMascota;
        document.getElementById("modalNombreMascota").value = nombreMascota;
        // Limpiamos los campos al abrir
        document.getElementById("idproceso").value = "";
        document.getElementById("descripcionProceso").value = "";
    }

    // Confirmación para defunción
    function confirmarBaja(idMascota, nombreMascota) {
        if(confirm("¿Estás absolutamente seguro de declarar el fallecimiento de " + nombreMascota + "?\nEsta acción lo marcará como NO disponible en el sistema permanentemente.")) {
            window.location.href = "${pageContext.request.contextPath}/VeterinariaServlet?accion=darDeBaja&idmascota=" + idMascota;
        }
    }
</script>