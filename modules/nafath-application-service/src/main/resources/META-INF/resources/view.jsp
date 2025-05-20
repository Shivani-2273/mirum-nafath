<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="com.liferay.portal.kernel.util.ResourceBundleUtil" %>
<%@ include file="/init.jsp" %>

<%
	// Initialize the ResourceBundle
	ThemeDisplay themeDisplayNew = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
	ResourceBundle resourceBundle = ResourceBundleUtil.getBundle("content.Language", themeDisplayNew.getLocale(), getClass());
%>
<c:if test="<%= themeDisplay.isSignedIn() %>">
<portlet:resourceURL id="getFacilities" var="getFacilitiesURL" />
<portlet:resourceURL id="getFacilityDetails" var="getFacilityDetailsURL" />


<portlet:actionURL name="/submitForm" var="submitActionURL" />

<div class="form-heading">
	<h1><liferay-ui:message key="form-name" /></h1>
	<div class="form-header-line"></div>
</div>


<div class="contact-form">
	<div class="required-indicator">
		<span style="color:red">*</span> <liferay-ui:message key="indicate-required-fields" />
	</div>
<aui:form action="${submitActionURL}" method="post" name="contactForm" validateOnBlur="false" cssClass="form-validate" novalidate="novalidate">

	<aui:input type="hidden" name="beneficiaryTypeValue" value="" />

	<!-- Radio Group -->
	<label class="aui-field-label mb-2 beneficiary-title">
		<liferay-ui:message key="beneficiary-type" />
	</label>
	<div class="d-flex flex-row gap-3 mb-3 beneficiary-option">
		<aui:input id="beneficiaryJoint" label='<%= LanguageUtil.get(request, "joint-venture") %>' name="SingleSelection31733470" type="radio" value="Option57860000" />
		<aui:input id="beneficiaryShared" label='<%= LanguageUtil.get(request, "shared-facility") %>' name="SingleSelection31733470" type="radio" value="Option37259187" />
		<aui:input id="beneficiaryIndividual" label='<%= LanguageUtil.get(request, "individuals") %>' name="SingleSelection31733470" type="radio" value="Option78885409" />
	</div>
	<div class="beneficiary-error-container"></div>



	<!-- Section Label -->
	<label class="aui-field-label mb-5 mt-3 contact-information-label">
		<liferay-ui:message key="contact-information" />
	</label>

	<div class="id-numbers-block">
		<aui:input name="Text48247902" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' id="id-number" />
	</div>
