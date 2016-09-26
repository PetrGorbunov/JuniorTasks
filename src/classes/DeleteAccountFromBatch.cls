global class DeleteAccountFromBatch implements Database.Batchable<sObject> {

    global final String Query;
    global DeleteAccountFromBatch(String q) {
        Query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<Sobject> scope) {
        List <Account> accounts = new list<Account>();
        for(Sobject s : scope) {
            Account a = (Account)s;
            accounts.add(a);
        }
        Delete accounts;
    }

    global void finish(Database.BatchableContext BC) {
        //Send email after batch completes
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'piotrgorbunov@mail.ru'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Batch Job is done');
        mail.setPlainTextBody('The batch Apex job processed ');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}