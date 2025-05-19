package com.mirum.nafath.application.service.configuration;
import aQute.bnd.annotation.metatype.Meta;
import com.liferay.portal.configuration.metatype.annotations.ExtendedObjectClassDefinition;


@ExtendedObjectClassDefinition(
        category = "nafath-configuration",
        scope = ExtendedObjectClassDefinition.Scope.SYSTEM
)
@Meta.OCD(
        id = "com.mirum.nafath.application.service.configuration.NafathConfiguration",
        localization = "content/Language",
        name = "Nafath Configuration"
)
public interface NafathConfiguration {

    @Meta.AD(
            deflt = "",
            required = false,
            name = "app-id"
    )
    String getAppID();

    @Meta.AD(
            deflt = "",
            required = false,
            name = "app-key"
    )
    String getAppKey();

    @Meta.AD(
            deflt = "",
            required = false,
            name = "base-url"
    )
    String getBaseURL();

    @Meta.AD(
            deflt = "https://es.jcci.org.sa/backend",
            required = false,
            name = "facility-base-url"
    )
    String getFacilityBaseURL();

    @Meta.AD(
            deflt = "gWKDkcyjEgtq12fNT3qp3ZfkcAxFgbyqpN6BrqX5AMn7",
            required = false,
            name = "facility-api-username"
    )
    String getFacilityAPIUsername();

    @Meta.AD(
            deflt = "khSXrNM+SRxZkuTnXPz55X1WvmfLAqsA2Tv21PtTZRD7oLE1nFiDafAZ5dH39sTz",
            required = false,
            name = "facility-api-password"
    )
    String getFacilityAPIPassword();

}
