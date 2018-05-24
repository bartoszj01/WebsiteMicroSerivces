@RestResource (urlMapping='/GetDocument/v2/*') 
global with sharing class TermsAndConditionsEndpointv2 {
	
	@HttpGet
    global static String GetDocument() {
    	
    	RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String type = req.params.get('type');
        System.debug(type);

        Id parentId = [SELECT Id FROM TermsAndConditions__c WHERE Type__c = :type AND Current__c = true LIMIT 1].Id;
        System.debug(parentId);
        Attachment doc = [SELECT Body FROM Attachment WHERE ParentId = :parentId LIMIT 1];
       	String bodyString = EncodingUtil.base64Encode(doc.Body);
       	
       	return bodyString;
    }
}