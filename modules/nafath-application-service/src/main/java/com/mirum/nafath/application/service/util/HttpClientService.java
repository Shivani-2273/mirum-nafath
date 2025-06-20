package com.mirum.nafath.application.service.util;

import com.liferay.portal.kernel.json.JSONObject;
import org.apache.commons.io.IOUtils;
import org.osgi.service.component.annotations.Component;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Component(service = HttpClientService.class)
public class HttpClientService {

    public HttpResponse post(String urlString, JSONObject requestBody, Map<String, String> headers) throws IOException {
        HttpURLConnection connection = null;
        try {
            URL url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            // Set headers
            if (headers != null) {
                for (Map.Entry<String, String> header : headers.entrySet()) {
                    connection.setRequestProperty(header.getKey(), header.getValue());
                }
            }

            // Send request body
            if (requestBody != null) {
                try (OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream(), StandardCharsets.UTF_8)) {
                    writer.write(requestBody.toString());
                    writer.flush();
                }
            }

            // Get response
            int responseCode = connection.getResponseCode();
            String responseBody;

            if (responseCode >= HttpURLConnection.HTTP_OK && responseCode < HttpURLConnection.HTTP_MOVED_TEMP) {
                try (InputStream inputStream = connection.getInputStream()) {
                    responseBody = IOUtils.toString(inputStream, StandardCharsets.UTF_8);
                }
            } else {
                try (InputStream errorStream = connection.getErrorStream()) {
                    responseBody = errorStream != null ?
                            IOUtils.toString(errorStream, StandardCharsets.UTF_8) : "Unknown error";
                }
            }

            return new HttpResponse(responseCode, responseBody);

        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    public static class HttpResponse {
        private final int statusCode;
        private final String body;

        public HttpResponse(int statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }

        public int getStatusCode() { return statusCode; }
        public String getBody() { return body; }
        public boolean isSuccess() { return statusCode >= 200 && statusCode < 300; }
    }
}
