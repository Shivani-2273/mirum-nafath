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
<portlet:resourceURL id="initiateNafathAuth" var="initiateNafathAuthURL" />
<portlet:resourceURL id="checkNafathStatus" var="checkNafathStatusURL" />


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
		<aui:input id="beneficiaryJoint" label='<%= LanguageUtil.get(request, "joint-venture") %>' name="SingleSelection49142181" type="radio" value="Option68585683" />
		<aui:input id="beneficiaryShared" label='<%= LanguageUtil.get(request, "shared-facility") %>' name="SingleSelection49142181" type="radio" value="Option73930235" />
		<aui:input id="beneficiaryIndividual" label='<%= LanguageUtil.get(request, "individuals") %>' name="SingleSelection49142181" type="radio" value="Option38756848" />
	</div>
	<div class="beneficiary-error-container"></div>



	<!-- Section Label -->
	<label class="aui-field-label mb-5 mt-3 contact-information-label">
		<liferay-ui:message key="contact-information" />
	</label>

	<div class="id-numbers-block">
		<aui:input name="Text37967193" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' id="id-number" />
	</div>
<%--	<div class="commercial-register-block">--%>
<%--		<aui:input name="Text32667190" type="text" label='<%= LanguageUtil.get(request, "commercial-register-number") %>' id="commercial-register-number"  />--%>
<%--	</div>--%>

	<div class="commercial-register-block">
		<div class="d-flex align-items-end mb-2">
			<div id="<portlet:namespace />crNumberFullDiv" class="w-100">
				<aui:input name="Text19727377" type="text" label='<%= LanguageUtil.get(request, "commercial-register-number") %>' id="commercial-register-number" />
			</div>
			<div id="<portlet:namespace />crNumberPartialDiv" style="display: none; width: 80%;">
				<aui:input name="Text19727377" type="text" label='<%= LanguageUtil.get(request, "commercial-register-number") %>' id="commercial-register-number-joint" />
			</div>

			<div id="<portlet:namespace />authBtnDiv" class="verify-btn" style="display: none;">
				<aui:button id="verifyBtn" class="verify-btn" type="button" primary="true" value='<%= LanguageUtil.get(request, "authenticate") %>' />
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
				<aui:input  name="Text26194049" type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' id="nameAR" />

				<aui:input  name="Text28520341" type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>'  id="nameEN"/>

			</div>
	</aui:fieldset-group>
	</aui:fieldset>


	<!-- Side Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "the-side-fieldset") %>' id="the-side-fieldset">
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "side-in-ar") %>' name="Text84285354" id="sideAR"/>
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "side-in-en") %>' name="Text21573226" id="sideEN"/>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Facility Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "facility-fieldset") %>' id="the-facility-fieldset">
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "facility-in-ar") %>' name="Text24890298" id="facilityAR"/>
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "facility-in-en") %>' name="Text18772368" id="facilityEN" />
			</div>
		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Position Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "position-fieldset") %>' id="the-position-fieldset">
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text74041813" id="positionAR"/>
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text68622509" id="positionEN"/>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Inputs in two columns -->
	<div class="two-columns mb-3 email-mobile-block">
		<aui:input id="email" name="Text30331048" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
		<aui:input id="mobile" name="Text68660518" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />
	</div>

	<div class="additional-mobile-block">
		<aui:input name="Text97163476" type="text" label='<%= LanguageUtil.get(request, "additional-mobile") %>' id="additional-mobile" />
	</div>

	<aui:fieldset label='<%= LanguageUtil.get(request, "method-of-communication") %>' id="communication-methods-fieldset">
		<aui:fieldset-group>
			<div class="multi-select-container">
				<div class="select-options">
					<div class="option-item">
						<aui:input type="checkbox" id="comm-email" name="MultipleSelection38517444" label='<%= LanguageUtil.get(request, "email") %>' value="Option77808468" />
					</div>
					<div class="option-item">
						<aui:input type="checkbox" id="comm-text-message" name="MultipleSelection38517444" label='<%= LanguageUtil.get(request, "text-message") %>' value="Option74566757" />
					</div>
					<div class="option-item">
						<aui:input type="checkbox" id="com-whatsapp" name="MultipleSelection38517444" label='<%= LanguageUtil.get(request, "whatsapp") %>' value="Option53635381" />
					</div>
				</div>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>


	<!-- National Address Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "national-address-fieldset") %>' id="national-address-fieldset">
		<aui:fieldset-group>
			<div class="two-columns">
				<aui:input type="text" label='<%= LanguageUtil.get(request, "short-title") %>' name="Text78233034" />
				<aui:input type="text" label='<%= LanguageUtil.get(request, "building-number") %>' name="Text52032644" />
			</div>

			<div class="two-columns">
				<aui:input type="text" label='<%= LanguageUtil.get(request, "zip-code") %>' name="Text19481304" />
				<aui:input type="text" label='<%= LanguageUtil.get(request, "city") %>' name="Text95323319" />
			</div>

			<div class="two-columns">
				<aui:input type="text" label='<%= LanguageUtil.get(request, "neighborhood") %>' name="Text63674077" />
				<aui:input type="text" label='<%= LanguageUtil.get(request, "street") %>' name="Text73000074" />
			</div>
		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Radio Group -->
   <div class="establishment-address">
		<label class="aui-field-label mb-3">
			<liferay-ui:message key="facility-in-jeddah" />
		</label>
		<div class="d-flex flex-row mb-5">
			<aui:input label='<%= LanguageUtil.get(request, "yes") %>' name="SingleSelection12409885" type="radio" value="Option14984869" />
			<aui:input label='<%= LanguageUtil.get(request, "no") %>' name="SingleSelection12409885" type="radio" value="Option75004962" />
		</div>
   </div>


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
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "agriculture-forestry-fishing") %>' value="Option49253573" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "mining-quarrying") %>' value="Option78047586" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "manufacturing") %>' value="Option46555568" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "electricity") %>' value="Option60959047" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "water-supply") %>' value="Option16925670" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "construction") %>' value="Option77751571" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "wholesale-retail") %>' value="Option93362632" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "transportation") %>' value="Option23938783" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "accommodation") %>' value="Option02057178" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "information") %>' value="Option35646412" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "financial") %>' value="Option39401703" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "real-estate") %>' value="Option08282432" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "professional") %>' value="Option20671930" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "admin") %>' value="Option63865034" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "public-admin") %>' value="Option37768330" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "Education") %>' value="Option39626120" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "human-health") %>' value="Option20886770" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "arts") %>' value="Option94919935" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "other-services") %>' value="Option21543383" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72769309" label='<%= LanguageUtil.get(request, "household-activities") %>' value="Option84802456" />
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
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "celebrations") %>' value="Option71012535" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "courses") %>' value="Option48790192" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "encounters") %>' value="Option71369019" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "marketing") %>' value="Option94440261" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "exhibitions") %>' value="Option44503599" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "forums") %>' value="Option21916009" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "trade-delegations") %>' value="Option12986564" />
							</div>
							<div class="option-item">
								<aui:input type="checkbox" name="MultipleSelection72831019" label='<%= LanguageUtil.get(request, "workshops") %>' value="Option12896922" />
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
					<aui:input type="checkbox" id="finance-departments" name="MultipleSelection70288431" label='<%= LanguageUtil.get(request, "finance") %>' value="Option01705536" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="hr-departments" name="MultipleSelection70288431" label='<%= LanguageUtil.get(request, "hr") %>' value="Option89878225" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="it-departments" name="MultipleSelection70288431" label='<%= LanguageUtil.get(request, "information-technology") %>' value="Option48943888" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="purchase-departments" name="MultipleSelection70288431" label='<%= LanguageUtil.get(request, "purchase") %>' value="Option56092187" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="legal-departments" name="MultipleSelection70288431" label='<%= LanguageUtil.get(request, "legal") %>' value="Option33597735" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" id="corporate-departments" name="MultipleSelection70288431" label='<%= LanguageUtil.get(request, "corporate-communication") %>' value="Option93903175" />
				</div>
			</div>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

