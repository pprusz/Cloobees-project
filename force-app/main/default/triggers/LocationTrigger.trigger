trigger LocationTrigger on Location__c (after insert, after update) {
    try {
        if (System.isBatch() == false && System.isFuture() == false) {
            List<Id> locationIds = new List<Id>();
    
            if (Trigger.isInsert) {
                for (Location__c location : Trigger.new) {
                    locationIds.add(location.Id);
                }
                LocationTriggerHandler.verifyInternationalAddress(locationIds);
            } 
    
            if (Trigger.isUpdate) {
                for (Location__c location : Trigger.new) {
                    locationIds.add(location.Id);
                }
                LocationTriggerHandler.verifyInternationalAddress(locationIds);
            } 
        }
    } catch (Exception e) {
        Error_Log__c errorLog = new Error_Log__c();
            errorLog.Log_Details__c = e.getMessage();
            errorLog.Process_Name__c = 'LocationTrigger';
            errorLog.Name = 'Error Log ' + Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss');
            errorLog.Log_Date_Time__c = Datetime.now();
            
            insert errorLog;
    }

}
