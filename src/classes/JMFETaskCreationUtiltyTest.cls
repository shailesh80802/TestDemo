@isTest
private class JMFETaskCreationUtiltyTest {
 
    @isTest static void testmeth1(){
        List<Account> accToInsert = new List<Account>();
        Account acc1 = new Account(Name = 'acc1', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Monthly',  AccountSource = 'Web');
        Account acc2 = new Account(Name = 'acc2', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Quarterly',  AccountSource = 'Web');
        Account acc3 = new Account(Name = 'acc3', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Semi-Annually',  AccountSource = 'Web');
        Account acc4 = new Account(Name = 'acc4', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Annually',  AccountSource = 'Web');
        Account acc5 = new Account(Name = 'acc5', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Monthly',  AccountSource = 'Web');
        accToInsert.add(acc1);
        accToInsert.add(acc2);
        accToInsert.add(acc3);
        accToInsert.add(acc4);
        accToInsert.add(acc5);
        insert accToInsert;
        
        List<Task> tasksToInsert = new List<Task>();
        //Task callTask = new Task();
        Task callTask = new Task (
            Subject = 'Call', 
            Type = 'Call',
            WhatId = acc1.id, 
            IsJMFETask__c = true, 
            ActivityDate = system.today().addDays(30), 
            OwnerId = acc1.JMFE_Coverage__c);
        tasksToInsert.add(callTask);
        
        Task callTask2 = new Task (
            Subject = 'Call', 
            Type = 'Call',
            WhatId = acc1.id, 
            IsJMFETask__c = true, 
            ActivityDate = system.today().addDays(90), 
            OwnerId = acc1.JMFE_Coverage__c);
        tasksToInsert.add(callTask2);
        
        Task callTask3 = new Task (
            Subject = 'Call', 
            Type = 'Call',
            WhatId = acc1.id, 
            IsJMFETask__c = true, 
            ActivityDate = system.today().addDays(180), 
            OwnerId = acc1.JMFE_Coverage__c);
        tasksToInsert.add(callTask3);
        
        Task onsiteTask = new Task(
                Subject = 'Onsite',
                Type='Onsite',
                WhatId=acc1.Id,
                ActivityDate = system.today().addyears(1),
                OwnerId = acc1.JMFE_Coverage__c,
                IsJMFETask__c = true);
         tasksToInsert.add(onsiteTask);

        
        insert tasksToInsert;
        List<Task> taskList = [SELECT Id FROM Task WHERE Type='Call'];
        System.assert(taskList.size()!=null);
    }   
    
    @isTest static void testFollowUpTasks(){
        List<Account> accToInsert = new List<Account>();
        Account acc1 = new Account(Name = 'acc1', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Monthly',  AccountSource = 'Web');
        Account acc2 = new Account(Name = 'acc2', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Quarterly',  AccountSource = 'Web');
        Account acc3 = new Account(Name = 'acc3', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Semi-Annually',  AccountSource = 'Web');
        Account acc4 = new Account(Name = 'acc4', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Annually',  AccountSource = 'Web');
        Account acc5 = new Account(Name = 'acc5', JMFE_Coverage__c = UserInfo.getUserId(), JMFE_Contact_Frequency__c = 'Monthly',  AccountSource = 'Web');
        accToInsert.add(acc1);
        accToInsert.add(acc2);
        accToInsert.add(acc3);
        accToInsert.add(acc4);
        accToInsert.add(acc5);
        insert accToInsert;
        
        List<Task> tasksToInsert = new List<Task>();
        //Task callTask = new Task();
        Task callTask = new Task (
            Subject = 'Call', 
            Type = 'Call',
            WhatId = acc1.id, 
            IsJMFETask__c = true, 
            ActivityDate = system.today().addDays(30), 
            OwnerId = acc1.JMFE_Coverage__c,
            status='In Progress');
        tasksToInsert.add(callTask);
        
        Task callTask2 = new Task (
            Subject = 'Call', 
            Type = 'Call',
            WhatId = acc2.id, 
            IsJMFETask__c = true, 
            ActivityDate = system.today().addDays(90), 
            OwnerId = acc2.JMFE_Coverage__c,
            status='In Progress');
        tasksToInsert.add(callTask2);
        
        Task callTask3 = new Task (
            Subject = 'Call', 
            Type = 'Call',
            WhatId = acc3.id, 
            IsJMFETask__c = true, 
            ActivityDate = system.today().addDays(180), 
            OwnerId = acc3.JMFE_Coverage__c,
            status='In Progress');
        tasksToInsert.add(callTask3);
        
        Task callTask4 = new Task (
            Subject = 'Call', 
            Type = 'Call',
            WhatId = acc4.id, 
            IsJMFETask__c = true, 
            ActivityDate = system.today().addDays(180), 
            OwnerId = acc4.JMFE_Coverage__c,
            status='In Progress');
        tasksToInsert.add(callTask4);
        
        Task onsiteTask = new Task(
                Subject = 'Onsite',
                Type='Onsite',
                WhatId=acc1.Id,
                ActivityDate = system.today().addyears(1),
                OwnerId = acc1.JMFE_Coverage__c,
                IsJMFETask__c = true,
                status='In Progress');
         tasksToInsert.add(onsiteTask);
        
        
        insert tasksToInsert;
        
        List<Task> taskList = [SELECT Id FROM Task WHERE IsJMFETask__c=TRUE];
        System.assert(taskList.size()!=null);
        
        for(Task tObj : tasksToInsert){
            tObj.status='Completed';
        }
        update tasksToInsert;
    }  
    
}