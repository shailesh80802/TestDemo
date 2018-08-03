public class CaseEmailCtrl {
    
    public Case cs {get;set;}
    
    public String caseId {get;set;}
    
    public String subject {get;set;}
    
    public String body {get;set;}
    
    public List<CaseArticle> caseArticleList;
    
    public Set<Id> knowledgeArticleIdSet;
    
    public List<KnowledgeArticleVersion> knowledgeArticleList {get;set;}
    
    public List<KnowledgeArticleListWrapper> wrapperList {get;set;}
    
    public DS_Customer_Details__c custDetails;
    public string customerEmails {get;set;}
    
    public CaseEmailCtrl(ApexPages.StandardController controller){
        cs = (Case)controller.getRecord();
        custDetails = [SELECT Id,Name, Email__c FROM DS_Customer_Details__c where DS_Customer_Name__c=: cs.Id limit 1];
        cs = [SELECT Id,ContactId,(Select Id From X10__r),Subject FROM Case WHERE Id=: cs.Id LIMIT 1];
        caseArticleList = [SELECT KnowledgeArticleId FROM CaseArticle WHERE CaseId =: cs.Id];
        customerEmails = custDetails.Email__c;
        System.debug('caseArticleList----->: '+caseArticleList);
        knowledgeArticleIdSet =  new Set<Id>();
        wrapperList = new List<KnowledgeArticleListWrapper>();
        for(CaseArticle ca: caseArticleList){
            knowledgeArticleIdSet.add(ca.KnowledgeArticleId);
        }
        System.debug('knowledgeArticleIdSet---->: '+knowledgeArticleIdSet);
        knowledgeArticleList = [SELECT id,Title,UrlName,KnowledgeArticleId,summary FROM KnowledgeArticleVersion WHERE KnowledgeArticleId IN:knowledgeArticleIdSet AND PublishStatus = 'Online'];
        

        for(KnowledgeArticleVersion obj: knowledgeArticleList){
            KnowledgeArticleListWrapper wrap = new KnowledgeArticleListWrapper();
            wrap.isSelected = false;
            wrap.title = obj.Title;
            wrap.url = obj.UrlName;
            wrap.id= obj.KnowledgeArticleId ;
            wrapperList.add(wrap);
            
            
        }
        System.debug('knowledgeArticleList: '+knowledgeArticleList);
    }
    
    public class KnowledgeArticleListWrapper{
         
        public boolean isSelected {get;set;}
       
        public String title {get;set;}
        
        public String url {get;set;}
        public String id{get;set;}
        
    }
    
    public pagereference sendEmail() {
        // Define the email
        blob emailBody;
        list<String> toAddresses  = new list<string>();
        if(customerEmails.contains(','))
        {
        toAddresses = customerEmails.split(',');
        }
        else{
        toAddresses.add(customerEmails);
        }
        //toAddresses.add('sourabhpatrikar@gmail.com');
        system.debug('toAddresses--->'+toAddresses);
        list<Messaging.EmailFileAttachment> attachmentList = new list<Messaging.EmailFileAttachment>();
        system.debug('wrapperList--->'+wrapperList);
        for(KnowledgeArticleListWrapper article:wrapperList)
        {
            if(article.isSelected == true)
            {
                emailBody = getAttachments(article.id);
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType('application/pdf');
                attach.setFileName(article.title+'KnowledgeArticle.pdf');
                attach.setInline(false);
                attach.Body = emailBody;
                attachmentList.add(attach);
                
        
            }
        }
        system.debug('attachmentList--->'+attachmentList);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'srbsalesforcedemo@gmail.com'];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setUseSignature(false);
        //mail.setReplyTo(UserInfo.getUserEmail());
        //mail.setSenderDisplayName(UserInfo.getUserEmail());
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        mail.setFileAttachments(attachmentList); 
        system.debug('mail--->'+mail);
        System.debug('Email invocations ---->: ' + Limits.getEmailInvocations());
        list<Messaging.SendEmailResult> results = new list<Messaging.SendEmailResult>();
        if(Limits.getEmailInvocations() != 0)
        {
            // Send the email
        results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        }else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'Email limit exceeded'));
        }
        

        if (results != null && !results.isEmpty() && results[0].success) {
        System.debug('The email was sent successfully.');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'Email Sent Successfully.'));
        } else if(results != null && !results.isEmpty() && !results[0].success) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,results[0].errors[0].message));
        System.debug('The email failed to send: ' + results[0].errors[0].message);
        }

        return null;
           

        }
        
        public blob getAttachments(string articleId)
        {
            PageReference pdf = Page.KnowledgeArticlePDFGenerator;
            pdf.getParameters().put('id',articleId);
            Blob body;
        
            try {
        
              body = pdf.getContent();
        
            } catch (VisualforceException e) {
              body = Blob.valueOf('Some Text');
            }
            return body;
        }

}