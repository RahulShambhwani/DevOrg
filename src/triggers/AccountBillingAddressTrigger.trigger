trigger AccountBillingAddressTrigger on Account (before insert, before update) {		
/*    for(Account acc: Trigger.new){
        if(Trigger.isInsert){        
            if(acc.Same_as_Shipping__c==true){
                acc.BillingStreet=acc.ShippingStreet;
                acc.BillingCity=acc.ShippingCity;
            }
        }
    }
*/
/*        if(Trigger.isUpdate){
            for(Account acc: Trigger.new){
                for(Account oldAcc: Trigger.old){				// Checkbox false to true //Will work only if checkbox updates
                    if(acc.Id==oldAcc.Id && acc.Same_as_Shipping__c==true && (acc.Same_as_Shipping__c!=oldAcc.Same_as_Shipping__c
                       || acc.BillingStreet!=acc.ShippingStreet || acc.BillingPostalCode!=oldAcc.ShippingPostalCode ||
                            acc.BillingStreet!=oldAcc.ShippingStreet ||
                            acc.BillingCity!=oldAcc.ShippingCity ||
                           	acc.BillingCountry!=oldAcc.ShippingCountry)){
                                
                       		acc.BillingPostalCode=acc.ShippingPostalCode;    
                            acc.BillingStreet=acc.ShippingStreet;
                            acc.BillingCity=acc.ShippingCity;
                           	acc.BillingCountry=acc.ShippingCountry;
                                                  }
                }
            }
    }
*/
    //Optimized way to compare
/*    If(Trigger.isUpdate){
	    for(Account acc: Trigger.new){
                    if( acc.Same_as_Shipping__c==true && (acc.Same_as_Shipping__c!=Trigger.oldMap.get(acc.Id).Same_as_Shipping__c
                        || acc.BillingPostalCode!=Trigger.oldMap.get(acc.Id).ShippingPostalCode ||
                            acc.BillingStreet!=Trigger.oldMap.get(acc.Id).ShippingStreet ||
                            acc.BillingCity!=Trigger.oldMap.get(acc.Id).ShippingCity ||
                            acc.BillingState!=Trigger.oldMap.get(acc.Id).shippingState||
                           	acc.BillingCountry!=Trigger.oldMap.get(acc.Id).ShippingCountry)){
                                
                       		acc.BillingPostalCode=acc.ShippingPostalCode;    
                            acc.BillingStreet=acc.ShippingStreet;
                            acc.BillingCity=acc.ShippingCity;
                            acc.BillingState=acc.ShippingState;
                           	acc.BillingCountry=acc.ShippingCountry;
                                                  }
        }
*/
    		// More Optimized because using insert & update in same if (Trigger.oldMap will null at insert time)
/*
     	    for(Account acc: Trigger.new){
                if(acc.Same_as_Shipping__c){
                    if( Trigger.oldMap==null || (acc.Same_as_Shipping__c!=Trigger.oldMap.get(acc.Id).Same_as_Shipping__c ||
                            acc.BillingPostalCode!=Trigger.oldMap.get(acc.Id).ShippingPostalCode ||
                            acc.BillingStreet!=Trigger.oldMap.get(acc.Id).ShippingStreet ||
                            acc.BillingCity!=Trigger.oldMap.get(acc.Id).ShippingCity ||
                            acc.BillingState!=Trigger.oldMap.get(acc.Id).shippingState||
                           	acc.BillingCountry!=Trigger.oldMap.get(acc.Id).ShippingCountry)){
                                
                       		acc.BillingPostalCode=acc.ShippingPostalCode;    
                            acc.BillingStreet=acc.ShippingStreet;
                            acc.BillingCity=acc.ShippingCity;
                            acc.BillingState=acc.ShippingState;
                           	acc.BillingCountry=acc.ShippingCountry;
                     }
				}        

    		}
*/
    
    		//More optimized
    		AccountTriggerHandler.populateShippingAddress(Trigger.new, Trigger.oldMap);	//Reusable class

    if(Trigger.isInsert)
        AccountTriggerHandler.populateFavoriteColor(Trigger.new);
}