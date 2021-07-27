@isTest
public with sharing class SetListGeneratorController_Test {

    @testSetup
    public static void Setup() {
        Song__c song1 = new Song__c(Name = 'Song 1', Length_Minutes__c=3, Length_Seconds__c=32, Rating__c='1', Original_Artist__c='Test Artist', Status__c='Active');
        insert song1;
        Song__c song2 = new Song__c(Name = 'Song 2', Length_Minutes__c=1, Length_Seconds__c=48, Rating__c='1', Original_Artist__c='Test Artist', Status__c='Active');
        insert song2;
        Song__c song3 = new Song__c(Name = 'Song 3', Length_Minutes__c=5, Length_Seconds__c=14, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Active');
        insert song3;
        Song__c song4 = new Song__c(Name = 'Song 4', Length_Minutes__c=4, Length_Seconds__c=37, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Active');
        insert song4;
        Song__c song5 = new Song__c(Name = 'Song 5', Length_Minutes__c=2, Length_Seconds__c=59, Rating__c='3', Original_Artist__c='Test Artist', Status__c='Active');
        insert song5;
        Song__c song6 = new Song__c(Name = 'Song 6', Length_Minutes__c=3, Length_Seconds__c=45, Rating__c='3', Original_Artist__c='Test Artist', Status__c='Active');
        insert song6;
        Song__c song7 = new Song__c(Name = 'Song 7', Length_Minutes__c=2, Length_Seconds__c=29, Rating__c='4', Original_Artist__c='Test Artist', Status__c='Active');
        insert song7;
        Song__c song8 = new Song__c(Name = 'Song 8', Length_Minutes__c=6, Length_Seconds__c=5, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Active');
        insert song8;
        Song__c song9 = new Song__c(Name = 'Song 9', Length_Minutes__c=1, Length_Seconds__c=14, Rating__c='5', Original_Artist__c='Test Artist', Status__c='Active');
        insert song9;
        Song__c song10 = new Song__c(Name = 'Song 10', Length_Minutes__c=0, Length_Seconds__c=59, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Active');
        insert song10;
        Song__c song11 = new Song__c(Name = 'Song 11', Length_Minutes__c=4, Length_Seconds__c=11, Rating__c='1', Original_Artist__c='Test Artist', Status__c='Active');
        insert song11;
        Song__c song12 = new Song__c(Name = 'Song 12', Length_Minutes__c=2, Length_Seconds__c=38, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Active');
        insert song12;
        Song__c song13 = new Song__c(Name = 'Song 13', Length_Minutes__c=5, Length_Seconds__c=15, Rating__c='3', Original_Artist__c='Test Artist', Status__c='Active');
        insert song13;
        Song__c song14 = new Song__c(Name = 'Song 14', Length_Minutes__c=4, Length_Seconds__c=2, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Active');
        insert song14;
        Song__c song15 = new Song__c(Name = 'Song 15', Length_Minutes__c=3, Length_Seconds__c=48, Rating__c='1', Original_Artist__c='Test Artist', Status__c='Active');
        insert song15;
        Song__c song16 = new Song__c(Name = 'Song 16', Length_Minutes__c=5, Length_Seconds__c=45, Rating__c='3', Original_Artist__c='Test Artist', Status__c='Active');
        insert song16;
        Song__c song17 = new Song__c(Name = 'Song 17', Length_Minutes__c=3, Length_Seconds__c=50, Rating__c='4', Original_Artist__c='Test Artist', Status__c='Active');
        insert song17;
        Song__c song18 = new Song__c(Name = 'Song 18', Length_Minutes__c=3, Length_Seconds__c=1, Rating__c='5', Original_Artist__c='Test Artist', Status__c='Active');
        insert song18;
        Song__c song19 = new Song__c(Name = 'Song 19', Length_Minutes__c=3, Length_Seconds__c=40, Rating__c='3', Original_Artist__c='Test Artist', Status__c='Retired');
        insert song19;
        Song__c song20 = new Song__c(Name = 'Song 20', Length_Minutes__c=3, Length_Seconds__c=58, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Retired');
        insert song20;
        Song__c song21 = new Song__c(Name = 'Song 21', Length_Minutes__c=3, Length_Seconds__c=25, Rating__c='3', Original_Artist__c='Test Artist', Status__c='Active');
        insert song21;
        Song__c song22 = new Song__c(Name = 'Song 20', Length_Minutes__c=2, Length_Seconds__c=59, Rating__c='2', Original_Artist__c='Test Artist', Status__c='Active');
        insert song22;
        Song__c song23 = new Song__c(Name = 'Song 23', Length_Minutes__c=6, Length_Seconds__c=1, Rating__c='4', Original_Artist__c='Test Artist', Status__c='Active');
        insert song23;
        Song__c song24 = new Song__c(Name = 'Song 24', Length_Minutes__c=5, Length_Seconds__c=0, Rating__c='5', Original_Artist__c='Test Artist', Status__c='Active');
        insert song24;
        Song__c song25 = new Song__c(Name = 'Song 24', Length_Minutes__c=1, Length_Seconds__c=30, Rating__c='1', Original_Artist__c='Test Artist', Status__c='Active');
        insert song25;
        Show__c show1= new Show__c(Date__c=Date.Today().addDays(-15), Location__c='Test Location', Name='Show 1', Length_Hours__c=0, Length_Minutes__c=15);
        insert show1;
        Show__c show2= new Show__c(Date__c=Date.Today().addDays(-7), Location__c='Test Location', Name='Show 2', Length_Hours__c=0, Length_Minutes__c=45);
        insert show2;
        Show__c show3= new Show__c(Date__c=Date.Today().addDays(-3), Location__c='Test Location', Name='Show 3', Length_Hours__c=0, Length_Minutes__c=35);
        insert show3;
        Show__c show4= new Show__c(Date__c=Date.Today().addDays(-1), Location__c='Test Location', Name='Show 4', Length_Hours__c=0, Length_Minutes__c=25);
        insert show4;
        Show__c show5= new Show__c(Date__c=Date.Today().addDays(5), Location__c='Test Location', Name='Show 5', Length_Hours__c=0, Length_Minutes__c=20);
        insert show5;
        Show__c show6= new Show__c(Date__c=Date.Today().addDays(10), Location__c='Test Location', Name='Show 6', Length_Hours__c=1, Length_Minutes__c=20);
        insert show6;
        Show__c show7= new Show__c(Date__c=Date.Today().addDays(-28), Location__c='Test Location', Name='Show 7', Length_Hours__c=0, Length_Minutes__c=30);
        insert show7;
        Set_List__c setListForShow7 = new Set_List__c(Name='Set List For Show 7', Length_Hours__c=0, Length_Minutes__c=30, Length_Seconds__c=14, Show__c=show7.Id);
        insert setListForShow7;
    }

    @IsTest
    static void createSetList_Test(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'TestUser', Email='admin@testorg.com', 
            EmailEncodingKey='UTF-8', FirstName='Test', LastName='Admin', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='andrea.f@globant.testuserdevorg');
        Test.startTest();
        Set<Id> setListIds = new Set<Id>();
        List<String> setListLengths = new List<String>();
        List<Show__c> shows = [SELECT Id FROM Show__c ORDER BY Date__c ASC];
        System.runAs(u){
            for(Show__c show : shows){
                Id setListId = SetListGeneratorController.createSetList(String.ValueOf(show.Id));
                if(setListId != null){
                    setListIds.add(setListId);
                    setListLengths.add(SetListGeneratorController.getSetListLength(show.Id));
                    List<Song__c> songs = SetListGeneratorController.getSetList(show.Id);
                }
            }
        }
        Test.stopTest();
        System.assertEquals(setListIds.size(), shows.size(), 'One set list was created for every show');
        System.assertEquals(setListIds.size(), setListLengths.size(), 'One length string was retrieved for every set list');        
    }

}