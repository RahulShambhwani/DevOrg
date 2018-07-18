trigger Test1Trigger on Test1__c (before insert, before update) {
    for(Test1__c t1: Trigger.new){
        if(t1.Stream__c=='Science')
        	t1.Subjects__c='Maths';
    }
}