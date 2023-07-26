public with sharing class PurgeOldEventsBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext oldEvents) {
        return Database.getQueryLocator([
            SELECT Id, Name, End_Date_Time__c, Live__c
            FROM Event__c
            WHERE End_Date_Time__c < LAST_N_MONTHS:2 AND Live__c = true
        ]);
    }
    public void execute(Database.BatchableContext oldEvents, List<Event__c> oldEv){
        delete oldEv;
        
    }
    public void finish(Database.BatchableContext oldEvents) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'patryk.pruszkowski@cloobees.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Task Completed');
        mail.setPlainTextBody('Task 11 done');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('finish done');
    }
}