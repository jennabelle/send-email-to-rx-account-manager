/*
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR          DATE                DETAIL                                
   1.0 -    Jenna Vuong     03-25-15            CreateNewCaseProgramClosedWon(), create new case when Rx Clinical Program is closed won
   1.1 -    Jenna Vuong     05-28-15            sendClosedWonEmail(), email rx account manager when closed won
======================================================================== */
 
public with sharing class ProgramTriggerHandler {
 
    private boolean isExecuting = false;
    private Integer BatchSize = 0;
    Map<String, Id> mapRTs = new Map<String, Id>();
    List<AccountTeamMember> listATMs = new List<AccountTeamMember>();
   
    public ProgramTriggerHandler(boolean isExecuting, Integer size) {
        isExecuting = isExecuting;
        BatchSize = size;
       
        // get case record type
        /**List<RecordType> caseRTs = new List<RecordType>([ Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Plan_Sponsor_Questions_or_Issues'
                                                         and isActive = true and sObjectType = 'Case' ]);
        if (caseRTs != null && caseRTs.size() >0) {
            for (RecordType r : caseRTs) {
                mapRTs.put(r.Name, r.Id);
            }
        } **/
    }
   
    /***** IGNORE PLEASE!! IGNORE PLEASE! *****
    public void CreateNewCaseProgramClosedWon(Map<Id, Rx_Clinical_Program_Opp__c> oldProgramMap, List<Rx_Clinical_Program_Opp__c> newPrograms) {
       
        Map<String, Id> mapAMs = new Map<String, Id>();
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        List<Opportunity> listOpps = new List<Opportunity>();
        List<Case> caseInsertList = new List<Case>();
 
        // get all Pharmacy Account Managers
                                for (Rx_Clinical_Program_Opp__c r : newPrograms) {
                                                oppIds.add(r.Opportunity__c);
                                }
 
        // get account ids for opportunities
        for (Opportunity o : [ Select Id, Name, AccountId From Opportunity Where Id In :oppIds ]) {
                                                acctIds.add(o.AccountId);
            mapOpps.put(o.Id, o);
                                }
 
        listATMs = [ Select TeamMemberRole, UserId, AccountId from AccountTeamMember where AccountId In :acctIds ];
       
        if (listATMs != null && listATMs.size() > 0) {
            for (AccountTeamMember a : listATMs) {
                mapAMs.put(a.TeamMemberRole, a.UserId);
            }
        }
 
                                for (Rx_Clinical_Program_Opp__c r : newPrograms) {
            
            if (oldProgramMap.get(r.Id).Stage__c != 'Closed Won' && r.Stage__c == 'Closed Won') {
               
                Case c = new Case();
                c.RecordTypeId = mapRTs.get('Plan Sponsor Questions or Issues');
                c.Opportunity__c = r.Opportunity__c;
                c.Aetna_Case_Type__c = 'Account Manager Case';
                c.AccountId = mapOpps.get(r.Opportunity__c).AccountId;
                c.Subject = 'New Rx Clinical Program Sold - '+ r.Name;
                c.Description = 'Please review the related opportunity and reach out to the field to verify that the required paperwork has been completed and submitted.  Once you have all the relevant information and have determined if an update to a CRD is needed, please work with the BCT Team to ensure the applicable CRDs are updated.';
                                                                c.OwnerId = mapAMs.get('Pharmacy Account Manager');
                                                                caseInsertList.add(c);
            }
                                }
       
        try {
            insert caseInsertList;
        } catch (DmlException e) {
            System.debug('ERROR! The following exception has occurred: ' + e.getMessage());
        }  
    }
    
    /** IGNORE PLEASE! **
    public void CreateNewCaseProgramClosedWon(List<Rx_Clinical_Program_Opp__c> newPrograms) {
       
        Map<String, Id> mapAMs = new Map<String, Id>();
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        List<Opportunity> listOpps = new List<Opportunity>();
        List<Case> caseInsertList = new List<Case>();
 
        // get all Pharmacy Account Managers
                                for (Rx_Clinical_Program_Opp__c r : newPrograms) {
                                                oppIds.add(r.Opportunity__c);
                                }
 
        // get account ids for opportunities
        for (Opportunity o : [ Select Id, Name, AccountId From Opportunity Where Id In :oppIds ]) {
                                                acctIds.add(o.AccountId);
            mapOpps.put(o.Id, o);
                                }
 
        listATMs = [ Select TeamMemberRole, UserId, AccountId from AccountTeamMember where AccountId In :acctIds ];
       
        if (listATMs != null && listATMs.size() > 0) {
            for (AccountTeamMember a : listATMs) {
                mapAMs.put(a.TeamMemberRole, a.UserId);
            }
        }
 
                                for (Rx_Clinical_Program_Opp__c r : newPrograms) {
           
            if (r.Stage__c == 'Closed Won') {
               
                Case c = new Case();
                c.RecordTypeId = mapRTs.get('Plan Sponsor Questions or Issues');
                c.Opportunity__c = r.Opportunity__c;
                c.Aetna_Case_Type__c = 'Account Manager Case';
                c.AccountId = mapOpps.get(r.Opportunity__c).AccountId;
                c.Subject = 'New Rx Clinical Program Sold - '+ r.Name;
                c.Description = 'Please review the related opportunity and reach out to the field to verify that the required paperwork has been completed and submitted.  Once you have all the relevant information and have determined if an update to a CRD is needed, please work with the BCT Team to ensure the applicable CRDs are updated.';
                                                                c.OwnerId = mapAMs.get('Pharmacy Account Manager');
                                                                caseInsertList.add(c);
            }
                                }
       
        try {
            insert caseInsertList;
        } catch (DmlException e) {
            System.debug('ERROR! The following exception has occurred: ' + e.getMessage());
        }  
    } **/
   
    // JV - 5/26/15 - after insert, send email to rx account manager when closed won
    public void sendClosedWonEmail(List<Program__c> newPrograms) {
       
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds =  new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        List<String> programIds = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>(); // list of email addresses to send to
        List<Contact> tempContactList = new List<Contact>();
        Map<User,Contact> tempContactMap = new Map<User,Contact>();

        // get all opp ids
        for (Program__c p : newPrograms) {
           
            if (p.Stage__c == 'Closed Won' && p.Opportunity__c != null) {
               
                oppIds.add(p.Opportunity__c);
                programIds.add(p.Id);
            }
        }
       
        // get all acct ids
        if (oppIds != null && oppIds.size() > 0) {
           
            for (Opportunity o : [ Select Id, AccountId From Opportunity Where Id In :oppIds] ) {
                acctIds.add(o.AccountId);
            }
        }
       
        // get all rx account managers
        if (acctIds != null && acctIds.size() > 0) {
           
            for (AccountTeamMember a : [ Select Id, AccountId, UserId, TeamMemberRole From AccountTeamMember Where AccountId In :acctIds and TeamMemberRole = 'Pharmacy Account Manager' Limit 1 ]) {
                userIds.add(a.UserId);
            }
        }
       
        // get email template id
        EmailTemplate templateId = [ Select Id, isActive, DeveloperName From EmailTemplate Where DeveloperName = 'Sold_Programs' and isActive = true LIMIT 1 ];
       
        // need a Map<Id,Opportunity> give user id, get program details
        Map<User,String> mapUserProgram = new Map<User,String>();
       
        for (User u : [ Select Id, FirstName, LastName, Email, isActive From User Where Id In :userIds and isActive = true ]) {

            System.debug('programIds: ' + programIds + 'programIds.size(): ' + programIds.size()); 
            
            if (programIds != null) {
                
                for (String i : programIds) {
                    mapUserProgram.put(u,i);
                }
            }
        }
  
        if (userIds != null) {
            
            for (User key : mapUserProgram.keySet()) {
                
                Contact tempContact = new Contact(email = key.email, firstName = key.firstName, lastName = key.lastName);
                tempContactList.add(tempContact);
                tempContactMap.put(key,tempContact);
            }
            
            try {
                insert tempContactList;
            }
            catch (DmlException e) {
                System.debug('An ERROR occurred! Insert tempContactList failed.');
            }
            
            for (User key : mapUserProgram.keySet()) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                // sendTo.add(key.Email); // JENNA: This sends duplicate email to Rx Account Manager, commenting this out
                // mail.setToAddresses(sendTo);
                mail.setTemplateId(templateId.id);
                for (Contact c : tempContactList) { // Jenna: This does not seem right. Is it?
                    mail.setTargetObjectId(tempContactMap.get(key).Id);
                }
                mail.setSaveAsActivity(false);
                mail.setWhatId(mapUserProgram.get(key)); 
                
                allmsg.add(mail);
            }
       
        if (allmsg != null) {
            Messaging.sendEmail(allmsg);
        }
 
        try {
      delete tempContactList;
        }
        catch (DmlException e) {
            System.debug('An ERROR occurred! Deletion of tempContactList failed.'); 
        }
         
    }
    }
    
    // JV - 6/9/15 - after update, send email to rx account manager when closed won
    public void sendClosedWonEmail(Map<Id, Program__c> oldProgramMap, List<Program__c> newPrograms) {
       
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds =  new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        List<String> programIds = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>(); // list of email addresses to send to
        List<Contact> tempContactList = new List<Contact>();
        Map<User,Contact> tempContactMap = new Map<User,Contact>();

        // get all opp ids
        for (Program__c p : newPrograms) {
           
            if (oldProgramMap.get(p.Id).Stage__c != 'Closed Won' && p.Stage__c == 'Closed Won' && p.Opportunity__c != null) {
               
                oppIds.add(p.Opportunity__c);
                programIds.add(p.Id);
            }
        }
       
        // get all acct ids
        if (oppIds != null && oppIds.size() > 0) {
           
            for (Opportunity o : [ Select Id, AccountId From Opportunity Where Id In :oppIds] ) {
                acctIds.add(o.AccountId);
            }
        }
       
        // get all rx account managers
        if (acctIds != null && acctIds.size() > 0) {
           
            for (AccountTeamMember a : [ Select Id, AccountId, UserId, TeamMemberRole From AccountTeamMember Where AccountId In :acctIds and TeamMemberRole = 'Pharmacy Account Manager' Limit 1 ]) {
                userIds.add(a.UserId);
            }
        }
       
        // get email template id
        EmailTemplate templateId = [ Select Id, isActive, DeveloperName From EmailTemplate Where DeveloperName = 'Sold_Programs' and isActive = true LIMIT 1 ];
       
        // need a Map<Id,Opportunity> give user id, get program details
        Map<User,String> mapUserProgram = new Map<User,String>();
       
        for (User u : [ Select Id, FirstName, LastName, Email, isActive From User Where Id In :userIds and isActive = true ]) {
           
            System.debug('programIds: ' + programIds + 'programIds.size(): ' + programIds.size()); 
            
            if (programIds != null) {
                
                for (String i : programIds) {
                    mapUserProgram.put(u,i);
                }
            }
        }
        
        if (userIds != null) {
            
            for (User key : mapUserProgram.keySet()) {
                
                Contact tempContact = new Contact(email = key.email, firstName = key.firstName, lastName = key.lastName);
                tempContactList.add(tempContact);
                tempContactMap.put(key,tempContact);
            }
            
            try {
                insert tempContactList;
            }
            catch (DmlException e) {
                System.debug('An ERROR occurred! Insert tempContactList failed.');
            }
 
            for (User key : mapUserProgram.keySet()) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                sendTo.add(key.Email);
                mail.setToAddresses(sendTo);
                mail.setTemplateId(templateId.id);
                for (Contact c : tempContactList) { // Jenna: This does not seem right. Is it?
                    mail.setTargetObjectId(tempContactMap.get(key).Id);
                }
                mail.setSaveAsActivity(false);
                mail.setWhatId(mapUserProgram.get(key)); 
                
                allmsg.add(mail);
            }
       
        if (allmsg != null) {
            Messaging.sendEmail(allmsg);
        }
 
            try {
                delete tempContactList;
            }
            catch (DmlException e) {
                System.debug('An ERROR occurred! Deletion of tempContactList failed.');
            }
         
    }
    }
}
