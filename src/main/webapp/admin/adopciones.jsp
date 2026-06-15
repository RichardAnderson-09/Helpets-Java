<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<link href="https://cdn.jsdelivr.net/npm/tom-select@2.2.2/dist/css/tom-select.bootstrap5.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/tom-select@2.2.2/dist/js/tom-select.complete.min.js"></script>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Gestión de Adopciones</h2>
        <p class="text-muted">Administra el registro de adoptantes y el seguimiento de solicitudes.</p>
    </div>
</div>

<div class="row g-4">
    
    <div class="col-lg-4">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-primary text-white fw-bold">
                <i class="bi bi-person-plus"></i> Registrar Adopción
            </div>
            <div class="card-body bg-light">
                <form action="${pageContext.request.contextPath}/AdopcionServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">1. Datos del Adoptante</h6>
                    <div class="row g-2 mb-4">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Tipo Doc.</label>
                            <select id="tipodoc" name="tipodoc" class="form-select form-select-sm" required>
                                <option value="DNI">DNI</option>
                                <option value="CE">CE</option>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Número</label>
                            <div class="input-group input-group-sm">
                                <input type="text" id="nrodoc" name="nrodoc" class="form-control" required>
                                <button class="btn btn-outline-secondary fw-bold" type="button" onclick="buscarAdoptante()">
                                    <i class="bi bi-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Nombres</label>
                            <input type="text" id="nombres" name="nombres" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Apellidos</label>
                            <input type="text" id="apellidos" name="apellidos" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Fecha Nacimiento</label>
                            <input type="date" id="fechanac" name="fechanac" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Teléfono</label>
                            <input type="text" id="telefono" name="telefono" class="form-control form-control-sm">
                        </div>
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Correo</label>
                            <input type="email" id="correo" name="correo" class="form-control form-control-sm">
                        </div>
                    </div>

                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">2. Detalle de Adopción</h6>
                    <div class="row g-2 mb-4">
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">1. Especie</label>
                            <select id="especieAdopcion" class="form-select form-select-sm" onchange="cargarMascotasAdopcion()" required>
                                <option value="">Seleccione especie...</option>
                                <c:forEach var="e" items="${listaEspecies}">
                                    <option value="${e.idespecie}">${e.nombreEspecie}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-7">
                            <label class="form-label small fw-semibold">2. Mascota Solicitada</label>
                            <select id="mascotaAdopcion" name="idmascota" required>
                                <option value="">Primero seleccione especie...</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Fecha</label>
                            <input type="date" name="fechaadopcion" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Estado</label>
                            <select name="estado_solicitud" class="form-select form-select-sm" required>
                                <option value="P">Pendiente</option>
                                <option value="E">Entrevista</option>
                                <option value="A">Aprobado</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Comentarios (Opcional)</label>
                            <textarea name="comentarios" class="form-control form-control-sm" rows="2"></textarea>
                        </div>
                    </div>

                    <div class="d-grid mt-2">
                        <button type="submit" class="btn btn-success fw-bold">
                            <i class="bi bi-save"></i> Guardar Solicitud
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="col-lg-8">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-list-ul"></i> Solicitudes Registradas</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-3"># Solicitud</th>
                                <th>Adoptante</th>
                                <th>Mascota</th>
                                <th>Fecha</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${listaAdopciones}">
                                <tr>
                                    <td class="px-3 fw-bold text-muted">#${a.idadopcion}</td>
                                    <td>
                                        <div class="fw-semibold">${a.nombreAdoptante}</div>
                                        <small class="text-muted"><i class="bi bi-telephone"></i> ${a.telefonoAdoptante}</small>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary">${a.nombreMascota}</span>
                                    </td>
                                    <td>${a.fechaadopcion}</td>
                                    <td>
                                        <span class="badge 
                                            ${a.estado_solicitud == 'A' ? 'bg-success' : 
                                              a.estado_solicitud == 'P' ? 'bg-warning text-dark' : 
                                              a.estado_solicitud == 'R' ? 'bg-danger' : 'bg-info'}">
                                            
                                            ${a.estado_solicitud == 'A' ? 'Aprobado' : 
                                              a.estado_solicitud == 'P' ? 'Pendiente' : 
                                              a.estado_solicitud == 'R' ? 'Rechazado' : 'Entrevista'}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-outline-info" title="Gestionar Progreso"
                                                data-id="${a.idadopcion}" 
                                                data-estado="${a.estado_solicitud}" 
                                                data-comentario="<c:out value='${a.comentarios}'/>"
                                                onclick="abrirModalEstado(this)">
                                            <i class="bi bi-arrow-repeat"></i> Gestionar
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty listaAdopciones}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No hay solicitudes de adopción registradas aún.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
                    
    <div class="modal fade" id="modalEstado" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title fw-bold"><i class="bi bi-card-checklist"></i> Seguimiento de Adopción</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/AdopcionServlet" method="POST" onsubmit="document.getElementById('modalSelectEstado').disabled = false;">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accion" value="actualizarEstado">
                        <input type="hidden" id="modalIdAdopcion" name="idadopcion">

                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Etapa del Proceso</label>
                            <select id="modalSelectEstado" name="estado_solicitud" class="form-select border-info" required>
                                <option value="P">1. Pendiente</option>
                                <option value="E">2. Entrevista</option>
                                <option value="A">3. Aprobado (Finalizado)</option>
                                <option value="R">3. Rechazado (Finalizado)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Bitácora / Comentarios</label>
                            <textarea id="modalComentarios" name="comentarios" class="form-control" rows="5" placeholder="Añade detalles sobre la entrevista, evaluación del hogar, motivos de rechazo..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-info text-white fw-bold">Actualizar Progreso</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
                    
