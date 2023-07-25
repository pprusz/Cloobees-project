trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {
    EventAttendeeTriggerHandler.sendEmail2Attendee(Trigger.new);
}