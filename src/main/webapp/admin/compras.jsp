<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Gestión de Compras y Suministros</h2>
        <p class="text-muted">Registra los gastos y reabastecimiento de inventario del refugio.</p>
    </div>
</div>

<div class="row g-4">
    
    <div class="col-lg-4">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-danger text-white fw-bold">
                <i class="bi bi-cart-plus"></i> Registrar Nueva Compra
            </div>
            <div class="card-body bg-light">
                <form action="${pageContext.request.contextPath}/CompraServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">Detalles de Facturación</h6>
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
                        
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Producto</label>
                            <div class="input-group input-group-sm">
                                <select id="idproducto" name="idproducto" class="form-select" required>
                                    <option value="" data-categoria="">Primero elija categoría...</option>
                                    <c:forEach var="p" items="${listaProductos}">
                                        <option value="${p.idproducto}" data-categoria="${p.categoria}">${p.nombreProducto} (Stock: ${p.stock})</option>
                                    </c:forEach>
                                </select>
                                <button class="btn btn-outline-danger" type="button" data-bs-toggle="modal" data-bs-target="#modalNuevoProducto">
                                    <i class="bi bi-plus-lg"></i>
                                </button>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Cantidad Adquirida</label>
                            <input type="number" name="cantidad" class="form-control form-control-sm" min="1" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Precio Unit. (S/)</label>
                            <input type="number" step="0.01" name="precio_unitario" class="form-control form-control-sm" min="0.01" required>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Fecha de Compra</label>
                            <input type="date" name="fechacompra" class="form-control form-control-sm" required>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Nota / Referencia de boleta</label>
                            <input type="text" name="nota" class="form-control form-control-sm" placeholder="Ej: Factura F001-230">
                        </div>
                    </div>

                    <div class="d-grid mt-2">
                        <button type="submit" class="btn btn-danger fw-bold">
                            <i class="bi bi-save"></i> Guardar Compra
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="col-lg-8">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-dark text-white fw-bold">
                <i class="bi bi-list-ul"></i> Historial de Adquisiciones
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-3">ID</th>
                                <th>Fecha</th>
                                <th>Producto</th>
                                <th class="text-center">Cant.</th>
                                <th class="text-end">P. Unit</th>
                                <th class="text-end px-3">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${listaCompras}">
                                <tr>
                                    <td class="px-3 fw-bold text-muted">#${c.idcompra}</td>
                                    <td>
                                        ${c.fechacompra}<br>
                                        <small class="text-muted"><i class="bi bi-person"></i> ${c.nombreUsuario}</small>
                                    </td>
                                    <td>
                                        <span class="badge bg-danger">${c.nombreProducto}</span>
                                        <div class="small text-muted fst-italic">${c.nota != null ? c.nota : ''}</div>
                                    </td>
                                    <td class="text-center fw-bold">+${c.cantidad}</td>
                                    <td class="text-end">S/ ${c.precioUnitario}</td>
                                    <td class="text-end px-3 fw-bold text-danger">S/ ${c.total}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaCompras}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-cart-x fs-1 d-block mb-2"></i>
                                        No se han registrado compras aún.
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
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-box-seam"></i> Añadir Nuevo Producto</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body bg-light">
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">Nombre del Producto</label>
                    <input type="text" id="nuevoNombreProducto" class="form-control" placeholder="Ej: Jeringas, Desparasitante...">
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
                <button type="button" class="btn btn-danger fw-bold" onclick="guardarNuevoProducto()">Guardar Producto</button>
            </div>
        </div>
    </div>
</div>

<script>
    var todasLasOpcionesProductos = [];

    window.addEventListener('DOMContentLoaded', function() {
        var selectProd = document.getElementById("idproducto");
        todasLasOpcionesProductos = Array.from(selectProd.options);
    });

    // Función para el desplegable en cascada
    function filtrarProductosPorCategoria() {
        var catSeleccionada = document.getElementById("categoriaFiltro").value;
        var selectProd = document.getElementById("idproducto");
        
        selectProd.innerHTML = "";
        
        todasLasOpcionesProductos.forEach(function(option) {
            var catOption = option.getAttribute("data-categoria");
            if (catSeleccionada === "" || catOption === "" || catOption === catSeleccionada) {
                selectProd.appendChild(option.cloneNode(true));
            }
        });
        
        selectProd.value = ""; 
    }

    // Función AJAX para procesar el modal apuntando a CompraServlet
    function guardarNuevoProducto() {
        var nombre = document.getElementById("nuevoNombreProducto").value;
        var categoria = document.getElementById("nuevaCategoriaProducto").value;
        
        if (nombre.trim() === "") {
            alert("Por favor, ingrese el nombre del producto.");
            return;
        }
        
        var params = new URLSearchParams();
        params.append("accion", "registrarProducto");
        params.append("nombre_producto", nombre);
        params.append("categoria", categoria);
        
        // Aquí apuntamos a CompraServlet
        fetch("${pageContext.request.contextPath}/CompraServlet", {
            method: "POST",
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if (data.exito) {
                var nuevaOpt = document.createElement("option");
                nuevaOpt.value = data.idproducto;
                // En compras mostramos el stock (que al ser nuevo, es 0)
                nuevaOpt.text = data.nombre + " (Stock: " + data.stock + ")";
                nuevaOpt.setAttribute("data-categoria", data.categoria);
                
                todasLasOpcionesProductos.push(nuevaOpt);
                
                var catFiltroActual = document.getElementById("categoriaFiltro").value;
                if (catFiltroActual === "" || catFiltroActual === data.categoria) {
                    var selectProd = document.getElementById("idproducto");
                    selectProd.appendChild(nuevaOpt.cloneNode(true));
                    selectProd.value = data.idproducto; 
                }
                
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
</script>