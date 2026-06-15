<%@page contentType="text/html" pageEncoding="UTF-8"%>
<h2 class="fw-bold text-dark">Panel de Control</h2>
<p class="text-muted">Bienvenido al sistema de resumen de HELPETS.</p>

<div class="row mt-4">
    <div class="col-md-4">
        <div class="card text-white bg-success mb-3 shadow border-0">
            <div class="card-body py-4">
                <h5 class="card-title opacity-75"><i class="bi bi-dog"></i> Perros Disponibles</h5>
                <p class="card-text display-4 fw-bold">12</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card text-white bg-warning mb-3 shadow border-0">
            <div class="card-body py-4">
                <h5 class="card-title opacity-75"><i class="bi bi-cat"></i> Gatos Disponibles</h5>
                <p class="card-text display-4 fw-bold">8</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card text-white bg-info mb-3 shadow border-0">
            <div class="card-body py-4">
                <h5 class="card-title opacity-75"><i class="bi bi-file-earmark-text"></i> Solicitudes Pendientes</h5>
                <p class="card-text display-4 fw-bold">5</p>
            </div>
        </div>
    </div>
</div>

<div class="row mt-4 g-4">
    <div class="col-md-7">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-bold text-muted py-3">
                <i class="bi bi-bar-chart-fill text-primary"></i> Ingreso Mensual de Mascotas (2026)
            </div>
            <div class="card-body p-4">
                <canvas id="chartIngresos" style="max-height: 300px;"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-5">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-bold text-muted py-3">
                <i class="bi bi-pie-chart-fill text-danger"></i> Distribución por Estado de Adopción
            </div>
            <div class="card-body p-4">
                <canvas id="chartEstados" style="max-height: 300px;"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    setTimeout(() => {
        const ctxIngresos = document.getElementById('chartIngresos')?.getContext('2d');
        if(ctxIngresos) {
            new Chart(ctxIngresos, {
                type: 'bar',
                data: {
                    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May'],
                    datasets: [{
                        label: 'Animales Rescatados',
                        data: [5, 12, 8, 15, 7],
                        backgroundColor: 'rgba(13, 110, 253, 0.7)',
                        borderColor: 'rgb(13, 110, 253)',
                        borderWidth: 1,
                        borderRadius: 5
                    }]
                },
                options: { responsive: true, scales: { y: { beginAtZero: true } } }
            });
        }

        const ctxEstados = document.getElementById('chartEstados')?.getContext('2d');
        if(ctxEstados) {
            new Chart(ctxEstados, {
                type: 'doughnut',
                data: {
                    labels: ['Disponibles', 'En Tratamiento', 'Adoptados'],
                    datasets: [{
                        data: [20, 4, 35],
                        backgroundColor: ['#198754', '#ffc107', '#0dcaf0'],
                        hoverOffset: 4
                    }]
                },
                options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
            });
        }
    }, 100);
</script>