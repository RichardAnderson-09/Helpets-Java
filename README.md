# 🐾 HELPETS - Sistema de Gestión para Refugio de Animales

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Jakarta EE](https://img.shields.io/badge/Jakarta_EE-EE0000?style=for-the-badge&logo=jakartaee&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white)

**HELPETS** es una aplicación web robusta desarrollada en **Java (Jakarta EE)** diseñada para optimizar y digitalizar las operaciones del refugio de animales "Patitas del Sur". El sistema permite administrar de forma integral el catálogo de mascotas, el seguimiento de solicitudes de adopción, la recepción de donaciones y el registro de compras, manteniendo un control automatizado del inventario.

## ✨ Características Principales (Módulos)

* **🐶 Gestión de Mascotas:** Registro, edición, eliminación y listado de mascotas. Soporte para carga de imágenes y exportación del catálogo completo a **Excel (.xlsx)** usando Apache POI.
* **🏡 Sistema de Adopciones:** Flujo completo de adopción con búsqueda asíncrona (AJAX) de adoptantes por documento, asignación de mascotas disponibles y gestión de la solicitud por etapas (Pendiente, Entrevista, Aprobado, Rechazado).
* **🎁 Módulo de Donaciones:** Registro de donantes y aportes materiales. Implementa un modelo transaccional (Maestro-Detalle) que actualiza automáticamente el stock de los productos.
* **🛒 Compras y Suministros:** Control de abastecimiento del refugio. Creación rápida de nuevos productos y registro de facturas que alimentan el inventario general.
* **📊 Dashboard y Reportes:** Panel de control principal con indicadores clave de rendimiento (KPIs) y gráficos estadísticos interactivos (Chart.js).
* **🔐 Seguridad y Accesos:** Sistema de Login validado, encriptación de contraseñas mediante **SHA-256**, protección de rutas y prevención de inyecciones SQL (`PreparedStatement`). Logs estructurados con **Logback**.

## 🛠️ Tecnologías y Arquitectura

El proyecto está construido bajo el patrón **MVC (Modelo-Vista-Controlador)** y aplica principios **SOLID** y el patrón **DAO**.

**Backend:**
* Java 17
* Jakarta EE 11 (Servlets, JSP)
* Maven (Gestor de dependencias)
* Librerías: Apache POI, Logback, Apache Commons Lang3

**Frontend:**
* HTML5, CSS3, JavaScript (Fetch API)
* Bootstrap 5 + Bootstrap Icons
* Chart.js & Tom-Select

**Base de Datos:**
* MySQL 8.0+ (Conector MySQL/J)

## 🚀 Instalación y Configuración Local

1. **Clonar el repositorio:**
```bash
   git clone https://github.com/TU-USUARIO/helpets-java.git
```

2. **Base de Datos:**
   - Crea una base de datos en MySQL llamada `helpets_database`.
   - Importa el script SQL provisto en la carpeta del proyecto.

3. **Configurar Credenciales:**
   - Edita el archivo `src/main/java/com/helpets/config/ConexionBD.java`.
   - Actualiza las constantes `USUARIO` y `PASSWORD` con las tuyas:
```java
   private static final String USUARIO = "root";
   private static final String PASSWORD = "tu_password";
```

4. **Despliegue:**
   - Abre el proyecto en tu IDE (NetBeans, Eclipse, IntelliJ).
   - Ejecuta **Clean and Build** con Maven.
   - Despliega en **Apache Tomcat 10/11**.

5. **Acceso:**
   - Navega a `http://localhost:8080/helpetsWeb`.
   - Inicia sesión con las credenciales de administrador de prueba.

## 📁 Estructura del Proyecto

```plaintext
Helpets-Java/
├── src/main/java/com/helpets/
│   ├── config/          # Conexión a BD, Encriptador
│   ├── controlador/     # Servlets (AdopcionServlet, MascotaServlet, etc.)
│   ├── dao/             # GestorDAO para la ejecución de Querys
│   └── modelo/          # Clases Java (Mascota, Donacion, Usuario, etc.)
├── src/main/webapp/
│   ├── admin/           # Vistas protegidas del panel de control (JSP)
│   ├── assets/img/      # Directorio de almacenamiento de fotografías
│   └── index.jsp        # Landing page y Login
└── pom.xml              # Archivo de configuración de Maven
```

---

Desarrollado para la gestión y bienestar de nuestros amigos de cuatro patas. 🐾
