public with sharing class AIRecommendationService {

    public static AIResponse generateRecommendation(
        Audit_Finding__c finding
    ) {

        AIResponse response = new AIResponse();

        response.success = true;
        response.confidence = 0.95;

        String ruleName = String.isBlank(finding.Rule_Name__c)
            ? 'UnknownRule'
            : finding.Rule_Name__c;

        switch on ruleName {

            when 'DMLInsideLoopRule' {

                response.risk =
                    'High risk of hitting governor limits during bulk operations.';

                response.impact =
                    'Transactions processing many records may fail with Too Many DML Statements errors.';

                response.businessImpact =
                    'This can cause process failures when the transaction touches larger data volumes.';

                response.explanation =
                    'A DML operation is being carried out inside a loop, which makes the transaction heavier and increases the chance of governor-limit failures.';

                response.recommendation =
                    'Collect records in a list and perform a single DML statement after the loop completes.';

                response.codeExample =
                    'List<Account> updates = new List<Account>();\n\n' +
                    'for(Account acc : accounts){\n' +
                    '    updates.add(acc);\n' +
                    '}\n\n' +
                    'update updates;';
            }

            when 'SOQLInsideLoopRule' {

                response.risk =
                    'SOQL queries inside loops can quickly exceed Salesforce governor limits.';

                response.impact =
                    'Large data volumes may cause Query Limit exceptions.';

                response.businessImpact =
                    'This increases the chance of slower performance and runtime exceptions in high-volume data jobs.';

                response.explanation =
                    'The Apex source performs a query while it is iterating over records, which can multiply the number of database calls and exceed platform limits.';

                response.recommendation =
                    'Move SOQL queries outside loops and use Maps for efficient lookups.';

                response.codeExample =
                    'Map<Id, Contact> contacts =\n' +
                    'new Map<Id, Contact>([\n' +
                    'SELECT Id, AccountId\n' +
                    'FROM Contact\n' +
                    'WHERE AccountId IN :accountIds\n' +
                    ']);';
            }

            when 'HardcodedIdRule' {

                response.risk =
                    'Hardcoded IDs reduce portability across environments.';

                response.impact =
                    'Deployments between Sandbox and Production may fail.';

                response.businessImpact =
                    'A deployment can break because the logic becomes tied to a specific environment instead of an org-safe configuration.';

                response.explanation =
                    'The code contains a literal Salesforce ID-like value, which is a portability smell and can make maintenance or migration harder.';

                response.recommendation =
                    'Replace hardcoded IDs with Custom Metadata or Custom Settings.';

                response.codeExample =
                    'My_Config__mdt config =\n' +
                    'My_Config__mdt.getInstance(\'Default\');';
            }

            when else {

                response.risk =
                    'Potential maintainability issue detected.';

                response.impact =
                    'Could negatively affect long-term scalability.';

                response.businessImpact =
                    'The code may be harder to maintain and may carry operational risk during future changes.';

                response.explanation =
                    'The audit found a pattern that does not match the current rule set, so the dashboard has no specialized remediation text for this finding.';

                response.recommendation =
                    'Review this component according to Salesforce best practices.';

                response.codeExample =
                    '// No example available.';
            }
        }

        return response;
    }

    @AuraEnabled
    public static void analyzeFinding(Id findingId) {

        Audit_Finding__c finding = [
            SELECT Id,
                Rule_Name__c,
                Component_Name__c,
                Severity__c,
                Message__c,
                Category__c,
                Recommendation__c,
                Audit_Run__c
            FROM Audit_Finding__c
            WHERE Id = :findingId
            LIMIT 1
        ];

        AIResponse ai = generateRecommendation(finding);

        finding.AI_Explanation__c = ai.explanation;
        finding.AI_Risk__c = ai.risk;
        finding.AI_Business_Impact__c = ai.businessImpact;
        finding.AI_Impact__c = ai.impact;
        finding.AI_Recommendation__c = ai.recommendation;
        finding.AI_Code_Sample__c = ai.codeExample;
        finding.AI_Confidence__c = ai.confidence;
        finding.AI_Status__c = 'Completed';

        update finding;
    }

    @AuraEnabled
    public static void analyzeFindings(List<Id> findingIds) {
        if (findingIds == null || findingIds.isEmpty()) {
            return;
        }

        List<Audit_Finding__c> findings = [
            SELECT Id,
                Rule_Name__c,
                Component_Name__c,
                Severity__c,
                Message__c,
                Category__c,
                Recommendation__c,
                Audit_Run__c
            FROM Audit_Finding__c
            WHERE Id IN :findingIds
        ];

        List<Audit_Finding__c> recordsToUpdate = new List<Audit_Finding__c>();

        for (Audit_Finding__c finding : findings) {
            AIResponse ai = generateRecommendation(finding);

            finding.AI_Explanation__c = ai.explanation;
            finding.AI_Risk__c = ai.risk;
            finding.AI_Business_Impact__c = ai.businessImpact;
            finding.AI_Impact__c = ai.impact;
            finding.AI_Recommendation__c = ai.recommendation;
            finding.AI_Code_Sample__c = ai.codeExample;
            finding.AI_Confidence__c = ai.confidence;
            finding.AI_Status__c = 'Completed';

            recordsToUpdate.add(finding);
        }

        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }

    @AuraEnabled
    public static String generateExecutiveSummary(Id auditRunId) {
        if (auditRunId == null) {
            return 'No audit run selected for executive summary.';
        }

        List<Audit_Finding__c> findings = [
            SELECT Id,
                Severity__c,
                Rule_Name__c,
                Component_Name__c,
                Category__c
            FROM Audit_Finding__c
            WHERE Audit_Run__c = :auditRunId
        ];

        if (findings.isEmpty()) {
            return 'No findings were detected for this audit run.';
        }

        Integer critical = 0;
        Integer high = 0;
        Integer medium = 0;
        Integer low = 0;

        Set<String> components = new Set<String>();
        Set<String> rules = new Set<String>();

        for (Audit_Finding__c finding : findings) {
            if (finding.Severity__c == 'Critical') {
                critical++;
            } else if (finding.Severity__c == 'High') {
                high++;
            } else if (finding.Severity__c == 'Medium') {
                medium++;
            } else if (finding.Severity__c == 'Low') {
                low++;
            }

            if (!String.isBlank(finding.Component_Name__c)) {
                components.add(finding.Component_Name__c);
            }

            if (!String.isBlank(finding.Rule_Name__c)) {
                rules.add(finding.Rule_Name__c);
            }
        }

        String summary =
            'This audit run detected ' + findings.size() + ' finding(s): ' +
            critical + ' critical, ' + high + ' high, ' + medium + ' medium, and ' + low + ' low. ' +
            'The main affected components are ' + String.join(new List<String>(components), ', ') + '. ' +
            'The primary rule patterns identified were ' + String.join(new List<String>(rules), ', ') + '. ' +
            'The org should prioritize remediation for the most severe items before they impact production stability.';

        Audit_Run__c run = [
            SELECT Id,
                Executive_Summary__c
            FROM Audit_Run__c
            WHERE Id = :auditRunId
            LIMIT 1
        ];

        run.Executive_Summary__c = summary;
        update run;

        return summary;
    }

}