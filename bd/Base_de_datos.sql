-- UBIGEO
CREATE TABLE departamentos
(
    iddepartamento		CHAR(2) 		NOT NULL,
    departamento		VARCHAR(45) 	NOT NULL,
	PRIMARY KEY (iddepartamento)
)ENGINE=INNODB;

CREATE TABLE provincias
(
    idprovincia		CHAR(4) 		NOT NULL,
    provincia		VARCHAR(45) 	NOT NULL,
    iddepartamento  CHAR(2) 		NOT NULL,
    PRIMARY KEY (idprovincia),
    KEY fk_iddepartamento_pro (iddepartamento),
    CONSTRAINT fk_iddepartamento_pro FOREIGN KEY (iddepartamento) REFERENCES departamentos(iddepartamento)
)ENGINE=INNODB;

CREATE TABLE distritos
(
    iddistrito		CHAR(6)			NOT NULL,
    distrito		VARCHAR(45) 	NOT NULL,
	idprovincia 	CHAR(4) 		NOT NULL,
    iddepartamento	VARCHAR(2)	    DEFAULT NULL,
	PRIMARY KEY (iddistrito),
	KEY fk_idprovincia_dis (idprovincia),
    KEY fk_iddepartamento_dis (iddepartamento),
	CONSTRAINT fk_idprovincia_dis FOREIGN KEY (idprovincia) REFERENCES provincias (idprovincia),
    CONSTRAINT fk_iddepartamento_dis FOREIGN KEY (iddepartamento) REFERENCES departamentos (iddepartamento)
)ENGINE=INNODB;

-- MASCOTAS
CREATE TABLE especies
(
    idespecie		INT  			AUTO_INCREMENT PRIMARY KEY,
    nombre_especie	VARCHAR(40) 	NOT NULL,
    CONSTRAINT uk_especies_esp UNIQUE (nombre_especie)	
)ENGINE=INNODB;

CREATE TABLE razas
(
    idraza     	INT 			AUTO_INCREMENT PRIMARY KEY,
    nombre_raza VARCHAR(60) 	NOT NULL,
    idespecie  	INT 	   		NOT NULL,
    CONSTRAINT fk_idespecie_raz  FOREIGN KEY (idespecie) REFERENCES especies(idespecie),
    CONSTRAINT uk_raza_raz UNIQUE(idespecie, nombre_raza)	
)ENGINE=INNODB;

CREATE TABLE mascotas
(
    idmascota 		INT 			AUTO_INCREMENT PRIMARY KEY,
    idraza    		INT  			NOT NULL,
    nombre    		VARCHAR(50) 	NOT NULL,
    fecharescate	DATE        	NOT NULL,
    disponibilidad  CHAR(1)         NOT NULL DEFAULT 1,  -- 0 No_Disponible / 1 Disponible
    foto			VARCHAR(200)	NULL,
    vive			CHAR(1)			NOT NULL DEFAULT 'S', -- S --> Si vive /   N --> No vive
    sexo			CHAR(1)			NOT NULL , -- H--> Hembra M --> Macho
    CONSTRAINT fk_idraza_mas  FOREIGN KEY (idraza) REFERENCES razas(idraza)
)ENGINE=INNODB;

CREATE TABLE procesosmedicos
(
    idprocesomedico	INT 		AUTO_INCREMENT PRIMARY KEY,
    procesomedico	VARCHAR(60) NOT NULL,
    descripcion 	TEXT 		NULL,
    CONSTRAINT uk_proceso_pro UNIQUE (procesomedico)
)
ENGINE=INNODB;

