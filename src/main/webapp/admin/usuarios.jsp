<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Gestión de Usuarios del Sistema</h2>
        <p class="text-muted">Administra el acceso de administradores, veterinarios y personal.</p>
    </div>
</div>

<div class="row g-4">
    
    <!-- REGISTRO DE USUARIOS -->
    <div class="col-lg-4">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-dark text-white fw-bold">
                <i class="bi bi-person-plus"></i> Registrar Usuario
            </div>
            <div class="card-body bg-light">
                <form action="${pageContext.request.contextPath}/UsuarioServlet" method="POST">
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

                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">2. Credenciales y Acceso</h6>
                    <div class="row g-2 mb-3">
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold text-primary">Rol del Sistema</label>
                            <select name="idrol" class="form-select form-select-sm border-primary" required>
                                <option value="">Seleccione el rol de acceso...</option>
                                <option value="1">Administrador</option>
                                <option value="3">Veterinario</option>
                                <option value="4">Usuario Común</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Nombre de Usuario</label>
                            <input type="text" name="nombreusuario" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Contraseña Inicial</label>
                            <input type="password" name="contraseña" class="form-control form-control-sm" required>
                        </div>
                    </div>

                    <div class="d-grid mt-3">
                        <button type="submit" class="btn btn-dark fw-bold">
                            <i class="bi bi-save"></i> Guardar Usuario
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- LISTA DE USUARIOS -->
    <div class="col-lg-8">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-dark text-white fw-bold">
                <i class="bi bi-person-lines-fill"></i> Lista de Usuarios Activos
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-3">Persona</th>
                                <th>Usuario y Rol</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${listaUsuarios}">
                                <tr>
                                    <td class="px-3">
                                        <div class="fw-bold">${u.nombresPersona} ${u.apellidosPersona}</div>
                                        <small class="text-muted">${u.tipodoc}: ${u.nrodoc}</small>
                                    </td>
                                    <td>
                                        <div class="fw-semibold text-primary">@${u.nombreusuario}</div>
                                        <span class="badge bg-secondary">${u.nombreRol}</span>
                                    </td>
                                    <td>
                                        <span class="badge ${u.estado == 'A' ? 'bg-success' : 'bg-danger'}">
                                            ${u.estado == 'A' ? 'Activo' : 'Inactivo'}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-primary" 
                                                data-idpersona="${u.idpersona}" data-idusuario="${u.idusuario}" data-idrol="${u.idrol}"
                                                data-nom="${u.nombresPersona}" data-ape="${u.apellidosPersona}"
                                                data-tel="${u.telefono}" data-corr="${u.correo}" data-user="${u.nombreusuario}"
                                                onclick="abrirModalEdicion(this)" title="Editar Datos">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" 
                                                onclick="confirmarBajaUsuario(${u.idusuario}, '${u.nombreusuario}')"
                                                title="Dar de Baja" ${u.estado == 'I' ? 'disabled' : ''}>
                                            <i class="bi bi-person-x"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaUsuarios}">
                                <tr><td colspan="4" class="text-center py-5 text-muted">No hay usuarios registrados.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL DE MODIFICACION DE USUARIOS -->
<div class="modal fade" id="modalEditarUsuario" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-person-gear"></i> Modificar Usuario</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/UsuarioServlet" method="POST">
                <div class="modal-body bg-light">
                    <input type="hidden" name="accion" value="editar">
                    <input type="hidden" id="editIdPersona" name="idpersona">
                    <input type="hidden" id="editIdUsuario" name="idusuario">
                    
                    <div class="mb-2">
                        <label class="form-label small fw-bold">Nombres y Apellidos</label>
                        <div class="input-group input-group-sm">
                            <input type="text" id="editNombres" name="nombres" class="form-control" required>
                            <input type="text" id="editApellidos" name="apellidos" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold">Teléfono / Correo</label>
                        <div class="input-group input-group-sm">
                            <input type="text" id="editTelefono" name="telefono" class="form-control">
                            <input type="email" id="editCorreo" name="correo" class="form-control">
                        </div>
                    </div>                    
                    <div class="mb-2 border-top pt-2 mt-3">
                        <label class="form-label small fw-bold text-primary">Rol Asignado</label>
                        <select id="editIdRol" name="idrol" class="form-select form-select-sm border-primary" required>
                            <option value="1">Administrador</option>
                            <option value="3">Veterinario</option>
                            <option value="4">Usuario Común</option>
                        </select>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold text-primary">Nombre de Usuario</label>
                        <input type="text" id="editNombreUsuario" name="nombreusuario" class="form-control form-control-sm fw-bold" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold text-danger">Nueva Contraseña (Opcional)</label>
                        <input type="password" name="contraseña" class="form-control form-control-sm" placeholder="Dejar en blanco para no cambiar">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-dark btn-sm fw-bold">Actualizar Datos</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function buscarPersonaAsincrona() {
        var tipo = document.getElementById("tipodoc").value;
        var nro = document.getElementById("nrodoc").value;
        if (nro.trim() === "") { alert("Por favor, ingresa el número de documento."); return; }

        fetch("${pageContext.request.contextPath}/UsuarioServlet?accion=buscarPersona&tipodoc=" + tipo + "&nrodoc=" + nro)
            .then(response => response.json())
            .then(data => {
                if (data.encontrado) {
                    document.getElementById("nombres").value = data.nombres;
                    document.getElementById("apellidos").value = data.apellidos;
                    document.getElementById("fechanac").value = data.fechanac;
                    document.getElementById("telefono").value = data.telefono;
                    document.getElementById("correo").value = data.correo;
                } else {
                    alert("Persona no registrada. Ingresa los datos manualmente.");
                }
            }).catch(error => console.error('Error:', error));
    }

    function abrirModalEdicion(btn) {
        document.getElementById("editIdPersona").value = btn.getAttribute("data-idpersona");
        document.getElementById("editIdUsuario").value = btn.getAttribute("data-idusuario");
        document.getElementById("editIdRol").value = btn.getAttribute("data-idrol");
        document.getElementById("editNombres").value = btn.getAttribute("data-nom");
        document.getElementById("editApellidos").value = btn.getAttribute("data-ape");
        document.getElementById("editTelefono").value = btn.getAttribute("data-tel");
        document.getElementById("editCorreo").value = btn.getAttribute("data-corr");
        document.getElementById("editNombreUsuario").value = btn.getAttribute("data-user");
        new bootstrap.Modal(document.getElementById('modalEditarUsuario')).show();
    }

    function confirmarBajaUsuario(idUsuario, username) {
        if (confirm("¿Seguro que deseas desactivar la cuenta del usuario @" + username + "?")) {
            window.location.href = "${pageContext.request.contextPath}/UsuarioServlet?accion=darDeBaja&idusuario=" + idUsuario;
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