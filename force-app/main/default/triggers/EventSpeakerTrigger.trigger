trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
    for (Event_Speaker__c newEventSpeaker : Trigger.new) {
        List<Event_Speaker__c> existingEventSpeakers;

        if (Trigger.isInsert) {
            existingEventSpeakers = [
                SELECT ID
                FROM Event_Speaker__c
                WHERE Speaker__c = :newEventSpeaker.Speaker__c
            ];
        } else if (Trigger.isUpdate) {
            existingEventSpeakers = [
                SELECT ID
                FROM Event_Speaker__c
                WHERE Speaker__c = :newEventSpeaker.Speaker__c
                AND Id != :newEventSpeaker.Id
            ];
        }

        if (!existingEventSpeakers.isEmpty()) {
            newEventSpeaker.addError('This speaker is already assigned to another event.');
        }
    }
}