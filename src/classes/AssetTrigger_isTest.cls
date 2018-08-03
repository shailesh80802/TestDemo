@isTest(SeeAllData=true)
 
private class AssetTrigger_isTest {
    static testMethod void validateInsertAssetTrigger() {
        
      //Test Data to create Asset Record
      Account acc = new Account(Name = 'Test');
      insert acc;
      
      OMG_ProductRelease__c omgProd = new OMG_ProductRelease__c();
      omgProd.Name = 'Alert Web Test';
      //omgProd.OMG_ProductLine__c = 'a0D30000000T87O';
      insert omgProd;
      
      OMG_ProductRelease__c dbOmgProd = [select id, Name from OMG_ProductRelease__c where Name =: 'Alert Web Test'];
      Asset ast = new Asset();
      ast.AccountId = acc.id;
      ast.OMG_Acronym__c = 'NYC123';
      ast.OMG_ProductRelease__c = dbOmgProd.id;
      //ast.Identifier__c = 'NYC123';
      //ast.Identifier_Type__c = 'Acronym';
      ast.Name = '1';
      test.startTest();
      insert ast;
      
      String astName = dbOmgProd.Name + ' - NYC123';
      
      Asset dbAsset = [Select Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c,Identifier__c, Identifier_Type__c, OMG_ProductRelease__r.Name FROM Asset where id =: ast.id];
      OMG_OmgeoProductIdentifier__c OProdIdentifier1 = [Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId, Is_Primary__c From OMG_OmgeoProductIdentifier__c where OMG_ID__c =: 'NYC123'];
      System.assertEquals(dbAsset.Identifier__c,'NYC123');
      System.assertEquals(dbAsset.Identifier_Type__c ,'Acronym');
      System.debug('ast ====='+ast);
      System.debug('dbAsset ====='+dbAsset);
      System.debug('OProdIdentifier1 ====='+OProdIdentifier1);
      System.assertEquals(dbAsset.Name,astName);
      System.assertEquals(OProdIdentifier1.OMG_ID__c,'NYC123'); 
      System.assertEquals(OProdIdentifier1.OMG_IdentifierName__c,'Acronym');       
      
      String astName1 = dbOmgProd.Name + ' - Bombay234';
      assetServices.bTestFlagSignOn = true;
      assetServices.bPreventAU = false;
      assetServices.bPreventRecursion = false;      
      ast.Identifier__c = 'Bombay234';
      ast.Identifier_Type__c = 'Sign On';
      System.debug('Update Operation Started......====================================.!!!!');
      update ast;
      Asset dbAsset1 = [Select Id, Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c, Identifier__c, Identifier_Type__c, OMG_ProductRelease__r.Name FROM Asset where id =: ast.id];
      System.debug('ast ====='+ast);
      System.debug('dbAsset1 ====='+dbAsset1);
      system.debug('Successfully Updated AST ......................');
      OMG_OmgeoProductIdentifier__c OProdIdentifier = [Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId, Is_Primary__c From OMG_OmgeoProductIdentifier__c where OMG_ID__c =: 'Bombay234'];     
      System.debug('OProdIdentifier ====='+OProdIdentifier);
      System.assertEquals(dbAsset1.OMG_SignOn__c,'Bombay234');
      System.assertEquals(OProdIdentifier.OMG_ID__c,'Bombay234'); 
      System.assertEquals(OProdIdentifier.OMG_IdentifierName__c,'Sign on');
      System.assertEquals(dbAsset1.Name,astName1);
      
      String astName2 = dbOmgProd.Name + ' - London456';
      assetServices.bTestFlagOrgID = true;
      assetServices.bPreventAU = false;
      assetServices.bPreventRecursion = false;
      ast.Identifier__c = 'London456';
      ast.Identifier_Type__c = 'ORG ID';
      ast.OMG_Acronym__c = '';
      System.debug('Update Operation Started. for Org ID.....====================================.!!!!');
      update ast;
      Asset dbAsset2 = [Select Id, Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c, Identifier__c, Identifier_Type__c, OMG_ProductRelease__r.Name FROM Asset where id =: ast.id];
      System.debug('ast ====='+ast);
      System.debug('dbAsset1 ====='+dbAsset1);
      System.debug('dbAsset2 ====='+dbAsset2);      
      OMG_OmgeoProductIdentifier__c OProdIdentifier2 = [Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId, Is_Primary__c From OMG_OmgeoProductIdentifier__c where OMG_ID__c =: 'London456'];     
      System.debug('OProdIdentifier2 ====='+OProdIdentifier2);
      System.assertEquals(dbAsset2.Org_ID__c,'London456');
      System.assertEquals(OProdIdentifier2.OMG_ID__c,'London456'); 
      System.assertEquals(OProdIdentifier2.OMG_IdentifierName__c,'ORG ID');
      System.assertEquals(dbAsset2.Name,astName2);
      
      String astName3 = dbOmgProd.Name + ' - Austin999';
      assetServices.bTestFlagAcronym = true;
      assetServices.bPreventAU = false;
      assetServices.bPreventRecursion = false;
      ast.Identifier__c = 'Austin999';
      ast.Identifier_Type__c = 'Acronym';
      ast.OMG_Acronym__c = '';
      //ast.Org_ID__c = '';
      System.debug('Update Operation Started. ====================================.!!!!');
      update ast;
      Asset dbAsset3 = [Select Id, Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c, Identifier__c, Identifier_Type__c, OMG_ProductRelease__r.Name FROM Asset where id =: ast.id];
      System.debug('ast ====='+ast);
      System.debug('dbAsset2 ====='+dbAsset2);
      System.debug('dbAsset3 ====='+dbAsset3);      
      OMG_OmgeoProductIdentifier__c OProdIdentifier3 = [Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId, Is_Primary__c From OMG_OmgeoProductIdentifier__c where OMG_ID__c =: 'Austin999'];     
      System.debug('OProdIdentifier3 ====='+OProdIdentifier3);
      System.assertEquals(dbAsset3.OMG_Acronym__c,'Austin999');
      System.assertEquals(OProdIdentifier3.OMG_ID__c,'Austin999'); 
      System.assertEquals(OProdIdentifier3.OMG_IdentifierName__c,'Acronym');
      System.assertEquals(dbAsset3.Name,astName3);
      
      String astName4 = dbOmgProd.Name + ' - Houston777';
      assetServices.bTestFlagAcro2 = true;
      assetServices.bPreventAU = false;
      assetServices.bPreventRecursion = false;
      ast.OMG_Acronym__c = 'Houston777';            
      System.debug('Update Operation Started. ====================================.!!!!');
      update ast;
      Asset dbAsset4 = [Select Id, Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c, Identifier__c, Identifier_Type__c, OMG_ProductRelease__r.Name FROM Asset where id =: ast.id];
      System.debug('ast ====='+ast);
      System.debug('dbAsset3 ====='+dbAsset3);
      System.debug('dbAsset4 ====='+dbAsset4);      
      OMG_OmgeoProductIdentifier__c OProdIdentifier4 = [Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId, Is_Primary__c From OMG_OmgeoProductIdentifier__c where OMG_ID__c =: 'Houston777'];     
      System.debug('OProdIdentifier4 ====='+OProdIdentifier4);
      System.assertEquals(dbAsset4.Identifier__c,'Houston777');
      System.assertEquals(dbAsset4.Identifier_Type__c ,'Acronym');
      System.assertEquals(OProdIdentifier4.OMG_ID__c,'Houston777'); 
      System.assertEquals(OProdIdentifier4.OMG_IdentifierName__c,'Acronym');
      System.assertEquals(dbAsset4.Name,astName4);
      
      String astName5 = dbOmgProd.Name + ' - Chicago312';
      assetServices.bTestFlagSign2 = true;
      assetServices.bPreventAU = false;
      assetServices.bPreventRecursion = false;
      ast.OMG_SignOn__c = 'Chicago312'; 
      ast.Identifier__c = null;
      ast.Identifier_Type__c = null;          
      System.debug('Update Operation Started. ====================================.!!!!');
      update ast;
      Asset dbAsset5 = [Select Id, Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c, Identifier__c, Identifier_Type__c, OMG_ProductRelease__r.Name FROM Asset where id =: ast.id];
      System.debug('ast ====='+ast);
      System.debug('dbAsset4 ====='+dbAsset4);
      System.debug('dbAsset5 ====='+dbAsset5);      
      OMG_OmgeoProductIdentifier__c OProdIdentifier5 = [Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId, Is_Primary__c From OMG_OmgeoProductIdentifier__c where OMG_ID__c =: 'Chicago312'];     
      System.debug('OProdIdentifier5 ====='+OProdIdentifier5);
      System.assertEquals(dbAsset5.Identifier__c,'Chicago312');
      System.assertEquals(dbAsset5.Identifier_Type__c ,'Acronym');
      System.assertEquals(OProdIdentifier5.OMG_ID__c,'Chicago312'); 
      System.assertEquals(OProdIdentifier5.OMG_IdentifierName__c,'Acronym');
      System.assertEquals(dbAsset5.Name,astName5);
      
      test.stopTest();
      
      }
      

    
}