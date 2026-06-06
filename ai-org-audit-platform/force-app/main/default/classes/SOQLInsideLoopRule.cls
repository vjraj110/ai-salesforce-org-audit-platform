public class SOQLInsideLoopRule
implements AuditRule {

    public List<AuditResult> evaluate(
        String metadata
    ) {

        List<AuditResult> results =
            new List<AuditResult>();

        if(metadata.contains('for(')
            && metadata.contains('[SELECT')) {

            AuditResult result =
                new AuditResult();

            result.ruleName =
                'SOQLInsideLoopRule';

            result.severity = 'High';

            result.category =
                'Performance';

            result.message =
                'Potential SOQL inside loop detected';

            result.recommendation =
                'Move SOQL query outside loop';

            result.passed = false;

            results.add(result);
        }

        return results;
    }

    public String getRuleId() {
        return 'SOQL_IN_LOOP';
    }

    public String getCategory() {
        return 'Performance';
    }

    public String getDefaultSeverity() {
        return 'High';
    }

    public String getDescription() {
        return 'Detects SOQL queries inside loops.';
    }
}