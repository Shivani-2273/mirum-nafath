package com.mirum.nafath.application.service.portlet;

import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.mirum.nafath.application.service.configuration.NafathConfiguration;
import com.mirum.nafath.application.service.constants.NafathConstants;
import com.mirum.nafath.application.service.dto.ApiResponse;
import com.mirum.nafath.application.service.dto.NafathStatusRequest;
import com.mirum.nafath.application.service.util.FacilityService;
import com.mirum.nafath.application.service.util.NafathAuthService;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import javax.portlet.*;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@Component(
		immediate = true,
		configurationPid = "com.mirum.nafath.application.service.configuration.NafathConfiguration",
		property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=Nafath Application Service",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + NafathConstants.NAFATHAPPLICATIONSERVICE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"

	},
	service = Portlet.class
)
public class NafathApplicationServicePortlet extends MVCPortlet {

	public static final Log _log = LogFactoryUtil.getLog(NafathApplicationServicePortlet.class);

	private volatile NafathConfiguration _nafathConfiguration;

	@Reference
	private NafathAuthService nafathAuthService;

	@Reference
	private FacilityService facilityService;

	@Activate
	@Modified
	public void activate(Map<String, Object> properties) throws PortletException {
		_nafathConfiguration = ConfigurableUtil.createConfigurable(NafathConfiguration.class, properties);
	}

	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
		try{

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
		String resourceId = resourceRequest.getResourceID();

		switch (resourceId){
			case NafathConstants.INITIATE_NAFATH_AUTH_RESOURCE_ID:
				handleInitiateAuth(resourceRequest, resourceResponse);
				break;
			case NafathConstants.CHECK_STATUS_RESOURCE_ID:
				handleCheckStatus(resourceRequest, resourceResponse);
				break;
			case NafathConstants.GET_FACILITIES_RESOURCE_ID:
				handleGetFacilities(resourceRequest, resourceResponse);
				break;
			case NafathConstants.GET_FACILITIES_DETAILS_RESOURCE_ID:
				handleGetFacilityDetails(resourceRequest, resourceResponse);
				break;
			default:
				super.serveResource(resourceRequest, resourceResponse);
				break;
		}
	}

	private void handleInitiateAuth(ResourceRequest request, ResourceResponse response) throws IOException {
		String nationalId = ParamUtil.getString(request, NafathConstants.PARAM_NATIONAL_ID, "");
		ApiResponse<JSONObject> result = nafathAuthService.initiateAuthentication(nationalId, _nafathConfiguration);
		sendJsonResponse(response, convertToJsonObject(result));
	}

	private void handleCheckStatus(ResourceRequest request, ResourceResponse response) throws IOException {
		String nationalId = ParamUtil.getString(request, NafathConstants.PARAM_NATIONAL_ID, "");
		String transId = ParamUtil.getString(request, NafathConstants.PARAM_TRANS_ID, "");
		String random = ParamUtil.getString(request, NafathConstants.PARAM_RANDOM, "");

		NafathStatusRequest statusRequest = new NafathStatusRequest(nationalId, transId, random);
		String result = nafathAuthService.checkAuthenticationStatus(statusRequest, _nafathConfiguration);
		sendRawResponse(response, result);
	}

	private void handleGetFacilities(ResourceRequest request, ResourceResponse response) throws IOException {
		String identificationNumber = ParamUtil.getString(request, NafathConstants.PARAM_IDENTIFICATION_NUMBER, "");
		String result = facilityService.getFacilities(identificationNumber, _nafathConfiguration);
		sendRawResponse(response, result);
	}

	private void handleGetFacilityDetails(ResourceRequest request, ResourceResponse response) throws IOException {
		String unifiedNumber = ParamUtil.getString(request, NafathConstants.PARAM_UNIFIED_NUMBER, "");
		String result = facilityService.getFacilityDetails(unifiedNumber, _nafathConfiguration);
		sendRawResponse(response, result);
	}

	private JSONObject convertToJsonObject(ApiResponse<?> apiResponse) {
		JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
		jsonObject.put("succeeded", apiResponse.isSucceeded());
		jsonObject.put("message", apiResponse.getMessage());
		jsonObject.put("data", apiResponse.getData());
		jsonObject.put("errors", apiResponse.getErrors());
		return jsonObject;
	}

	private void sendJsonResponse(ResourceResponse response, JSONObject jsonObject) throws IOException {
		response.setContentType(NafathConstants.CONTENT_TYPE_JSON);
		try (PrintWriter writer = response.getWriter()) {
			writer.write(jsonObject.toString());
		}
	}

	private void sendRawResponse(ResourceResponse response, String responseBody) throws IOException {
		response.setContentType(NafathConstants.CONTENT_TYPE_JSON);
		try (PrintWriter writer = response.getWriter()) {
			writer.write(responseBody);
		}
	}

}