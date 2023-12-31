public with sharing class LocationTriggerHandler {
    private static final String AUTH_ID = 'eeabacec-90df-66c7-5d49-e82d1434e511';
    private static final String AUTH_TOKEN = 'BN6c2o66gKiA9bQlTB2d';

    @future(callout=true)
    public static void verifyInternationalAddress(List<Id> locationIds) {
        List<Location__c> locations = [SELECT Id, Street__c, City__c, State__c, Postal_Code__c, Country__c, Verified__c FROM Location__c WHERE Id IN :locationIds];

        List<Location__c> locationsToUpdate = new List<Location__c>();

        for (Location__c location : locations) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            String country = EncodingUtil.urlEncode(location.Country__c, 'UTF-8');
            String address1 = EncodingUtil.urlEncode(location.Street__c, 'UTF-8');
            String locality = EncodingUtil.urlEncode(location.City__c, 'UTF-8');
            String administrativeArea = EncodingUtil.urlEncode(location.State__c, 'UTF-8');
            String postalCode = EncodingUtil.urlEncode(location.Postal_Code__c, 'UTF-8');

            request.setEndpoint('https://international-street.api.smarty.com/verify?auth-id=' + AUTH_ID + '&auth-token=' + AUTH_TOKEN + '&country=' + country + '&address1=' + address1 + '&locality=' + locality + '&administrative_area=' + administrativeArea + '&postal_code=' + postalCode);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
                if (!results.isEmpty()) {
                    Map<String, Object> resultAsMap = (Map<String, Object>) results[0];
                    location.Verified__c = true;
                } else {
                    location.Verified__c = false;
                }
            locationsToUpdate.add(location);
        }
        update locationsToUpdate;
    }
}
