public class AssetTriggerHandler extends TriggerHandler {

  public AssetTriggerHandler() {}
  
  protected override void  beforeInsert() {
  
      updateProductIdentifier();
      updateAssetName();
      
  }
  
  protected override void  beforeUpdate() {

      updateProductIdentifier();
      updateAssetName();
      updateProductIdentifierBucket();

  }

  protected override void  afterInsert() {
  
      updateProductIdentifierBucket();
      UpdateAccountFields();

  
  }
    
  protected override void  afterUpdate() {
      UpdateAccountFields();
  }
  /*
  protected override void  beforeDelete() {
 
  }
  
  */
  
   private void UpdateAccountFields() {
      Set<Id> accIds=new Set<Id>();
      for(Asset a: (List<Asset>) trigger.new){
          if(a.status=='Active'){
              accIds.add(a.AccountId);
          }
      }
      List<Account> accList=new List<Account>();
      accList =[select id,Type from account where Id in : accIds And type='Prospect'];
      for(Account acc : accList){
          acc.Type='Customer';  
      }
      update accList;
  }
  
  private String determineIdentifiter (Asset currentAsset, Asset oldAsset2 ) {
  
      String identifier = null;
      
      
      if ( trigger.isInsert ) {
      
          if ( currentAsset.Identifier__c != null && currentAsset.Identifier_Type__c != null ) {
              
              identifier = currentAsset.Identifier__c + '::' + currentAsset.Identifier_Type__c;
                 
          }else if (currentAsset.OMG_Acronym__c != null) {
              
              identifier = currentAsset.OMG_Acronym__c + '::Acronym';    
                   
          }else if (currentAsset.OMG_Signon__c != null) {
                  
              identifier = currentAsset.OMG_Signon__c + '::Signon';    
                  
          }else if (currentAsset.ORG_ID__c != null) {
              
              identifier = currentAsset.ORG_ID__c + '::ORG ID';    
                  
          }
      
      }else{
      
              Asset oldAsset =  (Asset) trigger.oldMap.get(currentAsset.id); 
      
              if (currentAsset.OMG_Acronym__c != null && oldAsset.OMG_Acronym__c == null) {
              
                  identifier = currentAsset.OMG_Acronym__c + '::Acronym'; 
                  
              }else if ( currentAsset.OMG_Acronym__c != null && ( currentAsset.OMG_Acronym__c != oldAsset.OMG_Acronym__c )) {   
              
                  identifier = currentAsset.OMG_Acronym__c + '::Acronym'; 
                  
              }else if (currentAsset.OMG_Signon__c != null && oldAsset.OMG_Signon__c == null) {    

                  identifier = currentAsset.OMG_Signon__c + '::Signon';  
                  
              }else if (currentAsset.OMG_Signon__c != null && ( currentAsset.OMG_Signon__c != oldAsset.OMG_Signon__c )) {     

                  identifier = currentAsset.OMG_Signon__c + '::Signon';  
                  
              }else if (currentAsset.ORG_Id__c != null && oldAsset.ORG_Id__c == null) {    

                  identifier = currentAsset.ORG_ID__c + '::ORG ID'; 
                  
              }else if (currentAsset.ORG_Id__c != null && ( currentAsset.ORG_Id__c  != oldAsset.ORG_Id__c  )) { 

                  identifier = currentAsset.ORG_ID__c + '::ORG ID'; 
              
              }else{
              
                  if ( currentAsset.Identifier__c != null && currentAsset.Identifier_Type__c != null ) {
              
                      identifier = currentAsset.Identifier__c + '::' + currentAsset.Identifier_Type__c;
                  
                  }
              
              }
      
      }
      
      return identifier;
  
  }
  
 
  
