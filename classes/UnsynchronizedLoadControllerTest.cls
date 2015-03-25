@isTest
private class UnsynchronizedLoadControllerTest {

    @testSetup
    static void setup() {
        //setup User
        insert new User(LastName='UserElse',
                        UserName='UserElse@sf1.angular.jp',
                        Email='UserElse@sf1.angular.jp',
                        Alias='test',
                        EmailEncodingKey='UTF-8',
                        LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US',
                        TimeZoneSidKey='America/Los_Angeles',
                        ProfileId=UserInfo.getProfileId());
        User userElse = [SELECT Id FROM User WHERE Name='UserElse'];
        //setup Account
        insert new Account(Name='Account00');
        insert new Account(Name='Account01');
        insert new Account(Name='Account02');
        insert new Account(Name='AccountElse', OwnerId=userElse.Id);
        Account account01 = [SELECT Id FROM Account WHERE Name='Account01'];
        Account account02 = [SELECT Id FROM Account WHERE Name='Account02'];
        Account accountElse = [SELECT Id FROM Account WHERE Name='AccountElse'];    //Exception data
        //setup Contact
        insert new Contact(LastName='Contact01_1', AccountId=account01.Id);
        insert new Contact(LastName='Contact02_1', AccountId=account02.Id);
        insert new Contact(LastName='Contact02_2', AccountId=account02.Id);
        insert new Contact(LastName='ContactElse', AccountId=accountElse.Id, OwnerId=userElse.Id);    //Exception data
        //setup Lead
        insert new Lead(LastName='Lead00', Company='LeadCompany00');
        insert new Lead(LastName='Lead01', Company='LeadCompany01');
        insert new Lead(LastName='LeadElse', Company='LeadCompanyElse', OwnerId=userElse.Id);    //Exception data
    }

    @isTest
    static void getUserTest() {
        User user = UnsynchronizedLoadController.getUser(UserInfo.getUserId());
        system.assertNotEquals(null, user);
        system.assertEquals(UserInfo.getUserId(), user.Id);
    }

    @isTest
    static void getAccountsByOwnerIdTest() {
        List<Account> accounts = UnsynchronizedLoadController.getAccountsByOwnerId(UserInfo.getUserId());
        system.assertEquals(3, accounts.size());
    }

    @isTest
    static void getContactsByOwnerIdTest() {
        List<Account> accounts = UnsynchronizedLoadController.getAccountsByOwnerId(UserInfo.getUserId());
        for(Account account : accounts){
            List<Contact> contacts = UnsynchronizedLoadController.getContactsByOwnerId(UserInfo.getUserId(), account.Id);
            if(account.Name == 'Account00'){
                system.assertEquals(0, contacts.size());
            }else if(account.Name == 'Account01'){
                system.assertEquals(1, contacts.size());
            }else if(account.Name == 'Account02'){
                system.assertEquals(2, contacts.size());
            }else{
                system.assert(false);
            }
        }
    }

    @isTest
    static void getLeadsByOwnerIdTest() {
        List<Lead> leads = UnsynchronizedLoadController.getLeadsByOwnerId(UserInfo.getUserId());
        system.assertEquals(2, leads.size());
    }
}