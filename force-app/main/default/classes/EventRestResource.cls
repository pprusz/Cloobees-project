@RestResource(urlMapping='/eventDetails/*')
global with sharing class EventRestResource {

    @HttpGet
    global static List<Event__c> getEventDetails() {
        return [SELECT Id, Name, Start_DateTime__c, Live__c
                FROM Event__c 
                WHERE Live__c = TRUE AND Start_DateTime__c > :System.today()];
    }
}
