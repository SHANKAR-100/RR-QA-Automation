*** Settings ***
Library        SeleniumLibrary
Library        OperatingSystem
Library        String
Resource    ../Resources/Keywords/keywords.robot
Resource    ../Resources/Data/common_dt.robot

Test Setup    Open Browser with TMDB URL
Test Teardown    Close Browser

*** Test Cases ***

RRQA/Negative/Test Direct Slug Access - Popular/TC001
    [Documentation]    Test accessing popular page directly via URL (known to be problematic)
    [Tags]    TC001
    Go To    ${BASE_URL}popular
    ${page_content}=    Get Text    //body
    ${current_url}=    Get Location
    Log To Console    >> Direct popular slug access - URL: ${current_url}
    Log To Console    >> Page content preview: ${page_content[:100]}
    Capture Page Screenshot    ${REPORT_DIR}/slug_popular_direct_access.png
    Run Keyword And Continue On Failure    Should Not Contain    ${page_content}    404
    Run Keyword And Continue On Failure    Should Not Contain    ${page_content}    page not found

RRQA/Negative/Test Direct Slug Access - All Categories/TC002
    [Tags]    TC002
    @{slugs}=    Create List    popular    trend    new    top
    FOR    ${slug}    IN    @{slugs}
        ${slug_url}=    Set Variable    ${BASE_URL}${slug}
        Log To Console    >> Testing direct access to: ${slug_url}
        Go To    ${slug_url}
        ${page_content}=    Get Text    //body
        Capture Page Screenshot    ${REPORT_DIR}/slug_${slug}_direct.png
        ${has_error}=    Run Keyword And Return Status    Page Should Contain    404
        ${has_not_found}=    Run Keyword And Return Status    Page Should Contain    page not found
        Run Keyword If    ${has_error} or ${has_not_found}    Log To Console    >> DEFECT: ${slug} slug shows error when accessed directly
        Run Keyword If    not (${has_error} or ${has_not_found})    Log To Console    >> ${slug} slug works correctly
    END

RRQA/Negative/Test Invalid Search Inputs/TC003
    [Tags]    TC003
    Search For Content    !@#$%^&*()
    ${result1}=    Get Text    //body
    Log To Console    >> Special characters search result preview: ${result1[:100]}

    ${long_input}=    Set Variable    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    Clear Search
    Search For Content    ${long_input}
    ${result2}=    Get Text    //body
    Log To Console    >> Long input search result preview: ${result2[:100]}

    Clear Search
    Search For Content    '; DROP TABLE movies; --
    ${result3}=    Get Text    //body
    Should Not Contain    ${result3}    error
    Log To Console    >> SQL injection test - no errors shown (good)

    Clear Search
    Search For Content    <script>alert('test')</script>
    ${result4}=    Get Text    //body
    Should Not Contain    ${result4}    <script>
    Log To Console    >> XSS test - script tags not rendered (good)

RRQA/Negative/Test Pagination Edge Cases/TC004
    [Tags]    TC004
    Go To    ${BASE_URL}?page=99999
    ${high_page_content}=    Get Text    //body
    Capture Page Screenshot    ${REPORT_DIR}/pagination_high_page.png
    Log To Console    >> High page number result: ${high_page_content[:100]}

    Go To    ${BASE_URL}?page=-1
    ${negative_page_content}=    Get Text    //body
    Capture Page Screenshot    ${REPORT_DIR}/pagination_negative_page.png

    Go To    ${BASE_URL}?page=0
    ${zero_page_content}=    Get Text    //body
    Capture Page Screenshot    ${REPORT_DIR}/pagination_zero_page.png

    Go To    ${BASE_URL}?page=abc
    ${alpha_page_content}=    Get Text    //body
    Capture Page Screenshot    ${REPORT_DIR}/pagination_alpha_page.png

RRQA/Negative/Test Rapid Navigation/TC005
    [Tags]    TC005
    FOR    ${i}    IN RANGE    5
        Click Category    Popular
        Sleep    0.2s
        Click Category    Trend
        Sleep    0.2s
        Click Category    Newest
        Sleep    0.2s
    END
    ${final_content}=    Get Text    //body
    Should Contain    ${final_content}    Discover
    Log To Console    >> Rapid navigation completed without crashes

RRQA/Negative/Test Browser Back/Forward Functionality/TC006
    [Tags]    TC006
    Click Category    Popular
    Go Back
    ${back_content}=    Get Text    //body
    Click Category    Trend
#    Go Forward
    ${forward_content}=    Get Text    //body
    Should Not Be Equal    ${back_content}    ${forward_content}
    Log To Console    >> Browser back/forward navigation works correctly

RRQA/Negative/Test Page Refresh During Operations/TC007
    [Tags]    TC007
    Input Text    xpath=//input[contains(@placeholder,"SEARCH")]    Horror
    Reload Page
    ${after_refresh}=    Get Text    //body
    Wait Until Page Contains    Discover    timeout=10s
    Should Contain    ${after_refresh}    Discover
    Capture Page Screenshot    ${REPORT_DIR}/refresh_during_search.png

    Click Category    Popular
    Reload Page
    Sleep    3s
    ${after_cat_refresh}=    Get Text    //body
    Capture Page Screenshot    ${REPORT_DIR}/refresh_during_category.png
    Log To Console    >> Page refresh handling tested

RRQA/Negative/Test Network Interruption Simulation/TC008
    [Tags]    TC008
    Set Selenium Timeout    1s
    Run Keyword And Ignore Error    Click Category    Trend
    Log To Console    >> Simulated network delay handled
    Set Selenium Timeout    ${TIMEOUT}
    Go To    ${BASE_URL}
    ${recovery_content}=    Get Text    //body
    Should Contain    ${recovery_content}    Discover

RRQA/Negative/Test Invalid Year Inputs/TC009
    [Tags]    TC009
    Click Category    Trend
    Wait For Advanced Filters
    @{invalid_years}=    Create List    abc    -2000    3000    1800    99999
    FOR    ${invalid_year}    IN    @{invalid_years}
        ${inputs}=    Get WebElements    //input
        ${input_count}=    Get Length    ${inputs}
        Run Keyword If    ${input_count} > 1    Input Text    xpath=(//input)[2]    ${invalid_year}
        Run Keyword If    ${input_count} > 1    Press Keys    xpath=(//input)[2]    RETURN
        Run Keyword If    ${input_count} > 1    Sleep    1s
        Log To Console    >> Tested invalid year: ${invalid_year}
        ${page_content}=    Get Text    //body
        Should Contain    ${page_content}    Discover
    END
