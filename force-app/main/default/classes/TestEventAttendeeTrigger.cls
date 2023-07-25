@isTest
public with sharing class TestEventAttendeeTrigger {

    @TestSetup
    static void setupTestData() {
        
        Event_Organizer__c eventOrganizer = new Event_Organizer__c(
            Name = 'TestOrganizer',
            Phone__c = '123456789',
            Email__c = 'testorganizer@gmail.com');
        insert eventOrganizer;
        
        Event__c event = new Event__c(
            Name__c = 'Test Event', 
            Max_Seats__c = 50, 
            Live__c = true,
            Event_Organizer__c = eventOrganizer.Id,
            Start_DateTime__c = DateTime.now().addHours(24), 
            End_Date_Time__c = DateTime.now().addHours(50));
        insert event;
        
        Attendee__c attendee = new Attendee__c(
            Name = 'Test Attendee',
             Email__c = 'test@example.com',
              Phone__c = '1234567890');
        insert attendee;
        
        Event_Attendee__c eventAttendee = new Event_Attendee__c(
            Event__c = event.Id,
            Attendee__c = attendee.Id,
            Name = 'Test Event Attendee');
        insert eventAttendee;
    }

    @isTest
    static void sendEmail2AttendeePositive() {
        List<Event_Attendee__c> eventAttendees = [
            SELECT Id, Event__c, Attendee__c 
            FROM Event_Attendee__c];
        Test.startTest();
        Integer beforeMail = Limits.getEmailInvocations();
        EventAttendeeTriggerHandler.sendEmail2Attendee(eventAttendees);
        Integer afterMail = Limits.getEmailInvocations();
        System.assertEquals(beforeMail + eventAttendees.size(), afterMail, 'The number of email invocations did not increase by 1 as expected.');
        Test.stopTest();
    }
}
