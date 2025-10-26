*** Settings ***
Resource    ../Resources/Keywords/keywords.robot
Resource    ../Resources/Data/common_dt.robot
Library        SeleniumLibrary
Library        OperatingSystem

Test Setup    Open Browser with TMDB URL
Test Teardown    Close Browser

*** Test Cases ***

RRQA/Filters/Test All Category Navigation/TC001
    [Documentation]    Check that all four main categories navigate correctly and show different content
    [Tags]    smoke    categories    navigation

    # Test Popular category
    Click Category    Popular
    Log To Console    >> Popular category navigation tested
    Verify Page Content Changed    Popular
    ${popular_url}=    Get Url
    Should Contain    ${popular_url}    /popular

    # Test Trend
    Click Category    Trend
    Verify Page Content Changed    Trend
    ${trend_url}=    Get Url
    Should Contain    ${trend_url}    /trend

    # Test Newest
    Click Category    Newest
    Verify Page Content Changed    Newest
    ${newest_url}=    Get Url
    Should Contain    ${newest_url}    /new

    # Test Top Rated
    Click Category    Top rated
    Verify Page Content Changed    Top rated
    ${top_url}=    Get Url
    Should Contain    ${top_url}    /top

RRQA/Filters/Test Search Functionality/TC002
    [Documentation]    Test the search feature with various inputs
    [Tags]    search    functional

    # Test valid search functionality
    Search For Content    Horror
    Log To Console    >> Search functionality tested
    Check Search Results Contain    Horror

    # Test another genre search
    Clear Search
    Search For Content    Action
    Check Search Results Contain    Action

    # Test empty search
    Clear Search
    ${page_content}=    Get Text    tag=body
    Should Contain    ${page_content}    Discover

RRQA/Filters/Test Advanced Filters On Category Pages/TC003

    [Documentation]    Test the advanced filtering options that appear on category pages
    [Tags]    filters    advanced

    # Navigate to a category page that shows filters
    Click Category    Trend
    Wait For Advanced Filters

    # Test Genre Filter (if dropdown available)
    ${genre_elements}=    Get Webelements    text=Genre
    ${genre_count}=    Get Length    ${genre_elements}
    Run Keyword If    ${genre_count} > 0    Test Genre Filter

    # Test Year Filter
    ${year_elements}=    Get Webelements    text=Year
    ${year_count}=    Get Length    ${year_elements}
    Run Keyword If    ${year_count} > 0    Test Year Filter

    # Test Type Filter (Movie/TV)
    ${type_elements}=    Get Webelements    text=Type
    ${type_count}=    Get Length    ${type_elements}
    Run Keyword If    ${type_count} > 0    Test Type Filter

RRQA/Filters/Test Movie Type Filter/TC001
    [Documentation]    Specifically test Movie vs TV Show type filtering
    [Tags]    type-filter    movies    tv-shows

    Click Category    Trend
    Wait For Advanced Filters

    # Verify default type is Movies
    ${page_content}=    Get Text    tag=body
    Should Contain    ${page_content}    Movie
    ${initial_content}=    Get Text    tag=body

    # Try to find TV option and test if available
    ${tv_elements}=    Get Webelements    text=TV
    ${tv_count}=    Get Length    ${tv_elements}
    Run Keyword If    ${tv_count} > 0    Click    text=TV
    Run Keyword If    ${tv_count} > 0    Wait For Load State    networkidle
    Run Keyword If    ${tv_count} > 0    Verify Content Changed    ${initial_content}

RRQA/Filters/Test Year Filter Functionality/TC004

    [Documentation]    Test year-based filtering
    [Tags]    year-filter    temporal

    Click Category    Newest
    Wait For Advanced Filters

    # Try to interact with year input
    ${year_inputs}=    Get Webelements    input
    ${year_count}=    Get Length    ${year_inputs}

    # If year input exists, test it
    Run Keyword If    ${year_count} > 0    Test Year Input    2020
    Run Keyword If    ${year_count} > 0    Test Year Input    2023

RRQA/Filters/Test Rating Filter Functionality/TC005

    [Documentation]    Test rating-based filtering (if available)
    [Tags]    rating-filter

    Click Category    Top rated
    Wait For Advanced Filters

    # Look for rating controls
    ${rating_elements}=    Get Webelements    text=/[Rr]ating/
    ${rating_count}=    Get Length    ${rating_elements}

    Run Keyword If    ${rating_count} > 0    Log To Console    >> Rating filters found
    Run Keyword If    ${rating_count} > 0    Test Rating Controls

RRQA/Filters/Test Genre Filter Functionality/TC006
    [Documentation]    Test Genre-based filtering
    [Tags]    Genre-filter

    Click Category    Popular
    Wait For Advanced Filters

    # Verify default type is Movies
    ${page_content}=    Get Text    tag=body
    Should Contain    ${page_content}    Movie
    ${initial_content}=    Get Text    tag=body

    # Try to find TV option and test if available
    ${tv_elements}=    Get Webelements    text=TV
    ${tv_count}=    Get Length    ${tv_elements}
    Run Keyword If    ${tv_count} > 0    Click    text=TV
    Run Keyword If    ${tv_count} > 0    Wait For Load State    networkidle
    Run Keyword If    ${tv_count} > 0    Verify Content Changed    ${initial_content}