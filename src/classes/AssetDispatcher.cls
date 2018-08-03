public with sharing class AssetDispatcher {
    /*
    Created By: Shailesh Bhirud
    Created On: 04/20/2015
    Purpose: 
    --------------------------------------------------------------------------
    Modified By:    
    Modified On:  
    Modification: 
    */

    public static MAP<string, string> errorMAP = new MAP<string, string>();

    public static MAP<string, string> Trigger_Handler(
        LIST<Asset> triggerOldLIST, 
        MAP<ID, Asset> triggerOldMAP, 
        LIST<Asset> triggerNewLIST, 
        MAP<ID, Asset> triggerNewMAP, 
        boolean bIsBefore, boolean bIsAfter, boolean bIsInsert, boolean bIsUpdate, boolean bIsDelete){
        
        //assetServices.sObjInsMAP = new MAP<string, sObject>(); // Must initialize in case of recursive call
        assetServices.sObjUpdMAP = new MAP<string, sObject>(); // Must initialize in case of recursive call
        assetServices.sObjDelMAP = new MAP<string, sObject>(); // Must initialize in case of recursive call
        assetServices.sObjInsErrMAP = new MAP<integer, string>(); // Must initialize in case of recursive call
        assetServices.sObjUpdErrMAP = new MAP<integer, string>(); // Must initialize in case of recursive call
        LIST<Asset> assetLIST = new LIST<Asset>(); // Single reference LIST variable for new or old
        MAP<ID, Asset> assetMAP = new MAP<ID, Asset>(); // Single reference MAP variable for new or old
        integer nIndex = 0;

        if (bIsDelete) {   // if delete assigning list and maps from old     
            assetLIST = triggerOldLIST;
            assetMAP = triggerOldMAP;
        } else { // keeping new copies into list and Map for all other events.
            assetLIST = triggerNewLIST;
            assetMAP = triggerNewMAP;
        } // END if (bIsDelete)

        system.debug('bPreventRecursion: ' + assetServices.bPreventRecursion + ', bIsBefore: ' + bIsBefore + ', bIsAfter: ' + bIsAfter 
            + ', bIsInsert: ' + bIsInsert + ', bIsUpdate: ' + bIsUpdate + ', bIsDelete: ' + bIsDelete);

        // ********** ACTION LOGIC **********
        Action(triggerOldLIST, triggerOldMAP, triggerNewLIST, triggerNewMAP,    
            bIsBefore, bIsAfter, bIsInsert, bIsUpdate, bIsDelete);
        
        system.debug('AAAAAAAAA action assetServices.sObjUpdMAP.values(): ' + assetServices.sObjUpdMAP.values());    
        system.debug('AAAAAAAAA action assetServices.sObjInsMAP.values(): ' + assetServices.sObjInsMAP.values());
        system.debug('AAAAAAAAA action assetServices.sObjInsMAP: ' + assetServices.sObjInsMAP);
        
        // Update Prevent Recursion booleans
        if (bIsBefore && bIsInsert) { 
            assetServices.bPreventBI = true; //Turning flags for each operation to avoid recursion. 
        } else if (bIsBefore && bIsUpdate) {
            assetServices.bPreventBU = true;
        } else if (bIsBefore && bIsDelete) {
            assetServices.bPreventBD = true;
        } else if (bIsAfter && bIsInsert) {
            assetServices.bPreventAI = true;
        } else if (bIsAfter && bIsUpdate) {
            assetServices.bPreventAU = true;
        } else if (bIsAfter && bIsDelete) {
            assetServices.bPreventAD = true;            
        } // END if (bIsBefore)
    if (bIsAfter) assetServices.bPreventRecursion = true;        

        // If we have Deletes to handle, process them here and return errors
        /* 
        system.debug('assetServices.sObjDelMAP.values(): ' + assetServices.sObjDelMAP.values());
        if (assetServices.sObjDelMAP.values().size() > 0) {
            nIndex = 0;            
            LIST<database.DeleteResult> srLIST = database.Delete(assetServices.sObjDelMAP.values(), false);
            system.debug('Delete Result LIST: ' + srLIST);
            for (database.DeleteResult srItem : srLIST) {
                if (!srItem.isSuccess()) {
                    errorMAP.put(sObjDelErrMAP.get(nIndex), srItem.getErrors()[0].getMessage());
                } // END if (!srItem.isSuccess())
                nIndex += 1;        
            } // END for (database.DeleteResult srItem : srLIST)
        } // END if (sObjDelLIST.size() > 0)
        */
        // If we have updates to handle, process them here and return errors
        system.debug('************ assetServices.sObjUpdMAP.values(): ' + assetServices.sObjUpdMAP.values());
        if (assetServices.sObjUpdMAP.values().size() > 0) {
            nIndex = 0;
            System.debug('from AssetDispatcher --- assetServices sObjUpdErrMAP ====== '+assetServices.sObjUpdErrMAP);
            LIST<database.SaveResult> srLIST = database.update(assetServices.sObjUpdMAP.values(), false);
            system.debug('Update SaveResult LIST: ' + srLIST);
            for (database.SaveResult srItem : srLIST) {
                system.debug('Update Successfully Saved: for srItem = ' + srItem);
                if (!srItem.isSuccess()) {
                    errorMAP.put(assetServices.sObjUpdErrMAP.get(nIndex), srItem.getErrors()[0].getMessage());
                    System.debug('from INSIDE if success block AssetDispatcher --- assetServices sObjUpdErrMAP ====== '+assetServices.sObjUpdErrMAP);
                    system.debug('========= from Update block Returning Error MAP to Trigger: ' + errorMAP);
                } // END if (!srItem.isSuccess())
                nIndex += 1;        
            } // END for (database.SaveResult srItem : srLIST)
            srLIST = null;
        } // END if (sObjUpdLIST.size() > 0)
        
        // If we have inserts to handle, process them here and return errors
        
        system.debug('$$$$$$$$$ Insert BLOCK AssetServices.sObjInsMAP.values(): ' + AssetServices.sObjInsMAP.values());
        system.debug('bPreventRecursion: ' + assetServices.bPreventRecursion + ', bIsBefore: ' + bIsBefore + ', bIsAfter: ' + bIsAfter 
            + ', bIsInsert: ' + bIsInsert + ', bIsUpdate: ' + bIsUpdate);
        system.debug('AssetServices.sObjInsMAP.values() SIZEEEE : ' + AssetServices.sObjInsMAP.values().size());
        system.debug('bPreventAU = ' + assetServices.bPreventAU + ' bPreventAI = ' +assetServices.bPreventAI);
        List<OMG_OmgeoProductIdentifier__c> lOProdIdentifiers1 = new List<OMG_OmgeoProductIdentifier__c>([Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId From OMG_OmgeoProductIdentifier__c where Asset__c in :AssetServices.lAssetIds AND Is_Primary__c=: true]);
        system.debug('lOProdIdentifiers1 = ' + lOProdIdentifiers1);
        if (bIsAfter && (bIsUpdate || bIsInsert) && lOProdIdentifiers1.size() == 0){
            if (AssetServices.sObjInsMAP.values().size() > 0) {
                nIndex = 0;            
                LIST<database.SaveResult> srLIST = database.insert(AssetServices.sObjInsMAP.values(), false);
                system.debug('Insert SaveResult LIST: ' + srLIST);
                for (database.SaveResult srItem : srLIST) {
                system.debug('Insert Successfully Saved: for srItem = ' + srItem);
                    if (!srItem.isSuccess()) {
                        errorMAP.put(assetServices.sObjInsErrMAP.get(nIndex), srItem.getErrors()[0].getMessage());
                        System.debug('Error map from Insert block'+errorMAP);
                    } // END if (!srItem.isSuccess())
                    nIndex += 1;        
                } // END for (database.SaveResult srItem : srLIST)
            } // END if (sObjInsLIST.size() > 0)
        }
        system.debug('Returning Error MAP to Trigger: ' + errorMAP);
        return errorMAP;
    } // END Trigger_Handler

    private static void Action(   
        LIST<Asset> triggerOldLIST, 
        MAP<ID, Asset> triggerOldMAP,
        LIST<Asset> triggerNewLIST, 
        MAP<ID, Asset> triggerNewMAP, 
        boolean bIsBefore, boolean bIsAfter, boolean bIsInsert, boolean bIsUpdate, boolean bIsDelete){

        // ACTION LOGIC
        // Handle Updates
        system.debug('ASSET DISPATCHER assetServices.bPreventAU: ' + assetServices.bPreventAU);
        system.debug('ASSET DISPATCHER assetServices.bPreventAI: ' + assetServices.bPreventAI);
        system.debug('ASSET DISPATCHER assetServices.bPreventRecursion: ' + assetServices.bPreventRecursion);
        system.debug('ASSET DISPATCHER bIsAfter : ' + bIsAfter);
        system.debug('ASSET DISPATCHER bIsUpdate: ' + bIsUpdate);
        system.debug('ASSET DISPATCHER bIsInsert : ' + bIsInsert);
        if ((!assetServices.bPreventAU || !assetServices.bPreventAI) && !assetServices.bPreventRecursion){  
            if (bIsAfter && (bIsUpdate || bIsInsert)){                  
                errorMAP.putAll(assetServices.InsertUpdate_All_Assets(  
                    triggerOldLIST, triggerNewLIST, 
                    triggerOldMAP, triggerNewMAP, 
                    bIsBefore, bIsAfter, bIsInsert, bIsUpdate, bIsDelete));
                system.debug('After executing InsertUpdate_All_Assets returned ErrorMAP: ' + errorMAP);
                errorMAP.putAll(assetServices.InsertUpdate_All_OProductIdentifiers(  
                        triggerOldLIST, triggerNewLIST, 
                        triggerOldMAP, triggerNewMAP, 
                        bIsBefore, bIsAfter, bIsInsert, bIsUpdate, bIsDelete));
                system.debug('After executing InsertUpdate_All_OProductIdentifiers returned ErrorMAP: ' + errorMAP);
            } //END if (bIsAfter && (bIsUpdate || bIsInsert))
        } // END if (!assetServices.bPreventAU || !assetServices.bPreventAI)
        
        system.debug('EEEEEEEEEEEEEE assetServices.sObjUpdMAP.values(): ' + assetServices.sObjUpdMAP.values());    
        system.debug('EEEEEEEEEEEEEE assetServices.sObjInsMAP.values(): ' + assetServices.sObjInsMAP.values());    
    } // END Action
} // END AssetDispatcher