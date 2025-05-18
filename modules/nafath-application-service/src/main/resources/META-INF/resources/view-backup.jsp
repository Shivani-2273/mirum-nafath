<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ include file="/init.jsp" %>

<style>
    .contact-form{
		max-width: 1248px;
		margin: 0 auto;
		overflow: hidden;
		padding: 0 15px 0 15px;
	}
	.contact-form .fieldset-legend{
		font-size: 0.875rem;
		font-weight: 600;
		padding: 0 0 8px 0;
		border-bottom: 1px solid rgba(0, 0, 0, .1);
		margin-bottom: 10px;
	}

	.contact-form .activity-title{
		border-bottom: 1px solid rgba(0, 0, 0, .1);
		padding: 0 0 10px 0px !important;
	}

	.contact-form .beneficiary-title{
		padding-top: 30px !important;
	}

	.contact-form .sheet .panel-group .sub-title{
		margin-bottom: 10px;
		border-bottom: 1px solid rgba(0, 0, 0, .1);
		padding: 0 0 8px 0;
		 width: 100%;
		 margin-left: 12px;
	}

	.contact-form label{
		padding: 0 12px;
	}

	.contact-form .form-group{
		padding: 0 12px;
	}

	.contact-form .form-group label{
		padding: 0;
	}

	.contact-form .show .panel-body{
		padding: 0;
	}

	.contact-form .aui-field-label {
		font-weight: 600;
		margin-bottom: 0.3rem;
		margin-left: 4px;
		display: inline-block;
		padding: 0 12px;
	}
	.contact-form .radio{
		padding: 0 12px;
	}

	.contact-form .radio label{
	   font-weight: 400;
		display: flex;
		align-items: center;
		gap: 8px;
   }
	.contact-form .radio label input[type=radio]{
		font-weight: 400;
         height: 1rem;
		width: 1rem;
		border: 1px solid rgba(0, 0, 0, .1);
	}
	.contact-form .sheet{
		border-style: hidden;
	   padding-left: 0;
	  padding-right: 0;
	   padding-top: 0;
		margin-top: 0 !important;
    }
	.contact-form .sheet .panel-group{
		margin-bottom: 25px;
	}

	.contact-form .d-flex {
        display: flex;
    }
	.contact-form .flex-row {
        flex-direction: row;
    }
	.contact-form .gap-3 > * + * {
        margin-left: 1.5rem;
    }
	.contact-form .mb-3 {
        margin-bottom: 1.5rem;
    }

	.contact-form .two-columns {
        display: flex;
        gap: 1rem;
    }

	.contact-form .two-columns .form-group{
        width: 50%;
        padding: 0 12px;
    }

	.contact-form .two-columns .form-group label{
		padding: 0;
    }

	.contact-form .two-columns.hidden-label label{
		display: none;
	}

	.contact-form .two-columns .field {
        flex: 1;
    }
	.contact-form .two-columns .select-options .option-item .form-group label , .select-options .option-item .form-group label {
		font-weight: 400;
	}

	.contact-form .two-columns .select-options .option-item .form-group , .select-options .option-item .form-group{
		width: 100%;
	}

	.contact-form .two-columns .select-options .option-item .form-group label input , .select-options .option-item .form-group label input{
	  height: 1rem;
	  width: 1rem;
	  border: 1px solid rgba(0, 0, 0, .1);
	}

	.contact-form .two-columns fieldset{
		padding: 0 0 0 10px;
	}
	.contact-form .para-title{
		padding: 30px 0 0 20px;
		font-weight: 600;
	}
	.contact-form .para-body{
		padding-bottom: 30px;
		font-weight: 400;
		padding-left: 20px;
	}
	.contact-form .two-columns .fieldset-legend{
		padding: 0 0 15px 12px;
		border-bottom: none;
	}
	.contact-form .btn{
		margin: 0 0 0 20px;
	}
	.contact-form .privacy-policy-section{
		padding: 30px 0 50px 0;
	}
	.contact-form .aui-fieldset-content {
        border: none !important;
        padding: 0 !important;
    }
	.contact-form .aui-fieldset-content::before {
        content: '';
        display: block;
        border-bottom: 1px solid #eee;
        margin-bottom: 1rem;
    }

	.contact-form .policy-line{
		padding: 25px 0 10px 12px;
	}

	@media screen and (max-width: 768px){

		.contact-form{
			padding: 0 15px 0 15px;
		}
		.contact-form .two-columns{
			flex-wrap: wrap;
		}
		.contact-form .gap-3 > * + * {
			margin-left: 0;
		}
		.contact-form .two-columns .form-group{
			width: 100%;
		}
		.contact-form .activities-section{
			width: 100%;
			flex: 0 0 auto !important;
		}

		.contact-form .radio{
			width: 100%;
		}

		.contact-form .beneficiary-option{
			flex-wrap: wrap;
		}
	}
</style>

<portlet:actionURL name="/submitForm" var="submitActionURL" />

