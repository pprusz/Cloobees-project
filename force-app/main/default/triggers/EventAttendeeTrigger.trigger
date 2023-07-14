trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

    for(Event_Attendee__c attendee : Trigger.new) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(new String[] {attendee.Email__c});
        mail.setSubject('Pass for the ' + attendee.Event_Name__c);
        
        String body = 'Dear ' + attendee.Name__c + ',\n';
        body += 'Thank you for registering for ' + attendee.Event_Name__c;
        body += ' which will be Organized on ' + attendee.Event_Date__c;
        body += ' & will be held in ' + attendee.Event_Location__c + '.\n';
        body += 'Find the Google Map Location for the Event Here. ';
        body += '(https://www.google.com/maps/place/' + attendee.Location__c + ')\n';
        body += 'Thanks,\n' + Event_Organizer.Name;
        mail.setHtmlBody(body);
        
        mails.add(mail);
    }
    Messaging.sendEmail(mails);
}
