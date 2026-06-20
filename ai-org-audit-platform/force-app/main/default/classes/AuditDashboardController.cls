public with sharing class AuditDashboardController {

    @AuraEnabled(cacheable=true)
    public static DashboardSummary getDashboardSummary() {
        DashboardSummary summary = new DashboardSummary();
        summary.healthScore = 0;
        summary.criticalCount = 0;
        summary.highCount = 0;
        summary.mediumCount = 0;
        summary.lowCount = 0;
        summary.totalFindings = 0;

        List<Audit_Run__c> runs = [
            SELECT Overall_Score__c,
                   Critical_Count__c,
                   High_Count__c,
                   Medium_Count__c,
                   Low_Count__c,
                   Total_Findings__c
            FROM Audit_Run__c
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        if (runs.isEmpty()) {
            return summary;
        }

        Audit_Run__c latestRun = runs[0];

        summary.healthScore = latestRun.Overall_Score__c;
        summary.criticalCount = latestRun.Critical_Count__c == null ? 0 : latestRun.Critical_Count__c.intValue();
        summary.highCount = latestRun.High_Count__c == null ? 0 : latestRun.High_Count__c.intValue();
        summary.mediumCount = latestRun.Medium_Count__c == null ? 0 : latestRun.Medium_Count__c.intValue();
        summary.lowCount = latestRun.Low_Count__c == null ? 0 : latestRun.Low_Count__c.intValue();
        summary.totalFindings = latestRun.Total_Findings__c == null ? 0 : latestRun.Total_Findings__c.intValue();

        return summary;
    }

    @AuraEnabled(cacheable=true)
    public static List<AuditFindingDTO> getLatestFindings() {
        List<AuditFindingDTO> findings = new List<AuditFindingDTO>();

        for (Audit_Finding__c finding : [
            SELECT Component_Name__c,
                   Rule_Name__c,
                   Severity__c,
                   Recommendation__c,
                   Category__c
            FROM Audit_Finding__c
            ORDER BY CreatedDate DESC
            LIMIT 50
        ]) {
            AuditFindingDTO dto = new AuditFindingDTO();
            dto.componentName = finding.Component_Name__c;
            dto.ruleName = finding.Rule_Name__c;
            dto.severity = finding.Severity__c;
            dto.recommendation = finding.Recommendation__c;
            dto.category = finding.Category__c;
            findings.add(dto);
        }

        return findings;
    }

    @AuraEnabled(cacheable=true)
    public static List<Audit_Run__c> getRecentRuns() {
        return [
            SELECT Id,
                   Name,
                   Overall_Score__c,
                   Critical_Count__c,
                   High_Count__c,
                   Medium_Count__c,
                   Low_Count__c,
                   Total_Findings__c,
                   Scan_Start_Time__c,
                   Scan_End_Time__c,
                   Status__c
            FROM Audit_Run__c
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
}
