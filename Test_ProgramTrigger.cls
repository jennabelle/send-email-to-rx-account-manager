/*
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR          DATE                DETAIL                                
   1.0 -    Jenna Vuong     03-25-15            create case when Rx Clinical Program is closed won
   1.1 -    Jenna Vuong     06-09-15            Test_SendClosedWonEmail(), email rx account manager when closed won
======================================================================== */

@isTest
private class Test_ProgramTrigger {

    static testMethod void Test_SendClosedWonEmail() {
        
        List<Profile> profile = new List<Profile>([ Select Id, Name From Profile Where Name = 'System Administrator' LIMIT 1 ]);
        
        // create test user
        User testUser = new User(FirstName = 'Jenna', LastName = 'Vuong', Email = 'jenna@aetna.com', Alias = 'jenna', Username = 'jenna@aetna.com', LocaleSidKey = 'en_US',
                                TimeZoneSidKey = 'GMT', ProfileID = profile[0].Id, LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8');
        insert testUser;
        
        // create test account
        Account testAcct = new Account(Name = 'Test Acct', PSU__c = 123);
        insert testAcct;
        
        // create test atm
        AccountTeamMember atm = new AccountTeamMember(AccountId = testAcct.Id, TeamMemberRole = 'Pharmacy Account Manager', UserId = testUser.Id);
        insert atm;
        
        // create test opp
        Opportunity testOpp = new Opportunity(AccountId = testAcct.Id, Name = 'Test Acct - Rx Clinical Program', StageName = 'Negotiation', CloseDate = System.today());
        insert testOpp;
 
        // Test after insert closed won program
        Program__c testProg = new Program__c(Opportunity__c = testOpp.Id, Name = 'Save A Copay Drug Classes', Stage__c = 'Closed Won', Program_Start_Date__c = System.today());
        insert testProg;
        
        // Test after update closed won program
        Program__c testProg2 = new Program__c(Opportunity__c = testOpp.Id, Name = 'Save A Copay Drug Classes', Stage__c = 'Negotiation', Program_Start_Date__c = System.today());
        insert testProg2;
        
        Test.startTest();
        
        testProg2.Stage__c = 'Closed Won';
        update testProg2;
        
        List<Program__c> programs = new List<Program__c>([ Select Id, Opportunity__c, Name, Stage__c from Program__c ]);
        
        Test.stopTest();
        
        System.assertEquals(2, programs.size());
        System.assertEquals('Closed Won', programs[0].Stage__c);
        System.assertEquals('Closed Won', programs[1].Stage__c);
        
    }
    
}
