public with sharing class RuleProcessorService {

    public static List<AuditResult> process(String metadata) {

        List<AuditResult> findings = new List<AuditResult>();

        List<AuditRule> rules = new List<AuditRule>{
            new DMLInsideLoopRule()
        };

        for(AuditRule rule : rules) {
            findings.addAll(rule.evaluate(metadata));
        }

        return findings;
    }
}