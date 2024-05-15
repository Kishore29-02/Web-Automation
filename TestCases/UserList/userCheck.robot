*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}    Chrome
${URL}    https://app-stage.thearkofrevival.com
${EMAIL}    admin@justomerchantz.com
${PASS}    P@ssword0123
${card_name_test}    All Users List
${EMAIL_LABEL_TEST}    Email
${PASS_LABEL_TEST}    Password
${EXPECTED_MESSAGE}    Login success 😃!
${search_user_test}    ishore
${ACTIVE}    active

*** Test Cases ***
Verify that Admin or Global admin can login
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains    Login to Ark Enterprise Platform

#    EMAIL inp
    ${EMAIL_LABEL}    Get Text    xpath://*[@testid='org-login-email-input-label']
    Should Be Equal As Strings    ${EMAIL_LABEL}  ${EMAIL_LABEL_TEST}
    Element Should Be Visible    id:email
    Element Should Be Enabled    id:email
    Input Text    id:email    ${EMAIL}

#    pass inp
    ${PASS_LABEL}    Get Text    xpath://*[@testid='org-login-password-input-label']
    Should Be Equal As Strings    ${EMAIL_LABEL}  ${EMAIL_LABEL_TEST}
    Element Should Be Visible    id:password
    Element Should Be Enabled    id:password
    Input Text    id:password    ${PASS}

#    click login button
    Page Should Contain Button    xpath://*[@testid='org-login-submit-button']
    Click Button    xpath://*[@testid='org-login-submit-button']

#    Alert test
    Wait Until Element Is Visible    xpath://div[contains(@class, "ant-message-success")]
    ${actual_message} =    Get Text    xpath://div[contains(@class, "ant-message-success")]
    Should Be Equal As Strings    ${actual_message}    ${EXPECTED_MESSAGE}

    Wait Until Page Contains    Choose an Organization        60

Verify that user can open support dashboard
    Mouse Over    xpath://*[@testid='org-dashboard-profile-icon']
    Wait Until Element Is Visible    xpath://a[@testid='org-profile-popover-support-dashboard-btn']    60
    Click Link    xpath://a[@testid='org-profile-popover-support-dashboard-btn']
    Wait Until Page Contains    Support Dashboard

Verify that user can navigate to all users page
    ${card_name}=    Get Text    xpath://*[@data-testid='sub-user-list']/span/strong
    Should Be Equal As Strings    ${card_name}    ${card_name_test}
    Click Element    //*[@data-testid='sub-user-list']

Verify that search is working
    ${type_drop}=    Select User Type Drop    select
    Click Element    ${type_drop}
    ${type_drop_down}=    Select User Type Drop    ${ACTIVE}
    Wait Until Element Is Visible    ${type_drop_down}
    Click Element    ${type_drop_down}
    Input Text    xpath://*[@data-testid='user-search-inp']/span/span/span[2]/input    ${search_user_test}
    Click Button    xpath://*[@data-testid='user-search-inp']/span/span/span[3]/button

    Sleep    5s
#    set Selenium Implicit Wait    10
#    Wait Until Element Is Enabled    //*[@class='ant-table-tbody']/tr    10
#    Get Selenium Implicit Wait
    ${result_count}    Get Element Count    //*[@class='ant-table-tbody']/tr
    Log To Console    ${result_count}
    Validate Search Result    ${result_count}
    Wait Until Element Is Visible    xpath://*[@data-testid='user-search-inp']/span/span/span[2]/span
    Click Element    xpath://*[@data-testid='user-search-inp']/span/span/span[2]/span
    Go Back

*** Keywords ***
select user type drop
    [Arguments]    ${type}
    ${temp}=    Evaluate    f"xpath://*[@data-testid='user-type-${type}']"
    RETURN    ${temp}

profile name path
    [Arguments]    ${i}
    ${temp}=    Evaluate    f"xpath://*[@data-testid='profile-name-${i}']"
    RETURN    ${temp}
   
status path
    [Arguments]    ${i}
    ${temp}=    Evaluate    f"xpath://*[@data-testid='user-tag-${i}']"
    RETURN    ${temp}
    
validate search result
    [Arguments]    ${count}
    FOR    ${i}    IN RANGE    2
        ${profile_tag}=    Profile Name Path    ${i}
        ${curr_name}=    Get Text    ${profile_tag}
        Should Contain    ${curr_name}    ${search_user_test}
        
        ${status_tag}=    Status Path    ${i}
        ${status}=    Get Text    ${status_tag}
    Should Be Equal As Strings    ${status.lower()}    ${ACTIVE.lower()}
    END
    RETURN    ${True}

Go Back
    Execute Javascript  history.back()