<%--	<div class="commercial-register-block">--%>
<%--		<aui:input name="Text32667190" type="text" label='<%= LanguageUtil.get(request, "commercial-register-number") %>' id="commercial-register-number"  />--%>
<%--	</div>--%>

	<div class="commercial-register-block">
		<div class="d-flex align-items-end mb-2">
			<div id="<portlet:namespace />crNumberFullDiv" class="w-100">
				<aui:input name="Text32667190" type="text" label='<%= LanguageUtil.get(request, "commercial-register-number") %>' id="commercial-register-number" />
			</div>
			<div id="<portlet:namespace />crNumberPartialDiv" style="display: none; width: 80%;">
				<aui:input name="Text32667190" type="text" label='<%= LanguageUtil.get(request, "commercial-register-number") %>' id="commercial-register-number-joint" />
			</div>

			<div id="<portlet:namespace />authBtnDiv" style="display: none; margin-left: 10px;">
				<button id="<portlet:namespace />verifyBtn" class="btn btn-primary verify-btn" type="button">
					<liferay-ui:message key="authenticate" />
				</button>
			</div>
		</div>
		<div id="<portlet:namespace />commercialRegisterErrorContainer" class="error-message-container mt-1" style="display: none; text-align: right;"></div>



		<div id="<portlet:namespace />facilityDropdownContainer" style="display: none;" class="mb-3">
			<label class="control-label"><liferay-ui:message key="select-facility" /></label>
			<select class="form-control" id="<portlet:namespace />facilityDropdown">
				<option value=""><liferay-ui:message key="select-facility" /></option>
			</select>
		</div>
	</div>

	<!-- Name Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "the-name-fieldset") %>' id="the-name-fieldset">
	<aui:fieldset-group>
			<div class="two-columns hidden-label" id="the-name-fieldset">
				<aui:input  name="Text11901603" type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' id="nameAR" />

				<aui:input  name="Text58108483" type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>'  id="nameEN"/>

			</div>
	</aui:fieldset-group>
	</aui:fieldset>


	<!-- Side Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "the-side-fieldset") %>' id="the-side-fieldset">
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "side-in-ar") %>' name="Text75967247" id="sideAR"/>
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "side-in-en") %>' name="Text74412617" id="sideEN"/>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Facility Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "facility-fieldset") %>' id="the-facility-fieldset">
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "facility-in-ar") %>' name="Text71274743" id="facilityAR"/>
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "facility-in-en") %>' name="Text87876384" id="facilityEN" />
			</div>
		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Position Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "position-fieldset") %>' id="the-position-fieldset">
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text33648088" id="positionAR"/>
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text05750920" id="positionEN"/>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Inputs in two columns -->
	<div class="two-columns mb-3 email-mobile-block">
		<aui:input id="email" name="Text26438725" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
		<aui:input id="mobile" name="Text16606223" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />
	</div>


	<!-- National Address Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "national-address-fieldset") %>' id="national-address-fieldset">
		<aui:fieldset-group>
			<div class="two-columns">
				<aui:input type="text" label='<%= LanguageUtil.get(request, "short-title") %>' name="Text02966926" />
				<aui:input type="text" label='<%= LanguageUtil.get(request, "building-number") %>' name="Text05487912" />
			</div>

			<div class="two-columns">
				<aui:input type="text" label='<%= LanguageUtil.get(request, "zip-code") %>' name="Text60172326" />
				<aui:input type="text" label='<%= LanguageUtil.get(request, "city") %>' name="Text37571330" />
			</div>

			<div class="two-columns">
				<aui:input type="text" label='<%= LanguageUtil.get(request, "neighborhood") %>' name="Text30517284" />
				<aui:input type="text" label='<%= LanguageUtil.get(request, "street") %>' name="Text98797381" />
			</div>
		</aui:fieldset-group>
	</aui:fieldset>


<%--	<!-- Radio Group -->--%>
<%--	<label class="aui-field-label mb-3">--%>
<%--		<liferay-ui:message key="facility-in-jeddah" />--%>
<%--	</label>--%>
<%--	<div class="d-flex flex-row gap-3 mb-3">--%>
<%--		<aui:input label='<%= LanguageUtil.get(request, "yes") %>' name="SingleSelection26821777" type="radio" value="Option02400048" />--%>
<%--		<aui:input label='<%= LanguageUtil.get(request, "no") %>' name="SingleSelection26821777" type="radio" value="Option66189828" />--%>
<%--	</div>--%>


