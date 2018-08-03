@isTest(SeeAllData=true)
private class AssetTriggerHandler_Test {

    private static testMethod void assetTest(){
    
        Id productReleaseID = [SELECT Id FROM OMG_ProductRelease__c WHERE Name = 'Clarient Entity Hub' Limit 1].Id;
        Id accountID = [SELECT Id FROM Account WHERE Name = 'Omgeo LLC' Limit 1].Id;
        
        Asset ass = new Asset(
        
            Name                  = 'test',
            AccountId             = accountID,
            OMG_ProductRelease__c = productReleaseID
            
        );
        
        insert ass;
        
        ass.OMG_Acronym__c  = 'TEST';
        update ass;
        
        ass.OMG_Signon__c   = 'TEST';
        update ass;
        
        ass.ORG_ID__c       = 'TEST';
        update ass;
        
        ass.OMG_Acronym__c     = null;
        ass.OMG_Signon__c      = null;
        ass.ORG_ID__c          = null;
        ass.Identifier__c      = null;
        ass.Identifier_Type__c = null;
        update ass;
        
        ass.Identifier__c      = '000000';
        ass.Identifier_Type__c = 'Acronym';
        update ass;
        
        Asset ass2 = new Asset(
        
            Name                 = 'test',
            AccountId            = accountID,
            Identifier__c        = '000000',
            Identifier_Type__c   = 'Acronym'
            
        );
        insert ass2;
        
        Asset ass3 = new Asset(
        
            Name                 = 'test',
            AccountId            = accountID,
            OMG_Acronym__c       = '000000'
            
        );
        insert ass3;
        
        Asset ass4 = new Asset(
        
            Name                 = 'test',
            AccountId            = accountID,
            OMG_Signon__c       = '000000'
            
        );
        insert ass4;
        
        Asset ass5 = new Asset(
        
            Name                 = 'test',
            AccountId            = accountID,
            ORG_ID__c       = '000000'
            
        );
        insert ass5;
        
    }
}