trigger CreateFollowupTaskJMFE on Task (after update) {

    List<Task> tasksToProcess = new List<Task>();
//    List<task> tasksToProcess
    Set<id> accIds = new Set<Id>();
    for(Task tObj : Trigger.new){
        if(tObj.Status=='Completed' && tObj.IsJMFETask__c){
            //as this task is created from Account WhatId is of Account only
            accIds.add(tObj.WhatId);
            tasksToProcess.add(tObj);
        }
    }
    
    if(!accIds.isEmpty()){
        Map<Id,Account> accountToProcess = new Map<Id,Account>([SELECT Id,Name,JMFE_Coverage__c,JMFE_Contact_Frequency__c,CreatedDate FROM Account WHERE id IN :accIds]);
        JMFETaskCreationUtilty.createJMFEFollowupTasks(accountToProcess,tasksToProcess);
    }

}