<%--	<aui:input type="text" label='<%= LanguageUtil.get(request, "headquarter-city") %>' name="Text59800910" />--%>

	<!-- Two-Column Multi-Selection Layout -->
	<div class="two-columns mb-3">
		<!-- Left Column -->
		<div class="activities-section" style="flex: 1;">
			<label class="aui-field-label mb-3 activity-title">
				<liferay-ui:message key="choose-activities" />
			</label>

			<aui:fieldset label='<%= LanguageUtil.get(request, "economic-activities") %>' id="activities-fieldset">
				<aui:fieldset-group>
					<div class="multi-select-container">
						<div class="select-options">
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "agriculture-forestry-fishing") %>' value="Option28648690" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "mining-quarrying") %>' value="Option93009697" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "manufacturing") %>' value="Option66911574" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "electricity") %>' value="Option15789151" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "water-supply") %>' value="Option59074135" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "construction") %>' value="Option34517420" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "wholesale-retail") %>' value="Option75026413" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "transportation") %>' value="Option49874292" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "accommodation") %>' value="Option52295489" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "information") %>' value="Option89904137" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "financial") %>' value="Option65687511" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "real-estate") %>' value="Option97760950" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "professional") %>' value="Option80240814" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "admin") %>' value="Option18646175" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "public-admin") %>' value="Option06402386" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "Education") %>' value="Option95563630" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "human-health") %>' value="Option51595558" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "arts") %>' value="Option02599313" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "other-services") %>' value="Option45017854" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection82787835" label='<%= LanguageUtil.get(request, "household-activities") %>' value="Option35695746" />
							</div>


						</div>
					</div>
				</aui:fieldset-group>
			</aui:fieldset>
			<div class="activity-error-container"></div>

		</div>

		<!-- Right Column -->
		<div class="activities-section" style="flex: 1;">
			<label class="aui-field-label mb-3 activity-title">
				<liferay-ui:message key="choose-chambers-events" />
			</label>

			<aui:fieldset label='<%= LanguageUtil.get(request, "chamber-events-activities") %>' id="chambers-events">
				<aui:fieldset-group>
					<div class="multi-select-container">
						<div class="select-options">
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "celebrations") %>' value="Option48554758" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "courses") %>' value="Option98422677" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "encounters") %>' value="Option90309109" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "marketing") %>' value="Option26341252" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "exhibitions") %>' value="Option72176748" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "forums") %>' value="Option34344261" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "trade-delegations") %>' value="Option82977171" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection32324860" label='<%= LanguageUtil.get(request, "workshops") %>' value="Option74527560" />
							</div>
						</div>
					</div>
				</aui:fieldset-group>
			</aui:fieldset>
			<div class="chamber-error-container"></div>

		</div>
	</div>

	<!-- Paragraph  -->
	<div class="contact-information-departments">
	<h4 class="para-title"><liferay-ui:message key="para-title" /></h4>
	<label class="para-body">
		<liferay-ui:message key="para-body" />
	</label>
	</div>



	<!-- Departments -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "department") %>' id="departments">
		<aui:fieldset-group>
			<div class="multi-select-container">
			<div class="select-options">
				<div class="option-item">
					<aui:input type="checkbox" id="finance-departments" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "finance") %>' value="Option72812845" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="hr-departments" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "hr") %>' value="Option74651805" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="it-departments" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "information-technology") %>' value="Option23954894" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="purchase-departments" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "purchase") %>' value="Option70997471" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="legal-departments" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "legal") %>' value="Option36842803" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="corporate-departments" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "corporate-communication") %>' value="Option80053693" />
				</div>
			</div>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

