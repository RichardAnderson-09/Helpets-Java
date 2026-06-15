<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold text-dark">Gestión de donaciones</h2>
        <p class="text-muted">Administra las donaciones del refugio.</p>
    </div>
    <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#modalMascota">
        <i class="bi bi-plus-circle"></i> Registrar donación
    </button>
</div>

<div class="card shadow-sm border-0">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Donador</th>
                        <th>Fecha Donación</th>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th class="text-center">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="fw-bold">#001</td>
                        <td>Juan Flores</td>
                        <td>12/05/2026</td>
                        <td>Comida Perro RicoCan 1kg</td>
                        <td>1</td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td class="fw-bold">#002</td>
                        <td>Maria Gimenez</td>
                        <td>13/05/2026</td>
                        <td>Comida gato RicoCat 1kg</td>
                        <td>5</td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

