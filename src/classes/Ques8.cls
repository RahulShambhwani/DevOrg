public class Ques8 {
  public static void sendEmailToAccountOwner()
  {
      for(Account acc1 : [SELECT Owner.Name , Owner.Email, Active__c, Name, Account.CreatedDate FROM Account 
                        WHERE Active__c='No' AND Account.CreatedDate = LAST_N_DAYS:7])
 {	
//          System.debug(acc1);
          
          if(acc1.Owner.Email != null )
 {
    //Step 1: Create new email
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      
      //Step 2: Set person to whom the email is to be sent
      List<String> accountOwnerEmail = new List<String>();
               accountOwnerEmail.add(acc1.Owner.Email);
               mail.setToAddresses(accountOwnerEmail);
               
              // Step 3: Set who the email is sent from
   mail.setReplyTo('rahul.shambhwani@gmail.com');
     mail.setSenderDisplayName('Appirio');
               
               //Step 4: complete your email
               mail.setSubject(' Activate The Account');
               String body = 'Dear '+ acc1.Owner.name + ', The account '+acc1.Name+' created on Date: ' + acc1.CreatedDate+
                   ' is still not active and it has been more than 7 days. Kindly take a note of it.';
                   mail.setHtmlBody(body);
      
               Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail} );
           }
  }
  } }