<!-- Finance Block -->
	<aui:fieldset id="finance-fieldset" label='<%= LanguageUtil.get(request, "finance") %>'>
		<aui:fieldset-group>
			<aui:input name="Text78843263" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Text85024004" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Text87369591" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text71686774" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text60071075" />
				</div>
			</aui:fieldset-group>


				<aui:input id="financeEmail" name="Text64321697" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
				<aui:input id="financeMobile" name="Text69478103" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- HR Block -->
	<aui:fieldset id="hr-fieldset" label='<%= LanguageUtil.get(request, "hr") %>'>
		<aui:fieldset-group>
			<aui:input name="Text57078469" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>

				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Text56756398" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Text92463430" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text36865380" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text95850360" />
				</div>
			</aui:fieldset-group>


			<aui:input id="hrEmail" name="Text42618261" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="hrMobile" name="Text85068191" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Information Technology Block -->
	<aui:fieldset id="information-technology-fieldset" label='<%= LanguageUtil.get(request, "information-technology") %>'>
		<aui:fieldset-group>
			<aui:input name="Text50230087" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Text61963725" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Text62543592" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text81046309" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text61591461" />
				</div>
			</aui:fieldset-group>


			<aui:input id="itEmail" name="Text93191153" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="itMobile" name="Text66776427" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Purchase Block -->
	<aui:fieldset  id="purchase-fieldset" label='<%= LanguageUtil.get(request, "purchase") %>'>
		<aui:fieldset-group>
			<aui:input name="Text16224428" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Text97866028" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Text59361440" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text87964762" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text29907495" />
				</div>
			</aui:fieldset-group>


			<aui:input id="purchaseEmail" name="Text97711703" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="purchaseMobile" name="Text86487041" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Legal Block -->
	<aui:fieldset id="legal-fieldset" label='<%= LanguageUtil.get(request, "legal") %>'>
		<aui:fieldset-group>
			<aui:input name="Text62954754" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Text36446089" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Text92214396" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text48445073" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text19494139" />
				</div>
			</aui:fieldset-group>


			<aui:input id="legalEmail" name="Text09004905" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="legalMobile" name="Text11960174" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Corporate Communication Block -->
	<aui:fieldset id="corporate-communication-fieldset" label='<%= LanguageUtil.get(request, "corporate-communication") %>'>
		<aui:fieldset-group>
			<aui:input name="Text96447241" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "the-name-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' name="Text52768215" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>' name="Text86542444" />
				</div>
			</aui:fieldset-group>

			<aui:fieldset-group>
				<label class="control-label sub-title"><%= LanguageUtil.get(request, "position-fieldset") %></label>
				<div class="two-columns hidden-label">
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text16981668" />
					<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text29824092" />
				</div>
			</aui:fieldset-group>


			<aui:input id="corporateEmail" name="Text17524631" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input id="corporateMobile" name="Text15583733" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Terms & Conditions -->
	<div class="terms-policies-section">
	<label class="aui-field-label mb-3 policy-line"><liferay-ui:message key="terms-policies" /></label>
	<aui:input label='<%= LanguageUtil.get(request, "agree") %>' name="SingleSelection23359718" type="radio" value="Option24943485" />
		<div class="terms-error-container"></div>

	</div>

	<!-- Privacy Policy  -->
	<div class="privacy-policy-section">
	 	<a class="policy-link" href="https://www.jcci.org.sa/%D8%A5%D8%B4%D8%B9%D8%A7%D8%B1-%D8%A7%D9%84%D8%AE%D8%B5%D9%88%D8%B5%D9%8A%D8%A9"><liferay-ui:message key="privacy-policy" /></a>
	</div>

	<!-- Submit Button -->
	<aui:button name="submit" class="form-submit-btn" type="submit" primary="true" value='<%= LanguageUtil.get(request, "submit") %>' />


