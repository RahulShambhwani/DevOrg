trigger ContactTrigger on Contact (after insert, after update, after delete) {
 //   if(Trigger.isUpdate)
//		ContactTriggerHandler.updatePhoneofBankAccount(Trigger.new, Trigger.oldMap);
/*    if(Trigger.isInsert){
        ContactTriggerHandler.createUserOnContactInsertion(Trigger.new);
        for(Contact con: Trigger.new)
	        ContactTriggerHandler.createUserOnContactInsertionFuture(con.LastName, con.Email);
    }
*/
    if(Trigger.isInsert )
        ContactTriggerHandler.duplicateContactExtended(Trigger.new, Trigger.OldMap);
    
    ContactTriggerHandler.rollupAmount(Trigger.new, Trigger.oldMap);
    
    ContactTriggerHandler.updateAccountOnContactUpdate(Trigger.new, Trigger.oldMap);
}