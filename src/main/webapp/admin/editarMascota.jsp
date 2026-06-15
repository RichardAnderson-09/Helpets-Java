<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="mb-4">
    <h2 class="fw-bold text-dark">Modificar Registro</h2>
    <p class="text-muted">Actualiza los datos de la mascota seleccionada.</p>
</div>

<div class="card shadow-sm border-0 col-lg-8 mx-auto">
    <div class="card-header bg-primary text-white fw-bold">
        <i class="bi bi-pencil-square"></i> Formulario de Edición
    </div>
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/MascotaServlet" method="POST" enctype="multipart/form-data">
            
            <input type="hidden" name="idmascota" value="${mascota.idmascota}">
            <input type="hidden" name="fotoActual" value="${mascota.foto}">

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Especie:</label>
                    <select id="especieSelect" class="form-control" onchange="cargarRazas()" required>
                        <option value="">Seleccione una especie</option>
                        <c:forEach var="e" items="${listaEspecies}">
                            <option value="${e.idespecie}">${e.nombreEspecie}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Raza:</label>
                    <select name="idraza" id="razaSelect" class="form-control" required>
                        <option value="${mascota.idraza}">Mantener raza actual</option>
                    </select>
                    <small class="text-muted">*Vuelve a seleccionar la especie si deseas cambiar la raza.</small>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Nombre:</label>
                    <input type="text" name="nombre" class="form-control" value="${mascota.nombre}" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Fecha de rescate:</label>
                    <input type="date" name="fecharescate" class="form-control" value="${mascota.fecharescate}" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Disponibilidad:</label>
                    <select name="disponibilidad" class="form-select" required>
                        <option value="1" ${mascota.disponibilidad == '1' ? 'selected' : ''}>Disponible</option>
                        <option value="0" ${mascota.disponibilidad == '0' ? 'selected' : ''}>No Disponible</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Sexo:</label>
                    <select name="sexo" class="form-select" required>
                        <option value="M" ${mascota.sexo == 'M' ? 'selected' : ''}>Macho</option>
                        <option value="H" ${mascota.sexo == 'H' ? 'selected' : ''}>Hembra</option>
                    </select>
                </div>

                <div class="col-md-12">
                    <label class="form-label fw-semibold">Actualizar Foto (Opcional):</label>
                    <div class="d-flex align-items-center gap-3">
                        <img src="${pageContext.request.contextPath}/assets/img/${mascota.foto}" class="rounded shadow-sm" style="width: 60px; height: 60px; object-fit: cover;">
                        <input type="file" name="foto" class="form-control" accept="image/*">
                    </div>
                </div>
            </div>

            <div class="text-end mt-4">
                <a href="${pageContext.request.contextPath}/MascotaServlet" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-success">
                    <i class="bi bi-check-circle"></i> Guardar Cambios
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function cargarRazas() {
        var idEspecie = document.getElementById("especieSelect").value;
        var razaSelect = document.getElementById("razaSelect");
        if (idEspecie === "") {
            razaSelect.innerHTML = "<option value=''>Primero seleccione una especie</option>";
            return;
        }
        fetch("${pageContext.request.contextPath}/RazaServlet?idespecie=" + idEspecie)
            .then(response => response.text())
            .then(html => { razaSelect.innerHTML = html; })
            .catch(error => console.error('Error al cargar razas:', error));
    }
</script>