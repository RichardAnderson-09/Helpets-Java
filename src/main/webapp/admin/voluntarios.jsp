<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Gestión de Voluntarios</h2>
        <p class="text-muted">Administra las incorporaciones de apoyo y el aprovisionamiento de accesos.</p>
    </div>
</div>

<div class="row g-4">
    
    <!-- REGISTRAR DE VOLUNTARIOS -->
    <div class="col-lg-4">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-primary text-white fw-bold">
                <i class="bi bi-person-plus"></i> Registrar Voluntario
            </div>
            <div class="card-body bg-light">
                <form action="${pageContext.request.contextPath}/VoluntarioServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">1. Datos Personales</h6>
                    <div class="row g-2 mb-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Tipo Doc.</label>
                            <select id="tipodoc" name="tipodoc" class="form-select form-select-sm" required>
                                <option value="DNI">DNI</option>
                                <option value="CE">CE</option>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Número Documento</label>
                            <div class="input-group input-group-sm">
                                <input type="text" id="nrodoc" name="nrodoc" class="form-control" required>
                                <button class="btn btn-outline-secondary fw-bold" type="button" onclick="buscarPersonaAsincrona()">
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
                            <label class="form-label small fw-semibold">Correo Electrónico</label>
                            <input type="email" id="correo" name="correo" class="form-control form-control-sm">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold">Departamento</label>
                            <select id="cboDepartamento" class="form-select" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="dep" items="${listaDepartamentos}">
                                    <option value="${dep.iddepartamento}">${dep.departamento}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold">Provincia</label>
                            <select id="cboProvincia" class="form-select" required disabled>
                                <option value="">Seleccione...</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold">Distrito</label>
                            <select id="cboDistrito" name="iddistrito" class="form-select" required disabled>
                                <option value="">Seleccione...</option>
                            </select>
                        </div>
                    </div>

                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">2. Cuenta y Periodo</h6>
                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Nombre de Usuario</label>
                            <input type="text" name="nombreusuario" class="form-control form-control-sm" placeholder="Ej: v_marta" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Contraseña Inicial</label>
                            <input type="password" name="contraseña" class="form-control form-control-sm" placeholder="********" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Fecha de Inicio</label>
                            <input type="date" name="fechainicio" class="form-control form-control-sm" required>
                        </div>
                    </div>

                    <div class="d-grid mt-3">
                        <button type="submit" class="btn btn-success fw-bold">
                            <i class="bi bi-save"></i> Guardar e Incorporar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
                   
    <!-- LISTA DE VOLUNTARIOS -->
    <div class="col-lg-8">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-dark text-white fw-bold">
                <i class="bi bi-list-stars"></i> Staff de Voluntarios Registrados
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-3">Voluntario</th>
                                <th>Usuario</th>
                                <th>Periodo de Apoyo</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="v" items="${listaVoluntarios}">
                                <tr>
                                    <td class="px-3">
                                        <div class="fw-bold">${v.nombres} ${v.apellidos}</div>
                                        <small class="text-muted">${v.tipodoc}: ${v.nrodoc}</small>
                                    </td>
                                    <td><span class="badge bg-secondary">${v.nombreusuario}</span></td>
                                    <td>
                                        <small class="d-block"><strong>Inicio:</strong> ${v.fechainicio}</small>
                                        <small class="d-block"><strong>Fin:</strong> ${v.fechafin != null ? v.fechafin : 'Indefinido'}</small>
                                    </td>
                                    <td>
                                        <span class="badge ${v.estadoVoluntario == 'A' ? 'bg-success' : 'bg-danger'}">
                                            ${v.estadoVoluntario == 'A' ? 'Activo' : 'Inactivo'}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-primary" 
                                                data-idpersona="${v.idpersona}" data-idusuario="${v.idusuario}"
                                                data-nom="${v.nombres}" data-ape="${v.apellidos}"
                                                data-tel="${v.telefono}" data-corr="${v.correo}" data-user="${v.nombreusuario}"
                                                onclick="abrirModalEdicion(this)" title="Editar Datos y Credenciales">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" 
                                                onclick="confirmarBajaVoluntario(${v.idhistorial}, ${v.idusuario}, '${v.nombres}')"
                                                title="Dar de Baja" ${v.estadoVoluntario == 'I' ? 'disabled' : ''}>
                                            <i class="bi bi-person-x"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaVoluntarios}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <i class="bi bi-people fs-1 d-block mb-2"></i> No se registran voluntarios inscritos aún.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL MODIFICACION VOLUNTARIO -->
