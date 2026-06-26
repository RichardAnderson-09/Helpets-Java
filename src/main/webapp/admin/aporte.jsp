<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="mb-4 text-center">
    <h2 class="fw-bold text-dark">Ayúdanos a seguir salvando vidas</h2>
    <p class="text-muted">Tu contribución nos permite comprar alimento, medicinas y mejorar el refugio.</p>
</div>

<c:if test="${not empty sessionScope.mensaje}">
    <div class="alert alert-success alert-dismissible fade show shadow-sm text-center col-md-8 mx-auto" role="alert">
        <i class="bi bi-heart-fill text-danger me-2"></i> <strong>${sessionScope.mensaje}</strong>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="mensaje" scope="session"/>
</c:if>

<div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
        <div class="card shadow-sm border-0">
            <div class="card-body p-4 p-md-5">
                
                <form action="${pageContext.request.contextPath}/AporteMonetarioServlet" method="POST" id="formDonacion">
                    <input type="hidden" name="accion" value="donar">
                    
                    <h5 class="fw-bold text-dark mb-3">1. Selecciona tu medio de pago</h5>
                    <div class="row g-2 mb-4">
                        <div class="col-4">
                            <input type="radio" class="btn-check" name="metodoPago" id="pagoYape" autocomplete="off" checked>
                            <label class="btn btn-outline-primary w-100 py-3 fw-bold rounded-3" for="pagoYape">
                                <i class="bi bi-phone d-block fs-3 mb-1"></i> Yape
                            </label>
                        </div>
                        <div class="col-4">
                            <input type="radio" class="btn-check" name="metodoPago" id="pagoPlin" autocomplete="off">
                            <label class="btn btn-outline-info w-100 py-3 fw-bold rounded-3" for="pagoPlin">
                                <i class="bi bi-phone-vibrate d-block fs-3 mb-1"></i> Plin
                            </label>
                        </div>
                        <div class="col-4">
                            <input type="radio" class="btn-check" name="metodoPago" id="pagoTransf" autocomplete="off">
                            <label class="btn btn-outline-secondary w-100 py-3 fw-bold rounded-3" for="pagoTransf">
                                <i class="bi bi-bank d-block fs-3 mb-1"></i> Banco
                            </label>
                        </div>
                    </div>

                    <h5 class="fw-bold text-dark mb-3">2. Ingresa el monto a colaborar</h5>
                    <div class="input-group input-group-lg mb-4 shadow-sm">
                        <span class="input-group-text bg-white fw-bold text-success border-end-0">S/</span>
                        <input type="number" name="monto" id="inputMonto" class="form-control border-start-0 fw-bold text-success fs-3" 
                               step="1.00" min="1.00" placeholder="0.00" required>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="button" class="btn btn-success btn-lg fw-bold shadow-sm" onclick="confirmarDonacion()">
                            <i class="bi bi-balloon-heart"></i> Enviar Donativo
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

<script>
    function confirmarDonacion() {
        var monto = document.getElementById("inputMonto").value;
        if(monto === "" || parseFloat(monto) <= 0) {
            alert("Por favor ingresa un monto válido para donar.");
            return;
        }
        
        if(confirm("Estás a punto de registrar una donación por S/ " + parseFloat(monto).toFixed(2) + ".\n¿Deseas confirmar la transacción?")) {
            document.getElementById("formDonacion").submit();
        }
    }
</script>

<style>
    /* Estilos para que los botones de pago visuales destaquen al ser seleccionados */
    .btn-check:checked + .btn-outline-primary { background-color: #742581; color: white; border-color: #742581; } /* Color Yape */
    .btn-check:checked + .btn-outline-info { background-color: #00D1CA; color: white; border-color: #00D1CA; } /* Color Plin */
</style>