package com.helpets.config;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.atomic.AtomicLong;

public class MetricsFilter implements Filter {

    private static final AtomicLong HTTP_REQUESTS_TOTAL = new AtomicLong(0);
    private static final AtomicLong HTTP_ERRORS_TOTAL = new AtomicLong(0);
    private static final AtomicLong HTTP_DURATION_TOTAL_MS = new AtomicLong(0);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        long start = System.currentTimeMillis();
        HTTP_REQUESTS_TOTAL.incrementAndGet();

        try {
            chain.doFilter(request, response);
        } finally {
            long duration = System.currentTimeMillis() - start;
            HTTP_DURATION_TOTAL_MS.addAndGet(duration);

            if (response instanceof HttpServletResponse httpResponse) {
                int status = httpResponse.getStatus();

                if (status >= 400) {
                    HTTP_ERRORS_TOTAL.incrementAndGet();
                }
            }
        }
    }

    public static long getHttpRequestsTotal() {
        return HTTP_REQUESTS_TOTAL.get();
    }

    public static long getHttpErrorsTotal() {
        return HTTP_ERRORS_TOTAL.get();
    }

    public static long getHttpDurationTotalMs() {
        return HTTP_DURATION_TOTAL_MS.get();
    }
}