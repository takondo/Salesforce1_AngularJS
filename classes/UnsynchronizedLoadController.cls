public with sharing class UnsynchronizedLoadController {

    @remoteAction
    public static User getUser(Id id){
        return [SELECT Id, Name, CompanyName, Department
                FROM User
                WHERE Id = :id];
    }

    @remoteAction
    public static List<Account> getAccountsByOwnerId(Id ownerId){
        return [SELECT Id, Name, Industry, Site
                FROM Account
                WHERE OwnerId = :ownerId
                LIMIT 1000];
    }

    @remoteAction
    public static List<Contact> getContactsByOwnerId(Id ownerId, Id accountId){
        return [SELECT Id, Name, AccountId, Department
                FROM Contact
                WHERE OwnerId = :ownerId AND AccountId = :accountId
                LIMIT 1000];
    }

    @remoteAction
    public static List<Lead> getLeadsByOwnerId(Id ownerId){
        return [SELECT Id, Name, Company, Title
                FROM Lead
                WHERE OwnerId = :ownerId
                LIMIT 1000];
    }
}