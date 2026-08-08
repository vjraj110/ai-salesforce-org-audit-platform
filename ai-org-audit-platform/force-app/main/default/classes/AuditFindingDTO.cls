public class AuditFindingDTO {

    @AuraEnabled
    public String componentName;

    @AuraEnabled
    public String ruleName;

    @AuraEnabled
    public String severity;

    @AuraEnabled
    public String recommendation;

    @AuraEnabled
    public String category;

    @AuraEnabled
    public String aiExplanation;

    @AuraEnabled
    public String aiRisk;

    @AuraEnabled
    public String aiBusinessImpact;

    @AuraEnabled
    public String aiImpact;

    @AuraEnabled
    public String aiRecommendation;

    @AuraEnabled
    public String aiCodeSample;

    @AuraEnabled
    public Decimal aiConfidence;

    @AuraEnabled
    public String aiStatus;
}
