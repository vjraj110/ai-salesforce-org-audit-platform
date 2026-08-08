public with sharing class AuditExecutionService {

    public static List<AuditResult> runAudit() {
        List<ApexClass> apexClasses = MetadataScannerService.getApexClasses();
        List<AuditResult> findings = new List<AuditResult>();

        for (ApexClass apexClass : apexClasses) {
            String metadata = apexClass.Body == null ? '' : apexClass.Body;
            List<AuditResult> ruleFindings = RuleProcessorService.process(metadata);

            for (AuditResult finding : ruleFindings) {
                finding.componentName = apexClass.Name;
                findings.add(finding);
            }
        }

        return findings;
    }
}
