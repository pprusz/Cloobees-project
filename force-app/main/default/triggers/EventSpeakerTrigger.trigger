trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
    for(Event_Speaker__c eventSpeaker : Trigger.new) {
        List<Event_Speaker__c> existingEvents = [SELECT Id FROM Event_Speaker__c WHERE Speaker__c = :eventSpeaker.Speaker__c AND Event__c = :eventSpeaker.Event__c];
        
        if(!existingEvents.isEmpty()){
            eventSpeaker.addError('This speaker is already assigned to another event.');
        }
    }
}
