public with sharing class RuleProcessorService {

    public class RuleSummary {
        public String ruleId;
        public String category;
        public String severity;
    }

    public static List<AuditResult> process(String metadata) {
        return process(metadata, null);
    }

    public static List<AuditResult> process(String metadata, String componentName) {
        if (metadata == null) {
            metadata = '';
        }

        List<AuditResult> findings = new List<AuditResult>();

        List<AuditRule> rules = new List<AuditRule>{
            new DMLInsideLoopRule(),
            new SOQLInsideLoopRule(),
            new HardcodedIdRule()
        };

        for (AuditRule rule : rules) {
            List<AuditResult> ruleResults = rule.evaluate(metadata);
            for (AuditResult result : ruleResults) {
                if (componentName != null) {
                    result.componentName = componentName;
                }
                findings.add(result);
            }
        }

        return findings;
    }

    public static List<AuditResult> processAll(Map<String, String> metadataByName) {
        List<AuditResult> findings = new List<AuditResult>();

        if (metadataByName == null) {
            return findings;
        }

        for (String componentName : metadataByName.keySet()) {
            findings.addAll(process(metadataByName.get(componentName), componentName));
        }

        return findings;
    }

    public static List<RuleSummary> getRegisteredRules() {
        List<RuleSummary> summaries = new List<RuleSummary>();

        RuleSummary dmlSummary = new RuleSummary();
        dmlSummary.ruleId = 'DML_INSIDE_LOOP';
        dmlSummary.category = 'Performance';
        dmlSummary.severity = 'High';
        summaries.add(dmlSummary);

        RuleSummary soqlSummary = new RuleSummary();
        soqlSummary.ruleId = 'SOQL_IN_LOOP';
        soqlSummary.category = 'Performance';
        soqlSummary.severity = 'High';
        summaries.add(soqlSummary);

        RuleSummary hardcodedIdSummary = new RuleSummary();
        hardcodedIdSummary.ruleId = 'HARDCODED_ID';
        hardcodedIdSummary.category = 'Maintainability';
        hardcodedIdSummary.severity = 'Medium';
        summaries.add(hardcodedIdSummary);

        return summaries;
    }
}