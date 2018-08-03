public class JMFETaskCreationUtilty{
    static Integer MONTHLY_DAYS=30;
    static Integer QUARTERLY_DAYS=90;
    static Integer SEMI_ANNUAL_DAYS=180;
    static Integer ANNUAL_DAYS=180;
    
    public static Boolean createJMFETasks(List<Account> accList){
        List<Task> tasksToInsert = new List<Task>();
    
        for(Account acc : accList){
            if(acc.JMFE_Coverage__c!= null && String.isNotBlank(acc.JMFE_Contact_Frequency__c) && acc.JMFE_Contact_Frequency__c!='None'){
                Task callTask = new Task();
                callTask.Subject = 'Call';
                callTask.Type='Call';
                callTask.WhatId=acc.Id;
                callTask.IsJMFETask__c = true;
                if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Monthly')){
                    callTask.ActivityDate = Date.valueOf(acc.createddate.addDays(MONTHLY_DAYS));
                }else if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Quarterly')){
                    callTask.ActivityDate = Date.valueOf(acc.createddate.addDays(QUARTERLY_DAYS));
                }else if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Semi-Annually')){
                    callTask.ActivityDate = Date.valueOf(acc.createddate.addDays(SEMI_ANNUAL_DAYS));
                }else if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Annually')){
                    callTask.ActivityDate = Date.valueOf(acc.createddate.addDays(ANNUAL_DAYS));
                }
                callTask.OwnerId = acc.JMFE_Coverage__c;
                tasksToInsert.add(callTask);
                
                Task onsiteTask = new Task();
                onsiteTask.Subject = 'Onsite';
                onsiteTask.Type='Onsite';
                onsiteTask.WhatId=acc.Id;
                onsiteTask.ActivityDate = Date.valueOf(acc.createddate.addyears(1));
                onsiteTask.OwnerId = acc.JMFE_Coverage__c;
                onsiteTask.IsJMFETask__c = true;
                tasksToInsert.add(onsiteTask);
                
            }
        }
        if(!tasksToInsert.isEmpty()){
            insert tasksToInsert;
            return true;
        }
        return false;
    }
    
    public static Boolean createJMFEFollowupTasks(Map<Id,Account> accountMap,List<Task> tasksToProcess){
        List<Task> listToInsert = new List<task>();
        for(Task tObj : tasksToProcess){
            Account acc = accountMap.get(tObj.WhatId);
            Task newTask = new Task();
            newTask.Subject = tObj.Subject;
            newTask.Type=tObj.Type;
            newTask.WhatId=tObj.WhatId;
            newTask.IsJMFETask__c = true;
            if(tObj.Type=='Call'){
                if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Monthly')){
                    newTask.ActivityDate = Date.valueOf(tObj.createddate.addDays(MONTHLY_DAYS));
                }else if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Quarterly')){
                    newTask.ActivityDate = Date.valueOf(tObj.createddate.addDays(QUARTERLY_DAYS));
                }else if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Semi-Annually')){
                    newTask.ActivityDate = Date.valueOf(tObj.createddate.addDays(SEMI_ANNUAL_DAYS));
                }else if(acc.JMFE_Contact_Frequency__c.equalsIgnoreCase('Annually')){
                    newTask.ActivityDate = Date.valueOf(tObj.createddate.addDays(ANNUAL_DAYS));
                }
            }else if(tObj.Type == 'Onsite'){
                newTask.ActivityDate = Date.valueOf(tObj.createddate.addyears(1));
            }
            newTask.OwnerId = acc.JMFE_Coverage__c;
            listToInsert.add(newTask);
        }
        if(!listToInsert.isEmpty()){
            insert listToInsert;
            return true;
        }
        return false;
        
    }
}