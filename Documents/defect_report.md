# Defect Report

## Summary
Testing of the TMDB Discover website confirmed the known issues mentioned in the assignment and identified additional navigation problems. All defects have been documented with reproduction steps and impact analysis.

## Test Environment
- **URL**: https://tmdb-discover.surge.sh/
- **Framework**: Robot Framework with Selenium Library
- **Browser**: Chrome
- **Date**: October 26, 2025

## Defects Found

### DEFECT 001: Direct Slug Access Failure (Known Issue)
**Severity**: High | **Status**: Confirmed

**Description**: Direct URL access to category pages returns "page not found" error

**Reproduction**:
1. Navigate directly to `/popular`, `/trend`, `/new`, or `/top`
2. Observe "page not found powered by surge.sh" message

**Impact**: Users cannot bookmark or share direct links to category pages

**Root Cause**: SPA routing issue - server lacks fallback configuration for client-side routes

### DEFECT 002: Page Refresh Navigation Loss
**Severity**: Medium | **Status**: Confirmed

**Description**: Browser refresh on category pages causes navigation failure

**Reproduction**:
1. Navigate to any category page (Popular, Trend, etc.)
2. Refresh browser (F5)
3. Observe "page not found" error

**Impact**: Poor user experience, loss of application state on refresh

### DEFECT 003: High Page Number Pagination Issues (Known Issue)
**Severity**: Medium | **Status**: Confirmed  

**Description**: Pagination fails on high page numbers as mentioned in assignment

**Reproduction**:
1. Navigate to very high page numbers (page 50+)
2. Observe pagination functionality degrades

**Impact**: Users cannot access all content through pagination

## Positive Findings

**Input Handling**: Invalid search inputs and year values processed safely  
**Performance**: No crashes during rapid navigation stress testing
**Core Functionality**: All filtering, search, and navigation features work correctly when accessed normally

## Summary

The website has solid core functionality but suffers from URL routing issues that affect user experience. The assignment's known issues were confirmed, and the application demonstrates good security practices despite the navigation problems.