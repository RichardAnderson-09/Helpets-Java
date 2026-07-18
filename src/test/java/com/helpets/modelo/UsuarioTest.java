package com.helpets.modelo;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class UsuarioTest {

    @Test
    void gettersYSettersMantienenDatosDeUsuario() {
        Usuario usuario = new Usuario();

        usuario.setIdusuario(5);
        usuario.setIdpersona(20);
        usuario.setIdrol(1);
        usuario.setNombreusuario("admin");
        usuario.setEstado("A");
        usuario.setNombresPersona("Richard");
        usuario.setApellidosPersona("Perez");
        usuario.setNombreRol("Administrador");
        usuario.setTipodoc("DNI");
        usuario.setNrodoc("12345678");
        usuario.setTelefono("999888777");
        usuario.setCorreo("admin@helpets.com");

        assertEquals(5, usuario.getIdusuario());
        assertEquals(20, usuario.getIdpersona());
        assertEquals(1, usuario.getIdrol());
        assertEquals("admin", usuario.getNombreusuario());
        assertEquals("A", usuario.getEstado());
        assertEquals("Richard", usuario.getNombresPersona());
        assertEquals("Perez", usuario.getApellidosPersona());
        assertEquals("Administrador", usuario.getNombreRol());
        assertEquals("DNI", usuario.getTipodoc());
        assertEquals("12345678", usuario.getNrodoc());
        assertEquals("999888777", usuario.getTelefono());
        assertEquals("admin@helpets.com", usuario.getCorreo());
    }
}