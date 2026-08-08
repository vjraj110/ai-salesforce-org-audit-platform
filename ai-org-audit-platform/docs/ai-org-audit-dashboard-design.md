# AI Org Audit Dashboard – Current Design Note

## Objective

This project implements a Salesforce Lightning dashboard for surfacing org quality findings and health indicators. The UI is an LWC dashboard that reads stored audit summary data from Salesforce objects. The underlying Apex service layer contains a rule-based metadata scanner that looks for common Apex code issues such as DML inside loops, SOQL inside loops, and hardcoded IDs.

## Runtime flow today

1. LWC Dashboard loads
   - The LWC in [force-app/main/default/lwc/auditDashboard/auditDashboard.js](../force-app/main/default/lwc/auditDashboard/auditDashboard.js) uses `@wire` adapters to fetch three data sets from Apex:
     - `getDashboardSummary()`
     - `getLatestFindings()`
     - `getRecentRuns()`
   - These are exposed by [force-app/main/default/classes/AuditDashboardController.cls](../force-app/main/default/classes/AuditDashboardController.cls).

2. Dashboard summary population
   - `getDashboardSummary()` reads the latest `Audit_Run__c` record and returns summary counters:
     - `Overall_Score__c`
     - `Critical_Count__c`
     - `High_Count__c`
     - `Medium_Count__c`
     - `Low_Count__c`
     - `Total_Findings__c`
   - The result is mapped into `DashboardSummary`.

3. Finding visualization
   - `getLatestFindings()` queries up to 50 `Audit_Finding__c` records, maps them into `AuditFindingDTO`, and returns a component-friendly list to the LWC.
   - The LWC translates severity strings into visual CSS classes such as `critical`, `high`, `medium`, and `low`.

4. Run audit button
   - The `Run Audit` button in the LWC makes a call to `runDashboardAudit()` on the controller.
   - The current implementation does not execute the real scanner. It calls the test-data generator instead, which inserts sample `Audit_Run__c` and `Audit_Finding__c` records.
   - This is how the dashboard is currently seeded with data for presentation.

## Scanner pipeline

The production scan contract is intentionally simple and can be described as follows:

1. Apex metadata collection
   - [force-app/main/default/classes/MetadataScannerService.cls](../force-app/main/default/classes/MetadataScannerService.cls) retrieves Apex class metadata through `getApexClasses()`.
   - It reads the `ApexClass.Body` for each class.

2. Rule execution
   - [force-app/main/default/classes/AuditExecutionService.cls](../force-app/main/default/classes/AuditExecutionService.cls) loops over retrieved classes.
   - For each class body, it invokes `RuleProcessorService.process(metadata)`.
   - The processor runs the rule implementations:
     - [force-app/main/default/classes/DMLInsideLoopRule.cls](../force-app/main/default/classes/DMLInsideLoopRule.cls)
     - [force-app/main/default/classes/SOQLInsideLoopRule.cls](../force-app/main/default/classes/SOQLInsideLoopRule.cls)
     - [force-app/main/default/classes/HardcodedIdRule.cls](../force-app/main/default/classes/HardcodedIdRule.cls)

3. Finding shape
   - Each rule emits an `AuditResult` object from [force-app/main/default/classes/AuditResult.cls](../force-app/main/default/classes/AuditResult.cls).
   - The result sets fields such as the rule name, severity, category, recommendation, and message.

4. Persisting the findings
   - The persistence layer [force-app/main/default/classes/FindingPersistenceService.cls](../force-app/main/default/classes/FindingPersistenceService.cls) is designed to create `Audit_Run__c` records and save a list of `Audit_Finding__c` records.
   - It also aggregates severity counts and computes an overall score using [force-app/main/default/classes/HealthScoringService.cls](../force-app/main/default/classes/HealthScoringService.cls).

## Queueable boundary

The queueable in [force-app/main/default/classes/AuditScanQueueable.cls](../force-app/main/default/classes/AuditScanQueueable.cls) invokes `AuditExecutionService.runAudit()`. This is a minimal orchestration point that triggers the scanner, but it is not currently connected to the save/summary completion path.

## AI enrichment boundary

The AI layer lives in [force-app/main/default/classes/AIRecommendationService.cls](../force-app/main/default/classes/AIRecommendationService.cls) and [force-app/main/default/classes/AIResponse.cls](../force-app/main/default/classes/AIResponse.cls).

- `generateRecommendation()` accepts an `Audit_Finding__c` record.
- It reads `Rule_Name__c` and maps it to a static response object with risk, impact, recommendation, and code-sample text.
- `analyzeFinding(Id findingId)` loads a single finding record and writes the AI fields into the object using the `AI_*` fields on the finding record.

That AI enrichment remains currently isolated from the main dashboard refresh flow and can be reconnected later.

## Current design gap

The repo currently has a conceptual architecture but not a fully wired production execution path:

- The UI surfaces dashboard data from stored run records.
- The scan engine is defined but not called by the dashboard’s active refresh action.
- The `Run Audit` action seeds sample data rather than triggering the scan engine.
- The AI recommendation enrichment is available but not yet connected to a complete persistent scan lifecycle.

## Target simplification

The project should settle on a single runtime path:

- the LWC dashboard should call a real Apex audit service
- that service should call the scanner and save audit results
- the saved run should refresh summary and finding views
- AI recommendation enrichment should be treated as an optional post-processing step

That keeps the dashboard simple, separates concern boundaries, and avoids coupling the UI to sample-data generation.
