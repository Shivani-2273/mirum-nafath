AUI().ready(function(A) {
    var namespace = window.portletNamespace;
    var form = A.one('#' + namespace + 'contactForm');
    console.log("Form found:", form);


    var beneficiaryRadios = A.all('.beneficiary-option input[type="radio"]');

    // Track the selected beneficiary type
    window.selectedBeneficiaryType = '';

    var sectionsToHide = [
        'label.contact-information-label',
        'fieldset',
        '.email-mobile-block',
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
            addErrorMessage('.beneficiary-error-container',  Liferay.Language.get('please-select-one-option'));
            hasErrors = true;
        }

        if (window.selectedBeneficiaryType === 'joint') {
            let crNumber = A.one('#' + namespace + 'commercial-register-number')?.get('value')?.trim();
            if (!crNumber) {
                addErrorMessage('#' + namespace + 'commercial-register-number',  Liferay.Language.get('this-field-is-required'));
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
                    addErrorMessage(selector, Liferay.Language.get('this-field-is-required'));
                    hasErrors = true;
                }
            });

            // Email
            var EmailAddress = A.one('#' + namespace + 'email').get('value').trim();
            if (!EmailAddress) {
                addErrorMessage('#' + namespace + 'email', Liferay.Language.get('this-field-is-required'));
                hasErrors = true;

            }

            // Mobile
            var mobileNumber = A.one('#' + namespace + 'mobile').get('value').trim();
            if (!mobileNumber) {
                addErrorMessage('#' + namespace + 'mobile', Liferay.Language.get('this-field-is-required'));
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
                    addErrorMessage(selector,  Liferay.Language.get('this-field-is-required'));
                    hasErrors = true;
                }
            });


            let anyActivity = false;
            A.all('#activities-fieldset input[type="checkbox"]').each(c => {
                if (c.get('checked')) anyActivity = true;
            });
            if (!anyActivity) {
                addErrorMessage('.activity-error-container', Liferay.Language.get('please-select-at-least-one-activity'));
                hasErrors = true;
            }

            // Email
            var email = A.one('#' + namespace + 'email').get('value').trim();
            if (!email) {
                addErrorMessage('#' + namespace + 'email', Liferay.Language.get('this-field-is-required'));
                hasErrors = true;
            }

            // Mobile
            var mobile = A.one('#' + namespace + 'mobile').get('value').trim();
            if (!mobile) {
                addErrorMessage('#' + namespace + 'mobile', Liferay.Language.get('this-field-is-required'));
                hasErrors = true;
            }


            let anyEvent = false;
            A.all('#chambers-events input[type="checkbox"]').each(c => {
                if (c.get('checked')) anyEvent = true;
            });
            if (!anyEvent) {
                addErrorMessage('.chamber-error-container', Liferay.Language.get('please-select-at-least-one-event'));
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
                                addErrorMessage(inputId,  Liferay.Language.get('this-field-is-required'));
                                hasErrors = true;
                            } else {
                                // Validate email
                                if (inputId.includes('Email') && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(inputVal)) {
                                    addErrorMessage(inputId, Liferay.Language.get('please-enter-valid-email'));
                                    hasErrors = true;
                                }

                                // Validate mobile
                                if (inputId.includes('Mobile') && !/^05\d{8}$/.test(inputVal)) {
                                    addErrorMessage(inputId, Liferay.Language.get('please-enter-valid-mobile'));
                                    hasErrors = true;
                                }
                            }
                        });

                    }
                }
            });

            if (!A.one('.terms-policies-section input[type="radio"]:checked')) {
                addErrorMessage('.terms-error-container', Liferay.Language.get('please-agree-to-terms'));
                hasErrors = true;
            }
        }

        if (window.selectedBeneficiaryType === 'individual') {
            if (!A.one('.terms-policies-section input[type="radio"]:checked')) {
                addErrorMessage('.terms-error-container', Liferay.Language.get('please-agree-to-terms'));
                hasErrors = true;
            }
        }

        // Always validate email and mobile format (if not empty)
        var emailField = A.one('#' + namespace + 'email');
        var emailVal = emailField?.get('value')?.trim();

        if (emailVal && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(emailVal)) {
            addErrorMessage('#' + namespace + 'email', Liferay.Language.get('please-enter-valid-email'));
            hasErrors = true;
        }

        var mobileField = A.one('#' + namespace + 'mobile');
        var mobileVal = mobileField?.get('value')?.trim();

        if (mobileVal && !/^05\d{8}$/.test(mobileVal)) {
            addErrorMessage('#' + namespace + 'mobile', Liferay.Language.get('please-enter-valid-mobile'));
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
        selectors.forEach(function(selector) {
            A.all(selector).each(function(el) {
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
        if(dom){
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

        A.all('input[type="checkbox"][id*="departments"]').each(function(checkbox) {
            var checkboxId = checkbox.get('id');
            for (var baseId in departmentMapping) {
                if (checkboxId.includes(baseId) || checkboxId.includes(baseId.split('-')[0])) {
                    (function(deptId) {
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

                        checkbox.on('change', function(e) {
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

        // Reset required indicators
        A.all('label:not(.beneficiary-title)').each(function(label) {
            label.removeClass('required-field');
        });

        A.all('legend').each(function(legend) {
            legend.removeClass('required-field');
        });

        // Clear checkboxes
        A.all('input[type="checkbox"]:checked').each(function(cb) {
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
        A.all('.error-message').each(function(errorMsg) {
            errorMsg.remove();
        });

        // Remove error classes
        A.all('.field-error').each(function(field) {
            field.removeClass('field-error');
        });
    }

    function showCommonFields() {
        showBlockByClass('email-mobile-block');
        showFieldsetSection('the-name-fieldset');
        showFieldsetSection('the-position-fieldset');
        showFieldsetSection('national-address-fieldset');
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
        showFieldsetSection('the-facility-fieldset');
        showCommonFields();
        showBlockByClass('contact-information-departments');

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
        showBlockByClass('commercial-register-block');
        showFieldsetSection('the-name-fieldset');
        showFieldsetSection('the-position-fieldset');
        showFieldsetSection('the-facility-fieldset');
        showBlockByClass('email-mobile-block');


        // Add required indicators for Joint Venture
        addRequiredIndicator('#' + namespace + 'commercial-register-number');
        addRequiredIndicator('#the-name-fieldset');
        addRequiredIndicator('#the-facility-fieldset');
        addRequiredIndicator('#the-position-fieldset');
        addRequiredIndicator('#' + namespace + 'email');
        addRequiredIndicator('#' + namespace + 'mobile');


    }

    // Clear error message when field value changes
    A.all('input').on('change', function(e) {
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
        console.log("Submit event triggered");
        if (!window.validateForm()) {
            event.preventDefault();
            console.log("Submission prevented");
            return false;
        }
        console.log("Form is valid, submission allowed");
    });


    // Event bindings for beneficiary radio buttons
    beneficiaryRadios.each(function(radio) {
        radio.on('change', function() {
            var selectedValue = radio.get('id');
            resetForm();
            if (selectedValue.includes('beneficiaryIndividual')) {
                showIndividualsForm();
            } else if (selectedValue.includes('beneficiaryShared')) {
                showSharedFacilityForm();
            } else if (selectedValue.includes('beneficiaryJoint')) {
                showJointVentureForm();
            }
        });
    });



});