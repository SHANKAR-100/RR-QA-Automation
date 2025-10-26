*** Settings ***
Library        SeleniumLibrary
Library        OperatingSystem
Library        String
Resource    ../Resources/Data/common_dt.robot

*** Keywords ***
Open Browser with TMDB URL
    [Documentation]    Open web site

    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains    text=Previous    timeout=${TIMEOUT}

*** Settings ***
Library    SeleniumLibrary
Resource   variables.robot

*** Keywords ***
Open Application
    [Documentation]    Open browser with the given base URL.
    Open Browser    ${BASE_URL}    ${BROWSER}    headless=${HEADLESS}
    Maximize Browser Window
    Wait Until Page Contains Element    //body    timeout=${TIMEOUT}
    Sleep    ${NORMAL_SLEEP}
    ${page_content}=    Get Text    //body
    Log To Console    >> Page content preview: ${page_content[:200]}...
    Log To Console    >> Opened ${BASE_URL}

Click Category
    [Arguments]    ${category}
    Wait Until Element Is Visible    xpath=//a[normalize-space()="${category}"]    timeout=${TIMEOUT}
    Click Element    xpath=//a[normalize-space()="${category}"]
    Wait Until Page Contains Element    //body    timeout=${TIMEOUT}
    Sleep    ${NORMAL_SLEEP}
    Log To Console    >> Category: ${category}

Search For Content
    [Arguments]    ${search_term}
    Wait Until Element Is Visible    xpath=//input[contains(@placeholder,"SEARCH")]    timeout=${TIMEOUT}
    Input Text    xpath=//input[contains(@placeholder,"SEARCH")]    ${search_term}
    Press Keys    xpath=//input[contains(@placeholder,"SEARCH")]    ENTER
    Sleep    ${NORMAL_SLEEP}
    Log To Console    >> Searched for: ${search_term}

Clear Search
    Wait Until Element Is Visible    xpath=//input[contains(@placeholder,"SEARCH")]    timeout=${TIMEOUT}
    Clear Element Text    xpath=//input[contains(@placeholder,"SEARCH")]
    Press Keys    xpath=//input[contains(@placeholder,"SEARCH")]    ENTER
    Sleep    ${NORMAL_SLEEP}
    Log To Console    >> Search cleared

Wait For Advanced Filters
    Wait Until Page Contains    DISCOVER OPTIONS    timeout=${TIMEOUT}
    Sleep    ${QUICK_SLEEP}

Verify Page Content Changed
    [Arguments]    ${category}
    Log To Console    >> Checking content for category: ${category}
    ${page_content}=    Get Text    //body
    Should Contain    ${page_content}    Discover
    Should Match Regexp    ${page_content}    \\d{4}

Check Search Results Contain
    [Arguments]    ${expected_term}
    ${page_content}=    Get Text    //body
    Should Contain    ${page_content}    ${expected_term}
    Log To Console    >> Search results contain: ${expected_term}

Verify Content Changed
    [Arguments]    ${original_content}
    ${new_content}=    Get Text    //body
    Should Not Be Equal    ${original_content}    ${new_content}
    Log To Console    >> Content successfully changed

Get Url
    [Documentation]    Replacement for Browser's Get Url.
    ${url}=    Get Location
    [Return]    ${url}

Test Genre Filter
    Log To Console    >> Testing Genre filter
    ${elements}=    Get WebElements    xpath=//*[contains(text(),"Select")]
    ${count}=    Get Length    ${elements}
    Run Keyword If    ${count} > 0    Click Element    ${elements}[0]
    Sleep    ${QUICK_SLEEP}

Test Year Filter
    Log To Console    >> Testing Year filter
    ${exists}=    Run Keyword And Return Status    Page Should Contain Element    //input
    Run Keyword If    ${exists}    Test Year Input    2020

Test Type Filter
    Log To Console    >> Testing Type filter (Movie/TV)
    ${current_content}=    Get Text    //body
    ${tv_exists}=    Run Keyword And Return Status    Page Should Contain Element    //button[contains(text(),"TV")]
    Run Keyword If    ${tv_exists}    Click Element    //button[contains(text(),"TV")]
    Run Keyword If    ${tv_exists}    Sleep    ${NORMAL_SLEEP}
    Run Keyword If    ${tv_exists}    Verify Content Changed    ${current_content}

Test Year Input
    [Arguments]    ${year}
    ${inputs}=    Get WebElements    //input
    ${count}=    Get Length    ${inputs}
    Run Keyword If    ${count} > 0    Input Text    ${inputs}[0]    ${year}
    Run Keyword If    ${count} > 0    Press Keys    ${inputs}[0]    ENTER
    Sleep    ${NORMAL_SLEEP}
    Log To Console    >> Applied year filter: ${year}

Test Rating Controls
    Log To Console    >> Testing Rating controls
    ${page_content}=    Get Text    //body
    Log To Console    >> Page contains rating-related content: ${page_content[:200]}
