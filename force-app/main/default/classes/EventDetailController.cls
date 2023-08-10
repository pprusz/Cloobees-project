public with sharing class EventDetailController {

    @AuraEnabled(cacheable=true)
    public static List<Speaker__c> getEventSpeakers(String eventId) {
        List<Event_Speaker__c> eventSpeakerList = [SELECT Speaker__c FROM Event_Speaker__c WHERE Event__c = :eventId];
        List<Id> speakerIds = new List<Id>();
        for(Event_Speaker__c es : eventSpeakerList) {
            speakerIds.add(es.Speaker__c);
        }
        return [SELECT Id, Name, Email__c  FROM Speaker__c WHERE Id IN :speakerIds];
    }

    @AuraEnabled(cacheable=true)
    public static List<Location__c> getLocation(String eventId) {
        Event__c eventRecord = [SELECT Location__c FROM Event__c WHERE Id = :eventId];
        return [SELECT Id, Name, City__c, Postal_Code__c, Street__c FROM Location__c WHERE Id = :eventRecord.Location__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Attendee__c> getEventAttendees(String eventId) {
        List<Event_Attendee__c> eventAttendeeList = [SELECT Attendee__c FROM Event_Attendee__c WHERE Event__c = :eventId];
        List<Id> attendeesIds = new List<Id>();
        for(Event_Attendee__c ea : eventAttendeeList) {
            attendeesIds.add(ea.Attendee__c);
        }
        return [SELECT Id, Name, Email__c, Location__r.Name  FROM Attendee__c WHERE Id IN :attendeesIds];
    }
}