*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BROWSER}    Chrome
${URL}    https://app-stage.thearkofrevival.com
${EMAIL}    admin@justomerchantz.com
${PASS}    P@ssword0123
${POST_DESC_TEST}    automation generated post tester2
${EMAIL_LABEL_TEST}    Email
${PASS_LABEL_TEST}    Password
${EXPECTED_MESSAGE}    Login success 😃!

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

Verify that organization card is clickable
    Wait Until Page Contains    Choose an Organization
    Page Should Contain Button    xpath://*[@testid='org-g-admin-org-list-card-0']
    Click Button    xpath://*[@id="root"]/div[2]/div[2]/div/button[1]

Verify that organisation post can be created
    Click Element    xpath://*[@id="posts"]/span/span
    Click Button    xpath://*[@id="nav-menu"]/section/main/div/div[1]/span[2]/div/button
    Input Text    xpath://*[@id="Posts_description"]    ${POST_DESC_TEST}
    Radio Button Should Not Be Selected    isPrivate
    Select Radio Button    isPrivate    true
    Click Button    xpath://*[@id="Posts"]/div[10]/div/div/div/div/button[1]

#Verify post is created
#    Page Should Contain Element    //p[contains(text(),'automation generated post3')]
#    Click Element    xpath://*[@testid='org-navigate-dashboard-post']
#    ${POST_DESC}=    Get Text    xpath://p[contains(text(),'automation generated post')]
#    Should Be Equal As Strings    ${POST_DESC}  ${POST_DESC_TEST}

*** Keywords ***

Get generated post content
    [Arguments]    ${arg}
    ${temp}    Evaluate    f'//p[contains(text(),'automation generated post3')]'
    RETURN    ${temp}