CREATE TABLE historialmedicos
(
	idhistorial		INT 			AUTO_INCREMENT PRIMARY KEY,
	idmascota		INT 			NOT NULL,
	idproceso		INT				NOT NULL,
	descripcion		TEXT  			NULL,
	fechaatencion	DATETIME 		NOT NULL DEFAULT CURRENT_TIMESTAMP,
	peso			DECIMAL(5,2) 	NOT NULL,
	CONSTRAINT fk_mascota_his FOREIGN KEY (idmascota) REFERENCES mascotas(idmascota),
	CONSTRAINT fk_proceso_his FOREIGN KEY (idproceso) REFERENCES procesosmedicos(idprocesomedico)
)
ENGINE=INNODB;

-- USURIOS 
CREATE TABLE roles
(
    idrol           INT             AUTO_INCREMENT PRIMARY KEY,
    rol             VARCHAR(50)     NOT NULL,
    CONSTRAINT uk_rol UNIQUE (rol)
) ENGINE=INNODB;

CREATE TABLE personas
(
    idpersona       INT             AUTO_INCREMENT PRIMARY KEY,
    nombres         VARCHAR(80)     NOT NULL,
    apellidos       VARCHAR(80)     NOT NULL,
    fechanac        DATE            NULL,
    tipodoc         CHAR(3)         NOT NULL, -- DNI, CE
    nrodoc          VARCHAR(11)     NOT NULL,
    telefono        VARCHAR(9)     	NULL,
    correo          VARCHAR(100)    NULL,
    nivelconfianza  INT             DEFAULT 1,
    foto            VARCHAR(200)    NULL,
    iddistrito      CHAR(6)         NOT NULL, -- Conectado a UBIGEO
    KEY fk_iddistrito_per (iddistrito),
    CONSTRAINT fk_iddistrito_per FOREIGN KEY (iddistrito) REFERENCES distritos(iddistrito),
    CONSTRAINT uk_nrodoc_per UNIQUE (tipodoc, nrodoc)
) ENGINE=INNODB;

CREATE TABLE usuarios
(
    idusuario       INT             AUTO_INCREMENT PRIMARY KEY,
    idpersona       INT             NOT NULL,
    idrol           INT             NOT NULL,
    nombreusuario   VARCHAR(50)     NOT NULL,
    contraseña      VARCHAR(255)    NOT NULL, 
    fecharegistro   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado          CHAR(1)         NOT NULL DEFAULT 'A', -- A: Activo, I: Inactivo
    fechabaja       DATETIME        NULL,
    KEY fk_idpersona_usu (idpersona),
    KEY fk_idrol_usu (idrol),
    CONSTRAINT fk_idpersona_usu FOREIGN KEY (idpersona) REFERENCES personas(idpersona),
    CONSTRAINT fk_idrol_usu FOREIGN KEY (idrol) REFERENCES roles(idrol),
    CONSTRAINT uk_nombreusuario UNIQUE (nombreusuario)
) ENGINE=INNODB;

CREATE TABLE historialvol
(
    idhistorial     INT             AUTO_INCREMENT PRIMARY KEY,
    idpersona       INT             NOT NULL,
    fechainicio     DATE            NOT NULL,
    fechafin        DATE            NULL,
    estado          CHAR(1)         NOT NULL DEFAULT 'A',  -- A: Activo, I: Inactivo
    KEY fk_idpersona_hvol (idpersona),
    CONSTRAINT fk_idpersona_hvol FOREIGN KEY (idpersona) REFERENCES personas(idpersona)
) ENGINE=INNODB;

-- OPERACIONES
CREATE TABLE adopciones
(
    idadopcion      INT             AUTO_INCREMENT PRIMARY KEY,
    idmascota       INT             NOT NULL,
    idpersona       INT             NOT NULL, -- Adoptante
    idusuario       INT             NOT NULL, -- Quien registra
    fechaadopcion   DATETIME        NOT NULL,
    fechadevolucion DATETIME        NULL,
    estado_solicitud CHAR(1)    	NOT NULL DEFAULT 'P', -- P: Pendiente, E: Entrevista, A: Aprobado, R: Rechazado
    comentarios     TEXT            NULL,
    KEY fk_idmascota_ado (idmascota),
    KEY fk_idpersona_ado (idpersona),
    KEY fk_idusuario_ado (idusuario),
    CONSTRAINT fk_idmascota_ado FOREIGN KEY (idmascota) REFERENCES mascotas(idmascota),
    CONSTRAINT fk_idpersona_ado FOREIGN KEY (idpersona) REFERENCES personas(idpersona),
    CONSTRAINT fk_idusuario_ado FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario)
) ENGINE=INNODB;

