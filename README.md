
Hey Everyone, I am Shankar and I am creating this repo for automation assignment given by Rapyuta Robotics for QA role

# Test Case Description Document

Project: Rapyuta Demo Website Automation (https://tmdb-discover.surge.sh)

Module: Filtering, Pagination, and Negative Scenarios

Automation Tool: Robot Framework + SeleniumLibrary

Browser: Chrome (default)

Environment: QA Demo Site

Tester: Shankar P


**Document Notes :**

All detailed test cases, including test steps, expected results, and priorities for each test suite, are maintained in an Excel file:

File Name: tmdb_tc_file.xlsx

Location: /Documents/tmdb_tc_file.xlsx



**Suite Execution Order:** 

FS_Filters.robot (Functional validations)

FS_Pagination.robot (Navigation behavior)

FS_Negative.robot (Error resilience and robustness)


Browsers Supported: Chrome, Edge, anyother (configurable)

Error Handling: Negative cases use Run Keyword And Continue On Failure for resilience.

Logging: All critical checks include console logs and screenshots for reporting.

**Setup and Installation:** 

Prerequisites:
Python 3.8 or higher
Internet connection for testing the live website

Installation Steps:

# Clone the repository
git clone https://github.com/SHANKAR-100/RR-QA-Automation.git

cd RR-QA-Automation

# Install dependencies
pip install -r Requirements.txt

**Run all tests:**
robot --outputdir reports TestSuites/

**Run specific test suite:**
robot --outputdir reports TestSuites/FS_Filters.robot

**Execution Time:**
Approximatly - 10 min



