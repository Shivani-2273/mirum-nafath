package com.mirum.nafath.application.service.portlet;

import com.liferay.dynamic.data.mapping.model.*;
import com.liferay.dynamic.data.mapping.service.DDMFormInstanceLocalServiceUtil;
import com.liferay.dynamic.data.mapping.service.DDMFormInstanceRecordLocalServiceUtil;
import com.liferay.dynamic.data.mapping.storage.DDMFormFieldValue;
import com.liferay.dynamic.data.mapping.storage.DDMFormValues;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.mirum.nafath.application.service.constants.NafathApplicationServicePortletKeys;
import org.osgi.service.component.annotations.Component;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import java.util.*;

@Component(
        immediate = true,
        property = {
                "javax.portlet.name=" + NafathApplicationServicePortletKeys.NAFATHAPPLICATIONSERVICE,
                "mvc.command.name=/submitForm",
                "javax.portlet.display-name=Application Form",
                "javax.portlet.init-param.template-path=/",
                "javax.portlet.init-param.view-template=/view.jsp",
                "javax.portlet.resource-bundle=content.Language",
                "javax.portlet.security-role-ref=power-user,user"
        },
        service = MVCActionCommand.class
)
public class SubmitFormMVCActionCommand implements MVCActionCommand {

    private static final Log _log = LogFactoryUtil.getLog(SubmitFormMVCActionCommand.class);

    @Override
    public boolean processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws PortletException {
        // Your form instance ID
        long formInstanceId = 56623;

        try {
            ServiceContext serviceContext = ServiceContextFactory.getInstance(
                    DDMFormInstanceRecord.class.getName(), actionRequest);

            DDMFormValues ddmFormValues = buildDDMFormValues(actionRequest, formInstanceId);

            DDMFormInstanceRecordLocalServiceUtil.addFormInstanceRecord(
                    serviceContext.getUserId(),
                    serviceContext.getScopeGroupId(),
                    formInstanceId,
                    ddmFormValues,
                    serviceContext);

            _log.info("Form entry submitted successfully.");
            actionResponse.setRenderParameter("mvcPath", "/success.jsp");
            return true;
        } catch (Exception e) {
            _log.error("Error submitting form: " + e.getMessage(), e);
            SessionErrors.add(actionRequest, "form-submit-error");
        }

        return false;
    }

    private DDMFormValues buildDDMFormValues(ActionRequest actionRequest, long formInstanceId) throws Exception {
        try {
            DDMFormInstance formInstance = DDMFormInstanceLocalServiceUtil.getFormInstance(formInstanceId);
            DDMForm ddmForm = formInstance.getStructure().getDDMForm();

            Locale userLocale = PortalUtil.getLocale(actionRequest);
            Set<Locale> availableLocales = ddmForm.getAvailableLocales();
            Locale defaultLocale = ddmForm.getDefaultLocale();

            DDMFormValues ddmFormValues = new DDMFormValues(ddmForm);
            ddmFormValues.setAvailableLocales(availableLocales);
            ddmFormValues.setDefaultLocale(defaultLocale);

            List<DDMFormFieldValue> ddmFormFieldValues = new ArrayList<>();
            Map<String, String[]> parameterMap = actionRequest.getParameterMap();

            // Get form field definitions for reference
            Map<String, DDMFormField> formFieldMap = new HashMap<>();
            for (DDMFormField field : ddmForm.getDDMFormFields()) {
                formFieldMap.put(field.getName(), field);
            }

            // Process all parameters that match form fields
            for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
                String fieldName = entry.getKey();
                String[] values = entry.getValue();

                // Skip standard action parameters and empty values
                if (fieldName.startsWith("javax.portlet") ||
                        fieldName.equals("formDate") ||
                        fieldName.equals("submit") ||
                        fieldName.equals("checkboxNames") ||
                        values == null ||
                        values.length == 0) {
                    continue;
                }

                // Check if this field exists in the form
                DDMFormField fieldDefinition = formFieldMap.get(fieldName);

                // Handle different field types
                if (fieldDefinition != null && "checkbox_multiple".equals(fieldDefinition.getType())) {
                    // Create proper JSON array for checkbox_multiple fields
                    _log.debug("Processing checkbox_multiple field: " + fieldName);
                    ddmFormFieldValues.add(createJsonArrayField(fieldName, values, userLocale, availableLocales));
                } else if(values.length > 1){
                    String beneficiaryType = ParamUtil.getString(actionRequest, "beneficiaryTypeValue", "");
                    String valueToSave = "";
                    if ("shared".equals(beneficiaryType)) {
                        valueToSave = values[0];

                    } else if ("joint".equals(beneficiaryType)) {
                        valueToSave = values[1];
                    }
                    ddmFormFieldValues.add(createFieldValue(fieldName, valueToSave, userLocale, availableLocales));
                } else {
                    // Single value field
                    _log.debug("Processing single value field: " + fieldName);
                    ddmFormFieldValues.add(createFieldValue(fieldName,
                            values.length > 0 ? values[0] : "", userLocale, availableLocales));
                }
            }

            ddmFormValues.setDDMFormFieldValues(ddmFormFieldValues);
            return ddmFormValues;
        } catch (Exception e) {
            _log.error("Error building form values: " + e.getMessage(), e);
            throw e;
        }
    }

    private DDMFormFieldValue createFieldValue(String fieldName, String value, Locale userLocale, Set<Locale> allLocales) {
        DDMFormFieldValue fieldValue = new DDMFormFieldValue();
        fieldValue.setName(fieldName);
        fieldValue.setInstanceId(StringUtil.randomString());

        LocalizedValue localizedValue = new LocalizedValue(userLocale);
        // Add the value for each available locale
        for (Locale locale : allLocales) {
            localizedValue.addString(locale, value);
        }
        fieldValue.setValue(localizedValue);
        return fieldValue;
    }

    private DDMFormFieldValue createJsonArrayField(String fieldName, String[] values, Locale userLocale, Set<Locale> allLocales) {
        try {
            // Create a JSON array with the values
            JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
            for (String value : values) {
                jsonArray.put(value);
            }

            // Convert JSON array to string for storage
            String jsonArrayString = jsonArray.toString();
            _log.info("JSON Array for " + fieldName + ": " + jsonArrayString);

            // Create field value with JSON array string
            return createFieldValue(fieldName, jsonArrayString, userLocale, allLocales);
        } catch (Exception e) {
            _log.error("Error creating JSON array field: " + e.getMessage(), e);
            // Fallback to simple string if JSON creation fails
            return createFieldValue(fieldName, String.join(",", values), userLocale, allLocales);
        }
    }
}