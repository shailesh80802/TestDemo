trigger AssetTrigger on Asset 
    (after delete, after insert, after update, 
    before delete, before insert, before update) {
    /*
    Created By: Shailesh Bhirud
    Created On: 04/20/2015
    Purpose: Trigger Code using EDA pattern.
    --------------------------------------------------------------------------
    Modified By:    
    Modified On:  
    Modification: 
    */
    
    // The below is used to determine if we should bypass this trigger for
    CS_Key_IDs__c fireTrigger = CS_Key_IDs__c.getInstance('AssetTrigger');
    //system.debug('AssetTrigger - fireTrigger = '+ fireTrigger);
    if (fireTrigger == null || fireTrigger.Flag__c == null || !fireTrigger.Flag__c.equalsIgnoreCase('Disable')) { // using custom settings to run the trigger or not.flag on trigger executes,else it wont. 
      MAP<string, string>dispatcherMAP = new MAP<string, string>();
      if (trigger.isDelete){
          system.debug('TRIGGER: IsUpdate - ' + trigger.isUpdate + ', IsInsert - ' + trigger.isInsert + ', IsDelete - ' 
            + trigger.isDelete + ', IsUndelete - ' + trigger.isUndelete + ', Size: ' + trigger.old.size());
          dispatcherMAP = AssetDispatcher.Trigger_Handler(//supplying old and oldMap as Delete wont have new and sending events, only trigger.isDelete would be TRUE and rest are false
            trigger.old, trigger.oldMap, 
            null, null, 
            trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isDelete);
      } else if (trigger.isInsert || trigger.isUnDelete) {//supplying new and newMap as Insert wont have old and sending events, only trigger.isInsert and trigger.isUndelete would be TRUE and rest are false
          system.debug('TRIGGER: IsUpdate - ' + trigger.isUpdate + ', IsInsert - ' + trigger.isInsert + ', IsDelete - ' 
            + trigger.isDelete + ', IsUndelete - ' + trigger.isUndelete + ', IsAfter - ' + trigger.isAfter + ', IsBefore - ' + trigger.isBefore + ', Size: ' + trigger.new.size());
          dispatcherMAP = AssetDispatcher.Trigger_Handler(
            null, null, 
            trigger.new, trigger.newMap, 
            trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isDelete);
      } else { // supplying both new and old as Update would have both copies and sending all flags, only update what ever event has it TRUE.
          system.debug('TRIGGER: IsUpdate - ' + trigger.isUpdate + ', IsInsert - ' + trigger.isInsert + ', IsDelete - ' 
            + trigger.isDelete + ', IsUndelete - ' + trigger.isUndelete + ', IsAfter - ' + trigger.isAfter + ', IsBefore - ' + trigger.isBefore + ', Size: ' + trigger.new.size());
          dispatcherMAP = AssetDispatcher.Trigger_Handler(
            trigger.old, trigger.oldMap, 
            trigger.new, trigger.newMap, 
            trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isDelete);
      } // end if (trigger.isDelete) 
    system.debug('Errors returned: dispatcherMAP = ' + dispatcherMAP);
  
      integer nIndex = 0;  //
      if(dispatcherMAP != null && dispatcherMAP.size() > 0){
      for (string strErrorID: dispatcherMAP.keySet()) {
          system.debug('From AssetTrigger line no. 44 = strErrorID' + strErrorID);
          if (strErrorID.isNumeric()) {

              nIndex = integer.valueOf(strErrorID);
              Trigger.new[nIndex].addError(dispatcherMAP.get(strErrorID));
          } else {
              if (trigger.isDelete) {
                  Trigger.oldMap.get(strErrorID).addError(dispatcherMAP.get(strErrorID));
              } // END if(trigger.isDelete)
              else {
                Trigger.newMap.get(strErrorID).addError(dispatcherMAP.get(strErrorID));
              } // END else
          } // END if (strErrorID.isNumeric())
          nIndex ++;
      } // END for (string strErrorID : dispatcherMAP.keySet()) 
      }
    } // END if (fireTrigger == null || fireTrigger.Flag__c == null || !fireTrigger.Flag__c.equalsIgnoreCase('Disable'))
    
} // END AssetTrigger