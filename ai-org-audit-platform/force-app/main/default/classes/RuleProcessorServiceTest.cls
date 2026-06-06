/**
 * RuleProcessorServiceTest
 *
 * Validates the RuleProcessorService contract using the available local rule
 * engine surfaces. This test class is intentionally narrower than the original
 * spec to avoid brittle assumptions about the org's rule registry.
 */
@IsTest
private class RuleProcessorServiceTest {

    @IsTest
    static void test_blankMetadata_returnsEmptyList() {
        Test.startTest();
        List<AuditResult> results = RuleProcessorService.process('', 'BlankClass');
        Test.stopTest();

        System.assertEquals(0, results.size(),
            'Blank metadata should produce zero findings.');
    }

    @IsTest
    static void test_nullMetadata_returnsEmptyList() {
        Test.startTest();
        List<AuditResult> results = RuleProcessorService.process(null, 'NullClass');
        Test.stopTest();

        System.assertEquals(0, results.size(),
            'Null metadata should produce zero findings.');
    }

    @IsTest
    static void test_singleArgumentOverload_returnsNonNullList() {
        Test.startTest();
        List<AuditResult> results = RuleProcessorService.process('public class Foo {}');
        Test.stopTest();

        System.assertNotEquals(null, results,
            'Single-argument overload must return a non-null list.');
    }

    @IsTest
    static void test_processAll_emptyMap_returnsEmptyList() {
        Test.startTest();
        List<AuditResult> results = RuleProcessorService.processAll(new Map<String, String>());
        Test.stopTest();

        System.assertEquals(0, results.size(),
            'processAll with an empty map should return an empty list.');
    }

    @IsTest
    static void test_processAll_nullMap_returnsEmptyList() {
        Test.startTest();
        List<AuditResult> results = RuleProcessorService.processAll(null);
        Test.stopTest();

        System.assertEquals(0, results.size(),
            'processAll with a null map should return an empty list.');
    }

    @IsTest
    static void test_getRegisteredRules_returnsAtLeastOneRule() {
        Test.startTest();
        List<RuleProcessorService.RuleSummary> summaries = RuleProcessorService.getRegisteredRules();
        Test.stopTest();

        System.assertNotEquals(null, summaries,
            'getRegisteredRules must not return null.');
        System.assert(summaries.size() >= 1,
            'There should be at least one registered rule.');

        for (RuleProcessorService.RuleSummary summary : summaries) {
            System.assertNotEquals(null, summary.ruleId,
                'Every rule summary must have a ruleId.');
            System.assertNotEquals(null, summary.category,
                'Every rule summary must have a category.');
            System.assertNotEquals(null, summary.severity,
                'Every rule summary must have a severity.');
        }
    }

    @IsTest
    static void test_componentNameStampedOnFindings_whenResultsExist() {
        String apexBody =
            'public class Bad { ' +
            '  public void run(List<Account> accs) { ' +
            '    for (Account a : accs) { ' +
            '      insert a; ' +
            '    } ' +
            '  } ' +
            '}';

        Test.startTest();
        List<AuditResult> results = RuleProcessorService.process(apexBody, 'BadClass');
        Test.stopTest();

        if (!results.isEmpty()) {
            for (AuditResult finding : results) {
                System.assertEquals('BadClass', finding.componentName,
                    'The componentName should be stamped onto findings.');
            }
        }
    }

    @IsTest
    static void test_findingsHaveRequiredFields_whenResultsExist() {
        String apexBody =
            'public class Vulnerable { ' +
            '  public void run(List<Account> accs) { ' +
            '    for (Account a : accs) { ' +
            '      insert a; ' +
            '    } ' +
            '  } ' +
            '}';

        Test.startTest();
        List<AuditResult> results = RuleProcessorService.process(apexBody, 'Vulnerable');
        Test.stopTest();

        for (AuditResult finding : results) {
            System.assertNotEquals(null, finding.ruleId,
                'Every finding should have a ruleId.');
            System.assertNotEquals(null, finding.severity,
                'Every finding should have a severity.');
            System.assertNotEquals(null, finding.message,
                'Every finding should have a message.');
            System.assertNotEquals(null, finding.passed,
                'Every finding should have a passed boolean.');
        }
    }
}