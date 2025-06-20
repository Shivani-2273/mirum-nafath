package com.mirum.nafath.application.service.portlet;

import com.liferay.dynamic.data.mapping.model.*;
import com.liferay.dynamic.data.mapping.service.DDMFormInstanceLocalServiceUtil;
import com.liferay.dynamic.data.mapping.service.DDMFormInstanceRecordLocalServiceUtil;
import com.liferay.dynamic.data.mapping.storage.DDMFormFieldValue;
import com.liferay.dynamic.data.mapping.storage.DDMFormValues;
import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.*;
import com.mirum.nafath.application.service.configuration.NafathConfiguration;
import com.mirum.nafath.application.service.constants.NafathConstants;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import java.util.*;

@Component(
        immediate = true,
        configurationPid = "com.mirum.nafath.application.service.configuration.NafathConfiguration",
        property = {
                "javax.portlet.name=" + NafathConstants.NAFATHAPPLICATIONSERVICE,
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

    private volatile NafathConfiguration _nafathConfiguration;

    @Activate
    @Modified
    public void activate(Map<String, Object> properties) throws PortletException {
        _nafathConfiguration = ConfigurableUtil.createConfigurable(NafathConfiguration.class, properties);
        _log.info("FormInstanceId "+_nafathConfiguration.getFormInstanceID());
    }
    @Override
    public boolean processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws PortletException {
        long formInstanceId = Long.parseLong(_nafathConfiguration.getFormInstanceID());
        try {

            ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
            Locale userLocale = themeDisplay.getLocale();

            ServiceContext serviceContext = ServiceContextFactory.getInstance(
                    DDMFormInstanceRecord.class.getName(), actionRequest);

            serviceContext.setLanguageId(LocaleUtil.toLanguageId(userLocale));

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
        ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
        try {
            DDMFormInstance formInstance = DDMFormInstanceLocalServiceUtil.getFormInstance(formInstanceId);
            DDMForm ddmForm = formInstance.getStructure().getDDMForm();

            Locale userLocale = themeDisplay.getLocale();
            Set<Locale> availableLocales = ddmForm.getAvailableLocales();
            Locale defaultLocale = ddmForm.getDefaultLocale();

            DDMFormValues ddmFormValues = new DDMFormValues(ddmForm);
            ddmFormValues.setAvailableLocales(availableLocales);

            if (availableLocales.contains(userLocale)) {
                ddmFormValues.setDefaultLocale(userLocale);
            } else {
                ddmFormValues.setDefaultLocale(defaultLocale);
            }

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
                    DDMFormFieldValue fieldValue = createJsonArrayField(fieldName, values, userLocale, availableLocales,  ddmFormValues.getDefaultLocale());
                    ddmFormFieldValues.add(fieldValue);
                } else if(values.length > 1){
                    String beneficiaryType = ParamUtil.getString(actionRequest, "beneficiaryTypeValue", "");
                    String valueToSave = "";
                    if ("shared".equals(beneficiaryType)) {
                        valueToSave = values[0];
                    } else if ("joint".equals(beneficiaryType)) {
                        valueToSave = values[1];
                    }
                    DDMFormFieldValue fieldValue = createFieldValue(fieldName, valueToSave, userLocale, availableLocales,  ddmFormValues.getDefaultLocale());
                    ddmFormFieldValues.add(fieldValue);
                } else {
                    DDMFormFieldValue fieldValue = createFieldValue(fieldName,
                            values.length > 0 ? values[0] : "", userLocale, availableLocales,  ddmFormValues.getDefaultLocale());
                    ddmFormFieldValues.add(fieldValue);
                }
            }

            ddmFormValues.setDDMFormFieldValues(ddmFormFieldValues);

            return ddmFormValues;
        } catch (Exception e) {
            _log.error("Error building form values: " + e.getMessage(), e);
            throw e;
        }
    }

    private DDMFormFieldValue createFieldValue(String fieldName, String value, Locale userLocale, Set<Locale> allLocales, Locale defaultLocale) {
        DDMFormFieldValue fieldValue = new DDMFormFieldValue();
        fieldValue.setName(fieldName);
        fieldValue.setInstanceId(StringUtil.randomString());

        // Create LocalizedValue with proper locale handling(herer)
        LocalizedValue localizedValue = new LocalizedValue(defaultLocale);

        // Add the value for ALL available locales to ensure validation passes
        for (Locale locale : allLocales) {
            localizedValue.addString(locale, value);
        }

        fieldValue.setValue(localizedValue);
        return fieldValue;
    }

    private DDMFormFieldValue createJsonArrayField(String fieldName, String[] values, Locale userLocale, Set<Locale> allLocales, Locale defaultLocale) {
        try {
            // Filter out "false" values and empty values from checkbox processing
            List<String> actualValues = new ArrayList<>();
            for (String value : values) {
                if (value != null && !value.trim().isEmpty() && !"false".equals(value)) {
                    actualValues.add(value);
                }
            }

            // Create JSON array only with actual selected values
            JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
            for (String value : actualValues) {
                jsonArray.put(value);
            }

            // Convert JSON array to string for storage
            String jsonArrayString = jsonArray.toString();

            // Create field value with JSON array string
            return createFieldValue(fieldName, jsonArrayString, userLocale, allLocales, defaultLocale);
        } catch (Exception e) {
            _log.error("Error creating JSON array field: " + e.getMessage(), e);
            return createFieldValue(fieldName, String.join(",", values), userLocale, allLocales, defaultLocale);
        }
    }
}