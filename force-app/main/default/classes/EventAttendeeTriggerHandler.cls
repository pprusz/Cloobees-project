public with sharing class EventAttendeeTriggerHandler {
    public static void sendEmail2Attendee(List<Event_Attendee__c> eventAttendees) {
        Set<Id> eventIds = new Set<Id>();
        Set<Id> attendeeIds = new Set<Id>();

        for(Event_Attendee__c eventAttendee : eventAttendees) {
            eventIds.add(eventAttendee.Event__c);
            attendeeIds.add(eventAttendee.Attendee__c);
        }

        Map<Id, Event__c> eventMap = new Map<Id, Event__c>(
            [SELECT Id, Name, Start_DateTime__c, Location__r.Name, Event_Organizer__r.Name
            FROM Event__c 
            WHERE Id IN :eventIds]);

        Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>(
            [SELECT Id, Name, Email__c
            FROM Attendee__c
            WHERE Id IN :attendeeIds]);

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Event_Attendee__c eventAttendee : eventAttendees) {
            Event__c event = eventMap.get(eventAttendee.Event__c);
            Attendee__c attendee = attendeeMap.get(eventAttendee.Attendee__c);
    
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String> { attendee.Email__c });
            email.setSubject('Pass for the ' + event.Name);
        
            String emailBody = 'Dear ' + attendee.Name + ',\n\n'
                + 'Thank you for registering for ' + event.Name
                + ' which will be organized on ' + event.Start_DateTime__c
                + ' and will be held in ' + event.Location__r.Name + '. '
                + 'We are excited to have you, see you in the event.\n\n'
                + 'Find the Google Map Location for the Event Here. (https://www.google.com/maps/place/' + event.Location__c + ')\n\n'
                + 'Thanks,\n'
                + event.Event_Organizer__r.Name;
            email.setPlainTextBody(emailBody);

            emails.add(email);
            System.debug(attendee.Email__c);
            System.debug('email z attendee: ' + email.getToAddresses() + ', subject: ' + email.getSubject());
            System.debug('treść emaila: '+ email.getHTMLBody());
        }
        try {
            Messaging.sendEmail(emails);
            System.debug('skończone sendEmail2Attendee');
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

    }
     public static void testInConsole() {
        List<Event_Attendee__c> eventAttendees = [SELECT Id, Event__c, Attendee__c FROM Event_Attendee__c WHERE Event__c = 'a080600002JZPY1AAP' AND Attendee__c = 'a050600001EzX1UAAV'];
        sendEmail2Attendee(eventAttendees);
        System.debug('wysłana wiadomość z drugiej metody');
    }
}