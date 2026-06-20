public class DMLInsideLoopRule implements AuditRule {

    public List<AuditResult> evaluate(String metadata) {

        List<AuditResult> results = new List<AuditResult>();

        if(metadata.contains('for(') &&
           (metadata.contains('update ') ||
            metadata.contains('insert '))) {

            AuditResult result = new AuditResult();
            result.ruleId = 'DML_IN_LOOP';
            result.ruleName = 'DMLInsideLoopRule';
            result.severity = 'High';
            result.category = 'Performance';
            result.message = 'Potential DML inside loop detected';
            result.recommendation = 'Move DML operations outside loops';
            result.passed = false;

            results.add(result);
        }

        return results;
    }
}