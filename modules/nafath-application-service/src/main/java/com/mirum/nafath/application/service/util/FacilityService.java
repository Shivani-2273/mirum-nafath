package com.mirum.nafath.application.service.util;

import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.mirum.nafath.application.service.configuration.NafathConfiguration;
import com.mirum.nafath.application.service.constants.NafathConstants;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import java.util.HashMap;
import java.util.Map;

@Component(service = FacilityService.class)
public class FacilityService {

    private static final Log _log = LogFactoryUtil.getLog(FacilityService.class);

    @Reference
    private HttpClientService httpClientService;

    @Reference
    private ResponseBuilder responseBuilder;

    public String getFacilities(String identificationNumber, NafathConfiguration config) {
        try {
            if (identificationNumber == null || identificationNumber.trim().isEmpty()) {
                return responseBuilder.createErrorJsonString("Commercial Register Number is required");
            }

            String token = getAuthToken(config);
            if (token == null) {
                return responseBuilder.createErrorJsonString("Failed to get authentication token");
            }

            String url = config.getFacilityBaseURL() + NafathConstants.FACILITY_LIST_ENDPOINT;

            JSONObject requestBody = JSONFactoryUtil.createJSONObject();
            requestBody.put("IdentificationNumber", identificationNumber);

            Map<String, String> headers = createAuthHeaders(token);

            HttpClientService.HttpResponse response = httpClientService.post(url, requestBody, headers);

            if (response.isSuccess()) {
                return response.getBody();
            } else {
                return responseBuilder.createErrorJsonStringFromApiResponse(response.getBody(), "Failed to retrieve facilities");
            }

        } catch (Exception e) {
            _log.error("Error getting facilities", e);
            return responseBuilder.createErrorJsonString("Server error: " + e.getMessage());
        }
    }

    public String getFacilityDetails(String unifiedNumber, NafathConfiguration config) {
        try {
            if (unifiedNumber == null || unifiedNumber.trim().isEmpty()) {
                return responseBuilder.createErrorJsonString("Unified Number is required");
            }

            String token = getAuthToken(config);
            if (token == null) {
                return responseBuilder.createErrorJsonString("Failed to get authentication token");
            }

            String url = config.getFacilityBaseURL() + NafathConstants.FACILITY_DETAILS_ENDPOINT;

            JSONObject requestBody = JSONFactoryUtil.createJSONObject();
            requestBody.put("Unified700Number", unifiedNumber);

            Map<String, String> headers = createAuthHeaders(token);

            HttpClientService.HttpResponse response = httpClientService.post(url, requestBody, headers);

            if (response.isSuccess()) {
                return response.getBody();
            } else {
                return responseBuilder.createErrorJsonStringFromApiResponse(response.getBody(), "Failed to retrieve facility details");
            }

        } catch (Exception e) {
            _log.error("Error getting facility details", e);
            return responseBuilder.createErrorJsonString("Server error: " + e.getMessage());
        }
    }

    private String getAuthToken(NafathConfiguration config) {
        try {
            String url = config.getFacilityBaseURL() + NafathConstants.FACILITY_AUTH_ENDPOINT;

            JSONObject requestBody = JSONFactoryUtil.createJSONObject();
            requestBody.put("Username", config.getFacilityAPIUsername());
            requestBody.put("Password", config.getFacilityAPIPassword());

            HttpClientService.HttpResponse response = httpClientService.post(url, requestBody, null);

            if (response.isSuccess()) {
                JSONObject jsonResponse = JSONFactoryUtil.createJSONObject(response.getBody());
                if (jsonResponse.getJSONObject("result").getBoolean("isSuccess")) {
                    return jsonResponse.getJSONObject("tokenObj").getString("token");
                }
            }

            return null;
        } catch (Exception e) {
            _log.error("Error getting auth token", e);
            return null;
        }
    }

    private Map<String, String> createAuthHeaders(String token) {
        Map<String, String> headers = new HashMap<>();
        headers.put(NafathConstants.HEADER_AUTHORIZATION, NafathConstants.BEARER_PREFIX + token);
        return headers;
    }

}
