package com.helpets.modelo;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class ProductoTest {

    @Test
    void gettersYSettersMantienenDatosDeProducto() {
        Producto producto = new Producto();

        producto.setIdproducto(10);
        producto.setNombreProducto("Alimento balanceado");
        producto.setDescripcion("Bolsa de 15 kg");
        producto.setCategoria("Alimentos");
        producto.setStock(25);

        assertEquals(10, producto.getIdproducto());
        assertEquals("Alimento balanceado", producto.getNombreProducto());
        assertEquals("Bolsa de 15 kg", producto.getDescripcion());
        assertEquals("Alimentos", producto.getCategoria());
        assertEquals(25, producto.getStock());
    }
}