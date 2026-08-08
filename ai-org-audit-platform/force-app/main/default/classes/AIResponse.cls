public class AIResponse {

    @AuraEnabled
    public String risk;

    @AuraEnabled
    public String impact;

    @AuraEnabled
    public String businessImpact;

    @AuraEnabled
    public String recommendation;

    @AuraEnabled
    public String explanation;

    @AuraEnabled
    public String codeExample;

    @AuraEnabled
    public Decimal confidence;

    @AuraEnabled
    public Boolean success;

    @AuraEnabled
    public String executiveSummary;

}