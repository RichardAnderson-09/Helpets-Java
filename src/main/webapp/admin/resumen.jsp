<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<h2 class="fw-bold text-dark">Panel de Control</h2>
<p class="text-muted">Bienvenido al sistema de resumen de operaciones del refugio.</p>

<h5 class="mt-4 mb-3 fw-bold text-secondary border-bottom pb-2">Inventario de Animales Disponibles</h5>
<div class="row">
    <c:forEach var="especie" items="${resumen.disponiblesPorEspecie}">
        <div class="col-md-3 col-sm-6">
            <div class="card text-white bg-success mb-3 shadow border-0">
                <div class="card-body py-3">
                    <h6 class="card-title opacity-75"><i class="bi bi-heptagon-fill"></i> ${especie.key}s</h6>
                    <p class="card-text display-5 fw-bold mb-0">${especie.value}</p>
                </div>
            </div>
        </div>
    </c:forEach>
    <c:if test="${empty resumen.disponiblesPorEspecie}">
        <div class="col-12"><p class="text-muted fst-italic">No hay mascotas disponibles para adopción en este momento.</p></div>
    </c:if>
</div>

<h5 class="mt-2 mb-3 fw-bold text-secondary border-bottom pb-2">Gestión de Adopciones</h5>
<div class="row">
    <div class="col-md-4">
        <div class="card text-white bg-warning mb-3 shadow border-0">
            <div class="card-body py-3">
                <h6 class="card-title opacity-75 text-dark"><i class="bi bi-file-earmark-text"></i> Solicitudes Pendientes</h6>
                <p class="card-text display-5 fw-bold text-dark mb-0">${resumen.solicitudesPendientes}</p>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card text-white bg-primary mb-3 shadow border-0">
            <div class="card-body py-3">
                <h6 class="card-title opacity-75"><i class="bi bi-house-heart"></i> Adopciones Exitosas</h6>
                <p class="card-text display-5 fw-bold mb-0">${resumen.adopcionesConcretadas}</p>
            </div>
        </div>
    </div>
</div>

<div class="row mt-3 g-4">
    <div class="col-md-7">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white fw-bold text-muted py-3">
                <i class="bi bi-bar-chart-fill text-primary"></i> Ingreso Mensual de Mascotas Rescatadas
            </div>
            <div class="card-body p-4 d-flex align-items-center">
                <canvas id="chartIngresos" style="max-height: 280px; width: 100%;"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-5">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white fw-bold text-muted py-3">
                <i class="bi bi-pie-chart-fill text-danger"></i> Distribución Histórica
            </div>
            <div class="card-body p-4 d-flex justify-content-center">
                <canvas id="chartEstados" style="max-height: 280px;"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    setTimeout(() => {
        // --- GRÁFICO BARRAS: Ingresos ---
        const ctxIngresos = document.getElementById('chartIngresos')?.getContext('2d');
        if(ctxIngresos) {
            new Chart(ctxIngresos, {
                type: 'bar',
                data: {
                    labels: [${resumen.mesesIngresos}], 
                    datasets: [{
                        label: 'Mascotas Rescatadas',
                        data: [${resumen.datosIngresos}], 
                        backgroundColor: 'rgba(13, 110, 253, 0.7)',
                        borderColor: 'rgb(13, 110, 253)',
                        borderWidth: 1,
                        borderRadius: 4
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } }
            });
        }

        // --- GRÁFICO CIRCULAR: Estados (Disponibles, Adoptados, Fallecidos) ---
        const ctxEstados = document.getElementById('chartEstados')?.getContext('2d');
        if(ctxEstados) {
            new Chart(ctxEstados, {
                type: 'doughnut',
                data: {
                    labels: [${resumen.labelsEstados}], 
                    datasets: [{
                        data: [${resumen.datosEstados}], 
                        backgroundColor: ['#198754', '#0dcaf0', '#dc3545', '#ffc107', '#6c757d'],
                        hoverOffset: 4
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
            });
        }
    }, 150);
</script>