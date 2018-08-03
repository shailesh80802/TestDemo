trigger CreatePortfolioJunction on Account (after insert) {
    Map<String,Portfolio__c> portfolioMap = new Map<String,Portfolio__c> ();
    for(Portfolio__c pf : [SELECT Id,Name FROM Portfolio__c]){
        portfolioMap.put(pf.Name.toLowercase(),pf);
    }
    List<Account_Portfolio__c> listToInsert = new List<Account_Portfolio__c>();
    String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('JMFE Investments').getRecordTypeId();
    Set<String> createdJunc = new Set<String>();
    for(Account acc : Trigger.New){
        if(acc.recordtypeId == recTypeId){
            if(String.isNotEmpty(acc.JMFE_Portfolio__c)){
                String[] availableValues = acc.JMFE_Portfolio__c.split(';');
                
                for(String str : availableValues){
                    Account_Portfolio__c juncObj = new Account_Portfolio__c();
                    if(str.contains('Corporate') && !createdJunc.contains('Corporate')){
                        juncObj.Account__c = acc.Id;
                        juncObj.Portfolio__c = portfolioMap.get('corporate').id;
                        createdJunc.add('Corporate');
                    }
                    if(str.contains('Insurance') && !createdJunc.contains('Insurance')){
                        juncObj.Account__c = acc.Id;
                        juncObj.Portfolio__c = portfolioMap.get('insurance').id;
                        createdJunc.add('Insurance');
                    }
                    if(str.contains('Retirement') && !createdJunc.contains('Retirement')){
                        juncObj.Account__c = acc.Id;
                        juncObj.Portfolio__c = portfolioMap.get('retirement').id;
                        createdJunc.add('Retirement');
                    }
                    if(juncObj.Account__c!=null && juncObj.Portfolio__c !=null){
                        listToInsert.add(juncObj);
                    }
                }
                
            }
        }
    }
    if(!listToInsert.isEmpty()){
        //insert listToInsert;
        Database.insert(listToInsert,false);
    }
}