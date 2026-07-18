package com.helpets.modelo;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.sql.Date;
import org.junit.jupiter.api.Test;

class MascotaTest {

    @Test
    void gettersYSettersMantienenDatosDeMascota() {
        Mascota mascota = new Mascota();
        Date fecha = Date.valueOf("2026-07-18");

        mascota.setIdmascota(1);
        mascota.setIdraza(2);
        mascota.setIdespecie(3);
        mascota.setNombre("Luna");
        mascota.setFecharescate(fecha);
        mascota.setDisponibilidad("1");
        mascota.setFoto("luna.jpg");
        mascota.setVive("S");
        mascota.setSexo("H");
        mascota.setNombreRaza("Mestizo");
        mascota.setNombreEspecie("Perro");

        assertEquals(1, mascota.getIdmascota());
        assertEquals(2, mascota.getIdraza());
        assertEquals(3, mascota.getIdespecie());
        assertEquals("Luna", mascota.getNombre());
        assertEquals(fecha, mascota.getFecharescate());
        assertEquals("1", mascota.getDisponibilidad());
        assertEquals("luna.jpg", mascota.getFoto());
        assertEquals("S", mascota.getVive());
        assertEquals("H", mascota.getSexo());
        assertEquals("Mestizo", mascota.getNombreRaza());
        assertEquals("Perro", mascota.getNombreEspecie());
    }
}