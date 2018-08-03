public class AccountCreation{
    
    public string siteType{get;set;}
    Public string siteTypePl{get;set;}
    public AccountCreation() {

    }


    ApexPages.standardController a_sc = null;

      public AccountCreation(ApexPages.standardController sc)
      {
        a_sc = sc;
      }
     
    @remoteAction
    Public Static List<Account> accountSearch(string selectedAccount)
    {
        //string recid=[select id from recordtype where name='Site'].id;
        //System.debug('recid = '+recid);
        string query='select id,Name,Type,Site from Account where Name like \'%'+selectedAccount+'\'';
        
        //query=query+' AND recordtypeid=\''+recid+'\'';
        query=query+' order by NAME asc limit 100';
        System.debug('query = '+query);
        List<Account> accList=Database.query(query);
        
        return accList;
    }
    
    Public string getTypePickListValues()
    {
        List<Schema.PicklistEntry> pleWithoutCustomer = new List<Schema.PicklistEntry>();
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p:ple){
            if(p.getValue() != 'Customer')
                pleWithoutCustomer.add(p);
        }
        List<String> pickListValues=new list<string>();
        return Json.serialize(pleWithoutCustomer);
    }
    
    Public pagereference redirectToNextPage(){
        pagereference p=new pagereference('/apex/AccountEditPage?siteType='+siteType+'&siteTypePL='+siteTypePl);
        if(apexpages.currentpage().getparameters().get('siteType')=='GTR')
        return null;
        return p;
    }

    public PageReference doCancel()
      {      
        PageReference newpage = new Pagereference('/001/o');
        newpage.setRedirect(true);
        return newpage;
      }

}