CREATE TABLE productos
(
    idproducto      INT             AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100)    NOT NULL,
    descripcion     TEXT            NULL,
    categoria       VARCHAR(50)     NOT NULL,  -- Alimento, Medicamento, Material
    stock           INT             NOT NULL
) ENGINE=INNODB;

CREATE TABLE movimientos_inventario
(
    idmovimiento    INT             AUTO_INCREMENT PRIMARY KEY,
    idproducto      INT             NOT NULL,
    idusuario       INT             NOT NULL,
    tipooperacion   CHAR(1)         NOT NULL, -- E: Entrada, S: Salida
    cantidad        INT             NOT NULL,
    fecharegistro   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY fk_idproducto_mov (idproducto),
    KEY fk_idusuario_mov (idusuario),
    CONSTRAINT fk_idproducto_mov FOREIGN KEY (idproducto) REFERENCES productos(idproducto),
    CONSTRAINT fk_idusuario_mov FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario)
) ENGINE=INNODB;

CREATE TABLE compras
(
    idcompra        INT             AUTO_INCREMENT PRIMARY KEY,
    idusuario       INT             NOT NULL,
    fechacompra     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nota            TEXT            NULL,
    KEY fk_idusuario_com (idusuario),
    CONSTRAINT fk_idusuario_com FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario)
) ENGINE=INNODB;

CREATE TABLE detalle_compra
(
    iddetallecompra INT             AUTO_INCREMENT PRIMARY KEY,
    idcompra        INT             NOT NULL,
    idproducto      INT             NOT NULL,
    cantidad        INT             NOT NULL,
    precio_unitario DECIMAL(8,2)    NOT NULL,
    KEY fk_idcompra_dcom (idcompra),
    KEY fk_idproducto_dcom (idproducto),
    CONSTRAINT fk_idcompra_dcom FOREIGN KEY (idcompra) REFERENCES compras(idcompra),
    CONSTRAINT fk_idproducto_dcom FOREIGN KEY (idproducto) REFERENCES productos(idproducto)
) ENGINE=INNODB;

CREATE TABLE donaciones
(
    iddonacion      INT             AUTO_INCREMENT PRIMARY KEY,
    idusuario       INT             NOT NULL, -- Quien registra/recibe
    idpersona       INT             NOT NULL, -- Donante
    fechadonacion   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipodonacion    VARCHAR(9)     NOT NULL, -- MONETARIA , MATERIAL
    KEY fk_idusuario_don (idusuario),
    KEY fk_idpersona_don (idpersona),
    CONSTRAINT fk_idusuario_don FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario),
    CONSTRAINT fk_idpersona_don FOREIGN KEY (idpersona) REFERENCES personas(idpersona)
) ENGINE=INNODB;

CREATE TABLE detalle_donacion
(
    iddetalledonacion 	INT           	AUTO_INCREMENT PRIMARY KEY,
    iddonacion      	INT             NOT NULL,
    idproducto      	INT             NULL,
    cantidad        	INT             NULL, 
    monto           	DECIMAL(8,2)    NULL, 
    KEY fk_iddonacion_ddon (iddonacion),
    KEY fk_idproducto_ddon (idproducto),
    CONSTRAINT fk_iddonacion_ddon FOREIGN KEY (iddonacion) REFERENCES donaciones(iddonacion),
    CONSTRAINT fk_idproducto_ddon FOREIGN KEY (idproducto) REFERENCES productos(idproducto)
) ENGINE=INNODB;