@RestResource (urlMapping='/GetDocument/v1/*') 
global with sharing class TermsAndConditionsEndpoint {
    
    @HttpGet
    global static Attachment GetDocument(){
    	
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String type = req.params.get('type');
        System.debug(type);

        Id parentId = [SELECT Id FROM TermsAndConditions__c WHERE Type__c = :type AND Current__c = true LIMIT 1].Id;
        System.debug(parentId);
        Attachment doc = [SELECT Body FROM Attachment WHERE ParentId = :parentId LIMIT 1];
        
        return doc;
    }
}