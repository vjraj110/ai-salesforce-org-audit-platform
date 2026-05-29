public interface AuditRule {

    List<AuditResult> evaluate(String metadata);

}