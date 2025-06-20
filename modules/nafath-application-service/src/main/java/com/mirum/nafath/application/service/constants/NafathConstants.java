package com.mirum.nafath.application.service.constants;


public class NafathConstants {

	public static final String NAFATHAPPLICATIONSERVICE =
		"com_mirum_nafath_application_service_NafathApplicationServicePortlet";


	public static final String GET_FACILITIES_RESOURCE_ID = "getFacilities";
	public static final String GET_FACILITIES_DETAILS_RESOURCE_ID = "getFacilityDetails";
	public static final String CHECK_STATUS_RESOURCE_ID = "checkNafathStatus";
	public static final String INITIATE_NAFATH_AUTH_RESOURCE_ID = "initiateNafathAuth";


	public static final String NAFATH_MFA_REQUEST_ENDPOINT = "/mfa/request";
	public static final String NAFATH_MFA_STATUS_ENDPOINT = "/mfa/request/status";
	public static final String FACILITY_AUTH_ENDPOINT = "/api/ApiAuth/login";
	public static final String FACILITY_LIST_ENDPOINT = "/api/FsciFacility/GetFacilitySeniorOfficialFacilities";
	public static final String FACILITY_DETAILS_ENDPOINT = "/api/FsciFacility/GetFacilityByUnifiedNumber";

	public static final String CONTENT_TYPE_JSON = "application/json";
	public static final String HEADER_APP_ID = "APP-ID";
	public static final String HEADER_APP_KEY = "APP-KEY";
	public static final String HEADER_AUTHORIZATION = "Authorization";
	public static final String BEARER_PREFIX = "Bearer ";

	public static final String PARAM_NATIONAL_ID = "nationalId";
	public static final String PARAM_TRANS_ID = "transId";
	public static final String PARAM_RANDOM = "random";
	public static final String PARAM_IDENTIFICATION_NUMBER = "identificationNumber";
	public static final String PARAM_UNIFIED_NUMBER = "unifiedNumber";
}