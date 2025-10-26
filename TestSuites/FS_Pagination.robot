*** Settings ***
Library        SeleniumLibrary
Library        OperatingSystem
Library        String
Resource    ../Resources/Keywords/keywords.robot
Resource    ../Resources/Data/common_dt.robot

Test Setup    Open Browser with TMDB URL
Test Teardown    Close Browser

*** Test Cases ***

RRQA/Pagination/Test Basic Pagination Navigation/TC001
    [Documentation]    Test initial pagination that should work according to assignment notes
    [Tags]    TC001    pagination    functional    working-pages

    Log To Console    >> Testing basic pagination (should work for initial pages)

    # Get initial page content to compare
    ${initial_content}=    Get Text    tag=body

    # Test Next button functionality
    Wait Until Element Is Visible    xpath=//a[contains(text(), 'Next') or contains(@class, 'next') or button[contains(text(), 'Next')]]    timeout=${TIMEOUT}
    Click Element    xpath=//a[contains(text(), 'Next') or contains(@class, 'next') or button[contains(text(), 'Next')]]
    Sleep    ${NORMAL_SLEEP}

    ${next_content}=    Get Text    tag=body
    # Page content should change after clicking Next (different movies)
    Should Not Be Equal    ${initial_content}    ${next_content}
    Log To Console    >> Next navigation works - content changed

    # Test Previous button functionality
    Wait Until Element Is Visible    xpath=//a[contains(text(), 'Previous') or contains(@class, 'prev') or button[contains(text(), 'Previous')]]    timeout=${TIMEOUT}
    Click Element    xpath=//a[contains(text(), 'Previous') or contains(@class, 'prev') or button[contains(text(), 'Previous')]]
    Sleep    ${NORMAL_SLEEP}

    # Verify we can navigate back
    ${prev_content}=    Get Text    tag=body
    Should Not Be Empty    ${prev_content}
    Log To Console    >> Previous navigation works

RRQA/Pagination/Test Edge Case High Page Numbers/TC002
    [Documentation]    Test the known issue: "last few pages may not function properly"
    [Tags]    TC002    pagination    negative    edge-cases    known-issue

    Log To Console    >> Testing edge case: High page numbers (known to fail per assignment)

    # Try to navigate to potentially problematic high page numbers
    # This tests the known issue mentioned in assignment

    ${original_url}=    Get Location
    Go To    ${BASE_URL}?page=999

    ${high_page_content}=    Get Text    tag=body
    ${page_url}=    Get Location

    # Check if high page number causes issues
    ${content_lower}=    Convert To Lower Case    ${high_page_content}
    ${has_error}=    Evaluate    'error' in """${content_lower}""" or 'not found' in """${content_lower}""" or '404' in """${content_lower}"""

    IF    ${has_error}
        Log To Console    >> High page numbers show error (expected)
    ELSE IF    '999' in '${page_url}'
        Log To Console    >> WARNING: High page number accepted but may have empty/incorrect content
    ELSE
        Log To Console    >> WARNING: URL redirected from high page number
    END

RRQA/Pagination/Test Sequential Page Navigation to Find Boundaries/TC003
    [Documentation]    Navigate through multiple pages to find where pagination breaks
    [Tags]    TC003    pagination    boundary-testing    defect-discovery

    Log To Console    >> Testing: Sequential navigation to find pagination boundaries

    ${working_pages}=    Set Variable    ${1}
    ${max_pages_to_test}=    Set Variable    ${10}    # Reasonable limit for testing

    FOR    ${page_num}    IN RANGE    2    ${max_pages_to_test + 1}
        ${next_elements}=    Get Element Count    xpath=//a[contains(text(), 'Next') or contains(@class, 'next') or button[contains(text(), 'Next')]]

        IF    ${next_elements} > 0
            Click Element    xpath=//a[contains(text(), 'Next') or contains(@class, 'next') or button[contains(text(), 'Next')]]
            ${working_pages}=    Evaluate    ${working_pages} + 1
            Log To Console    >> Page ${page_num}: Navigation successful
        ELSE
            Log To Console    >> WARNING: Page ${page_num}: No Next button found (reached end)
            Exit For Loop
        END
    END

    Log To Console    >> PAGINATION SUMMARY: ${working_pages} pages tested successfully
    Should Be True    ${working_pages} >= 2    At least 2 pages should work for basic pagination

RRQA/Pagination/Test Direct URL Page Access/TC004
    [Documentation]    Test direct access to specific page URLs (tests known slug issue)
    [Tags]    TC004    pagination    url-testing    known-issue

    Log To Console    >> Testing: Direct URL access to paginated content

    # Test various page URL patterns that might exist
    @{page_urls}=    Create List
    ...    /?page=2
    ...    /?page=5
    ...    /page/2
    ...    /2

    FOR    ${page_url}    IN    @{page_urls}
        ${current_url}=    Get Location
        Go To    ${BASE_URL}${page_url}

        ${new_url}=    Get Location
        ${page_content}=    Get Text    tag=body

        ${page_content_lower}=    Convert To Lower Case    ${page_content}
        ${page_has_error}=    Evaluate    'error' in """${page_content_lower}""" or 'not found' in """${page_content_lower}""" or '404' in """${page_content_lower}"""

        IF    ${page_has_error}
            Log To Console    >> CONFIRMED: Direct page URL access fails (expected per assignment)
        ELSE
            Log To Console    >> WARNING: Direct page access works: ${new_url}
        END
    END
