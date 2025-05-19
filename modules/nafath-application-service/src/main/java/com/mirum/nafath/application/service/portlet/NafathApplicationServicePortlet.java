package com.mirum.nafath.application.service.portlet;

import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.mirum.nafath.application.service.configuration.NafathConfiguration;
import com.mirum.nafath.application.service.constants.NafathApplicationServicePortletKeys;
import org.apache.commons.io.IOUtils;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import javax.portlet.*;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Component(
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=Nafath Application Service",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + NafathApplicationServicePortletKeys.NAFATHAPPLICATIONSERVICE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"

	},
	service = Portlet.class
)
public class NafathApplicationServicePortlet extends MVCPortlet {

	public static final Log _log = LogFactoryUtil.getLog(NafathApplicationServicePortlet.class);

	private volatile NafathConfiguration _nafathConfiguration;


	@Activate
	@Modified
	public void activate(Map<String, Object> properties) throws PortletException {
		_nafathConfiguration = ConfigurableUtil.createConfigurable(NafathConfiguration.class, properties);
		_log.info("Nafath Application Service Portlet initialized");
	}

	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
		try{
			_log.info("based url "+_nafathConfiguration.getFacilityBaseURL());
			renderRequest.setAttribute("facilityBaseUrl", _nafathConfiguration.getFacilityBaseURL());
			renderRequest.setAttribute("facilityApiUserName", _nafathConfiguration.getFacilityAPIUsername());
			renderRequest.setAttribute("facilityApiPassword", _nafathConfiguration.getFacilityAPIPassword());


		}catch (Exception e){
			_log.error("Error loading Nafath Configuration " + e.getMessage());
		}

		super.render(renderRequest, renderResponse);

	}

	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortletException {
		String resourceID = resourceRequest.getResourceID();
		_log.info("resourceID="+resourceID);

		if ("getFacilities".equals(resourceID)) {
			getFacilities(resourceRequest, resourceResponse);
		} else if ("getFacilityDetails".equals(resourceID)) {
			getFacilityDetails(resourceRequest, resourceResponse);
		} else {
			super.serveResource(resourceRequest, resourceResponse);
		}
	}

	private void getFacilities(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException {
		String identificationNumber = ParamUtil.getString(resourceRequest, "identificationNumber", "");
		_log.info("identificationNumber="+identificationNumber);

		if (identificationNumber.isEmpty()) {
			sendJsonResponse(resourceResponse, createErrorResponse("Commercial Register Number is required"));
			return;
		}
		try {
			String token = getAuthToken();
			if (token == null) {
				sendJsonResponse(resourceResponse, createErrorResponse("Failed to get authentication token"));
				return;
			}

			String baseUrl = _nafathConfiguration.getFacilityBaseURL();
			URL url = new URL(baseUrl + "/api/FsciFacility/GetFacilitySeniorOfficialFacilities");
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("Authorization", "Bearer " + token);
			connection.setDoOutput(true);

			// Create request body
			JSONObject requestBody = JSONFactoryUtil.createJSONObject();
			requestBody.put("IdentificationNumber", identificationNumber);

			// Send request
			OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
			writer.write(requestBody.toString());
			writer.flush();

			// Get response
			int responseCode = connection.getResponseCode();
			if (responseCode == HttpURLConnection.HTTP_OK) {
				InputStream inputStream = connection.getInputStream();
				String response = IOUtils.toString(inputStream, "UTF-8");

				// Forward the response to the client
				sendRawResponse(resourceResponse, response);
			} else {
				sendJsonResponse(resourceResponse, createErrorResponse("API error: " + responseCode));
			}

		} catch (Exception e) {
			_log.error("Error getting facilities", e);
			sendJsonResponse(resourceResponse, createErrorResponse("Server error: " + e.getMessage()));
		}
	}

	private void getFacilityDetails(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException {
		String unifiedNumber = ParamUtil.getString(resourceRequest, "unifiedNumber", "");

		if (unifiedNumber.isEmpty()) {
			sendJsonResponse(resourceResponse, createErrorResponse("Unified Number is required"));
			return;
		}

		try {
			String token = getAuthToken();
			if (token == null) {
				sendJsonResponse(resourceResponse, createErrorResponse("Failed to get authentication token"));
				return;
			}

			String baseUrl = _nafathConfiguration.getFacilityBaseURL();
			URL url = new URL(baseUrl + "/api/FsciFacility/GetFacilityByUnifiedNumber");
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("Authorization", "Bearer " + token);
			connection.setDoOutput(true);

			// Create request body
			JSONObject requestBody = JSONFactoryUtil.createJSONObject();
			requestBody.put("Unified700Number", unifiedNumber);

			// Send request
			OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
			writer.write(requestBody.toString());
			writer.flush();

			// Get response
			int responseCode = connection.getResponseCode();
			if (responseCode == HttpURLConnection.HTTP_OK) {
				InputStream inputStream = connection.getInputStream();
				String response = IOUtils.toString(inputStream, "UTF-8");

				// Forward the response to the client
				sendRawResponse(resourceResponse, response);
			} else {
				sendJsonResponse(resourceResponse, createErrorResponse("API error: " + responseCode));
			}

		} catch (Exception e) {
			_log.error("Error getting facility details", e);
			sendJsonResponse(resourceResponse, createErrorResponse("Server error: " + e.getMessage()));
		}
	}

	private String getAuthToken() {
		_log.info("in getAuthToken");
		try {
			String baseUrl = _nafathConfiguration.getFacilityBaseURL();
			String username = _nafathConfiguration.getFacilityAPIUsername();
			String password = _nafathConfiguration.getFacilityAPIPassword();

			_log.info("baseUrl="+baseUrl);
			_log.info("username="+username);
			_log.info("password="+password);

			URL url = new URL(baseUrl + "/api/ApiAuth/login");
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setDoOutput(true);

			// Create request body
			JSONObject requestBody = JSONFactoryUtil.createJSONObject();
			requestBody.put("Username", username);
			requestBody.put("Password", password);

			// Send request
			OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
			writer.write(requestBody.toString());
			writer.flush();

			// Get response
			int responseCode = connection.getResponseCode();
			if (responseCode == HttpURLConnection.HTTP_OK) {
				InputStream inputStream = connection.getInputStream();
				String response = IOUtils.toString(inputStream, StandardCharsets.UTF_8);

				// Parse response to get token
				JSONObject jsonResponse = JSONFactoryUtil.createJSONObject(response);
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

	private JSONObject createErrorResponse(String errorMessage) {
		JSONObject response = JSONFactoryUtil.createJSONObject();
		response.put("succeeded", false);
		response.put("message", "error");

		JSONArray errors = JSONFactoryUtil.createJSONArray();
		errors.put(errorMessage);
		response.put("errors", errors);

		response.put("data", JSONFactoryUtil.createJSONObject());

		return response;
	}

	private void sendJsonResponse(ResourceResponse resourceResponse, JSONObject jsonObject) throws IOException {
		resourceResponse.setContentType("application/json");
		PrintWriter writer = resourceResponse.getWriter();
		writer.write(jsonObject.toString());
		writer.close();
	}

	private void sendRawResponse(ResourceResponse resourceResponse, String response) throws IOException {
		resourceResponse.setContentType("application/json");
		PrintWriter writer = resourceResponse.getWriter();
		writer.write(response);
		writer.close();
	}


}