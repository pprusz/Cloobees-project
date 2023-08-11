public with sharing class EventsListController {
    @AuraEnabled(cacheable=true)
    public static List<Event__c> getEvents(String eventName, String startDate) {
        DateTime searchDate = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        if (startDate != null) {
            Date inputDate = Date.valueOf(startDate);
            searchDate = DateTime.newInstance(inputDate, Time.newInstance(0, 0, 0, 0));
        }
        String likeCondition = '';
        if (eventName != null && eventName != '') {
            eventName = '%' + eventName + '%';
            likeCondition = ' AND Name__c LIKE :eventName';
        }

        String query = 'SELECT Name__c, Event_Organizer__r.Name, Location__r.Name, Event_Detail__c, Start_DateTime__c FROM Event__c WHERE Start_DateTime__c >= :searchDate' + likeCondition;

        return Database.query(query);
    }
}
