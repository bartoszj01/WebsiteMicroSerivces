@isTest
public with sharing class TermsAndConditionsEndpoint_Test {
    
    @testSetup
    static void createTestData() {
    	
    	// create terms and conditions with specific type
    	List<TermsAndConditions__c> tnList = new List<TermsAndConditions__c>();
    	TermsAndConditions__c tnc = new TermsAndConditions__c(Name='Tnc1', Type__c = 'AGB', Current__c = true, Valid__c = true);
    	TermsAndConditions__c tn1 = new TermsAndConditions__c(Name='Tnc1', Type__c = 'Privacy Policy', Current__c = true, Valid__c = true);
    	tnList.add(tnc);
    	tnlist.add(tn1);
    	insert tnList;
    	
    	System.debug(tnc);
    	// create attachments
    	List<Attachment> attList = new List<Attachment>();
    	String s = 'Attachment body';
    	
    	Attachment att = new Attachment();
    	att.Name = 'AGB Document';
    	att.Body = Blob.valueOf(s);
    	att.ParentId = tnc.Id;
    	attList.add(att);
    	
    	Attachment at1 = new Attachment();
    	at1.Name = 'AGB Duplicate';
    	at1.Body = Blob.valueOf(s);
    	at1.ParentId = tnc.Id;
    	attList.add(at1);
    	
    	Attachment at2 = new Attachment();
    	at2.Name = 'Privacy policy';
    	at2.Body = Blob.valueOf(s);
    	at2.ParentId = tn1.Id;
    	attList.add(at2);
    	insert attList;
    	
    }
    
    @isTest
    Static void testMethod1() {
    	
    	RestRequest req = new RestRequest();
    	RestResponse res = new RestResponse();
    	
  		req.httpMethod = 'GET';
  		req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/GetDocument/v1';
  		req.params.put('type', 'AGB');
  		
  		System.debug(req.requestURI);
  		RestContext.request = req;
  		RestContext.response = res;
  		
  		Attachment a = TermsAndConditionsEndpoint.GetDocument();
  		
  		System.assertEquals(a.Id, [SELECT Id FROM Attachment WHERE Parent.Name = 'Tnc1' LIMIT 1].Id);
    }
    
    @isTest
    static void testMethod2() {
    	RestRequest req = new RestRequest();
    	RestResponse res = new RestResponse();
    	
  		req.httpMethod = 'GET';
  		req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/GetDocument/v2';
  		req.params.put('type', 'AGB');
  		
  		System.debug(req.requestURI);
  		RestContext.request = req;
  		RestContext.response = res;
  		
  		Id parentId = [SELECT Id FROM TermsAndConditions__c WHERE Type__c = 'AGB' AND Current__c = true LIMIT 1].Id;
  		Attachment a = [SELECT Body FROM Attachment WHERE ParentId = :parentId LIMIT 1];
  		
  		String bodyString = TermsAndConditionsEndpointv2.GetDocument();
  		Blob b = EncodingUtil.base64Decode(bodyString);
  		System.assertEquals(b, a.Body);
  		
    }
 }