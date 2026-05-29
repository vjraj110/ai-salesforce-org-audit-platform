public with sharing class MetadataScannerService {

    public static List<ApexClass> getApexClasses() {

        return [
            SELECT Id, Name, ApiVersion, Body, LengthWithoutComments
            FROM ApexClass
            ORDER BY Name
        ];
    }
}