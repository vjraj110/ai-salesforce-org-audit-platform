public with sharing class RuleRegistryService {

    public static List<AuditRule>
        getEnabledRules() {

        return new List<AuditRule>{

            new DMLInsideLoopRule(),

            new SOQLInsideLoopRule(),

            new HardcodedIdRule()
        };
    }
}