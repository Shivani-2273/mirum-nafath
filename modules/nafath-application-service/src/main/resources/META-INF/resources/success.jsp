<%@ include file="/init.jsp" %>

<div class="main-container">
    <div class="container-fluid container-fluid-max-xl success-container">
        <h1><liferay-ui:message key="form-name" /></h1>
        <div class="separator"></div>
        <div class="alert alert-success info-container">
            <h3><liferay-ui:message key="thank-you" /></h3>
            <p><liferay-ui:message key="form-submitted-successfully-message" /></p>
            <div class="btn-container">
                <a href="<portlet:renderURL />" class="btn btn-secondary">
                    <liferay-ui:message key="back-to-form" />
                </a>
            </div>
        </div>

    </div>
</div>