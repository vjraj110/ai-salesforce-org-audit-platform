public with sharing class MetadataScannerService {

    public static List<ApexClass> getApexClasses() {

        return [
            SELECT Id, Name, ApiVersion, LengthWithoutComments
            FROM ApexClass
            ORDER BY Name
            LIMIT 20
        ];
    }
}