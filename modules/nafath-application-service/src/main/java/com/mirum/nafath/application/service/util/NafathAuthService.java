package com.mirum.nafath.application.service.util;

import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.mirum.nafath.application.service.configuration.NafathConfiguration;
import com.mirum.nafath.application.service.constants.NafathConstants;
import com.mirum.nafath.application.service.dto.ApiResponse;
import com.mirum.nafath.application.service.dto.NafathStatusRequest;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import javax.portlet.ResourceRequest;
import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;


@Component(service = NafathAuthService.class)
public class NafathAuthService {

    private static final Log _log = LogFactoryUtil.getLog(NafathAuthService.class);

    @Reference
    private HttpClientService httpClientService;

    @Reference
    private ResponseBuilder responseBuilder;

    public ApiResponse<JSONObject> initiateAuthentication(String nationalId, NafathConfiguration config) {
        try {
            if (nationalId == null || nationalId.trim().isEmpty()) {
                return ApiResponse.error("Identification Number is required");
            }

            String requestId = UUID.randomUUID().toString();
            String url = config.getNafathBaseURL() + NafathConstants.NAFATH_MFA_REQUEST_ENDPOINT +
                    "?local=ar&requestId=" + requestId;

            JSONObject requestBody = JSONFactoryUtil.createJSONObject();
            requestBody.put(NafathConstants.PARAM_NATIONAL_ID, nationalId);
            requestBody.put("service", "Login");

            Map<String, String> headers = createNafathHeaders(config);

            HttpClientService.HttpResponse response = httpClientService.post(url, requestBody, headers);

            if (response.getStatusCode() == HttpURLConnection.HTTP_CREATED) {
                JSONObject jsonResponse = JSONFactoryUtil.createJSONObject(response.getBody());
                if (jsonResponse.has("transId") && jsonResponse.has("random")) {
                    jsonResponse.put(NafathConstants.PARAM_NATIONAL_ID, nationalId);
                    return ApiResponse.success(jsonResponse);
                } else {
                    return ApiResponse.error("Invalid response from Nafath API");
                }
            } else {
                String userFriendlyMessage = responseBuilder.extractUserFriendlyMessage(response.getBody(), "Authentication request failed");
                return ApiResponse.error(userFriendlyMessage);
            }

        } catch (Exception e) {
            return ApiResponse.error("Server error: " + e.getMessage());
        }
    }

    public String checkAuthenticationStatus(NafathStatusRequest request, NafathConfiguration config) {
        try {
            if (!isValidStatusRequest(request)) {
                return responseBuilder.createErrorJsonString("National ID, Transaction ID, and Random are required");
            }

            String url = config.getNafathBaseURL() + NafathConstants.NAFATH_MFA_STATUS_ENDPOINT;

            JSONObject requestBody = JSONFactoryUtil.createJSONObject();
            requestBody.put(NafathConstants.PARAM_NATIONAL_ID, request.getNationalId());
            requestBody.put(NafathConstants.PARAM_TRANS_ID, request.getTransId());
            requestBody.put(NafathConstants.PARAM_RANDOM, request.getRandom());

            Map<String, String> headers = createNafathHeaders(config);

            HttpClientService.HttpResponse response = httpClientService.post(url, requestBody, headers);

            if (response.getStatusCode() == HttpURLConnection.HTTP_CREATED) {
                return response.getBody();
            } else {

                return responseBuilder.createErrorJsonStringFromApiResponse(response.getBody(), "Status check failed");
            }

        } catch (Exception e) {
            _log.error("Error checking Nafath status", e);
            return responseBuilder.createErrorJsonString("Server error: " + e.getMessage());
        }
    }

    private Map<String, String> createNafathHeaders(NafathConfiguration config) {
        Map<String, String> headers = new HashMap<>();
        headers.put(NafathConstants.HEADER_APP_ID, config.getAppID());
        headers.put(NafathConstants.HEADER_APP_KEY, config.getAppKey());
        return headers;
    }

    private boolean isValidStatusRequest(NafathStatusRequest request) {
        return request != null &&
                request.getNationalId() != null && !request.getNationalId().trim().isEmpty() &&
                request.getTransId() != null && !request.getTransId().trim().isEmpty() &&
                request.getRandom() != null && !request.getRandom().trim().isEmpty();
    }


}
