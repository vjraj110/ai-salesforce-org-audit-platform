public class BadSOQLClass {

    public void processAccounts(List<Account> accounts){

        for(Account acc : accounts){

            List<Contact> contacts =
                [SELECT Id FROM Contact];

        }
    }
}