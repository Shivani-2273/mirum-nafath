let nafathAuthData = null;
let statusCheckInterval = null;
const STATUS_CHECK_INTERVAL = 5000;

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
        errorDiv.classList.add('arabic-text');
    } else {
        errorDiv.dir = 'ltr';
        errorDiv.style.textAlign = 'left';
    }

    errorDiv.appendChild(errorSpan);
    container.appendChild(errorDiv);
    container.style.display = 'block';
}


function displaySuccessMessage(containerId, message) {
    const container = document.getElementById(containerId);
    if (!container) return;

    // Remove any existing success/error messages but keep random display
    const existingMessages = container.querySelectorAll('.success-message, .error-message');
    existingMessages.forEach(msg => msg.remove());

    const successDiv = document.createElement('div');
    successDiv.className = 'success-message';

    const successSpan = document.createElement('span');
    successSpan.className = 'text-success';
    successSpan.textContent = message;

    const isArabic = /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]/.test(message);

    if (isArabic) {
        successDiv.dir = 'rtl';
        successDiv.style.textAlign = 'right';
        successDiv.classList.add('arabic-text');
    } else {
        successDiv.dir = 'ltr';
        successDiv.style.textAlign = 'left';
    }

    successDiv.appendChild(successSpan);
    container.appendChild(successDiv);
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

function displayNafathRandomNumber(randomNumber) {
    const namespace = window.portletNamespace;
    const container = document.getElementById(`${namespace}commercialRegisterErrorContainer`);
    if (!container) return;

    let randomDiv = container.querySelector('.nafath-random-display');
    if (!randomDiv) {
        randomDiv = document.createElement('div');
        randomDiv.className = 'nafath-random-display';
        container.appendChild(randomDiv);
    }

    randomDiv.innerHTML = `
        <div style="padding: 10px; border: 1px solid #ccc; border-radius: 4px; background: #f9f9f9; text-align: center; margin: 10px 0;">
            <span style="font-size: 14px; color: #666;">${window.formLanguageKeys['verification-number']} </span>
            <strong style="font-size: 20px; color: #333; font-family: monospace; font-weight: 500;">${randomNumber}</strong>
        </div>
    `;



    container.style.display = 'block';
}
function clearNafathRandomNumber() {
    const namespace = window.portletNamespace;
    const container = document.getElementById(`${namespace}commercialRegisterErrorContainer`);
    if (container) {
        const randomDiv = container.querySelector('.nafath-random-display');
        if (randomDiv) {
            randomDiv.remove();
        }
    }
}

function updateButtonState(buttonId, text, disabled = false, loading = false) {
    const button = document.getElementById(buttonId);
    if (!button) return;

    button.textContent = text;
    button.disabled = disabled;

    if (loading) {
        button.classList.add('loading');
        // You can add a spinner class here if you have CSS for it
    } else {
        button.classList.remove('loading');
    }
}

