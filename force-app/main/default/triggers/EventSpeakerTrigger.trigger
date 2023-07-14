trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
    Set<Id> speakerIds = new Set<Id>();
    
    for (Event_Speaker__c newEventSpeaker : Trigger.new) {
        speakerIds.add(newEventSpeaker.Speaker__c);
    }
    
    Map<Id, Event_Speaker__c> existingEventSpeakers = new Map<Id, Event_Speaker__c>(
        [SELECT Speaker__c 
        FROM Event_Speaker__c 
        WHERE Speaker__c IN :speakerIds]
    );
    
    for (Event_Speaker__c newEventSpeaker : Trigger.new) {
        if ((Trigger.isInsert || (Trigger.isUpdate && existingEventSpeakers.get(newEventSpeaker.Speaker__c).Id != newEventSpeaker.Id))
            && existingEventSpeakers.containsKey(newEventSpeaker.Speaker__c)) {
            newEventSpeaker.addError('This speaker is already assigned to another event.');
        }
    }
}
