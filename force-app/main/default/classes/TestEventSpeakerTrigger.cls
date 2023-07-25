@isTest
public with sharing class TestEventSpeakerTrigger {

    @TestSetup
    static void setupTestData(){
        List<Speaker__c> speakers = new List<Speaker__c>();
        for(Integer i=0; i<2; i++){
            Speaker__c speaker = new Speaker__c(
                Name = 'Speaker' + i,
                Phone__c = '12345678' + i,
                Email__c = 'Speaker' + i + '@gmail.com'
            );
            speakers.add(speaker);
        }
        insert speakers;

        Event_Organizer__c eventOrganizer = new Event_Organizer__c(
            Name = 'Test Organizer',
            Phone__c = '1234567890',
            Email__c = 'organizer@test.com'
        );
        insert eventOrganizer;
        
        Event__c eventForTestClass = new Event__c(
            Name__c = 'eventForTestClass',
            Max_Seats__c = 100,
            Start_DateTime__c = DateTime.now().addHours(24),
            End_Date_Time__c = DateTime.now().addHours(48),
            Live__c = true, 
            Event_Organizer__c = eventOrganizer.Id
        );
        insert eventForTestClass;

        Event_Speaker__c eventSpeaker = new Event_Speaker__c(
            Speaker__c=speakers[0].Id,
            Event__c=eventForTestClass.Id
        );
        insert eventSpeaker;
    }

    @isTest
    static void testEventSpeakerTriggerPositive(){
        Speaker__c speaker = [SELECT Id FROM Speaker__c WHERE Name='Speaker1' LIMIT 1];
        Event__c eventForTestClass = [SELECT Id FROM Event__c WHERE Name__c='eventForTestClass' LIMIT 1];

        Test.startTest();
            Event_Speaker__c newEventSpeaker = new Event_Speaker__c(
                Speaker__c=speaker.Id,
                Event__c=eventForTestClass.Id
            );
            insert newEventSpeaker;
        Test.stopTest();

        Event_Speaker__c insertedRecord = [
            SELECT Id, Speaker__c 
            FROM Event_Speaker__c 
            WHERE Speaker__c =:speaker.Id 
            AND Event__c =:eventForTestClass.Id];
        System.assertNotEquals(null, insertedRecord.Id, 'Record should be created successfully.');
    }
 
    @isTest
    static void testEventSpeakerTriggerNegative(){
        Speaker__c speaker = [SELECT Id FROM Speaker__c WHERE Name='Speaker0' LIMIT 1];
        Event__c eventForTestClass = [SELECT Id FROM Event__c WHERE Name__c='eventForTestClass' LIMIT 1];

        Test.startTest();
            Event_Speaker__c newEventSpeaker = new Event_Speaker__c(
                Speaker__c=speaker.Id,
                Event__c=eventForTestClass.Id
            );
            Database.SaveResult result = Database.insert(newEventSpeaker, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess(), 'Record should not be created successfully.');
        System.assertEquals('This speaker is already assigned to another event.', result.getErrors()[0].getMessage(), 'Expected error message is not matched.');
    }
}
