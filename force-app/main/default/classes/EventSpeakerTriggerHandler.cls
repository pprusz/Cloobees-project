public with sharing class EventSpeakerTriggerHandler {
    public static void eventSpeakerCheck(List<Event_Speaker__c> newEventSpeaker) {
        Set<Id> speakersId = new Set<Id>();
        Map<Id, Event_Speaker__c> speakerId2EventSpeaker = new Map<Id, Event_Speaker__c>();
    
        for(Event_Speaker__c eventSpeaker : newEventSpeaker){
            speakersId.add(eventSpeaker.Speaker__c);
            speakerId2EventSpeaker.put(eventSpeaker.Speaker__c, eventSpeaker);
        }
    
        List<Event_Speaker__c> eventSpeakers = [SELECT Speaker__c FROM Event_Speaker__c WHERE Speaker__c IN :speakersId];
    
        for(Id speakerId : speakersId){
            for(Event_Speaker__c eventSpeaker : eventSpeakers){
                if(speakerId == eventSpeaker.Speaker__c){
                    speakerId2EventSpeaker.get(eventSpeaker.Speaker__c).addError('This speaker is already assigned to another event.');
                }
            }
        }
    }
}