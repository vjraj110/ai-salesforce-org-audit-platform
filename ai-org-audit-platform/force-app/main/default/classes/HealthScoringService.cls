public with sharing class HealthScoringService {

    public static Decimal calculateScore(
        List<AuditResult> findings
    ) {

        Decimal score = 100;

        for(AuditResult finding : findings) {

            switch on finding.severity {

                when 'Critical' {
                    score -= 10;
                }

                when 'High' {
                    score -= 5;
                }

                when 'Medium' {
                    score -= 2;
                }

                when 'Low' {
                    score -= 1;
                }

                when else {
                }
            }
        }

        return Math.max(score,0);
    }
}