<div class="modal fade" id="modalEditarVoluntario" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-person-gear"></i> Modificar Voluntario</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/VoluntarioServlet" method="POST">
                <div class="modal-body bg-light">
                    <input type="hidden" name="accion" value="editar">
                    <input type="hidden" id="editIdPersona" name="idpersona">
                    <input type="hidden" id="editIdUsuario" name="idusuario">
                    
                    <div class="mb-2">
                        <label class="form-label small fw-bold">Nombres</label>
                        <input type="text" id="editNombres" name="nombres" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold">Apellidos</label>
                        <input type="text" id="editApellidos" name="apellidos" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold">Teléfono</label>
                        <input type="text" id="editTelefono" name="telefono" class="form-control form-control-sm">
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold">Correo</label>
                        <input type="email" id="editCorreo" name="correo" class="form-control form-control-sm">
                    </div>
                    <div class="mb-2 border-top pt-2">
                        <label class="form-label small fw-bold text-primary">Nombre de Usuario</label>
                        <input type="text" id="editNombreUsuario" name="nombreusuario" class="form-control form-control-sm text-primary fw-bold" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold text-danger">Nueva Contraseña (Opcional)</label>
                        <input type="password" name="contraseña" class="form-control form-control-sm" placeholder="Dejar en blanco para no cambiar">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success btn-sm fw-bold">Actualizar Datos</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Buscador asíncrono reutilizado
    ChilfFunciona = false;
    function buscarPersonaAsincrona() {
        var tipo = document.getElementById("tipodoc").value;
        var nro = document.getElementById("nrodoc").value;

        if (nro.trim() === "") {
            alert("Por favor, ingresa el número de documento.");
            return;
        }

        fetch("${pageContext.request.contextPath}/VoluntarioServlet?accion=buscarPersona&tipodoc=" + tipo + "&nrodoc=" + nro)
            .then(response => response.json())
            .then(data => {
                if (data.encontrado) {
                    document.getElementById("nombres").value = data.nombres;
                    document.getElementById("apellidos").value = data.apellidos;
                    document.getElementById("fechanac").value = data.fechanac;
                    document.getElementById("telefono").value = data.telefono;
                    document.getElementById("correo").value = data.correo;
                    alert("¡Persona encontrada! Los datos han sido precargados automáticamente.");
                } else {
                    alert("Persona no registrada. Ingresa los datos manualmente.");
                }
            })
            .catch(error => console.error('Error en búsqueda asíncrona:', error));
    }

    // Inyectar al modal
    function abrirModalEdicion(btn) {
        document.getElementById("editIdPersona").value = btn.getAttribute("data-idpersona");
        document.getElementById("editIdUsuario").value = btn.getAttribute("data-idusuario");
        document.getElementById("editNombres").value = btn.getAttribute("data-nom");
        document.getElementById("editApellidos").value = btn.getAttribute("data-ape");
        document.getElementById("editTelefono").value = btn.getAttribute("data-tel");
        document.getElementById("editCorreo").value = btn.getAttribute("data-corr");
        document.getElementById("editNombreUsuario").value = btn.getAttribute("data-user");
        
        var modal = new bootstrap.Modal(document.getElementById('modalEditarVoluntario'));
        modal.show();
    }

    // Alerta de baja vinculada
    function confirmarBajaVoluntario(idHistorial, idUsuario, nombre) {
        if (confirm("¿Estás seguro de dar de baja al voluntario " + nombre + "?\nEsto deshabilitará su cuenta de acceso de forma automática.")) {
            window.location.href = "${pageContext.request.contextPath}/VoluntarioServlet?accion=darDeBaja&idhistorialvol=" + idHistorial + "&idusuario=" + idUsuario;
        }
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        const cboDep = document.getElementById('cboDepartamento');
        const cboProv = document.getElementById('cboProvincia');
        const cboDist = document.getElementById('cboDistrito');

        // Cuando se cambia al Departamento
        cboDep.addEventListener('change', function() {
            const idDep = this.value;

            // Limpiamos y bloqueamos los siguientes combos
            cboProv.innerHTML = '<option value="">Seleccione...</option>';
            cboDist.innerHTML = '<option value="">Seleccione...</option>';
            cboProv.disabled = true;
            cboDist.disabled = true;

            if (idDep) {
                // Hacemos la petición al Servlet que crearemos
                fetch('${pageContext.request.contextPath}/UbigeoServlet?accion=provincias&iddepartamento=' + idDep)
                .then(response => response.json())
                .then(data => {
                    data.forEach(p => {
                        const opt = document.createElement('option');
                        opt.value = p.id;
                        opt.textContent = p.nombre;
                        cboProv.appendChild(opt);
                    });
                    cboProv.disabled = false; // Habilitamos la provincia
                })
                .catch(err => console.error("Error cargando provincias:", err));
            }
        });

        // Cuando cambia la Provincia
        cboProv.addEventListener('change', function() {
            const idProv = this.value;

            cboDist.innerHTML = '<option value="">Seleccione...</option>';
            cboDist.disabled = true;

            if (idProv) {
                fetch('${pageContext.request.contextPath}/UbigeoServlet?accion=distritos&idprovincia=' + idProv)
                .then(response => response.json())
                .then(data => {
                    data.forEach(d => {
                        const opt = document.createElement('option');
                        opt.value = d.id;
                        opt.textContent = d.nombre;
                        cboDist.appendChild(opt);
                    });
                    cboDist.disabled = false; // Habilitamos el distrito
                })
                .catch(err => console.error("Error cargando distritos:", err));
            }
        });
    });
</script>