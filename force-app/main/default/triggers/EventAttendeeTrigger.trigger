trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {
    Set<Id> attendeeIds = new Set<Id>();
    for(Event_Attendee__c attendee : Trigger.new) {
        attendeeIds.add(attendee.Attendee__c); 
    };

    Map<Id, Attendee__c> attendeesMap = new Map<Id, Attendee__c>([SELECT Id, Email__c FROM Attendee__c WHERE Id IN :attendeeIds]);

    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

    for(Event_Attendee__c attendee : Trigger.new) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        mail.setToAddresses(new String[] {attendeesMap.get(attendee.Attendee__c).Email__c});
        mail.setSubject('Pass for the ' + attendee.Event_Name__c);
        
        String body = 'Dear ' + attendeesMap.get(attendee.Attendee__c).Name + ',\n';
        body += 'Thank you for registering for ' + attendee.Event_Name__c;
        body += ' which will be Organized on ' + attendee.Event_Date__c;
        body += ' & will be held in ' + attendee.Event_Location__c + '.\n';
        body += 'Find the Google Map Location for the Event Here. ';
        body += '(https://www.google.com/maps/place/' + attendee.Location__c + ')\n';
        body += 'Thanks,\n' + Event_Organizer__c;
        mail.setHtmlBody(body);
        
        mails.add(mail);
    }
    Messaging.sendEmail(mails);
}
