public class DashboardSummary {

    @AuraEnabled
    public Decimal healthScore;

    @AuraEnabled
    public Integer totalFindings;

    @AuraEnabled
    public Integer criticalCount;

    @AuraEnabled
    public Integer highCount;

    @AuraEnabled
    public Integer mediumCount;

    @AuraEnabled
    public Integer lowCount;
}