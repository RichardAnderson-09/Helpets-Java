package com.helpets.config;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class EncriptadorTest {

    @Test
    void encriptarSHA256RetornaHashConocido() {
        String hash = Encriptador.encriptarSHA256("admin123");

        assertEquals(
            "240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9",
            hash
        );

        assertEquals(64, hash.length());
    }

    @Test
    void encriptarSHA256GeneraHashesDiferentes() {
        String hash1 = Encriptador.encriptarSHA256("admin123");
        String hash2 = Encriptador.encriptarSHA256("otraClave");

        assertNotEquals(hash1, hash2);
    }
}