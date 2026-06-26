<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="mb-4">
    <h2 class="fw-bold text-dark">Adopta a tu nuevo mejor amigo</h2>
    <p class="text-muted">Conoce a nuestras mascotas que están esperando un hogar lleno de amor.</p>
</div>

<c:if test="${not empty sessionScope.mensaje}">
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.mensaje}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="mensaje" scope="session"/>
</c:if>

<div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
    <c:forEach var="m" items="${listaCatalogo}">
        <div class="col">
            <div class="card h-100 shadow-sm border-0 animal-card" 
                 onclick="abrirModalDetalle('${m.idmascota}', '${m.nombre}', '${m.nombreEspecie}', '${m.nombreRaza}', '${m.sexo}', '${m.fecharescate}', '${m.foto}')" 
                 style="cursor: pointer;">
                
                <img src="${pageContext.request.contextPath}/assets/img/${m.foto}" class="card-img-top" alt="${m.nombre}" style="height: 220px; object-fit: cover;">
                
                <div class="card-body text-center">
                    <h5 class="card-title fw-bold text-primary mb-1">${m.nombre}</h5>
                    <p class="card-text text-muted mb-2">${m.nombreEspecie} • ${m.nombreRaza}</p>
                    <span class="badge ${m.sexo == 'M' ? 'bg-info text-dark' : 'bg-danger bg-opacity-75'} px-3 py-2">
                        ${m.sexo == 'M' ? '<i class="bi bi-gender-male"></i> Macho' : '<i class="bi bi-gender-female"></i> Hembra'}
                    </span>
                </div>
            </div>
        </div>
    </c:forEach>

    <c:if test="${empty listaCatalogo}">
        <div class="col-12 text-center py-5">
            <i class="bi bi-emoji-frown display-1 text-muted d-block mb-3"></i>
            <h4 class="text-muted">Por el momento no tenemos peluditos disponibles para adopción.</h4>
        </div>
    </c:if>
</div>

<div class="modal fade" id="modalDetalleMascota" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-dark text-white border-0">
                <h5 class="modal-title fw-bold"><i class="bi bi-info-circle"></i> Conoce a <span id="modalNombreTit"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            
            <div class="modal-body p-0">
                <img id="modalFoto" src="" class="img-fluid w-100" style="max-height: 350px; object-fit: cover;">
                
                <div class="p-4 bg-white">
                    <h2 id="modalNombre" class="fw-bold text-primary mb-3"></h2>
                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <p class="mb-0 text-muted small text-uppercase fw-bold">Especie</p>
                            <p id="modalEspecie" class="fw-bold fs-5 mb-0 text-dark"></p>
                        </div>
                        <div class="col-6">
                            <p class="mb-0 text-muted small text-uppercase fw-bold">Raza</p>
                            <p id="modalRaza" class="fw-bold fs-5 mb-0 text-dark"></p>
                        </div>
                        <div class="col-6">
                            <p class="mb-0 text-muted small text-uppercase fw-bold">Sexo</p>
                            <p id="modalSexo" class="fw-bold fs-5 mb-0 text-dark"></p>
                        </div>
                        <div class="col-6">
                            <p class="mb-0 text-muted small text-uppercase fw-bold">En el refugio desde</p>
                            <p id="modalRescate" class="fw-bold fs-5 mb-0 text-dark"></p>
                        </div>
                    </div>
                    
                    <div class="alert alert-info border-0 mb-0">
                        <i class="bi bi-info-circle-fill"></i> Al solicitar la adopción, nuestro equipo revisará tu perfil y se pondrá en contacto contigo para coordinar una breve entrevista.
                    </div>
                </div>
            </div>
            
            <div class="modal-footer bg-light border-0">
                <form action="${pageContext.request.contextPath}/CatalogoMascotasServlet" method="POST" id="formAdopcion" class="w-100">
                    <input type="hidden" name="accion" value="solicitarAdopcion">
                    <input type="hidden" name="idmascota" id="modalIdMascota">
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-success fw-bold py-2 fs-5 shadow-sm" onclick="confirmarAdopcion()">
                            <i class="bi bi-house-heart-fill"></i> ¡Quiero Adoptar!
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Función para inyectar los datos en el modal cuando se da clic a una Card
    function abrirModalDetalle(id, nombre, especie, raza, sexo, rescate, foto) {
        document.getElementById("modalIdMascota").value = id;
        document.getElementById("modalNombreTit").innerText = nombre;
        document.getElementById("modalNombre").innerText = nombre;
        document.getElementById("modalEspecie").innerText = especie;
        document.getElementById("modalRaza").innerText = raza;
        document.getElementById("modalSexo").innerHTML = sexo === 'M' ? 'Macho' : 'Hembra';
        document.getElementById("modalRescate").innerText = rescate;
        document.getElementById("modalFoto").src = "${pageContext.request.contextPath}/assets/img/" + foto;
        
        var modal = new bootstrap.Modal(document.getElementById('modalDetalleMascota'));
        modal.show();
    }

    // Función que pregunta si está seguro antes de enviar el formulario automáticamente
    function confirmarAdopcion() {
        var nombre = document.getElementById("modalNombre").innerText;
        if(confirm("¿Estás completamente seguro de que deseas iniciar el proceso de adopción para " + nombre + "?\n\nAl confirmar, enviaremos tu solicitud al equipo del refugio para su evaluación.")) {
            document.getElementById("formAdopcion").submit();
        }
    }
</script>

<style>
    /* Efecto de elevación al pasar el mouse por las Cards */
    .animal-card { 
        transition: transform 0.2s ease-in-out, box-shadow 0.2s; 
        border-radius: 12px;
        overflow: hidden;
    }
    .animal-card:hover { 
        transform: translateY(-5px); 
        box-shadow: 0 1rem 3rem rgba(0,0,0,.175)!important; 
    }
</style>