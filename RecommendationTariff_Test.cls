/**
 * Created by b.jarmolinski on 25/04/2018.
 * Tests the following classes: FreeElectricityCalculation, MonthlyAdvancePayment, RecommendationTariff
 */
@isTest
public with sharing class RecommendationTariff_Test {

    @testSetup static void createTestData() {

        String products = 'Product2:{Name=sonnenFlat 4250, AmountFreeEnergy__c=4250}, Product2:{Name=sonnenFlat 5500, AmountFreeEnergy__c=5500}, Product2:{Name=sonnenFlat 6750, AmountFreeEnergy__c=6750}, Product2:{Name=sonnenFlat 8000, AmountFreeEnergy__c=8000}, Product2:{Name=sonnenStrom plus})';

        List<Product2> products2 = new List<Product2>();

        Product2 p1 = new Product2();
        p1.Name = 'sonnenFlat 4250';
        p1.AmountFreeEnergy__c = 4250;
        p1.Type__c = 'Electricity contract';
        p1.IsActive = true;
        products2.add(p1);

        Product2 p2 = new Product2();
        p2.Name = 'sonnenFlat 5500';
        p2.AmountFreeEnergy__c = 5500;
        p2.Type__c = 'Electricity contract';
        p2.IsActive = true;
        products2.add(p2);

        Product2 p3 = new Product2();
        p3.Name = 'sonnenFlat 6750';
        p3.AmountFreeEnergy__c = 6750;
        p3.Type__c = 'Electricity contract';
        p3.IsActive = true;
        products2.add(p3);

        Product2 p4 = new Product2();
        p4.Name = 'sonnenFlat 8000';
        p4.AmountFreeEnergy__c = 8000;
        p4.Type__c = 'Electricity contract';
        p4.IsActive = true;
        products2.add(p4);

        Product2 p5 = new Product2();
        p5.Name = 'sonnenStrom plus';
        p5.AmountFreeEnergy__c = 0;
        p5.Type__c = 'Electricity contract';
        p5.IsActive = true;
        products2.add(p5);

        insert products2;
        System.debug(products2);

        Pricebook2 pb = new Pricebook2(Name = 'sonnen Sales DE', Description = 'sonnen Sales DE', IsActive = true);
        insert pb;

        List<PriceBookEntry> pbeList = new List<PricebookEntry>();
        // standard price book
        // obtain Id of standard pricebook
        Id standard = Test.getStandardPricebookId();

        //create pricebook entries for the standard Price book
        PricebookEntry pbs1 = new PricebookEntry(Product2Id=p1.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=4400.00, MaximalConsumption__c=4750, RecommendedBatteryCapacity2__c='6 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=standard, isActive=true);
        pbeList.add(pbs1);

        PricebookEntry pbs2 = new PricebookEntry(Product2Id=p2.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=6000, MaximalConsumption__c=100000, RecommendedBatteryCapacity2__c='8 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=standard, isActive=true);
        pbeList.add(pbs2);

        PricebookEntry pbs3 = new PricebookEntry(Product2Id=p3.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=7600, MaximalConsumption__c=100000, RecommendedBatteryCapacity2__c='10 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=standard, isActive=true);
        pbeList.add(pbs3);

        PricebookEntry pbs4 = new PricebookEntry(Product2Id=p4.Id, UnitPrice=29.99, MinYearlyEnergyProduction__c=7600, MaximalConsumption__c=100000, RecommendedBatteryCapacity2__c='12 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=standard, isActive=true);
        pbeList.add(pbs4);

        PricebookEntry pbs5 = new PricebookEntry(Product2Id=p5.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=0, MaximalConsumption__c=100000, ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=standard, isActive=true);
        pbeList.add(pbs5);

        // sonnen Sales DE price book

        PricebookEntry pbe1 = new PricebookEntry(Product2Id=p1.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=4400.00, MaximalConsumption__c=10000, RecommendedBatteryCapacity2__c='6 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=pb.Id, isActive=true);
        pbeList.add(pbe1);

        PricebookEntry pbe2 = new PricebookEntry(Product2Id=p2.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=6000, MaximalConsumption__c=100000, RecommendedBatteryCapacity2__c='8 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=pb.Id, isActive=true);
        pbeList.add(pbe2);

        PricebookEntry pbe3 = new PricebookEntry(Product2Id=p3.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=7600, MaximalConsumption__c=100000, RecommendedBatteryCapacity2__c='10 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=pb.Id, isActive=true);
        pbeList.add(pbe3);

        PricebookEntry pbe4 = new PricebookEntry(Product2Id=p4.Id, UnitPrice=29.99, MinYearlyEnergyProduction__c=7600, MaximalConsumption__c=100000, RecommendedBatteryCapacity2__c='12 kWh', ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=pb.Id, isActive=true);
        pbeList.add(pbe4);

        PricebookEntry pbe5 = new PricebookEntry(Product2Id=p5.Id, UnitPrice=19.99, MinYearlyEnergyProduction__c=0, MaximalConsumption__c=100000, ElectricityPrice__c=0.2300, ElectricityPrice2000__c=0.2590, Pricebook2Id=pb.Id, isActive=true);
        pbeList.add(pbe5);

        insert pbeList;
    }


    static testMethod void scenario1() {

        String jsonMessage = '{ "energyConsumption": 4200, "yearlyProduction": 4500, "batterySize": 6, "nominalPower": 4.5 } ';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/recommendTariff';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonMessage);

        RestContext.request = req;
        RestContext.response = res;

        String jsonRes = RecommendationTariff.recommendTariff();

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);
        System.assertEquals('sonnenFlat 4250', (String) responseMap.get('name'));
        System.assertEquals(4250, (Decimal) responseMap.get('freeElectricity') );
        System.assertEquals(0, (Decimal) responseMap.get('monthlyAdvPayment'));

    }

    static testMethod void scenario2() {

        String jsonMessage = '{ "energyConsumption": 4000, "yearlyProduction": 3850, "batterySize": 6, "nominalPower": 5.5 }';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/recommendTariff';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonMessage);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String jsonRes = RecommendationTariff.recommendTariff();
        Test.stopTest();

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);
        System.assertEquals('sonnenFlat 4250', (String) responseMap.get('name'));
        System.assertEquals(3820, (Decimal) responseMap.get('freeElectricity') );
        System.assertEquals(3.45, (Decimal) responseMap.get('monthlyAdvPayment'));

    }

    static testMethod void scenario3() {

        String jsonMessage = '{ "energyConsumption": 4000, "yearlyProduction": 2000, "batterySize": 6, "nominalPower": 5.5 }';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/recommendTariff';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonMessage);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String jsonRes = RecommendationTariff.recommendTariff();
        Test.stopTest();

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);
        System.assertEquals('sonnenStrom plus', (String) responseMap.get('name'));
        System.assertEquals(0, (Decimal) responseMap.get('freeElectricity') );
        System.assertEquals(0, (Decimal) responseMap.get('monthlyAdvPayment'));
    }

    static testMethod void scenario4() {

        String jsonMessage = '{ "energyConsumption": 8000, "yearlyProduction": 5000, "batterySize": 6, "nominalPower": 5.5 }';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/recommendTariff';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonMessage);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String jsonRes = RecommendationTariff.recommendTariff();
        Test.stopTest();

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);
        System.assertEquals('sonnenFlat 4250', (String) responseMap.get('name'));
        System.assertEquals(4250, (Decimal) responseMap.get('freeElectricity') );
        System.assertEquals(76.10, (Decimal) responseMap.get('monthlyAdvPayment'));
    }
}