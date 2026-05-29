public class DMLInsideLoopRule implements AuditRule {

    public List<AuditResult> evaluate(String metadata) {

        List<AuditResult> results = new List<AuditResult>();

        if(metadata.contains('for(') &&
           (metadata.contains('update ') ||
            metadata.contains('insert '))) {

            AuditResult result = new AuditResult();
            result.severity = 'High';
            result.message = 'Potential DML inside loop detected';
            result.passed = false;

            results.add(result);
        }

        return results;
    }
}