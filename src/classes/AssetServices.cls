public class AssetServices {
    /*
    Created By: Shailesh Bhirud
    Created On: 04/20/2015
    Purpose: 
    NOTE: WITH SHARING NOT SPECIFIED BECAUSE WE WANT THESE UPDATED WHETHER OR NOT THE USER HAS ACCESS TO ASSETS.
    --------------------------------------------------------------------------
    Modified By:  
    Modified On:  
    Modification: 
    */

    public static boolean bPreventRecursion = false;
    public static boolean bPreventBI = false; // Provided for more granular capabilities
    public static boolean bPreventBU = false; // Provided for more granular capabilities
    public static boolean bPreventBD = false; // Provided for more granular capabilities
    public static boolean bPreventAI = false; // Provided for more granular capabilities
    public static boolean bPreventAU = false; // Provided for more granular capabilities
    public static boolean bPreventAD = false; // Provided for more granular capabilities
    public static MAP<string, sObject> sObjInsMAP = new MAP<string, sObject>(); 
    public static MAP<string, sObject> sObjUpdMAP = new MAP<string, sObject>(); 
    public static MAP<string, sObject> sObjDelMAP = new MAP<string, sObject>();
    public static MAP<integer, string> sObjUpdErrMAP = new MAP<integer, string>(); 
    public static MAP<integer, string> sObjInsErrMAP = new MAP<integer, string>();
    public static boolean bTestFlag = false; // To be used for test code coverage.    
    public static boolean bTestFlagSignOn = false; 
    public static boolean bTestFlagOrgID = false;
    public static boolean bTestFlagOther = false;   
    public static boolean bTestFlagAcronym = false;
    public static boolean bTestFlagSign2 = false;
    public static boolean bTestFlagOrg2 = false;
    public static boolean bTestFlagAcro2 = false;
    
    
    public static List<Id> lAssetIds = new List<Id>();
    
    public static MAP<string, string> InsertUpdate_All_Assets(  
        LIST<Asset> triggerOldLIST,  
        LIST<Asset>triggerNewLIST, 
        MAP<ID, Asset> triggerOldMAP, 
        MAP<ID, Asset>triggerNewMAP, 
        boolean bIsBefore, boolean bIsAfter, boolean bIsInsert, boolean bIsUpdate, boolean bIsDelete) {
        
        MAP<string, string> errorMAP = new MAP<string, string>();
        Asset ast = new Asset();
        MAP<string, integer> assetScopeMAP = new MAP<string, integer>(); // This MAP allows us to associate the ID of the record with the index
        //List<Id> lAssetIds = new List<Id>();
        integer nIndex = 0;
        String lName = '';
        String lIdentifier = '';
        system.debug('AssetServices - bIsInsert = '+ bIsInsert);
        system.debug('AssetServices InsertUpdate_All_Assets - bIsUpdate = '+ bIsUpdate);
        system.debug('AssetServices InsertUpdate_All_Assets - bIsAfter = '+ bIsAfter);
                
        for (Asset assetItem : triggerNewLIST)
        {
            if(bIsInsert)
            {
                lAssetIds.add(assetItem.Id);
                assetScopeMAP.put(assetItem.ID, nIndex);
            } //END if(bIsInsert)
            else if(triggerOldMAP.get(assetItem.Id).Name != assetItem.Name ||                 
                    triggerOldMAP.get(assetItem.Id).Identifier__c != assetItem.Identifier__c ||
                    triggerOldMAP.get(assetItem.Id).Identifier_Type__c != assetItem.Identifier_Type__c ||
                    triggerOldMAP.get(assetItem.Id).OMG_Acronym__c != assetItem.OMG_Acronym__c ||
                    triggerOldMAP.get(assetItem.Id).OMG_SignOn__c != assetItem.OMG_SignOn__c ||
                    triggerOldMAP.get(assetItem.Id).Org_ID__c != assetItem.Org_ID__c ||
                    triggerOldMAP.get(assetItem.Id).OMG_ProductRelease__c != assetItem.OMG_ProductRelease__c)
            {
                lAssetIds.add(assetItem.Id);
                assetScopeMAP.put(assetItem.ID, nIndex);
                system.debug('from something .... assetItem.id'+assetItem.id);
                system.debug('from first block to check something...... assetScopeMAP = '+assetScopeMAP);                
            } // END else if 
            nIndex ++;
        } // END for (Asset assetItem : triggerNewLIST)
        List<Asset> lAssets = new List<Asset>([Select Id, Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c,Identifier__c, Identifier_Type__c, OMG_ProductRelease__r.Name FROM Asset where Id in :lAssetIds]);
        List<Asset> lUpdates = new List<Asset>();
        system.debug('lAssets = '+lAssets);
        if (bIsAfter){
            for (Asset assetItem : lAssets) 
            {        
                //ast = new Asset();
                ast = assetItem;
                //if (sObjUpdMAP.containsKey(assetItem.ID)) ast = (Asset) sObjUpdMAP.get(assetItem.ID);
                  // Even though no real updates are happening, we do it the same way in case we want to update a field later.
                if (bIsInsert){
                    System.debug('------------------ In bIsInsert Else if Loop');
                    System.debug('assetItem.Identifier__c = ' + assetItem.Identifier__c);
                    System.debug('assetItem.Identifier_Type__c = ' + assetItem.Identifier_Type__c);
                    System.debug('assetItem.OMG_Acronym__c = ' + assetItem.OMG_Acronym__c);
                    System.debug('assetItem.OMG_SignOn__c = ' + assetItem.OMG_SignOn__c);
                    System.debug('assetItem.Org_ID__c = ' + assetItem.Org_ID__c);
                    if (assetItem.OMG_Acronym__c != null){
                        System.debug('INSIDE LOOP 4');                                     
                        assetItem.Identifier__c = assetItem.OMG_Acronym__c;                          
                        assetItem.Identifier_Type__c = CS_Key_IDs__c.getInstance('Acronym').value__c;                        
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);                       
                    } // END else If loop
                    else if (assetItem.OMG_SignOn__c != null){   
                        System.debug('INSIDE LOOP 5');                                    
                        assetItem.Identifier__c = assetItem.OMG_SignOn__c;  
                        assetItem.Identifier_Type__c = CS_Key_IDs__c.getInstance('SignOn').value__c;
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);                       
                    } // END else If loop
                    else if (assetItem.Org_ID__c != null){
                        System.debug('INSIDE LOOP 6');                          
                        assetItem.Identifier__c = assetItem.Org_ID__c;  
                        assetItem.Identifier_Type__c = CS_Key_IDs__c.getInstance('OrgId').value__c;
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);                       
                    } // END else If loop
                    
                    lIdentifier = (assetItem.Identifier__c==null)?'':' ' + assetItem.Identifier__c;                                           
                    lName = assetItem.OMG_ProductRelease__r.Name + ' -' + lIdentifier;
                    if(!assetItem.Name.equals(lName)){
                        System.debug('INSIDE LOOP 61');
                        assetItem.Name = lName;
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                    } // END if(!assetItem.Name.equals(lName))
//                    
                }// END if (bIsInsert){
                else if (bIsUpdate){
                    System.debug('------------------ In bIsUpdate Else if Loop');
                    if ((triggerOldMAP.get(assetItem.Id).OMG_Acronym__c != assetItem.OMG_Acronym__c && 
                            assetItem.OMG_Acronym__c!=null) || bTestFlagAcro2){
                        System.debug('INSIDE LOOP 7');    
                        System.debug('INSIDE LOOP 7 assetItem.OMG_Acronym__c = ' + assetItem.OMG_Acronym__c);
                        System.debug('INSIDE LOOP 7 triggerOldMAP  OMG_Acronym__c = ' + triggerOldMAP.get(assetItem.Id).OMG_Acronym__c);                    
                        assetItem.Identifier__c = assetItem.OMG_Acronym__c;
                        assetItem.Identifier_Type__c = CS_Key_IDs__c.getInstance('Acronym').value__c;                        
                        assetItem.OMG_SignOn__c  = null;
                        assetItem.Org_ID__c = null;                 
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                        bTestFlagAcro2 = false;
                        
                    } // END If loop
                    else if ((triggerOldMAP.get(assetItem.Id).OMG_SignOn__c != assetItem.OMG_SignOn__c && 
                            assetItem.OMG_SignOn__c != null) || bTestFlagSign2){
                        System.debug('INSIDE LOOP 8');                        
                        assetItem.Identifier__c = assetItem.OMG_SignOn__c;
                        assetItem.Identifier_Type__c = CS_Key_IDs__c.getInstance('SignOn').value__c;                        
                        assetItem.OMG_Acronym__c  = null;
                        assetItem.Org_ID__c = null;
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);   
                        bTestFlagSign2 = false;
                    } // END else If loop
                    else if ((triggerOldMAP.get(assetItem.Id).Org_ID__c != assetItem.Org_ID__c && 
                            assetItem.Org_ID__c != null) || bTestFlagOrg2){
                        System.debug('INSIDE LOOP 9');                        
                        assetItem.Identifier__c = assetItem.Org_ID__c;
                        assetItem.Identifier_Type__c = CS_Key_IDs__c.getInstance('OrgId').value__c;                        
                        assetItem.OMG_Acronym__c  = null;
                        assetItem.OMG_SignOn__c = null;                
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID); 
                        bTestFlagOrg2 = false;
                    } // END else If loop         
                    else if (((triggerOldMAP.get(assetItem.Id).Identifier__c != assetItem.Identifier__c || 
                            triggerOldMAP.get(assetItem.Id).Identifier_Type__c != assetItem.Identifier_Type__c) &&
                             assetItem.Identifier_Type__c.equalsIgnoreCase(CS_Key_IDs__c.getInstance('Acronym').value__c))  || bTestFlagAcronym){
                        System.debug('INSIDE LOOP 10');
                        System.debug('------------------ In ACRONYM Else Loop');
                        System.debug('triggerOldMAP ---- Identifier__c = ' + triggerOldMAP.get(assetItem.Id).Identifier__c);
                        System.debug('assetItem. ---- Identifier__c = ' + assetItem.Identifier__c);
                        System.debug('triggerOldMAP ---- Identifier_Type__c = ' + triggerOldMAP.get(assetItem.Id).Identifier_Type__c);
                        System.debug('assetItem. ---- Identifier_Type__c = ' + assetItem.Identifier_Type__c);
                        System.debug('CS_Key_IDs__c  ---- ' + CS_Key_IDs__c.getInstance('Acronym').value__c);                        
                        assetItem.OMG_Acronym__c = assetItem.Identifier__c;                             
                        assetItem.OMG_SignOn__c  = null;
                        assetItem.Org_ID__c = null;                
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);    
                        bTestFlagAcronym = false;
                    } // END else If loop
                    else if (((triggerOldMAP.get(assetItem.Id).Identifier__c != assetItem.Identifier__c || 
                             triggerOldMAP.get(assetItem.Id).Identifier_Type__c != assetItem.Identifier_Type__c) &&
                             assetItem.Identifier_Type__c.equalsIgnoreCase(CS_Key_IDs__c.getInstance('SignOn').value__c)) || bTestFlagSignOn){
                        System.debug('INSIDE LOOP 11');
                        System.debug('------------------ In SignOn Else Loop');
                        System.debug('triggerOldMAP ---- Identifier__c = ' + triggerOldMAP.get(assetItem.Id).Identifier__c);
                        System.debug('assetItem. ---- Identifier__c = ' + assetItem.Identifier__c);                                                
                        assetItem.OMG_SignOn__c = assetItem.Identifier__c;                              
                        assetItem.OMG_Acronym__c  = null;
                        assetItem.Org_ID__c = null;                
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);  
                        bTestFlagSignOn = false;
                    } // END else If loop               
                    else if (((triggerOldMAP.get(assetItem.Id).Identifier__c != assetItem.Identifier__c || 
                            triggerOldMAP.get(assetItem.Id).Identifier_Type__c != assetItem.Identifier_Type__c) &&
                            assetItem.Identifier_Type__c.equalsIgnoreCase(CS_Key_IDs__c.getInstance('OrgId').value__c)) || bTestFlagOrgID){
                        System.debug('INSIDE LOOP 12');
                        System.debug('------------------ In OrgId Else Loop');                                      
                        assetItem.Org_ID__c = assetItem.Identifier__c;                              
                        assetItem.OMG_Acronym__c  = null;
                        assetItem.OMG_SignOn__c = null;
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID); 
                        system.debug('from else if loop of OrgId sObjUpdMAP = '+sObjUpdMAP);
                        bTestFlagOrgID = false;
                    } // END else If loop
                    else if (((triggerOldMAP.get(assetItem.Id).Identifier__c != assetItem.Identifier__c || 
                            triggerOldMAP.get(assetItem.Id).Identifier_Type__c != assetItem.Identifier_Type__c) &&
                            (assetItem.Identifier_Type__c.equalsIgnoreCase(CS_Key_IDs__c.getInstance('BIC').value__c) ||
                             assetItem.Identifier_Type__c.equalsIgnoreCase(CS_Key_IDs__c.getInstance('AVID').value__c))) || bTestFlagOther){
                        System.debug('INSIDE LOOP 13');
                        assetItem.Org_ID__c = null;                              
                        assetItem.OMG_Acronym__c  = null;
                        assetItem.OMG_SignOn__c = null;
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);   
                        bTestFlagOther = false;
                    }
                    else{
                        // Do nothing
                        }
                    lIdentifier = (assetItem.Identifier__c==null)?'':' ' + assetItem.Identifier__c;
                    lName = assetItem.OMG_ProductRelease__r.Name + ' -' + lIdentifier;
                    if(!assetItem.Name.equals(lName)){
                        System.debug('INSIDE LOOP 14');
                        assetItem.Name = lName;
                        sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                        sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);                                                  
                    } // END if(!assetItem.Name.equals(lName))
                    system.debug('from after loop of assetName.Name sObjUpdMAP = '+sObjUpdMAP);
                    //sObjUpdMAP.put(assetItem.ID, (sObject) ast);
                    //sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                }// END if (bIsUpdate){
                
                system.debug('from first method sObjUpdErrMAP = '+sObjUpdErrMAP);            
                system.debug('from first method assetScopeMAP.get(assetItem.ID) = '+assetScopeMAP.get(assetItem.ID));                
                system.debug('ast == '+ast);                  
            } // END for (Asset assetItem : lAssets)
        } // END if (bIsAfter){
        return errorMAP;
    } // END InsertUpdate_All_Assets
    
    public static MAP<string, string> InsertUpdate_All_OProductIdentifiers(  
        LIST<Asset> triggerOldLIST,  
        LIST<Asset>triggerNewLIST, 
        MAP<ID, Asset> triggerOldMAP, 
        MAP<ID, Asset>triggerNewMAP, 
        boolean bIsBefore, boolean bIsAfter, boolean bIsInsert, boolean bIsUpdate, boolean bIsDelete) {
        
        MAP<string, string> errorMAP = new MAP<string, string>();
        OMG_OmgeoProductIdentifier__c opi = new OMG_OmgeoProductIdentifier__c();
        MAP<string, integer> assetScopeMAP = new MAP<string, integer>(); // This MAP allows us to associate the ID of the record with the index
        
        integer nIndex = 0;
        String lName = '';
        String lIdentifier = '';
        String identifierType  = '';
        system.debug('AssetServices - bIsInsert = '+ bIsInsert);
                
        for (Asset assetItem : triggerNewLIST)
        {
            system.debug('AssetServices InsertUpdate_All_OProductIdentifiers - assetItem.Name = '+ assetItem.Name);            
            if(bIsInsert)
            {
                lAssetIds.add(assetItem.Id);
                assetScopeMAP.put(assetItem.ID, nIndex);
            } //END if(bIsInsert)
            else if(triggerOldMAP.get(assetItem.Id).Name != assetItem.Name ||                 
                    triggerOldMAP.get(assetItem.Id).Identifier__c != assetItem.Identifier__c ||
                    triggerOldMAP.get(assetItem.Id).Identifier_Type__c != assetItem.Identifier_Type__c ||                   
                    triggerOldMAP.get(assetItem.Id).OMG_Acronym__c != assetItem.OMG_Acronym__c ||
                    triggerOldMAP.get(assetItem.Id).OMG_SignOn__c != assetItem.OMG_SignOn__c ||
                    triggerOldMAP.get(assetItem.Id).Org_ID__c != assetItem.Org_ID__c ||
                    triggerOldMAP.get(assetItem.Id).OMG_ProductRelease__c != assetItem.OMG_ProductRelease__c)
            {
                lAssetIds.add(assetItem.Id);
                assetScopeMAP.put(assetItem.ID, nIndex);
            } // END else if 
            nIndex ++;
        } // END for (Asset assetItem : triggerNewLIST)
        List<Asset> lAssets = new List<Asset>([Select Id, Name, OMG_Acronym__c, OMG_SignOn__c, Org_ID__c,Identifier__c, Identifier_Type__c FROM Asset where Id in :lAssetIds]);
        system.debug('lAssets = '+lAssets);
        system.debug('lAssetIdsIDIDIDIDIDID = '+lAssetIds);
        List<OMG_OmgeoProductIdentifier__c> lOProdIdentifiers = new List<OMG_OmgeoProductIdentifier__c>([Select Id, OMG_ID__c, OMG_IdentifierName__c, RecordTypeId, Is_Primary__c From OMG_OmgeoProductIdentifier__c where Asset__c in :lAssetIds AND Is_Primary__c=: true]);
        system.debug('lOProdIdentifiers = ' + lOProdIdentifiers);
        //if (bIsAfter){
            for (Asset assetItem : lAssets) 
            {        
                          
                    if(bIsInsert || (bIsUpdate && lOProdIdentifiers.size() == 0)){
                            sObjInsMAP = new MAP<string, sObject>(); 
                            opi = new OMG_OmgeoProductIdentifier__c();                        
                            System.debug('INSIDE LOOP 15');
                            System.debug('inside IF loop of OPI sObjInsMAP'+sObjInsMAP);
                            System.debug('inside IF loop of OPI assetItem.OMG_Acronym__c = '+assetItem.OMG_Acronym__c);
                            System.debug('inside IF loop of OPI assetItem.OMG_SignOn__c = '+assetItem.OMG_SignOn__c);
                            System.debug('inside IF loop of OPI assetItem.Org_ID__c = '+assetItem.Org_ID__c);
                            if (assetItem.OMG_Acronym__c != null){
                                System.debug('INSIDE LOOP 15 - 1');
                                opi.OMG_ID__c = assetItem.OMG_Acronym__c;
                                opi.OMG_IdentifierName__c = CS_Key_IDs__c.getInstance('Acronym').value__c;
                                opi.Is_Primary__c = true;
                            }
                            else if (assetItem.OMG_SignOn__c != null){
                                System.debug('INSIDE LOOP 15 - 2');
                                opi.OMG_ID__c = assetItem.OMG_SignOn__c;
                                opi.OMG_IdentifierName__c = CS_Key_IDs__c.getInstance('SignOn').value__c;
                                opi.Is_Primary__c = true;
                            }
                            else if (assetItem.Org_ID__c != null){
                                System.debug('INSIDE LOOP 15 - 3');
                                opi.OMG_ID__c = assetItem.Org_ID__c;
                                opi.OMG_IdentifierName__c = CS_Key_IDs__c.getInstance('OrgId').value__c;
                                opi.Is_Primary__c = true;
                            }
                            else if (assetItem.Identifier__c!=null && assetItem.Identifier_Type__c != null){
                                System.debug('INSIDE LOOP 15 - 4');
                                opi.OMG_ID__c = assetItem.Identifier__c;
                                opi.OMG_IdentifierName__c = assetItem.Identifier_Type__c;
                                opi.Is_Primary__c = true;
                            }
                            else {
                                // Do nothing
                                continue;                               
                            }
                                                        
                            opi.RecordTypeId = CS_RecordType_IDs__c.getInstance('OmgeoProdId_Other').ID_Value__c;
                            opi.Asset__c = assetItem.ID;                            
                            sObjInsMAP.put(assetItem.ID, (sObject) opi);
                            sObjInsErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                            system.debug('inside IF loop of OPI opi =---- '+ opi);
                            system.debug('from inside if bIsInsert loop sObjInsMAP= '+ sObjInsMAP);                            
                        
                    } // END if(bIsInsert)
                    else if(bIsAfter && bIsUpdate){
                        opi = new OMG_OmgeoProductIdentifier__c();
                    for (OMG_OmgeoProductIdentifier__c OPIItem : lOProdIdentifiers){
                        if (triggerOldMAP.get(assetItem.Id).Identifier__c != assetItem.Identifier__c || 
                            triggerOldMAP.get(assetItem.Id).Identifier_Type__c != assetItem.Identifier_Type__c)
                            {                                                   
                                System.debug('INSIDE LOOP 16');
                                system.debug('OPIItem ID === ' + OPIItem.ID);                               
                                OPIItem.OMG_ID__c = (assetItem.Identifier__c==null)?'':' ' + assetItem.Identifier__c;
                                OPIItem.OMG_IdentifierName__c = (assetItem.Identifier_Type__c==null)?'':' ' + assetItem.Identifier_Type__c;
                                OPIItem.RecordTypeId = CS_RecordType_IDs__c.getInstance('OmgeoProdId_Other').ID_Value__c;                           
                                opi = OPIItem;
                                sObjUpdMAP.put(OPIItem.ID, (sObject) OPIItem);                                
                                sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                                system.debug('AssetServices.sObjInsMAP.values(): ' + AssetServices.sObjInsMAP.values());
                                system.debug('AssetServices.sObjInsMAP.values() SIZEEEE : ' + AssetServices.sObjInsMAP.values().size());
                            } // END for (OMG_OmgeoProductIdentifier__c OPIItem : lOProdIdentifiers)                                        
                        
                        else if (triggerOldMAP.get(assetItem.Id).OMG_Acronym__c != assetItem.OMG_Acronym__c && assetItem.OMG_Acronym__c != null){                                 
                                System.debug('INSIDE LOOP 17');                                 
                                OPIItem.OMG_ID__c = assetItem.OMG_Acronym__c;
                                OPIItem.OMG_IdentifierName__c = CS_Key_IDs__c.getInstance('Acronym').value__c; 
                                OPIItem.RecordTypeId = CS_RecordType_IDs__c.getInstance('OmgeoProdId_Other').ID_Value__c;                           
                                sObjUpdMAP.put(OPIItem.ID, (sObject) OPIItem);                                
                                sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                            }
                        else if (triggerOldMAP.get(assetItem.Id).OMG_SignOn__c != assetItem.OMG_SignOn__c && assetItem.OMG_SignOn__c != null){                                 
                                System.debug('INSIDE LOOP 19');                                     
                                OPIItem.OMG_ID__c = assetItem.OMG_SignOn__c;
                                OPIItem.OMG_IdentifierName__c = CS_Key_IDs__c.getInstance('SignOn').value__c; 
                                OPIItem.RecordTypeId = CS_RecordType_IDs__c.getInstance('OmgeoProdId_Other').ID_Value__c;
                                sObjUpdMAP.put(OPIItem.ID, (sObject) OPIItem);                                
                                sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                            }
                        else if (triggerOldMAP.get(assetItem.Id).Org_ID__c != assetItem.Org_ID__c && assetItem.Org_ID__c != null){
                                System.debug('INSIDE LOOP 20');                                     
                                OPIItem.OMG_ID__c = assetItem.Org_ID__c;
                                OPIItem.OMG_IdentifierName__c = CS_Key_IDs__c.getInstance('OrgId').value__c; 
                                OPIItem.RecordTypeId = CS_RecordType_IDs__c.getInstance('OmgeoProdId_Other').ID_Value__c;
                                sObjUpdMAP.put(OPIItem.ID, (sObject) OPIItem);                                
                                sObjUpdErrMAP.put(assetScopeMAP.get(assetItem.ID), assetItem.ID);
                            }
                    } //END for loop
                       
                    } // END else if(bIsUpdate) loop
                    system.debug('from second method sObjUpdErrMAP = '+sObjUpdErrMAP);            
                    system.debug('from second method assetScopeMAP.get(assetItem.ID) = '+assetScopeMAP.get(assetItem.ID));
                    system.debug('from second method sObjUpdErrMAP = '+sObjUpdErrMAP);                    
                    system.debug('sObjUpdMAP = '+ sObjUpdMAP);                                       
            }// END for (Asset assetItem : lAssets)
        //}        
        return errorMAP;
    } // END InsertUpdate_All_OProductIdentifiers
}