public with sharing class TestDataGenerator {

    public static void generateSampleAuditData() {
        List<Audit_Run__c> runs = new List<Audit_Run__c>{
            new Audit_Run__c(
                Overall_Score__c = 63,
                Critical_Count__c = 2,
                High_Count__c = 4,
                Medium_Count__c = 3,
                Low_Count__c = 1,
                Total_Findings__c = 10,
                Scan_Start_Time__c = Datetime.now().addHours(-5),
                Scan_End_Time__c = Datetime.now().addHours(-4).addMinutes(-30),
                Status__c = 'Completed'
            ),
            new Audit_Run__c(
                Overall_Score__c = 77,
                Critical_Count__c = 1,
                High_Count__c = 3,
                Medium_Count__c = 5,
                Low_Count__c = 2,
                Total_Findings__c = 11,
                Scan_Start_Time__c = Datetime.now().addHours(-4),
                Scan_End_Time__c = Datetime.now().addHours(-3).addMinutes(-30),
                Status__c = 'Completed'
            ),
            new Audit_Run__c(
                Overall_Score__c = 85,
                Critical_Count__c = 1,
                High_Count__c = 2,
                Medium_Count__c = 3,
                Low_Count__c = 4,
                Total_Findings__c = 10,
                Scan_Start_Time__c = Datetime.now().addHours(-2),
                Scan_End_Time__c = Datetime.now().addHours(-1).addMinutes(-30),
                Status__c = 'Completed'
            ),
            new Audit_Run__c(
                Overall_Score__c = 93,
                Critical_Count__c = 0,
                High_Count__c = 1,
                Medium_Count__c = 4,
                Low_Count__c = 2,
                Total_Findings__c = 7,
                Scan_Start_Time__c = Datetime.now().addHours(-1),
                Scan_End_Time__c = Datetime.now().addMinutes(-15),
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
                Audit_Run__c = runs[0].Id,
                Component_Name__c = 'PolicyBatch',
                Rule_Name__c = 'Excessive SOQL',
                Severity__c = 'Critical',
                Recommendation__c = 'Reduce SOQL inside loops and batch records.',
                Category__c = 'Performance'
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
                Component_Name__c = 'BillingHelper',
                Rule_Name__c = 'Hardcoded Currency',
                Severity__c = 'High',
                Recommendation__c = 'Use org currency settings and labels.',
                Category__c = 'Maintainability'
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
                Audit_Run__c = runs[2].Id,
                Component_Name__c = 'CaseHelper',
                Rule_Name__c = 'Uncaught exception',
                Severity__c = 'Medium',
                Recommendation__c = 'Handle exceptions gracefully and log failures.',
                Category__c = 'Reliability'
            ),
            new Audit_Finding__c(
                Audit_Run__c = runs[2].Id,
                Component_Name__c = 'LeadProcessor',
                Rule_Name__c = 'Unsupported DML',
                Severity__c = 'Medium',
                Recommendation__c = 'Use supported DML operations in triggers.',
                Category__c = 'Best Practices'
            ),
            new Audit_Finding__c(
                Audit_Run__c = runs[3].Id,
                Component_Name__c = 'UserSyncService',
                Rule_Name__c = 'Field access issue',
                Severity__c = 'Low',
                Recommendation__c = 'Verify field-level security for all user fields.',
                Category__c = 'Security'
            ),
            new Audit_Finding__c(
                Audit_Run__c = runs[3].Id,
                Component_Name__c = 'ReportScheduler',
                Rule_Name__c = 'Inefficient query',
                Severity__c = 'Low',
                Recommendation__c = 'Optimize query filters and avoid SELECT * patterns.',
                Category__c = 'Performance'
            )
        };
        insert findings;
    }
}