<div class="contact-form">
<aui:form action="${submitActionURL}" method="post">

	<!-- Radio Group -->
	<label class="aui-field-label mb-2 beneficiary-title">
		<liferay-ui:message key="beneficiary-type" />
	</label>
	<div class="d-flex flex-row gap-3 mb-3 beneficiary-option">
		<aui:input label='<%= LanguageUtil.get(request, "joint-venture") %>' name="SingleSelection31733470" type="radio" value="Option57860000" />
		<aui:input label='<%= LanguageUtil.get(request, "shared-facility") %>' name="SingleSelection31733470" type="radio" value="Option37259187" />
		<aui:input label='<%= LanguageUtil.get(request, "individuals") %>' name="SingleSelection31733470" type="radio" value="Option78885409" />
	</div>

	<!-- Section Label -->
	<label class="aui-field-label mb-5 mt-3">
		<liferay-ui:message key="contact-information" />
	</label>

		<aui:input name="Text48247902" type="text" label='<%= LanguageUtil.get(request, "id-number") %>' />
		<aui:input name="Text32667190" type="text" label='<%= LanguageUtil.get(request, "commercial-register-number") %>' />


	<!-- Name Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "the-name-fieldset") %>'>
	<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input  name="Text11901603" type="text" placeholder='<%= LanguageUtil.get(request, "name-in-ar") %>' />
				<aui:input  name="Text58108483" type="text" placeholder='<%= LanguageUtil.get(request, "name-in-en") %>'  />
			</div>
	</aui:fieldset-group>
	</aui:fieldset>


	<!-- Side Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "the-side-fieldset") %>'>
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "side-in-ar") %>' name="Text75967247" />
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "side-in-en") %>' name="Text74412617" />
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Facility Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "facility-fieldset") %>'>
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "facility-in-ar") %>' name="Text71274743" />
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "facility-in-en") %>' name="Text87876384" />
			</div>
		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Facility Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "position-fieldset") %>'>
		<aui:fieldset-group>
			<div class="two-columns hidden-label">
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-ar") %>' name="Text33648088" />
				<aui:input type="text" placeholder='<%= LanguageUtil.get(request, "position-in-en") %>' name="Text05750920" />
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Inputs in two columns -->
	<div class="two-columns mb-3">
		<aui:input name="Text26438725" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
		<aui:input name="Text16606223" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />
	</div>


	<!-- National Address Fieldset -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "national-address-fieldset") %>'>
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


	<!-- Radio Group -->
	<label class="aui-field-label mb-3">
		<liferay-ui:message key="facility-in-jeddah" />
	</label>
	<div class="d-flex flex-row gap-3 mb-3">
		<aui:input label='<%= LanguageUtil.get(request, "yes") %>' name="SingleSelection26821777" type="radio" value="Option02400048" />
		<aui:input label='<%= LanguageUtil.get(request, "no") %>' name="SingleSelection26821777" type="radio" value="Option66189828" />
	</div>


	<aui:input type="text" label='<%= LanguageUtil.get(request, "headquarter-city") %>' name="Text59800910" />

	<!-- Two-Column Multi-Selection Layout -->
	<div class="two-columns mb-3">
		<!-- Left Column -->
		<div class="activities-section" style="flex: 1;">
			<label class="aui-field-label mb-3 activity-title">
				<liferay-ui:message key="choose-activities" />
			</label>

			<aui:fieldset label='<%= LanguageUtil.get(request, "economic-activities") %>'>
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
		</div>

		<!-- Right Column -->
		<div class="activities-section" style="flex: 1;">
			<label class="aui-field-label mb-3 activity-title">
				<liferay-ui:message key="choose-chambers-events" />
			</label>

			<aui:fieldset label='<%= LanguageUtil.get(request, "chamber-events-activities") %>'>
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
		</div>
	</div>

	<!-- Paragraph  -->
	<h4 class="para-title"><liferay-ui:message key="para-title" /></h4>
	<label class="para-body">
		<liferay-ui:message key="para-body" />
	</label>



	<!-- Departments -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "department") %>'>
		<aui:fieldset-group>
			<div class="multi-select-container">
			<div class="select-options">
				<div class="option-item">
					<aui:input type="checkbox" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "finance") %>' value="Option72812845" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "hr") %>' value="Option74651805" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "information-technology") %>' value="Option23954894" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "purchase") %>' value="Option70997471" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "legal") %>' value="Option36842803" />
				</div>
				<div class="option-item">
					<aui:input type="checkbox" name="MultipleSelection67908018" label='<%= LanguageUtil.get(request, "corporate-communication") %>' value="Option80053693" />
				</div>
			</div>
			</div>
		</aui:fieldset-group>
	</aui:fieldset>

<!-- Finance Block -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "finance") %>'>
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


				<aui:input name="Text40540494" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
				<aui:input name="Text54170527" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- HR Block -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "hr") %>'>
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


			<aui:input name="Field60859902" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input name="Field49141481" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Information Technology Block -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "information-technology") %>'>
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


			<aui:input name="Field45598067" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input name="Field15319663" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Purchase Block -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "purchase") %>'>
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


			<aui:input name="Field89611484" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input name="Field04658136" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Legal Block -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "legal") %>'>
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


			<aui:input name="Field28818236" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input name="Field44379879" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>

	<!-- Corporate Communication Block -->
	<aui:fieldset label='<%= LanguageUtil.get(request, "corporate-communication") %>'>
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


			<aui:input name="Field00345900" type="text" label='<%= LanguageUtil.get(request, "email") %>' placeholder="example@email.com" />
			<aui:input name="Field95741530" type="text" label='<%= LanguageUtil.get(request, "mobile") %>' placeholder="05xxxxxxxx" />

		</aui:fieldset-group>
	</aui:fieldset>


	<!-- Terms & Conditions -->
	<label class="aui-field-label mb-3 policy-line"><liferay-ui:message key="terms-policies" /></label>
	<aui:input label='<%= LanguageUtil.get(request, "agree") %>' name="SingleSelection74748058" type="radio" value="Option08619081" />


	<!-- Privacy Policy  -->
	<div class="privacy-policy-section">
	 	<a class="para-title" href="https://www.jcci.org.sa/%D8%A5%D8%B4%D8%B9%D8%A7%D8%B1-%D8%A7%D9%84%D8%AE%D8%B5%D9%88%D8%B5%D9%8A%D8%A9"><liferay-ui:message key="privacy-policy" /></a>
	</div>

	<!-- Submit Button -->
	<aui:button name="submit" type="submit" primary="true" value="Submit" />

</aui:form>
</div>