<!-- Finance Block -->
	<aui:fieldset id="finance-fieldset" label='<%= LanguageUtil.get(request, "finance") %>'>
		<aui:fieldset-group>
			<aui:input name="Text37569148" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Text03132573" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Text63235386" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Field26746989" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Field84398430" />
				</div>
			</aui:fieldset-group>


				<aui:input id="financeEmail" name="Text40540494" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
				<aui:input id="financeMobile" name="Text54170527" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- HR Block -->
	<aui:fieldset id="hr-fieldset" label='<%= LanguageUtil.get(request, "hr") %>'>
		<aui:fieldset-group>
			<aui:input name="Field23772962" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>

				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Field83091156" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Field65953305" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Field63941023" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Field98586460" />
				</div>
			</aui:fieldset-group>


			<aui:input id="hrEmail" name="Field60859902" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="hrMobile" name="Field49141481" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Information Technology Block -->
	<aui:fieldset id="information-technology-fieldset" label='<%= LanguageUtil.get(request, "information-technology") %>'>
		<aui:fieldset-group>
			<aui:input name="Field79528544" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Field01434275" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Field46869730" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Field61654272" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Field82429394" />
				</div>
			</aui:fieldset-group>


			<aui:input id="itEmail" name="Field45598067" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="itMobile" name="Field15319663" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Purchase Block -->
	<aui:fieldset  id="purchase-fieldset" label='<%= LanguageUtil.get(request, "purchase") %>'>
		<aui:fieldset-group>
			<aui:input name="Field79581387" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Field97568085" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Field93065457" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Field29806728" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Field04285173" />
				</div>
			</aui:fieldset-group>


			<aui:input id="purchaseEmail" name="Field89611484" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="purchaseMobile" name="Field04658136" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Legal Block -->
	<aui:fieldset id="legal-fieldset" label='<%= LanguageUtil.get(request, "legal") %>'>
		<aui:fieldset-group>
			<aui:input name="Field72461426" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Field31248998" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Field03343352" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Field13051923" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Field30279475" />
				</div>
			</aui:fieldset-group>


			<aui:input id="legalEmail" name="Field28818236" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="legalMobile" name="Field44379879" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Corporate Communication Block -->
	<aui:fieldset id="corporate-communication-fieldset" label='<%= LanguageUtil.get(request, "corporate-communication") %>'>
		<aui:fieldset-group>
			<aui:input name="Field58216222" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Field25347647" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Field13991883" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Field75492677" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Field73802044" />
				</div>
			</aui:fieldset-group>


			<aui:input id="corporateEmail" name="Field00345900" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="corporateMobile" name="Field95741530" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Terms & Conditions -->
	<div class="terms-policies-section">
	<label class="aui-field-label mb-3 policy-line"><liferay-ui:message key="terms-policies" /></label>
	<aui:input label='<%= LanguageUtil.get(request, "agree") %>' name="SingleSelection74748058" type="radio" value="Option08619081" />
		<div class="terms-error-container"></div>

	</div>

	<!-- Privacy Policy  -->
	<div class="privacy-policy-section">
	 	<a class="policy-link" href="https://www.jcci.org.sa/%D8%A5%D8%B4%D8%B9%D8%A7%D8%B1-%D8%A7%D9%84%D8%AE%D8%B5%D9%88%D8%B5%D9%8A%D8%A9"><liferay-ui:message key="privacy-policy" /></a>
	</div>

	<!-- Submit Button -->
	<aui:button name="submit" type="submit" primary="true" value="Submit" />


</aui:form>
</div>

<aui:script>

	window.apiConfig = {
	getFacilitiesURL: '${getFacilitiesURL}',
	getFacilityDetailsURL: '${getFacilityDetailsURL}'
	};


	// Create window-level variables for language keys
	window.formLanguageKeys = {
	'please-select-one-option': '<%= LanguageUtil.get(resourceBundle, "please-select-one-option") %>',
	'custom-field-is-required': '<%= LanguageUtil.get(resourceBundle, "custom-field-is-required") %>',
	'please-select-at-least-one-activity': '<%= LanguageUtil.get(resourceBundle, "please-select-at-least-one-activity") %>',
	'please-select-at-least-one-event': '<%= LanguageUtil.get(resourceBundle, "please-select-at-least-one-event") %>',
	'please-enter-valid-email': '<%= LanguageUtil.get(resourceBundle, "please-enter-valid-email") %>',
	'please-enter-valid-mobile': '<%= LanguageUtil.get(resourceBundle, "please-enter-valid-mobile") %>',
	'please-agree-to-terms': '<%= LanguageUtil.get(resourceBundle, "please-agree-to-terms") %>'
	};
</aui:script>


<script src="<%=request.getContextPath()%>/js/index.js"></script>
<script src="<%=request.getContextPath()%>/js/facility-integration.js"></script>

<script>
	window.portletNamespace = '<portlet:namespace />';
</script>
</c:if>