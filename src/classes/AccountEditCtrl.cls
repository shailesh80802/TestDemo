public class AccountEditCtrl {
    
    //variable declaration
    public Contact c{get;set;}
    public account a{get;set;}
    Public boolean isLinked{get;set;}
    Public id selectedCompAccount{get;set;}
    Public string parentAccount{get;set;}
    Public string companyAccount{get;set;}
    Public boolean isCreateCon{get;set;}
    
    //constructor
    public AccountEditCtrl() {
        a=new account();
        c=new contact();
        a.Site=getSiteType();
        a.Type= apexpages.currentpage().getparameters().get('siteTypePl');
       // a.OMG_AccountType__c=getSiteType();
        isLinked=false;
       // a.OMG_ClientTier__c='Undefined';
    }
    
    
    //search method -- will be called from angular function
    @remoteAction
    Public Static List<Account> searchAccounts(string selectedAccount,string recType)
    {    
        string recid=[select id from recordtype where name='Company'].id;        
        string query='select id,Name,Parent.Name,OMG_AccountType__c,is_CLE__c from Account where Name like \'%'+selectedAccount+'%\'';
        query=query+' AND recordtypeid=\''+recid+'\'';
        query=query+' order by createddate desc limit 100';
        System.debug('query = '+query);
        List<Account> accList=Database.query(query);
        return accList;
    }
    
    @remoteAction
    Public static boolean isDuplicate(string siteName)
    {
        integer count=[select count() from account where name=:siteName];
        if(count>0)
            return true;
        else
            return false;    
    }
    
    // set sitetype value
    Public string getSiteType()
    {
        if(apexpages.currentpage().getparameters().get('siteType')=='True')
            return 'GTR';
        else
            return null;    
    }
    
    public PageReference doCancel() {
        PageReference newpage = new Pagereference('/001/o');
        newpage.setRedirect(true);
        return newpage;
    }
    
     public PageReference goBack() {
        PageReference newpage = new Pagereference('/apex/AccountEditPage');
        return newpage;
    }
    
    public PageReference goBackToFirstPage() {
        PageReference newpage = new Pagereference('/apex/NewAccountCreatePage');
        newpage.setRedirect(true);
        return newpage;
    }

    public PageReference redirectToNextPage() {
        pagereference p=new pagereference('/apex/AccountFinalReviewPage');
        return p;    
    }
    
    Public pagereference doSave()
    {
        try
        {
            string siteId=[select id from recordtype where name='Site'].id;        
            string compId=[select id from recordtype where name='Company'].id;   
            string parentId=[select id from recordtype where name='Parent'].id;   
            
            if(isLinked)  // is linked to existing company account
            {
                 //a.RecordTypeId=siteId;
                 a.Parentid=selectedCompAccount;
                 insert a;
                 //contact inserting
                 if(isCreateCon)
                 {
                     c.accountid=a.id;
                     insert c;
                 }
            }
            else // if users select NO
            {
                   
                   System.debug('Inside Else loop');
                   //add Parent record type account
                   Account a2=new account();
                   a2=a.clone();
                   a2.Site='';  // making site location as null
                   a2.Name=a.Name.toUpperCase();
                   System.debug('a2 = '+a2);
                   //a2.RecordTypeId=parentId;
                   insert a2;
                   
                  //add Comp record type Account
                   Account a1=new account();
                   a1=a.clone();
                   //a1.Recordtypeid=compId;
                   a1.Site=''; // making site location as null.
                   a1.parentId=a2.id;
                   System.debug('a1 = '+a1);
                   insert a1;
                   
                   //add siteRec in list.
                  // a.RecordTypeId=siteId;
                   a.parentId=a1.id;
                   System.debug('a = '+a);
                   insert a;
                   //contact insertion
                   if(isCreateCon)
                   {
                       c.accountid=a.id;
                       System.debug('c = '+c);
                       insert c;
                   }
            }
        
            pagereference pg=new pagereference('/'+a.id);
            return pg;
        }   
        catch(exception e)
        {
            system.debug('exception = '+string.valueof(e));
            return null;
        }
    }
    
}