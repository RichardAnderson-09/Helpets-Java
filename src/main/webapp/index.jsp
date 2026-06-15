<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            <a class="navbar-brand fw-bold" href="index.jsp">🐾 HELPETS</a>
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
        <div class="text-center mb-5">
            <h1 class="display-4 fw-bold text-dark">¡Encuentra a tu nuevo mejor amigo!</h1>
            <p class="lead text-muted">Explora nuestro catálogo de peluditos esperando un hogar lleno de amor.</p>
        </div>
        
        <div class="row mt-5 p-5 bg-white border rounded shadow-sm text-center">
            <div class="col text-muted">
                <!--<h4><i class="bi bi-images text-secondary"></i></h4>-->
                <!--<p><em>[Espacio reservado para el catálogo dinámico de mascotas con JSTL]</em></p>-->
                <div class="row row-cols-1 row-cols-md-3 g-4 mt-3">
    
                <div class="col">
                    <div class="card h-100 shadow-sm">
                        <img src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500" class="card-img-top" alt="Gato">
                        <div class="card-body">
                            <h5 class="card-title">Luna</h5>
                            <p class="card-text">Una gatita juguetona y muy cariñosa que busca un hogar lleno de paz.</p>
                            <a href="#" class="btn btn-primary w-100">¡Adóptame!</a>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card h-100 shadow-sm">
                        <img src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500" class="card-img-top" alt="Perro">
                        <div class="card-body">
                            <h5 class="card-title">Max</h5>
                            <p class="card-text">Un labrador lleno de energía, ideal para familias que disfrutan los paseos.</p>
                            <a href="#" class="btn btn-primary w-100">¡Adóptame!</a>
                        </div>
                    </div>
                </div>

    <div class="col">
        <div class="card h-100 shadow-sm">
            <img src="https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=500" class="card-img-top" alt="Perro">
            <div class="card-body">
                <h5 class="card-title">Rocky</h5>
                <p class="card-text">Rocky es un compañero fiel, tranquilo y perfecto para vivir en departamentos.</p>
                <a href="#" class="btn btn-primary w-100">¡Adóptame!</a>
            </div>
        </div>
    </div>

</div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fw-bold" id="loginModalLabel">🐾 Acceso del Personal</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <div class="modal-body p-4">
                    <form action="admin/dashboard.jsp" method="POST">
                        <div class="mb-3">
                            <label for="usuario" class="form-label text-muted fw-bold">Correo Electrónico</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="usuario" placeholder="ejemplo@helpets.com" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label text-muted fw-bold">Contraseña</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" placeholder="********" required>
                            </div>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary fw-bold py-2">Ingresar al Sistema</button>
                        </div>
                    </form>
                </div>
                
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>