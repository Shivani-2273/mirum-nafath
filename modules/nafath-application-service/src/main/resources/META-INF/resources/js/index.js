AUI().ready(function(A) {

    // Create a custom validation flag
    window.formValidationPassed = false;

    function findAndInitForm() {
        var namespace = window.portletNamespace;
        var form = A.one('#' + namespace + 'contactForm');

        if (form && namespace) {
            form.detach('submit');
            console.log("Form ready! Initializing...");
            initializeFormLogic(A, form, namespace);
        } else {
            setTimeout(findAndInitForm, 100);
        }
    }

    // Start looking for the form
    findAndInitForm();

    function initializeFormLogic(A, form, namespace) {

    function getLanguageKey(key) {
        // First try our custom window.formLanguageKeys
        if (window.formLanguageKeys && window.formLanguageKeys[key]) {
            return window.formLanguageKeys[key];
        }
        // Fallback to Liferay.Language
        if (Liferay.Language) {
            return Liferay.Language.get(key) || key;
        }
        return key;
    }

        var beneficiaryRadios = A.all('.beneficiary-option input[type="radio"]');

        // Track the selected beneficiary type
        window.selectedBeneficiaryType = '';

        var sectionsToHide = [
            'label.contact-information-label',
            'fieldset',
            '.email-mobile-block',
            '.additional-mobile-block',
            '.establishment-address',
            '.id-numbers-block',
            '.commercial-register-block',
            '.activities-section',
            '.contact-information-departments',
            '.terms-policies-section'
        ];

        var departmentMapping = {
            'finance-departments': 'finance-fieldset',
            'hr-departments': 'hr-fieldset',
            'it-departments': 'information-technology-fieldset',
            'purchase-departments': 'purchase-fieldset',
            'legal-departments': 'legal-fieldset',
            'corporate-departments': 'corporate-communication-fieldset'
        };

        // Form validation function
        window.validateForm = function () {
            A.all('.error-message').remove();
            A.all('.field-error').removeClass('field-error');

            let hasErrors = false;

            let beneficiarySelected = false;
            beneficiaryRadios.each(radio => {
                if (radio.get('checked')) beneficiarySelected = true;
            });
            if (!beneficiarySelected) {
                addErrorMessage('.beneficiary-error-container', getLanguageKey('please-select-one-option'));
                hasErrors = true;
            }

            if (window.selectedBeneficiaryType === 'joint') {

                let crNumber = A.one('#' + namespace + 'commercial-register-number-joint')?.get('value')?.trim();
                if (!crNumber) {
                    addErrorMessage('#' + namespace + 'commercial-register-number-joint', getLanguageKey('custom-field-is-required'));
                    hasErrors = true;
                }
                let checkList = [
                    '#' + namespace + 'nameAR',
                    '#' + namespace + 'nameEN',
                    '#' + namespace + 'facilityAR',
                    '#' + namespace + 'facilityEN',
                    '#' + namespace + 'positionAR',
                    '#' + namespace + 'positionEN'
                ];
                checkList.forEach(selector => {
                    let value = A.one(selector)?.get('value')?.trim();
                    if (!value) {
                        addErrorMessage(selector, getLanguageKey('custom-field-is-required'));
                        hasErrors = true;
                    }
                });

                // Email
                var EmailAddress = A.one('#' + namespace + 'email').get('value').trim();
                if (!EmailAddress) {
                    addErrorMessage('#' + namespace + 'email', getLanguageKey('custom-field-is-required'));
                    hasErrors = true;

                }

                // Mobile
                var mobileNumber = A.one('#' + namespace + 'mobile').get('value').trim();
                if (!mobileNumber) {
                    addErrorMessage('#' + namespace + 'mobile', getLanguageKey('custom-field-is-required'));
                    hasErrors = true;
                }

                let facilityDropdown = A.one('#' + namespace + 'facilityDropdown');
                if (facilityDropdown && (!facilityDropdown.get('value') || facilityDropdown.get('value') === '')) {
                    addErrorMessage('#' + namespace + 'facilityDropdown', getLanguageKey('please-select-a-facility'));
                    hasErrors = true;
                }

            }

            if (window.selectedBeneficiaryType === 'shared') {
                let checkList = [
                    '#' + namespace + 'nameAR',
                    '#' + namespace + 'nameEN',
                    '#' + namespace + 'facilityAR',
                    '#' + namespace + 'facilityEN',
                    '#' + namespace + 'positionAR',
                    '#' + namespace + 'positionEN'
                ];
                checkList.forEach(selector => {
                    let value = A.one(selector)?.get('value')?.trim();
                    if (!value) {
                        addErrorMessage(selector, getLanguageKey('custom-field-is-required'));
                        hasErrors = true;
                    }
                });


                let anyActivity = false;
                A.all('#activities-fieldset input[type="checkbox"]').each(c => {
                    if (c.get('checked')) anyActivity = true;
                });
                if (!anyActivity) {
                    addErrorMessage('.activity-error-container', getLanguageKey('please-select-at-least-one-activity'));
                    hasErrors = true;
                }

                // Email
                var email = A.one('#' + namespace + 'email').get('value').trim();
                if (!email) {
                    addErrorMessage('#' + namespace + 'email', getLanguageKey('custom-field-is-required'));
                    hasErrors = true;
                }

                // Mobile
                var mobile = A.one('#' + namespace + 'mobile').get('value').trim();
                if (!mobile) {
                    addErrorMessage('#' + namespace + 'mobile', getLanguageKey('custom-field-is-required'));
                    hasErrors = true;
                }


                let anyEvent = false;
                A.all('#chambers-events input[type="checkbox"]').each(c => {
                    if (c.get('checked')) anyEvent = true;
                });
                if (!anyEvent) {
                    addErrorMessage('.chamber-error-container', getLanguageKey('please-select-at-least-one-event'));
                    hasErrors = true;
                }

                A.all('input[type="checkbox"][id*="departments"]:checked').each(checkbox => {
                    let checkboxId = checkbox.get('id');
                    for (let baseId in departmentMapping) {
                        if (checkboxId.includes(baseId)) {
                            let fieldset = A.one('#' + departmentMapping[baseId]);
                            fieldset?.all('input[type="text"]').each(input => {
                                const inputVal = input.get('value')?.trim();
                                const inputId = '#' + input.get('id');
                                if (!inputVal) {
                                    addErrorMessage(inputId, getLanguageKey('custom-field-is-required'));
                                    hasErrors = true;
                                } else {
                                    // Validate email
                                    if (inputId.includes('Email') && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(inputVal)) {
                                        addErrorMessage(inputId, getLanguageKey('please-enter-valid-email'));
                                        hasErrors = true;
                                    }

                                    // Validate mobile
                                    if (inputId.includes('Mobile') && !/^05\d{8}$/.test(inputVal)) {
                                        addErrorMessage(inputId, getLanguageKey('please-enter-valid-mobile'));
                                        hasErrors = true;
                                    }
                                }
                            });

                        }
                    }
                });

                if (!A.one('.terms-policies-section input[type="radio"]:checked')) {
                    addErrorMessage('.terms-error-container', getLanguageKey('please-agree-to-terms'));
                    hasErrors = true;
                }
            }

            if (window.selectedBeneficiaryType === 'individual') {
                if (!A.one('.terms-policies-section input[type="radio"]:checked')) {
                    addErrorMessage('.terms-error-container', getLanguageKey('please-agree-to-terms'));
                    hasErrors = true;
                }
            }

            // Always validate email and mobile format (if not empty)
            var emailField = A.one('#' + namespace + 'email');
            var emailVal = emailField?.get('value')?.trim();

            if (emailVal && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(emailVal)) {
                addErrorMessage('#' + namespace + 'email', getLanguageKey('please-enter-valid-email'));
                hasErrors = true;
            }

            var mobileField = A.one('#' + namespace + 'mobile');
            var mobileVal = mobileField?.get('value')?.trim();

            if (mobileVal && !/^05\d{8}$/.test(mobileVal)) {
                addErrorMessage('#' + namespace + 'mobile', getLanguageKey('please-enter-valid-mobile'));
                hasErrors = true;
            }

            var additionalMobileField = A.one('#' + namespace + 'additional-mobile');
            var additionalMobileVal = additionalMobileField?.get('value')?.trim();
            if (additionalMobileVal && !/^05\d{8}$/.test(additionalMobileVal)) {
                addErrorMessage('#' + namespace + 'additional-mobile', getLanguageKey('please-enter-valid-mobile'));
                hasErrors = true;
            }


            if (hasErrors) {
                window.scrollTo(0, A.one('.error-message')?.getY() - 100 || 0);
                return false;
            }

            return true;
        };

    function addErrorMessage(selector, message) {
            const el = A.one(selector);
            if (!el) return;
            const errorHTML = `<div class="error-message"><span class="text-danger">${message}</span></div>`;
            if (selector.includes('error-container')) {
                el.append(errorHTML);
            } else {
                const container = el.ancestor();
                container?.addClass('field-error');
                container?.append(errorHTML);
            }
        }

        // Function to add required indicator to labels
        function addRequiredIndicator(selector) {
            var element = A.one(selector);
            if (!element) return;

            if (element.get('nodeName').toLowerCase() === 'fieldset') {
                // For fieldsets, add to legend
                var legend = element.one('legend');
                if (legend) {
                    legend.addClass('required-field');
                }
            } else {
                // For inputs, add to label
                var label = element.ancestor().one('label');
                if (label) {
                    label.addClass('required-field');
                }
            }
        }


        function hideInitialSections() {
            hideAllSelectors(sectionsToHide);

            for (var baseId in departmentMapping) {
                var fieldset = A.one('#' + departmentMapping[baseId]);
                if (fieldset) {
                    fieldset.setStyle('display', 'none');
                }
            }
        }

        function hideAllSelectors(selectors) {
            selectors.forEach(function (selector) {
                A.all(selector).each(function (el) {
                    el.setStyle('display', 'none');
                });
            });
        }

        function showBlockByClass(className) {
            var el = A.one('.' + className);
            var dom = el?.getDOMNode();
            if (el) {
                el.setStyle('display', 'block');
            }
            if (dom) {
                var wrapper = dom.closest('.two-columns');
                if (wrapper) wrapper.style.display = 'flex';
            }
        }

        function showFieldsetSection(id) {
            var fieldset = A.one('#' + id);
            if (fieldset) fieldset.setStyle('display', 'block');

            var dom = fieldset?.getDOMNode();
            if (dom) {
                var section = dom.closest('.activities-section');
                if (section) section.style.display = 'block';
                var wrapper = dom.closest('.two-columns.mb-3');
                if (wrapper) wrapper.style.display = 'flex';
            }
        }

        function departmentSync() {
            showFieldsetSection('departments');

            A.all('input[type="checkbox"][id*="departments"]').each(function (checkbox) {
                var checkboxId = checkbox.get('id');
                for (var baseId in departmentMapping) {
                    if (checkboxId.includes(baseId) || checkboxId.includes(baseId.split('-')[0])) {
                        (function (deptId) {
                            var fieldsetId = departmentMapping[deptId];
                            var fieldset = A.one('#' + fieldsetId);

                            if (checkbox.get('checked') && fieldset) {
                                fieldset.setStyle('display', 'block');

                                // For Shared Facility, add required class to department fieldsets
                                if (window.selectedBeneficiaryType === 'shared') {
                                    var legend = fieldset.one('legend');
                                    if (legend) {
                                        legend.addClass('required-field');
                                    }
                                }
                            }

                            checkbox.on('change', function (e) {
                                var isChecked = e.currentTarget.get('checked');

                                if (fieldset) {
                                    fieldset.setStyle('display', isChecked ? 'block' : 'none');

                                    // Toggle required class for Shared Facility
                                    if (window.selectedBeneficiaryType === 'shared') {
                                        var legend = fieldset.one('legend');
                                        if (legend) {
                                            if (isChecked) {
                                                legend.addClass('required-field');
                                            } else {
                                                legend.removeClass('required-field');
                                            }
                                        }
                                    }
                                }
                            });
                        })(baseId);
                        break;
                    }
                }
            });
        }

        function resetForm() {
            hideInitialSections();

            if (typeof resetFormFields === 'function') {
                resetFormFields();
            }

            // Reset required indicators
            A.all('label:not(.beneficiary-title)').each(function (label) {
                label.removeClass('required-field');
            });

            A.all('legend').each(function (legend) {
                legend.removeClass('required-field');
            });

            // Reset commercial register field layout
            document.getElementById(`${namespace}crNumberFullDiv`).style.display = 'block';
            document.getElementById(`${namespace}crNumberPartialDiv`).style.display = 'none';
            document.getElementById(`${namespace}authBtnDiv`).style.display = 'none';

            const dropdownContainer = document.getElementById(`${namespace}facilityDropdownContainer`);
            if (dropdownContainer) {
                dropdownContainer.style.display = 'none';
            }

            // Clear checkboxes
            A.all('input[type="checkbox"]:checked').each(function (cb) {
                cb.set('checked', false);
            });

            // Clear radio buttons
            A.all('input[type="radio"]').each(radio => {
                if (!radio.ancestor('.beneficiary-option')) {
                    radio.set('checked', false);
                }
            });

            // Clear all text inputs
            A.all('input[type="text"]').each(input => input.set('value', ''));

            // Clear error messages
            A.all('.error-message').each(function (errorMsg) {
                errorMsg.remove();
            });

            // Remove error classes
            A.all('.field-error').each(function (field) {
                field.removeClass('field-error');
            });
        }

        function showCommonFields() {
            showBlockByClass('email-mobile-block');
            showBlockByClass('additional-mobile-block');
            showFieldsetSection('the-name-fieldset');
            showFieldsetSection('the-position-fieldset');
            showFieldsetSection('national-address-fieldset');
            showFieldsetSection('communication-methods-fieldset');
            showFieldsetSection('activities-fieldset');
            showFieldsetSection('chambers-events');
            showBlockByClass('terms-policies-section');
        }

        function showIndividualsForm() {
            // Set beneficiary type for validation
            window.selectedBeneficiaryType = 'individual';

            showBlockByClass('contact-information-label');
            showBlockByClass('id-numbers-block');
            showFieldsetSection('the-side-fieldset');
            showCommonFields();

            // Only Terms is required for Individual
            var termsLabel = A.one('.terms-policies-section .policy-line');
            if (termsLabel) {
                termsLabel.addClass('required-field');
            }
        }

        function showSharedFacilityForm() {
            // Set beneficiary type for validation
            window.selectedBeneficiaryType = 'shared';

            showBlockByClass('contact-information-label');
            showBlockByClass('commercial-register-block');
            showBlockByClass('establishment-address');
            showFieldsetSection('the-facility-fieldset');
            showCommonFields();
            showBlockByClass('contact-information-departments');

            const namespace = window.portletNamespace;

            // Show full width div and hide partial width with button
            document.getElementById(`${namespace}crNumberFullDiv`).style.display = 'block';
            document.getElementById(`${namespace}crNumberPartialDiv`).style.display = 'none';
            document.getElementById(`${namespace}authBtnDiv`).style.display = 'none';

            const dropdownContainer = document.getElementById(`${namespace}facilityDropdownContainer`);
            if (dropdownContainer) {
                dropdownContainer.style.display = 'none';
            }


            // Add required indicators
            addRequiredIndicator('#the-name-fieldset');
            addRequiredIndicator('#the-facility-fieldset');
            addRequiredIndicator('#the-position-fieldset');
            addRequiredIndicator('#' + namespace + 'email');
            addRequiredIndicator('#' + namespace + 'mobile');

            // Add required to activity section titles
            var activitiesTitle = A.one('.activity-title');
            if (activitiesTitle) {
                activitiesTitle.addClass('required-field');
            }

            var chambersTitle = A.one('.activities-section:nth-child(2) .activity-title');
            if (chambersTitle) {
                chambersTitle.addClass('required-field');
            }

            // Terms & policies
            var termsLabel = A.one('.terms-policies-section .policy-line');
            if (termsLabel) {
                termsLabel.addClass('required-field');
            }

            departmentSync();
        }

        function showJointVentureForm() {
            // Set beneficiary type for validation
            window.selectedBeneficiaryType = 'joint';

            showBlockByClass('contact-information-label');
            showBlockByClass('additional-mobile-block');
            showBlockByClass('commercial-register-block');
            showFieldsetSection('the-name-fieldset');
            showFieldsetSection('the-position-fieldset');
            showFieldsetSection('communication-methods-fieldset');
            showFieldsetSection('the-facility-fieldset');
            showBlockByClass('email-mobile-block');


            // Hide full width div and show partial width with button
            document.getElementById(`${namespace}crNumberFullDiv`).style.display = 'none';
            document.getElementById(`${namespace}crNumberPartialDiv`).style.display = 'block';
            document.getElementById(`${namespace}authBtnDiv`).style.display = 'block';


            // Add required indicators for Joint Venture
            addRequiredIndicator('#' + namespace + 'commercial-register-number-joint');
            addRequiredIndicator('#the-name-fieldset');
            addRequiredIndicator('#the-facility-fieldset');
            addRequiredIndicator('#the-position-fieldset');
            addRequiredIndicator('#' + namespace + 'email');
            addRequiredIndicator('#' + namespace + 'mobile');


        }

        var submitButton = A.one('#' + namespace + 'contactForm input[type="submit"], #' + namespace + 'contactForm button[type="submit"]');
        if (submitButton) {
            submitButton.on('click', function(event) {

                // Always prevent the default action first
                event.preventDefault();
                event.stopPropagation();

                // Run validation
                if (!window.validateForm()) {
                    console.log("Validation failed - submission blocked");
                    window.formValidationPassed = false;
                    return false;
                }

                console.log("Validation passed - submitting form");
                window.formValidationPassed = true;

                // Manually submit the form after validation passes
                var formElement = form.getDOMNode();
                if (formElement) {
                    formElement.submit();
                }
            });
        }

        // Clear error message when field value changes
        A.all('input').on('change', function (e) {
            var input = e.currentTarget;

            // For radios and checkboxes, clear error containers
            if (input.get('type') === 'radio') {
                if (input.get('name').includes('beneficiaryType')) {
                    A.one('.beneficiary-error-container').empty();
                } else if (input.get('name').includes('termsAgreement')) {
                    A.one('.terms-error-container').empty();
                }
            } else if (input.get('type') === 'checkbox') {
                if (input.ancestor('#activities-fieldset')) {
                    A.one('.activity-error-container').empty();
                } else if (input.ancestor('#chambers-events')) {
                    A.one('.chamber-error-container').empty();
                }
            } else {
                // For text inputs, remove error message and class
                var container = input.ancestor();
                container.removeClass('field-error');
                var errorMsg = container.one('.error-message');
                if (errorMsg) errorMsg.remove();
            }
        });

        // Initial setup
        hideInitialSections();

        var beneficiaryLabel = A.one('.beneficiary-title');
        if (beneficiaryLabel) {
            beneficiaryLabel.addClass('required-field');
        }

        form?.on('submit', function (event) {
            console.log("Form submit event triggered, validation flag:", window.formValidationPassed);

            if (!window.formValidationPassed) {
                event.preventDefault();
                event.stopPropagation();
                event.stopImmediatePropagation();
                return false;
            }

            // Reset the flag for next time
            window.formValidationPassed = false;
            return true;
        });


        // Event bindings for beneficiary radio buttons
        beneficiaryRadios.each(function (radio) {
            radio.on('change', function () {
                var selectedValue = radio.get('id');
                resetForm();
                if (selectedValue.includes('beneficiaryIndividual')) {
                    A.one('#' + namespace + 'beneficiaryTypeValue').set('value', 'individual');
                    showIndividualsForm();
                } else if (selectedValue.includes('beneficiaryShared')) {
                    A.one('#' + namespace + 'beneficiaryTypeValue').set('value', 'shared');
                    showSharedFacilityForm();
                } else if (selectedValue.includes('beneficiaryJoint')) {
                    A.one('#' + namespace + 'beneficiaryTypeValue').set('value', 'joint');
                    showJointVentureForm();
                }
            });
        });
    }

});