// Function to initiate Nafath authentication
async function initiateNafathAuth() {
    const namespace = window.portletNamespace;
    const crField = document.getElementById(`${namespace}commercial-register-number-joint`);

    if (!crField) {
        console.error("Commercial register field not found");
        return;
    }

    const nationalId = crField.value.trim();
    if (!nationalId) {
        displayErrorMessage(
            `${namespace}commercialRegisterErrorContainer`,
            window.formLanguageKeys['custom-field-is-required'] || 'National ID is required'
        );
        return;
    }

    clearErrorMessage(`${namespace}commercialRegisterErrorContainer`);
    updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticating'], true, true);

    try {
        const formData = new FormData();
        formData.append(`${namespace}nationalId`, nationalId);

        const response = await fetch(window.apiConfig.initiateNafathAuthURL, {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (data.succeeded && data.data) {
            nafathAuthData = data.data;

            displayNafathRandomNumber(nafathAuthData.random);

            displaySuccessMessage(
                `${namespace}commercialRegisterErrorContainer`,
                window.formLanguageKeys['nafath-auth-initiated'] || 'Authentication initiated. Please check your Nafath app and approve the request.'
            );

            updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['checking-status'], true, true);

            // Start checking status
            startStatusCheck();
        } else {
            const errorMsg = data.errors && data.errors.length > 0
                ? data.errors[0]
                : 'Failed to initiate Nafath authentication';

            displayErrorMessage(`${namespace}commercialRegisterErrorContainer`, errorMsg);
            updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
        }
    } catch (error) {
        console.error('Error initiating Nafath authentication:', error);
        displayErrorMessage(
            `${namespace}commercialRegisterErrorContainer`,
            window.formLanguageKeys['api-error'] || 'Error initiating authentication'
        );
        updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
    }
}


function startStatusCheck() {
    statusCheckInterval = setInterval(checkNafathStatus, STATUS_CHECK_INTERVAL);
}


function stopStatusCheck() {
    if (statusCheckInterval) {
        clearInterval(statusCheckInterval);
        statusCheckInterval = null;
    }
}

async function checkNafathStatus() {
    const namespace = window.portletNamespace;

    if (!nafathAuthData) {
        stopStatusCheck();
        displayErrorMessage(
            `${namespace}commercialRegisterErrorContainer`,
            window.formLanguageKeys['api-error'] || 'Authentication data lost. Please try again.'
        );
        updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
        return;
    }

    try {
        const formData = new FormData();
        formData.append(`${namespace}nationalId`, nafathAuthData.nationalId);
        formData.append(`${namespace}transId`, nafathAuthData.transId);
        formData.append(`${namespace}random`, nafathAuthData.random);

        const response = await fetch(window.apiConfig.checkNafathStatusURL, {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        switch (data.status) {
            case 'COMPLETED':
                stopStatusCheck();
                clearNafathRandomNumber();

                displaySuccessMessage(
                    `${namespace}commercialRegisterErrorContainer`,
                    window.formLanguageKeys['nafath-auth-completed'] || 'Authentication completed successfully!'
                );

                // Proceed with facility verification after a short delay
                setTimeout(() => {
                    proceedWithFacilityVerification();
                }, 1000);
                break;

            case 'REJECTED':
                stopStatusCheck();
                clearNafathRandomNumber();
                displayErrorMessage(
                    `${namespace}commercialRegisterErrorContainer`,
                    window.formLanguageKeys['nafath-auth-failed'] || 'Authentication was rejected. Please try again.'
                );
                updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
                break;

            case 'EXPIRED':
                stopStatusCheck();
                clearNafathRandomNumber();
                displayErrorMessage(
                    `${namespace}commercialRegisterErrorContainer`,
                    window.formLanguageKeys['nafath-auth-timeout'] || 'Authentication request expired. Please try again.'
                );
                updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
                break;

            case 'WAITING':
                break;

            default:
                // Handle unexpected status
                console.warn('Unexpected Nafath status:', data.status);
                break;
        }

    } catch (error) {
        console.error('Error checking Nafath status:', error);

        // On network error, stop after showing error
        stopStatusCheck();
        clearNafathRandomNumber()
        displayErrorMessage(
            `${namespace}commercialRegisterErrorContainer`,
            window.formLanguageKeys['api-error'] || 'Network error. Please check your connection and try again.'
        );
        updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
    }
}

async function proceedWithFacilityVerification() {
    const namespace = window.portletNamespace;
    const crField = document.getElementById(`${namespace}commercial-register-number-joint`);
    const crNumber = crField.value.trim();

    updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['loading-facilities'], true, true);
    clearErrorMessage(`${namespace}commercialRegisterErrorContainer`);

    try {
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
            updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['verified'], false, false);
        } else {
            const errorMsg = data.errors && data.errors.length > 0
                ? data.errors[0]
                : (window.formLanguageKeys['no-facilities-found'] || 'No facilities found for this commercial register number');

            displayErrorMessage(`${namespace}commercialRegisterErrorContainer`, errorMsg);
            updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
        }
    } catch (error) {
        console.error('Error verifying commercial register:', error);
        displayErrorMessage(
            `${namespace}commercialRegisterErrorContainer`,
            window.formLanguageKeys['api-error'] || 'Error verifying commercial register'
        );
        updateButtonState(`${namespace}verifyBtn`, window.formLanguageKeys['authenticate'], false, false);
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

    // Start with Nafath authentication
    await initiateNafathAuth();
}


// Function to populate the facility dropdown
function populateFacilityDropdown(facilities) {
    const namespace = window.portletNamespace;
    const dropdown = document.getElementById(`${namespace}facilityDropdown`);

    // Clear existing options except the first one
    while (dropdown.options.length > 1) {
        dropdown.remove(1);
    }

    var uniqueFacilities = removeDuplicates(facilities,"unified700Number")

    uniqueFacilities.forEach(facility => {
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
function removeDuplicates(array, key) {
    return Array.from(new Map(array.map(item => [item[key], item])).values());
}

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
            console.error(errorMsg)
        }
    } catch (error) {
        console.error('Error getting facility details:', error);
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

    //clear all fields value
    Object.values(fieldMappings).forEach(formField =>{
        const element = document.getElementById(formField);
        if(element){
            element.value = '';
            element.readOnly = false;
            element.classList.remove('read-only-field');

            //reset parent container class if needed
            const parent = element.closest('.form-group');
            if(parent){
                parent.classList.remove('field-read-only')
            }
        }

    });


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
// Initialize when document is ready
document.addEventListener('DOMContentLoaded', initializeFacilityIntegration);