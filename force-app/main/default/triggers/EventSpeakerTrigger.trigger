trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
    for (Event_Speaker__c newEventSpeaker : Trigger.new) {
        List<Event_Speaker__c> existingEventSpeakers = [
            SELECT ID
            FROM Event_Speaker__c
            WHERE Speaker__c = :newEventSpeaker.Speaker__c
            AND (Trigger.isInsert OR (Trigger.isUpdate AND Id != :newEventSpeaker.Id))
        ];

        if (!existingEventSpeakers.isEmpty()) {
            newEventSpeaker.addError('This speaker is already assigned to another event.');
        }
    }
}
