trigger CreateCustomerDetailTrigger on Case (after insert) {
    List<DS_Customer_Details__c> customersToCreate = new List<DS_Customer_Details__c>();
    
    for(Case cs : Trigger.New){
        DS_Customer_Details__c customerObj = new DS_Customer_Details__c();
        customerObj.DS_Customer_Name__c = cs.Id;
        customerObj.First_Name__c = cs.SuppliedName;
        customerObj.Last_Name__c = cs.SuppliedName;
        customerObj.Email__c = cs.ContactEmail;
        customerObj.Phone__c = cs.ContactMobile;
        customersToCreate.add(customerObj);
    }
    if(!customersToCreate.isEmpty()){
        insert customersToCreate; 
    }

}