  private void updateAssetName() {
  
      String identifier     = null;
      String identifierType = null;
      String assetName      = null;
      
      Map<Id, OMG_ProductRelease__c> productRelease =  new Map<Id, OMG_ProductRelease__c>([Select Id, Name From OMG_ProductRelease__c ]); 
  
      for(Asset a: (List<Asset>) trigger.new){
      
          String   identifierInfo    = determineIdentifiter (a, null) ;
          
          if ( identifierInfo != null && identifierInfo != '' ) {
          
              String[] arridentifierInfo = identifierInfo.split('::');
              
              identifier     = arridentifierInfo[0];
              identifierType = arridentifierInfo[1];
              
          }    
          
              assetName      = null;

          
              if (a.OMG_ProductRelease__c != null) {
                  if ( productRelease.get(a.OMG_ProductRelease__c).Name != null ) {
                      assetName = productRelease.get(a.OMG_ProductRelease__c).Name;
                  }
              }

              assetName = assetName + ' - ';

              if ( identifier != null ) {
                  assetName = assetName + identifier;
              }
          
              a.Name = assetName;
          


      }
  
  }
  
  
  
  private void updateProductIdentifier() {
  
      String identifier     = null;
      String identifierType = null;
      
      for(Asset a: (List<Asset>) trigger.new){
      
          String   identifierInfo    = determineIdentifiter (a, null) ;
          
          if ( identifierInfo == null || identifierInfo == '' ) {
              return;
          }
          
          String[] arridentifierInfo = identifierInfo.split('::');
      
          identifier     = arridentifierInfo[0];
          identifierType = arridentifierInfo[1];
      
          if (a.Identifier__c != identifier) {
              a.Identifier__c = identifier;
          }
          if (a.Identifier_Type__c != identifierType) {
              a.Identifier_Type__c = identifierType;
          }
          
          if (identifierType == null && identifier == null) {
              a.OMG_Acronym__c     = null;
              a.OMG_Signon__c      = null;
              a.ORG_ID__c          = null;
              a.Identifier_Type__c = null;
              a.Identifier__c      = null;
          }else if (identifierType == 'Acronym') {
              a.OMG_Signon__c  = null;
              a.OMG_Acronym__c = identifier;
              a.ORG_ID__c      = null;
          }else if (identifierType == 'Signon') {
              a.OMG_Signon__c  = identifier;
              a.OMG_Acronym__c = null;
              a.ORG_ID__c      = null;
          }else if (identifierType == 'ORG ID') {
              a.OMG_Signon__c  = null;
              a.OMG_Acronym__c = null;
              a.ORG_ID__c      = identifier;
          }else{
              a.OMG_Acronym__c = null;
              a.OMG_Signon__c  = null;
              a.ORG_ID__c      = null;
          }
      
      }
  
  
  }
  
