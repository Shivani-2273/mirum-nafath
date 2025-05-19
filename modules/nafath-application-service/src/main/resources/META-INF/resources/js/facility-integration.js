// Function to display error message (supports Arabic and other languages)
function displayErrorMessage(containerId, message) {
    const container = document.getElementById(containerId);
    if (!container) return;

    container.innerHTML = '';


    // Create error message element
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';

    const errorSpan = document.createElement('span');
    errorSpan.className = 'text-danger';
    errorSpan.textContent = message;

    const isArabic = /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]/.test(message);


    if (isArabic) {
        errorDiv.dir = 'rtl';
        errorDiv.style.textAlign = 'right';
        // Add a class for Arabic-specific styling if needed
        errorDiv.classList.add('arabic-text');
    } else {
        errorDiv.dir = 'ltr';
        errorDiv.style.textAlign = 'left';
    }

    errorDiv.appendChild(errorSpan);
    container.appendChild(errorDiv);
    container.style.display = 'block';
}

// Function to clear error message
function clearErrorMessage(containerId) {
    const container = document.getElementById(containerId);
    if (container) {
        container.innerHTML = '';
        container.style.display = 'none';
    }
}

// Function to verify commercial register and get facilities
async function verifyCommercialRegister() {
    const namespace = window.portletNamespace;

    // Only proceed if the beneficiary type is joint
    if (window.selectedBeneficiaryType !== 'joint') {
        console.log("API verification is only for joint beneficiary type");
        return;
    }

    // Get the joint commercial register number
    const crField = document.getElementById(`${namespace}commercial-register-number-joint`);
    if (!crField) {
        console.error("Commercial register field not found");
        return;
    }

    clearErrorMessage(`${namespace}commercialRegisterErrorContainer`);

    const crNumber = crField.value.trim();
    // if (!crNumber) {
    //     alert(window.formLanguageKeys['custom-field-is-required'] || 'Commercial Register Number is required');
    //     return;
    // }



    try {

        // Call the server-side resource handler instead of direct API call
        const formData = new FormData();
        formData.append(`${namespace}identificationNumber`, crNumber);

        const response = await fetch(window.apiConfig.getFacilitiesURL, {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (data.succeeded && data.data && data.data.length > 0) {
            clearErrorMessage(`${namespace}commercialRegisterErrorContainer`);

            populateFacilityDropdown(data.data);
        } else {
            const errorMsg = data.errors && data.errors.length > 0
                ? data.errors[0]
                : (window.formLanguageKeys['no-facilities-found'] || 'No facilities found for this commercial register number');

            displayErrorMessage(`${namespace}commercialRegisterErrorContainer`, errorMsg);
        }
    } catch (error) {
        console.error('Error verifying commercial register:', error);
        displayErrorMessage(
            `${namespace}commercialRegisterErrorContainer`,
            window.formLanguageKeys['api-error'] || 'Error verifying commercial register'
        );
    }
}

// Function to populate the facility dropdown
function populateFacilityDropdown(facilities) {
    const namespace = window.portletNamespace;
    const dropdown = document.getElementById(`${namespace}facilityDropdown`);

    // Clear existing options except the first one
    while (dropdown.options.length > 1) {
        dropdown.remove(1);
    }


    facilities.forEach(facility => {
        const option = document.createElement('option');
        option.value = facility.unified700Number;
        option.textContent = facility.titleAr;
        option.dataset.id = facility.id;
        dropdown.appendChild(option);
    });

    // Show the dropdown container
    const container = document.getElementById(`${namespace}facilityDropdownContainer`);
    if (container) {
        container.style.display = 'block';
    }
}

// Helper function to remove duplicates from array by key
// function removeDuplicates(array, key) {
//     return Array.from(new Map(array.map(item => [item[key], item])).values());
// }

// Function to get facility details
async function getFacilityDetails(unifiedNumber) {
    const namespace = window.portletNamespace;

    if (!unifiedNumber) {
        return;
    }

    try {
        // Call the server-side resource handler instead of direct API call
        const formData = new FormData();
        formData.append(`${namespace}unifiedNumber`, unifiedNumber);

        const response = await fetch(window.apiConfig.getFacilityDetailsURL, {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (data.succeeded && data.data) {
            autofillFormFields(data.data);
        } else {
            const errorMsg = data.errors && data.errors.length > 0 ? data.errors[0] : 'Failed to get facility details';
            alert(errorMsg);
        }
    } catch (error) {
        console.error('Error getting facility details:', error);
        alert(window.formLanguageKeys['api-error'] || 'Error getting facility details');
    }
}

// Function to autofill form fields
function autofillFormFields(facilityData) {
    const namespace = window.portletNamespace;

    // Map API fields to form fields
    const fieldMappings = {
        'seniorOfficialTitleAr': `${namespace}nameAR`,
        'seniorOfficialTitleEn': `${namespace}nameEN`,
        'titleAr': `${namespace}facilityAR`,
        'titleEn': `${namespace}facilityEN`,
        'seniorOfficialJobTitleAr': `${namespace}positionAR`,
        'seniorOfficialJobTitleEn': `${namespace}positionEN`,
        'seniorOfficialEmail': `${namespace}email`,
        'seniorOfficialMobileNumber': `${namespace}mobile`
    };

    // Fill in the fields
    for (const [apiField, formField] of Object.entries(fieldMappings)) {
        const element = document.getElementById(formField);
        if (element && facilityData[apiField]) {
            element.value = facilityData[apiField];
            element.readOnly = true;

            element.classList.add('read-only-field');
            const parent = element.closest('.form-group');
            if(parent){
                parent.classList.add('.field-read-only');
            }
        }
    }

    // Make the facility dropdown required
    const facilityDropdown = document.getElementById(`${namespace}facilityDropdown`);
    if (facilityDropdown) {
        const facilityLabel = document.querySelector(`label[for="${namespace}facilityDropdown"]`);
        if (facilityLabel) {
            facilityLabel.classList.add('required-field');
        }
    }
}

// Initialize facility integration
function initializeFacilityIntegration() {
    const namespace = window.portletNamespace;

    // Add click event to verify button
    const verifyBtn = document.getElementById(`${namespace}verifyBtn`);
    if (verifyBtn) {
        verifyBtn.addEventListener('click', verifyCommercialRegister);
    }

    // Add change event to facility dropdown
    const facilityDropdown = document.getElementById(`${namespace}facilityDropdown`);
    if (facilityDropdown) {
        facilityDropdown.addEventListener('change', function() {
            // Only proceed if beneficiary type is joint
            if (window.selectedBeneficiaryType !== 'joint') {
                return;
            }

            const unifiedNumber = this.value;
            if (unifiedNumber) {
                getFacilityDetails(unifiedNumber);
            }
        });
    }
}

// Add function to reset read-only fields
function resetFormFields() {
    const namespace = window.portletNamespace;

    // Fields that might be set to read-only
    const fields = [
        `${namespace}nameAR`,
        `${namespace}nameEN`,
        `${namespace}facilityAR`,
        `${namespace}facilityEN`,
        `${namespace}positionAR`,
        `${namespace}positionEN`,
        `${namespace}email`,
        `${namespace}mobile`
    ];

    // Reset read-only state
    fields.forEach(fieldId => {
        const element = document.getElementById(fieldId);
        if (element) {
            element.readOnly = false;
            element.classList.remove('read-only-field');

            // If using AUI, access the parent and remove the class
            const parent = element.closest('.form-group');
            if (parent) {
                parent.classList.remove('field-read-only');
            }
        }
    });
}

// Update reset function
function resetFacilityIntegration() {
    const namespace = window.portletNamespace;

    // Hide verify button and dropdown
    const verifyBtn = document.getElementById(`${namespace}verifyBtn`);
    if (verifyBtn) {
        verifyBtn.style.display = 'none';
    }

    const dropdownContainer = document.getElementById(`${namespace}facilityDropdownContainer`);
    if (dropdownContainer) {
        dropdownContainer.style.display = 'none';
    }

    // Clear error messages
    clearErrorMessage(`${namespace}commercialRegisterErrorContainer`);

    // Reset read-only states
    resetFormFields();

    // Reset dropdown
    const dropdown = document.getElementById(`${namespace}facilityDropdown`);
    if (dropdown) {
        dropdown.selectedIndex = 0;
    }
}

// Initialize when document is ready
document.addEventListener('DOMContentLoaded', initializeFacilityIntegration);