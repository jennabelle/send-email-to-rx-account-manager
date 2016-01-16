/*
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR          DATE                DETAIL                                
   1.0 -    Jenna Vuong     03-25-15            create case when Rx Clinical Program is closed won
   1.1 -    Jenna Vuong     05-28-15            sendClosedWonEmail(), email rx account manager when closed won
======================================================================== */
 
trigger TRG_Program on Program__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
 
    ProgramTriggerHandler handler = new ProgramTriggerHandler(Trigger.isExecuting, Trigger.size);                                                               
 
        if (Trigger.isInsert && Trigger.isBefore) {
                                                      
        }
        else if (Trigger.isInsert && Trigger.isAfter) {

            if (Trigger.new != null) {
                handler.sendClosedWonEmail(Trigger.new); // email Rx Account Manager when closed won
            }
        }
      else if (Trigger.isUpdate && Trigger.isAfter) {
            
            if (Trigger.new != null) {
                handler.sendClosedWonEmail(Trigger.oldMap, Trigger.new); // email Rx Account Manager when closed won
            }
      }
}
