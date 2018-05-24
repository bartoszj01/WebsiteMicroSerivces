/**
 * Created by b.jarmolinski on 24/04/2018.
 */
@RestResource (urlMapping='/recommendTariff/*')
global without sharing class RecommendationTariff {

    @HttpPost
    global static String recommendTariff() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String jsonBody = req.requestBody.toString();

        Map<String, Object> desMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);

        // POST parameters
        Decimal energyConsumption = (Decimal) desMap.get('energyConsumption');  // Verbrauch
        Decimal yearlyProduction = (Decimal) desMap.get('yearlyProduction');   // Erzeugung pro Jahr
        Decimal batterySize = (Decimal) desMap.get('batterySize');
        Decimal nominalPower = (Decimal) desMap.get('nominalPower'); // max Leistung kWp

        // query custom metadata types for parameters
        WrSettings__mdt settings = [SELECT PriceBookName__c, Factor__c FROM WrSettings__mdt WHERE Label = 'WRApi'];
        System.debug(settings.PriceBookName__c);
        List<PricebookEntry> pbeList = [SELECT Id FROM PricebookEntry];
        System.debug(pbeList.size());
        // query pricebook entries
        List<PriceBookEntry> productList = [SELECT Id, Product2.Name, MinYearlyEnergyProduction__c, MaximalConsumption__c, Product2.AmountFreeEnergy__c,
                                            RecommendedBatteryCapacity2__c, ElectricityPrice__c, ElectricityPrice2000__c
                                            FROM PriceBookEntry WHERE Product2.Type__c = 'Electricity contract' AND Pricebook2.Name =: settings.PriceBookName__c AND isActive = true ];

        System.debug(productList.size());
        // return variables
        String productName;
        Decimal freeElectricity;
        Decimal monthlyAdvPayment;

        // recommendation logic
        Map<Decimal, String> prodNameMap = new Map<Decimal, String>();
        Map<Decimal, Decimal> minProdMap = new Map<Decimal,Decimal>();
        Map<Decimal, Decimal> freeElectricityMap = new Map<Decimal, Decimal>();
        Map<Decimal, Decimal> priceMap = new Map<Decimal, Decimal>();
        Map<Decimal, Decimal> price2000Map = new Map<Decimal, Decimal>();


        for (PriceBookEntry  pbe : productList) {
            if (pbe.Product2.Name.contains('sonnenFlat')) {
                List<String> sList = pbe.RecommendedBatteryCapacity2__c.split(' ');
                Decimal size = Decimal.valueOf(sList[0]);
                prodNameMap.put(size, pbe.Product2.Name);
                minProdMap.put(size, (Decimal)pbe.MinYearlyEnergyProduction__c);
                freeElectricityMap.put(size, (Decimal) pbe.Product2.AmountFreeEnergy__c);
                priceMap.put(size, pbe.ElectricityPrice__c);
                price2000Map.put(size, pbe.ElectricityPrice2000__c);
            }
        }
        System.debug(prodNameMap);
        if (nominalPower >= 3 && yearlyProduction >= 2400 && batterySize >= 6) {
            productName = prodNameMap.get(batterySize);

            // free Electricity calculation
            System.debug(minProdMap);
            System.debug(freeElectricityMap);
            Decimal minProduction = minProdMap.get(batterySize);
            Decimal maxFreeAllowance = freeElectricityMap.get(batterySize);
            FreeElectricityCalculation fec = new FreeElectricityCalculation(yearlyProduction, minProduction, maxFreeAllowance, settings.Factor__c);
            freeElectricity = fec.calculateAllowance();

            // monthly payments
            MonthlyAdvancePayment monAdvPay = new MonthlyAdvancePayment(energyConsumption, freeElectricity, priceMap.get(batterySize), price2000Map.get(batterySize));
            monthlyAdvPayment = monAdvPay.calculate();

        } else {
            productName = 'sonnenStrom plus';
            freeElectricity = 0;
            monthlyAdvPayment = 0;
        }

        // for loop through productList
        // construct JSON array
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('name', productName);
        gen.writeNumberField('freeElectricity', freeElectricity);
        gen.writeNumberField('monthlyAdvPayment', monthlyAdvPayment);
        gen.writeEndObject();

        String jsonRes = gen.getAsString();
        return jsonRes;
    }
}