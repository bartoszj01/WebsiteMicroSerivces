@RestResource (urlMapping='/GetDocument/v3/*') 
global class TermsAndConditionsEndpointv3 {
	
	@HttpGet
    global static String GetDocument() {
    	
    	RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String type = req.params.get('type');
        System.debug(type);

        Id parentId = [SELECT Id FROM TermsAndConditions__c WHERE Type__c = :type AND Current__c = true LIMIT 1].Id;
        System.debug(parentId);
        Id contentDocId = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parentId].ContentDocumentId;
        System.debug('ContentDocId: '+ContentDocId);
        List<ContentVersion> cvList = [SELECT VersionData FROM ContentVersion WHERE isLatest = true];
        
       	String bodyString = EncodingUtil.base64Encode(cvList[0].VersionData);
       	
       	return bodyString;
    }

}