</aui:form>
</div>

<aui:script>

	window.apiConfig = {
	initiateNafathAuthURL: '${initiateNafathAuthURL}',
	checkNafathStatusURL: '${checkNafathStatusURL}',
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
	'please-agree-to-terms': '<%= LanguageUtil.get(resourceBundle, "please-agree-to-terms") %>',
	'nafath-auth-initiated': '<%= LanguageUtil.get(resourceBundle, "nafath-auth-initiated") %>',
	'nafath-auth-pending': '<%= LanguageUtil.get(resourceBundle, "nafath-auth-pending") %>',
	'nafath-auth-failed': '<%= LanguageUtil.get(resourceBundle, "nafath-auth-failed") %>',
	'nafath-auth-timeout': '<%= LanguageUtil.get(resourceBundle, "nafath-auth-timeout") %>',
	'nafath-auth-completed': '<%= LanguageUtil.get(resourceBundle, "nafath-auth-completed") %>',
	'nafath-verification-number': '<%= LanguageUtil.get(resourceBundle, "nafath-verification-number") %>',
	'nafath-match-number': '<%= LanguageUtil.get(resourceBundle, "nafath-match-number") %>',
	'please-select-a-facility': '<%= LanguageUtil.get(resourceBundle, "please-select-a-facility") %>',
	'no-facilities-found': '<%= LanguageUtil.get(resourceBundle, "no-facilities-found") %>',
	'api-error': '<%= LanguageUtil.get(resourceBundle, "api-error") %>',
	'authenticate': '<%= LanguageUtil.get(resourceBundle, "authenticate") %>',
	'verified': '<%= LanguageUtil.get(resourceBundle, "verified") %>',
	'loading-facilities': '<%= LanguageUtil.get(resourceBundle, "loading-facilities") %>',
	'checking-status': '<%= LanguageUtil.get(resourceBundle, "checking-status") %>',
	'authenticating': '<%= LanguageUtil.get(resourceBundle, "authenticating") %>',
	'verification-number': '<%= LanguageUtil.get(resourceBundle, "verification-number") %>'
	};
</aui:script>


<script src="<%=request.getContextPath()%>/js/index.js"></script>
<script src="<%=request.getContextPath()%>/js/facility-integration.js"></script>

<script>
	window.portletNamespace = '<portlet:namespace />';
</script>
</c:if>