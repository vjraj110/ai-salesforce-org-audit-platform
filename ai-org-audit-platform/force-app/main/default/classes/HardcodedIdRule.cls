public class HardcodedIdRule
implements AuditRule {

    public List<AuditResult> evaluate(
        String metadata
    ) {

        List<AuditResult> results =
            new List<AuditResult>();

        Pattern p =
            Pattern.compile(
            '[a-zA-Z0-9]{15,18}'
        );

        Matcher m =
            p.matcher(metadata);

        if(m.find()) {

            AuditResult result =
                new AuditResult();

            result.ruleName =
                'HardcodedIdRule';

            result.severity = 'Medium';

            result.category =
                'Maintainability';

            result.message =
                'Potential hardcoded Id found';

            result.recommendation =
                'Use Custom Metadata or Custom Settings';

            result.passed = false;

            results.add(result);
        }

        return results;
    }

    public String getRuleId() {
        return 'HARDCODED_ID';
    }

    public String getCategory() {
        return 'Maintainability';
    }

    public String getDefaultSeverity() {
        return 'Medium';
    }

    public String getDescription() {
        return 'Detects potential hardcoded Salesforce IDs in code.';
    }
}