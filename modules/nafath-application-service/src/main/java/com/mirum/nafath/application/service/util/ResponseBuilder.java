package com.mirum.nafath.application.service.util;

import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextThreadLocal;
import com.liferay.portal.kernel.util.LocaleThreadLocal;
import com.liferay.portal.kernel.util.LocaleUtil;
import org.osgi.service.component.annotations.Component;
import java.util.Locale;

@Component(service = ResponseBuilder.class)
public class ResponseBuilder {

    private static final Log _log = LogFactoryUtil.getLog(ResponseBuilder.class);

    public JSONObject buildErrorResponse(String errorMessage) {
        JSONObject response = JSONFactoryUtil.createJSONObject();
        response.put("succeeded", false);
        response.put("message", "error");

        JSONArray errors = JSONFactoryUtil.createJSONArray();
        errors.put(errorMessage);
        response.put("errors", errors);
        response.put("data", JSONFactoryUtil.createJSONObject());

        return response;
    }



    public String extractUserFriendlyMessage(String errorResponseBody, String defaultMessage) {
        try {
            if (errorResponseBody != null && !errorResponseBody.trim().isEmpty()) {
                JSONObject errorJson = JSONFactoryUtil.createJSONObject(errorResponseBody);

                // Priority order for message extraction
                String[] messageFields = {"message", "error_description", "detail", "error", "title"};

                for (String field : messageFields) {
                    if (errorJson.has(field)) {
                        String message = errorJson.getString(field);
                        if (message != null && !message.trim().isEmpty() && !message.equals("null")) {
                            // Clean up technical error codes and make more user-friendly
                            return cleanErrorMessage(message);
                        }
                    }
                }

                // Check for nested error objects
                if (errorJson.has("error") && errorJson.get("error") instanceof JSONObject) {
                    JSONObject nestedError = errorJson.getJSONObject("error");
                    for (String field : messageFields) {
                        if (nestedError.has(field)) {
                            String message = nestedError.getString(field);
                            if (message != null && !message.trim().isEmpty()) {
                                return cleanErrorMessage(message);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            _log.debug("Could not parse error response as JSON: " + e.getMessage());
        }

        return defaultMessage;
    }


    private Locale getCurrentLocale() {

        // 1. Try to get from ServiceContext (most reliable in service layer)
        ServiceContext serviceContext = ServiceContextThreadLocal.getServiceContext();
        if (serviceContext != null) {
            Locale locale = serviceContext.getLocale();
            if (locale != null) {
                return locale;
            }
        }

        // 2. Try to get from LocaleThreadLocal (set by portal filters)
        Locale threadLocale = LocaleThreadLocal.getThemeDisplayLocale();
        if (threadLocale != null) {
            return threadLocale;
        }

        // 4. Fallback to default locale
        return LocaleUtil.getDefault();
    }


    private String cleanErrorMessage(String message) {
        if (message == null) return null;

        Locale locale = getCurrentLocale() ;
        System.out.println("locale: " + locale);
        // Map common technical messages to user-friendly ones
        String lowerMessage = message.toLowerCase();

        if (lowerMessage.contains("invalid request") || lowerMessage.contains("bad request")) {
           return LanguageUtil.get(locale, "invalid-request");
           // return "Please check your input and try again";
        }

        if (lowerMessage.contains("unauthorized") || lowerMessage.contains("authentication failed")) {
            return "Authentication failed. Please verify your credentials";
        }

        if (lowerMessage.contains("forbidden") || lowerMessage.contains("access denied")) {
            return "You don't have permission to access this resource";
        }

        if (lowerMessage.contains("not found")) {
            return "The requested information was not found";
        }

        if (lowerMessage.contains("timeout") || lowerMessage.contains("timed out")) {
            return "Request timed out. Please try again";
        }

        if (lowerMessage.contains("internal server error") || lowerMessage.contains("server error")) {
            return "A server error occurred. Please try again later";
        }

        if (lowerMessage.contains("service unavailable") || lowerMessage.contains("temporarily unavailable")) {
            return "Service is temporarily unavailable. Please try again later";
        }

        // For validation errors, return as is since they're usually user-friendly
        if (lowerMessage.contains("validation") || lowerMessage.contains("required") ||
                lowerMessage.contains("invalid format") || lowerMessage.contains("must be")) {
            return message;
        }

        // Remove technical error codes (like "422-031-046") but keep the message
        String cleanedMessage = message.replaceAll("\\d{3}-\\d{3}-\\d{3}", "").trim();
        if (cleanedMessage.isEmpty()) {
            return message;
        }

        return cleanedMessage;
    }


    public String createErrorJsonString(String errorMessage) {
        return buildErrorResponse(errorMessage).toString();
    }

    public String createErrorJsonStringFromApiResponse(String apiErrorResponse, String defaultMessage) {
        String userFriendlyMessage = extractUserFriendlyMessage(apiErrorResponse, defaultMessage);
        return createErrorJsonString(userFriendlyMessage);
    }
}


