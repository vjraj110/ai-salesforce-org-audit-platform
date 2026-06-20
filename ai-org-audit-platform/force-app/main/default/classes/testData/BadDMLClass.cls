public class BadDMLClass {

    public void processAccounts(List<Account> accounts){

        for(Account acc : accounts){

            update acc;

        }
    }
}