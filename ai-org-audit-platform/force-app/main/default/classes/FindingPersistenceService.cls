public with sharing class FindingPersistenceService {

    public static Id createAuditRun() {

        Audit_Run__c run = new Audit_Run__c(
            Status__c = 'In Progress',
            Scan_Start_Time__c = System.now()
        );

        insert run;

        return run.Id;
    }

    public static void saveFindings(
        Id auditRunId,
        List<AuditResult> results
    ) {

        List<Audit_Finding__c> findings =
            new List<Audit_Finding__c>();

        for(AuditResult result : results) {

            findings.add(
                new Audit_Finding__c(
                    Audit_Run__c = auditRunId,
                    Component_Name__c = result.componentName,
                    Rule_Name__c = result.ruleName,
                    Severity__c = result.severity,
                    Category__c = result.category,
                    Recommendation__c = result.recommendation,
                    Message__c = result.message
                )
            );
        }

        if(!findings.isEmpty()) {
            insert findings;
        }
    }

    public static void completeRun(
        Id runId,
        List<AuditResult> findings
    ) {

        Integer criticalCount = 0;
        Integer highCount = 0;
        Integer mediumCount = 0;
        Integer lowCount = 0;

        for(AuditResult result : findings) {

            if(result.severity == 'Critical')
                criticalCount++;

            else if(result.severity == 'High')
                highCount++;

            else if(result.severity == 'Medium')
                mediumCount++;

            else if(result.severity == 'Low')
                lowCount++;
        }

        Decimal score =
            HealthScoringService.calculateScore(findings);

        Audit_Run__c run =
            [SELECT Id, Scan_Start_Time__c
             FROM Audit_Run__c
             WHERE Id=:runId
             LIMIT 1];

        run.Status__c = 'Completed';

        run.Overall_Score__c = score;

        run.Total_Findings__c = findings.size();

        run.Critical_Count__c = criticalCount;
        run.High_Count__c = highCount;
        run.Medium_Count__c = mediumCount;
        run.Low_Count__c = lowCount;

        run.Scan_End_Time__c = System.now();

        run.Duration_Seconds__c =
            run.Scan_End_Time__c.getTime() -
            run.Scan_Start_Time__c.getTime();

        update run;
    }
}