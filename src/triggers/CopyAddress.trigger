trigger CopyAddress on Contact (before insert, before update) {

    for(Contact ct: Trigger.new){
        ct.OtherCity=ct.MailingCity;
        ct.OtherCountry=ct.MailingCountry;
    }
    
}