public with sharing class TestDataGenerator {

    public static void generateSampleAuditData() {
        List<Audit_Run__c> runs = new List<Audit_Run__c>{
            new Audit_Run__c(
                Overall_Score__c = 85,
                Critical_Count__c = 1,
                High_Count__c = 2,
                Medium_Count__c = 3,
                Low_Count__c = 4,
                Total_Findings__c = 10,
                Scan_Start_Time__c = Datetime.now().addHours(-2),
                Scan_End_Time__c = Datetime.now().addMinutes(-90),
                Status__c = 'Completed'
            ),
            new Audit_Run__c(
                Overall_Score__c = 92,
                Critical_Count__c = 0,
                High_Count__c = 1,
                Medium_Count__c = 4,
                Low_Count__c = 2,
                Total_Findings__c = 7,
                Scan_Start_Time__c = Datetime.now().addHours(-1),
                Scan_End_Time__c = Datetime.now().addMinutes(-30),
                Status__c = 'Completed'
            )
        };
        insert runs;

        List<Audit_Finding__c> findings = new List<Audit_Finding__c>{
            new Audit_Finding__c(
                Audit_Run__c = runs[0].Id,
                Component_Name__c = 'OrderService',
                Rule_Name__c = 'DML inside loop',
                Severity__c = 'High',
                Recommendation__c = 'Move DML operations outside the loop.',
                Category__c = 'Performance'
            ),
            new Audit_Finding__c(
                Audit_Run__c = runs[0].Id,
                Component_Name__c = 'AccountTrigger',
                Rule_Name__c = 'Hardcoded Id',
                Severity__c = 'Medium',
                Recommendation__c = 'Use Custom Metadata or Custom Setting instead of hardcoded IDs.',
                Category__c = 'Maintainability'
            ),
            new Audit_Finding__c(
                Audit_Run__c = runs[1].Id,
                Component_Name__c = 'OpportunityController',
                Rule_Name__c = 'Missing bulk safeguards',
                Severity__c = 'Critical',
                Recommendation__c = 'Add bulk-safe handling for collections.',
                Category__c = 'Best Practices'
            ),
            new Audit_Finding__c(
                Audit_Run__c = runs[1].Id,
                Component_Name__c = 'InvoiceBatch',
                Rule_Name__c = 'Too many queries',
                Severity__c = 'High',
                Recommendation__c = 'Reduce SOQL queries inside loops.',
                Category__c = 'Performance'
            ),
            new Audit_Finding__c(
                Audit_Run__c = runs[1].Id,
                Component_Name__c = 'CaseHelper',
                Rule_Name__c = 'Uncaught exception',
                Severity__c = 'Medium',
                Recommendation__c = 'Handle exceptions gracefully and log failures.',
                Category__c = 'Reliability'
            )
        };
        insert findings;
    }
}