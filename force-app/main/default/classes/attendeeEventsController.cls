public with sharing class attendeeEventsController {

    @AuraEnabled(cacheable=true)
    public static List<Event__c> getPastEvents(String attendeeId) {
        return [
            SELECT Id, Name, Start_DateTime__c, Location__r.Name
            FROM Event__c
            WHERE Event__c.Id IN (
                SELECT Event_Attendee__c.Event__c 
                FROM Event_Attendee__c
                WHERE Event_Attendee__c.Attendee__c = :attendeeId
            ) AND Event__c.Start_DateTime__c < :System.now()
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Event__c> getUpcomingEvents(String attendeeId) {
        return [
            SELECT Event__c.Id, Event__c.Name, Event__c.Start_DateTime__c, Location__r.Name
            FROM Event__c
            WHERE Event__c.Id IN (
                SELECT Event_Attendee__c.Event__c 
                FROM Event_Attendee__c
                WHERE Event_Attendee__c.Attendee__c = :attendeeId
            ) AND Event__c.Start_DateTime__c >= :System.now()
        ];
    }
}
