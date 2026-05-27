@isTest
private class MetadataScannerServiceTest {
    @isTest static void testGetApexClasses() {
        List<ApexClass> classes = MetadataScannerService.getApexClasses();
        System.assertNotEquals(null, classes, 'getApexClasses should return a list');
        System.debug(classes);
    }
}