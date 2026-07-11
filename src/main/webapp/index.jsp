<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Helpets - Adopta un amigo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/inicio">🐾 HELPETS</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#loginModal">
                            <i class="bi bi-person-fill"></i> Iniciar Sesión
                        </button>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <c:if test="${not empty mensajeExito}">
            <div class="alert alert-success alert-dismissible fade show text-center fw-bold shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill"></i> ${mensajeExito}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="mensajeExito" scope="session" />
        </c:if>

        <c:if test="${not empty errorRegistro}">
            <div class="alert alert-danger alert-dismissible fade show text-center fw-bold shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${errorRegistro}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorRegistro" scope="session" />
        </c:if>
        <div class="text-center mb-5">
            <h1 class="display-4 fw-bold text-dark">¡Encuentra a tu nuevo mejor amigo!</h1>
            <p class="lead text-muted">Explora nuestro catálogo de peluditos esperando un hogar lleno de amor.</p>
        </div>
        
        <div class="row mt-5 p-5 bg-white border rounded shadow-sm text-center">
            <div class="col text-muted">
                <div class="row row-cols-1 row-cols-md-3 g-4 mt-3">
                    <c:forEach var="m" items="${listaCatalogo}">
                        <div class="col">
                            <div class="card h-100 shadow-sm animal-card">
                                <img src="${pageContext.request.contextPath}/assets/img/${m.foto}" class="card-img-top" alt="${m.nombre}" style="height: 250px; object-fit: cover;">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title fw-bold text-primary">${m.nombre}</h5>
                                    <p class="card-text text-muted mb-3">${m.nombreEspecie} • ${m.nombreRaza}<br>
                                       Sexo: ${m.sexo == 'M' ? 'Macho' : 'Hembra'}
                                    </p>
                                    <button type="button" class="btn btn-primary w-100 mt-auto fw-bold" data-bs-toggle="modal" data-bs-target="#registroModal">
                                        ¡Adóptame!
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty listaCatalogo}">
                        <div class="col-12 text-center py-5">
                            <h5 class="text-muted">Aún no hay peluditos disponibles en este momento.</h5>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL INICIO DE SESION -->
    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fw-bold" id="loginModalLabel">🐾 Acceso del Personal</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                        <div class="mb-3">
                            <label for="usuario" class="form-label text-muted fw-bold">Nombre de Usuario</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="usuario" name="usuario" placeholder="Usuario" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label text-muted fw-bold">Contraseña</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="********" required>
                            </div>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger text-center p-2 mb-3" role="alert">
                                ${error}
                            </div>
                            <c:remove var="error" scope="session" />
                            <script>
                                window.addEventListener('DOMContentLoaded', function() {
                                    var loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
                                    loginModal.show();
                                });
                            </script>
                        </c:if>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary fw-bold py-2">Ingresar al Sistema</button>
                        </div>

                        <hr class="my-3 text-muted">
                        <div class="text-center">
                            <p class="text-muted mb-2 small">¿Aún no tienes cuenta para adoptar?</p>
                            <button type="button" class="btn btn-outline-success fw-bold w-100" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#registroModal">
                                Crear una cuenta
                            </button>
                        </div>
                    </form>
                </div>
                
            </div>
        </div>
    </div>
            
    <!-- MODAL REGISTRO DE USUARIO -->
    <div class="modal fade" id="registroModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="bi bi-person-plus-fill"></i> Crear Cuenta para Adoptar</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/UsuarioServlet" method="POST">
                        <input type="hidden" name="accion" value="registrar">
                        <input type="hidden" name="idrol" value="4"> 

                        <div class="row g-3">
                            <h6 class="text-muted border-bottom pb-2 mb-3">Datos Personales</h6>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Tipo Doc.</label>
                                <select name="tipodoc" class="form-select" required>
                                    <option value="DNI">DNI</option>
                                    <option value="CE">CE</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Nro. Documento</label>
                                <input type="text" name="nrodoc" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Nombres</label>
                                <input type="text" name="nombres" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Apellidos</label>
                                <input type="text" name="apellidos" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Teléfono</label>
                                <input type="text" name="telefono" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Correo Electrónico</label>
                                <input type="email" name="correo" class="form-control">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label text-muted fw-bold">Fecha de Nacimiento</label>
                                <input type="date" name="fechanac" class="form-control">
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
                            
                            <h6 class="text-muted border-bottom pb-2 mt-4 mb-3">Datos de Acceso</h6>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Usuario</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" name="nombreusuario" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold">Contraseña</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" name="contraseña" class="form-control" required>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-success fw-bold py-2">Completar Registro</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<script>
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