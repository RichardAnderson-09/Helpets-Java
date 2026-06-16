<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Gestión de Donaciones (Materiales)</h2>
        <p class="text-muted">Registra los ingresos de productos y donantes al almacén.</p>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-4">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-primary text-white fw-bold">
                <i class="bi bi-box-seam"></i> Registrar Donación
            </div>
            <div class="card-body bg-light">
                <form action="${pageContext.request.contextPath}/DonacionServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <input type="hidden" name="tipodonacion" value="MATERIAL">
                    
                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">1. Datos del Donante</h6>
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
                                <button class="btn btn-outline-secondary fw-bold" type="button" onclick="buscarDonante()">
                                    <i class="bi bi-search"></i>
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
                            <label class="form-label small fw-semibold">Teléfono</label>
                            <input type="text" id="telefono" name="telefono" class="form-control form-control-sm">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Correo</label>
                            <input type="email" id="correo" name="correo" class="form-control form-control-sm">
                        </div>
                    </div>

                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">2. Detalle de los Materiales</h6>
                    <div class="row g-2 mb-4">
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Categoría del Producto</label>
                            <select id="categoriaFiltro" class="form-select form-select-sm" onchange="filtrarProductosPorCategoria()" required>
                                <option value="">Seleccione categoría...</option>
                                <option value="Material">Material</option>
                                <option value="Alimento">Alimento</option>
                                <option value="Medicamento">Medicamento</option>
                            </select>
                        </div>

                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Producto</label>
                            <div class="input-group input-group-sm">
                                <select id="idproducto" name="idproducto" class="form-select" required>
                                    <option value="" data-categoria="">Primero elija categoría...</option>
                                    <c:forEach var="p" items="${listaProductos}">
                                        <option value="${p.idproducto}" data-categoria="${p.categoria}">${p.nombreProducto}</option>
                                    </c:forEach>
                                </select>
                                <button class="btn btn-outline-primary" type="button" data-bs-toggle="modal" data-bs-target="#modalNuevoProducto">
                                    <i class="bi bi-plus-lg"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Cantidad</label>
                            <input type="number" name="cantidad" class="form-control form-control-sm" min="1" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Fecha Donación</label>
                            <input type="date" name="fechadonacion" class="form-control form-control-sm" required>
                        </div>
                    </div>
                    
                    <div class="d-grid mt-2">
                        <button type="submit" class="btn btn-success fw-bold">
                            <i class="bi bi-save"></i> Registrar Ingreso
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="col-lg-8">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-list-ul"></i> Historial de Donaciones Materiales</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-3"># ID</th>
                                <th>Donante</th>
                                <th>Fecha</th>
                                <th>Tipo</th>
                                <th>Detalle / Producto</th>
                                <th class="text-center">Cantidad / Importe</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${listaDonaciones}">
                                <tr>
                                    <td class="px-3 fw-bold text-muted">#${d.iddonacion}</td>
                                    <td>
                                        <div class="fw-semibold">${d.nombreDonante}</div>
                                        <small class="text-muted"><i class="bi bi-telephone"></i> ${d.telefonoDonante}</small>
                                    </td>
                                    <td>${d.fechadonacion}</td>
                                    <td>
                                        <span class="badge ${d.tipodonacion == 'MATERIAL' ? 'bg-primary' : 'bg-success'}">
                                            ${d.tipodonacion}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.tipodonacion == 'MATERIAL'}">
                                                <span class="badge bg-info text-dark">${d.nombreProducto}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Aporte Económico</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center fw-bold">
                                        <c:choose>
                                            <c:when test="${d.tipodonacion == 'MATERIAL'}">
                                                <span class="text-success">+${d.cantidad} und.</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-primary">S/ ${d.monto}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty listaDonaciones}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No hay donaciones registradas en el sistema aún.
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
                    
                    <div class="modal fade" id="modalNuevoProducto" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-box-seam"></i> Añadir Nuevo Producto</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body bg-light">
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">Nombre del Producto</label>
                    <input type="text" id="nuevoNombreProducto" class="form-control" placeholder="Ej: Mantas polares, Ricocan Cachorros 3kg">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">Categoría del Producto</label>
                    <select id="nuevaCategoriaProducto" class="form-select">
                        <option value="Material">Material</option>
                        <option value="Alimento">Alimento</option>
                        <option value="Medicamento">Medicamento</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary fw-bold" onclick="guardarNuevoProducto()">Guardar Producto</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Variable global para respaldar la lista completa de opciones del select original
    var todasLasOpcionesProductos = [];

    window.addEventListener('DOMContentLoaded', function() {
        // Al cargar la página, respaldamos todas las opciones de productos que vinieron de la BD
        var selectProd = document.getElementById("idproducto");
        todasLasOpcionesProductos = Array.from(selectProd.options);
    });

    // Función para el desplegable en cascada
    function filtrarProductosPorCategoria() {
        var catSeleccionada = document.getElementById("categoriaFiltro").value;
        var selectProd = document.getElementById("idproducto");

        // Limpiamos el selector de productos
        selectProd.innerHTML = "";

        // Evaluamos y repoblamos solo las opciones correspondientes
        todasLasOpcionesProductos.forEach(function(option) {
            var catOption = option.getAttribute("data-categoria");
            if (catSeleccionada === "" || catOption === "" || catOption === catSeleccionada) {
                selectProd.appendChild(option.cloneNode(true));
            }
        });

        selectProd.value = ""; // Reseteamos la selección activa
    }

    // Función AJAX para procesar el modal de nuevo producto
    function guardarNuevoProducto() {
        var nombre = document.getElementById("nuevoNombreProducto").value;
        var categoria = document.getElementById("nuevaCategoriaProducto").value;

        if (nombre.trim() === "") {
            alert("Por favor, ingrese el nombre del producto.");
            return;
        }

        // Construimos los parámetros URL-encoded para el POST del servlet
        var params = new URLSearchParams();
        params.append("accion", "registrarProducto");
        params.append("nombre_producto", nombre);
        params.append("categoria", categoria);

        fetch("${pageContext.request.contextPath}/DonacionServlet", {
            method: "POST",
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if (data.exito) {
                // 1. Instanciamos la nueva opción dinámica en memoria
                var nuevaOpt = document.createElement("option");
                nuevaOpt.value = data.idproducto;
                nuevaOpt.text = data.nombre;
                nuevaOpt.setAttribute("data-categoria", data.categoria);

                // 2. Insertamos la opción en nuestro arreglo global de respaldo para persistirla
                todasLasOpcionesProductos.push(nuevaOpt);

                // 3. Si coincide con el filtro activo en pantalla (o el filtro está vacío), lo agregamos visualmente
                var catFiltroActual = document.getElementById("categoriaFiltro").value;
                if (catFiltroActual === "" || catFiltroActual === data.categoria) {
                    var selectProd = document.getElementById("idproducto");
                    selectProd.appendChild(nuevaOpt.cloneNode(true));
                    selectProd.value = data.idproducto; // Lo dejamos seleccionado automáticamente
                }

                // Limpiamos el modal y lo cerramos usando la API nativa de Bootstrap
                document.getElementById("nuevoNombreProducto").value = "";
                var modalElement = document.getElementById('modalNuevoProducto');
                var modalInstance = bootstrap.Modal.getInstance(modalElement);
                modalInstance.hide();

                alert("¡Producto creado y añadido con éxito!");
            } else {
                alert("No se pudo registrar el producto en el sistema.");
            }
        })
        .catch(error => console.error('Error en el registro del producto:', error));
    }
    
    
    // Reutilizamos la misma lógica de búsqueda AJAX de Adopciones para autocompletar al Donante
    function buscarDonante() {
        var tipo = document.getElementById("tipodoc").value;
        var nro = document.getElementById("nrodoc").value;

        if (nro.trim() === "") {
            alert("Por favor, ingresa el número de documento.");
            return;
        }

        // Hacemos la consulta al Servlet de Adopciones que ya tiene este método para la tabla 'Personas'
        fetch("${pageContext.request.contextPath}/AdopcionServlet?accion=buscarPersona&tipodoc=" + tipo + "&nrodoc=" + nro)
            .then(response => response.json())
            .then(data => {
                if (data.encontrado) {
                    document.getElementById("nombres").value = data.nombres;
                    document.getElementById("apellidos").value = data.apellidos;
                    document.getElementById("telefono").value = data.telefono;
                    document.getElementById("correo").value = data.correo;
                } else {
                    alert("Nuevo donante. Ingresa sus datos manualmente.");
                    document.getElementById("nombres").value = "";
                    document.getElementById("apellidos").value = "";
                    document.getElementById("telefono").value = "";
                    document.getElementById("correo").value = "";
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>