  private void updateProductIdentifierBucket() {
  
      String identifier     = null;
      String identifierType = null;
       
      List <OMG_OmgeoProductIdentifier__c> newOPI   = new List<OMG_OmgeoProductIdentifier__c>();
      List <OMG_OmgeoProductIdentifier__c> updatePIs = new List<OMG_OmgeoProductIdentifier__c>();
      List <OMG_OmgeoProductIdentifier__c> deletePIs = new List<OMG_OmgeoProductIdentifier__c>();
          
      if ( trigger.isInsert ) {
      
          for(Asset a: (List<Asset>) trigger.new){
          
              String   identifierInfo    = determineIdentifiter (a, null) ;
              
              if ( identifierInfo != null && identifierInfo != '' ) {
              
                  String[] arridentifierInfo = identifierInfo.split('::');
      
                  identifier     = arridentifierInfo[0];
                  identifierType = arridentifierInfo[1];
              
                  if ( identifier != null && identifierType != null ) {
              
                      OMG_OmgeoProductIdentifier__c opiToAdd = new OMG_OmgeoProductIdentifier__c();
                        
                      opiToAdd.RecordTypeId           = '012300000005gna';       
                      opiToAdd.Asset__c               = a.Id;
                      opiToAdd.OMG_IdentifierName__c  = identifierType;
                      opiToAdd.OMG_ID__c              = identifier;
                      opiToAdd.Is_Primary__c          = true;
                         
                      newOPI.add(opiToAdd);
              
                  }
              
              }
              
          }
      
      }else{
      
          Set<Id> assetIDs = new Set<Id>();
          
          for(Asset a: (List<Asset>) trigger.new){
              assetIDs.add(a.Id);
          }
          
          Map<Id, OMG_OmgeoProductIdentifier__c> existingPI =  new Map<Id, OMG_OmgeoProductIdentifier__c>([Select Id, Asset__c  From OMG_OmgeoProductIdentifier__c WHERE Is_Primary__c = true AND Asset__c IN :assetIDs ]); 
          
          Map<Id,String> existingPIs     = new Map<Id,Id>();
          
          for(OMG_OmgeoProductIdentifier__c tempExistingPI : [Select Id, Asset__c  From OMG_OmgeoProductIdentifier__c WHERE Is_Primary__c = true AND Asset__c IN :assetIDs limit 1000]) {
              existingPIs.put(tempExistingPI.Asset__c, tempExistingPI.ID);
          }
          
          for(Asset a: (List<Asset>) trigger.new){
          
              String   identifierInfo    = determineIdentifiter (a, null) ;

              if ( identifierInfo != null && identifierInfo != '' ) {
              
                   String[] arridentifierInfo = identifierInfo.split('::');
      
                  identifier     = arridentifierInfo[0];
                  identifierType = arridentifierInfo[1];
              
                  if (  existingPIs.size() > 0 ) {
              
                      if (  existingPIs.get(a.Id) != null ) {
                  
                          if ( identifier == null && identifierType == null ) {
                          
                              OMG_OmgeoProductIdentifier__c piToUpdate = new OMG_OmgeoProductIdentifier__c();
                          
                              piToUpdate.Id = existingPIs.get(a.Id);
                      
                              deletePIs.add(piToUpdate);
                      
                          }else{
              
                              OMG_OmgeoProductIdentifier__c piToUpdate = new OMG_OmgeoProductIdentifier__c();
                                
                              piToUpdate.Id                    = existingPIs.get(a.Id);
                              piToUpdate.OMG_IdentifierName__c = identifierType;
                              piToUpdate.OMG_ID__c             = identifier;
                                
                              updatePIs.add(piToUpdate);
                      
                          }
                  
                      }else{
                  
                          if ( identifier != null && identifierType != null ) {
                  
                              OMG_OmgeoProductIdentifier__c opiToAdd = new OMG_OmgeoProductIdentifier__c();
                          
                              opiToAdd.RecordTypeId          = '012300000005gna';      
                              opiToAdd.Asset__c              = a.Id;
                              opiToAdd.OMG_IdentifierName__c = identifierType;
                              opiToAdd.OMG_ID__c             = identifier;
                              opiToAdd.Is_Primary__c         = true;
                                
                              newOPI.add(opiToAdd);
                      
                          }
                      
                      }
              
                  }else{
              
                      if ( identifier != null && identifierType != null ) {
              
                          OMG_OmgeoProductIdentifier__c opiToAdd = new OMG_OmgeoProductIdentifier__c();
                      
                          opiToAdd.RecordTypeId          = '012300000005gna';        
                          opiToAdd.Asset__c              = a.Id;
                          opiToAdd.OMG_IdentifierName__c = identifierType;
                          opiToAdd.OMG_ID__c             = identifier;
                          opiToAdd.Is_Primary__c         = true;  
                          newOPI.add(opiToAdd);
                  
                      }
              
                  }
              }
          }
      
      }
      
      if(newOPI.size() > 0) { 
          insert newOPI;   
      }
      if(updatePIs.size() > 0) { 
          update updatePIs;   
      } 
      if(deletePIs.size() > 0) { 
          delete deletePIs;   
      } 
      
  
  }
  
}