</div>
                    
<script>
    // Variable global para manejar el buscador
    var buscadorMascota;

    // Inicializar el buscador visual cuando carga la página
    window.addEventListener('DOMContentLoaded', function() {
        buscadorMascota = new TomSelect("#mascotaAdopcion", {
            create: false,
            sortField: { field: "text", direction: "asc" },
            placeholder: "Esperando especie..."
        });
    });

    // Función que se dispara al cambiar la Especie
    function cargarMascotasAdopcion() {
        var idEspecie = document.getElementById("especieAdopcion").value;
        var selectMascota = document.getElementById("mascotaAdopcion");

        if (idEspecie === "") {
            buscadorMascota.destroy();
            selectMascota.innerHTML = "<option value=''>Primero seleccione especie...</option>";
            buscadorMascota = new TomSelect("#mascotaAdopcion", { create: false, placeholder: "Esperando especie..." });
            return;
        }

        // Llamada AJAX al Servlet
        fetch("${pageContext.request.contextPath}/AdopcionServlet?accion=cargarMascotas&idespecie=" + idEspecie)
            .then(response => response.text())
            .then(html => {
                // Destruimos el buscador actual, metemos el HTML nuevo y lo recreamos
                buscadorMascota.destroy();
                selectMascota.innerHTML = html;
                buscadorMascota = new TomSelect("#mascotaAdopcion", {
                    create: false,
                    sortField: { field: "text", direction: "asc" },
                    placeholder: "Busca o selecciona una mascota..."
                });
            })
            .catch(error => console.error('Error al cargar mascotas:', error));
    }
    
    function abrirModalEstado(boton) {
        // 1. Extraemos los datos que escondimos en el botón
        var id = boton.getAttribute('data-id');
        var estado = boton.getAttribute('data-estado');
        var comentario = boton.getAttribute('data-comentario');
        
        // 2. Inyectamos la información en los inputs del Modal
        document.getElementById('modalIdAdopcion').value = id;
        document.getElementById('modalSelectEstado').value = estado;
        document.getElementById('modalComentarios').value = comentario;
        
        // 3. Forzamos a que el modal aparezca en pantalla
        var modal = new bootstrap.Modal(document.getElementById('modalEstado'));
        modal.show();
    }
    
    function buscarAdoptante() {
        var tipo = document.getElementById("tipodoc").value;
        var nro = document.getElementById("nrodoc").value;

        if (nro.trim() === "") {
            alert("Por favor, ingresa el número de documento antes de buscar.");
            return;
        }

        // Hacemos la consulta en segundo plano al Servlet
        fetch("${pageContext.request.contextPath}/AdopcionServlet?accion=buscarPersona&tipodoc=" + tipo + "&nrodoc=" + nro)
            .then(response => response.json())
            .then(data => {
                if (data.encontrado) {
                    // Autocompletar campos
                    document.getElementById("nombres").value = data.nombres;
                    document.getElementById("apellidos").value = data.apellidos;
                    document.getElementById("fechanac").value = data.fechanac;
                    document.getElementById("telefono").value = data.telefono;
                    document.getElementById("correo").value = data.correo;
                } else {
                    // Alerta y limpieza de campos
                    alert("Persona no registrada en el sistema. Procede a ingresar sus datos manualmente.");
                    document.getElementById("nombres").value = "";
                    document.getElementById("apellidos").value = "";
                    document.getElementById("fechanac").value = "";
                    document.getElementById("telefono").value = "";
                    document.getElementById("correo").value = "";
                }
            })
            .catch(error => console.error('Error en la búsqueda:', error));
    }
    
    function abrirModalEstado(boton) {
        // 1. Extraemos los datos que escondimos en el botón
        var id = boton.getAttribute('data-id');
        var estado = boton.getAttribute('data-estado');
        var comentario = boton.getAttribute('data-comentario');
        
        // 2. Inyectamos la información en los inputs del Modal
        document.getElementById('modalIdAdopcion').value = id;
        
        var selectEstado = document.getElementById('modalSelectEstado');
        selectEstado.value = estado;
        
        document.getElementById('modalComentarios').value = comentario;
        
        // 3. Lógica de bloqueo (Si es Aprobado 'A' o Rechazado 'R')
        if (estado === 'A' || estado === 'R') {
            selectEstado.disabled = true;
        } else {
            selectEstado.disabled = false; // Nos aseguramos de habilitarlo si abren uno pendiente
        }
        
        // 4. Forzamos a que el modal aparezca en pantalla
        var modal = new bootstrap.Modal(document.getElementById('modalEstado'));
        modal.show();
    }
</script>