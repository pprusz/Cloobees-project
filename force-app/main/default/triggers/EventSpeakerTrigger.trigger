trigger EventSpeakerTrigger on Event_Speaker__c(before insert, before update) {
    for(Event_Speaker__c eventSpeaker :Trigger.new){
        List<Event_Speaker__c> existingEventSpeakers=[
            SELECT ID
            FROM Event_Speaker__c
            WHERE Speaker__c = : eventSpeaker.Speaker__c
            AND ID != :eventSpeaker.ID]
        ]
    }
}