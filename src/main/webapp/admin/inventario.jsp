<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Inventario y Almacén</h2>
        <p class="text-muted">Gestión de entradas, salidas y control del stock total del refugio.</p>
    </div>
</div>

<c:if test="${not empty sessionScope.mensaje}">
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.mensaje}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="mensaje" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="error" scope="session"/>
</c:if>

<div class="row g-4">
    
    <div class="col-lg-4">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-primary text-white fw-bold">
                <i class="bi bi-box-arrow-in-right"></i> Registrar Operación
            </div>
            <div class="card-body bg-light">
                <form action="${pageContext.request.contextPath}/InventarioServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">Detalles del Movimiento</h6>
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
                            <select id="idproducto" name="idproducto" class="form-select form-select-sm" required>
                                <option value="" data-categoria="">Primero elija categoría...</option>
                                <c:forEach var="p" items="${listaProductos}">
                                    <option value="${p.idproducto}" data-categoria="${p.categoria}">${p.nombreProducto} (Stock Actual: ${p.stock})</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="col-md-7">
                            <label class="form-label small fw-semibold">Tipo de Ajuste</label>
                            <select name="tipooperacion" class="form-select form-select-sm" required>
                                <option value="E">Entrada (Suma Stock)</option>
                                <option value="S">Salida (Resta Stock)</option>
                            </select>
                        </div>

                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">Cantidad</label>
                            <input type="number" name="cantidad" class="form-control form-control-sm" min="1" required>
                        </div>
                        
                    </div>

                    <div class="d-grid mt-2">
                        <button type="submit" class="btn btn-primary fw-bold">
                            <i class="bi bi-save"></i> Procesar Movimiento
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="col-lg-8">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-boxes"></i> Stock Total de Almacén</span>
                <button class="btn btn-sm btn-outline-light" data-bs-toggle="modal" data-bs-target="#modalHistorial">
                    <i class="bi bi-clock-history"></i> Ver Kardex Completo
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-3">Cód.</th>
                                <th>Producto</th>
                                <th>Categoría</th>
                                <th class="text-center">Stock Actual</th>
                                <th class="text-center px-3">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${listaProductos}">
                                <tr>
                                    <td class="px-3 text-muted fw-bold">#${p.idproducto}</td>
                                    <td class="fw-semibold">${p.nombreProducto}</td>
                                    <td><span class="badge bg-secondary">${p.categoria}</span></td>
                                    <td class="text-center fs-6 fw-bold">${p.stock}</td>
                                    <td class="text-center px-3">
                                        <c:choose>
                                            <c:when test="${p.stock == 0}">
                                                <span class="badge bg-danger">Agotado</span>
                                            </c:when>
                                            <c:when test="${p.stock <= 5}">
                                                <span class="badge bg-warning text-dark">Crítico</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">Abastecido</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaProductos}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <i class="bi bi-inboxes fs-1 d-block mb-2"></i>
                                        No hay productos registrados en el inventario.
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

<div class="modal fade" id="modalHistorial" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-journal-text"></i> Historial de Movimientos (Kardex)</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body bg-light">
                
                <div class="mb-3 text-center">
                    <div class="btn-group shadow-sm" role="group">
                        <button type="button" class="btn btn-outline-secondary active btn-filtro" onclick="filtrarKardex('TODOS', this)">Todos</button>
                        <button type="button" class="btn btn-outline-success btn-filtro" onclick="filtrarKardex('E', this)"><i class="bi bi-arrow-down-circle"></i> Entradas</button>
                        <button type="button" class="btn btn-outline-danger btn-filtro" onclick="filtrarKardex('S', this)"><i class="bi bi-arrow-up-circle"></i> Salidas</button>
                    </div>
                </div>

                <div class="table-responsive bg-white border rounded">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-3">Fecha</th>
                                <th>Producto</th>
                                <th class="text-center">Operación</th>
                                <th class="text-center">Cant.</th>
                                <th class="px-3">Registrado por</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mov" items="${listaMovimientos}">
                                <tr class="fila-movimiento" data-tipo="${mov.tipooperacion}">
                                    <td class="px-3 small text-muted">${mov.fecharegistro}</td>
                                    <td class="fw-semibold">${mov.nombreProducto}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${mov.tipooperacion == 'E'}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success">ENTRADA</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger">SALIDA</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center fw-bold ${mov.tipooperacion == 'E' ? 'text-success' : 'text-danger'}">
                                        ${mov.tipooperacion == 'E' ? '+' : '-'}${mov.cantidad}
                                    </td>
                                    <td class="px-3 small text-muted"><i class="bi bi-person"></i> ${mov.nombreUsuario}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaMovimientos}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        No hay movimientos registrados.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<script>
    // -------------------------------------------------------------
    // 1. LÓGICA DE FILTRADO POR CATEGORÍA (Tomado de tu compra.jsp)
    // -------------------------------------------------------------
    var todasLasOpcionesInventario = [];
    
    window.addEventListener('DOMContentLoaded', function() {
        var selectProd = document.getElementById("idproducto");
        if(selectProd) {
            todasLasOpcionesInventario = Array.from(selectProd.options);
        }
    });

    function filtrarProductosPorCategoria() {
        var catSeleccionada = document.getElementById("categoriaFiltro").value;
        var selectProd = document.getElementById("idproducto");
        
        selectProd.innerHTML = "";
        
        todasLasOpcionesInventario.forEach(function(option) {
            var catOption = option.getAttribute("data-categoria");
            if (catSeleccionada === "" || catOption === "" || catOption === catSeleccionada) {
                selectProd.appendChild(option.cloneNode(true));
            }
        });
        selectProd.value = ""; 
    }

    // -------------------------------------------------------------
    // 2. LÓGICA DE FILTRADO PARA EL KARDEX EN EL MODAL
    // -------------------------------------------------------------
    function filtrarKardex(tipo, boton) {
        // Estilos del botón activo
        var botones = document.querySelectorAll('.btn-filtro');
        botones.forEach(b => b.classList.remove('active'));
        boton.classList.add('active');

        // Filtrado de filas
        var filas = document.querySelectorAll('.fila-movimiento');
        filas.forEach(fila => {
            var tipoFila = fila.getAttribute('data-tipo');
            if (tipo === 'TODOS' || tipo === tipoFila) {
                fila.style.display = '';
            } else {
                fila.style.display = 'none';
            }
        });
    }
</script>