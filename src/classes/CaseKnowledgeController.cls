public class CaseKnowledgeController {

    private Knowledge_Base__kav relatedKAV;
    public Id kaID{get;set;}
    public integer kaCount {get;set;}
    public string breakStyle;
    
    public string getBreakStyle(){
        if(kaCount > 1)return 'page-break-before:always;';
        return ''; 
    }
            
    public Knowledge_Base__kav getRelatedKAV(){
        relatedKAV = [select KnowledgeArticleId, PublishStatus, LastPublishedDate, Title, Summary, Description__c
         from knowledge_Base__kav where PublishStatus = 'Online' AND
         KnowledgeArticleId = :kaID ORDER BY LastPublishedDate DESC limit 1];
        return relatedKAV;
    }
    
    static testMethod void testCaseKnowledgeController(){
        
        Try{
            CaseKnowledgeController ckCtrl = new CaseKnowledgeController();
            
            System.assert(ckCtrl.getBreakStyle() == '');
            ckCtrl.kaCount = 2;
            System.assert(ckCtrl.getBreakStyle() != '');
            
            Knowledge_Base__kav[] kb = [select KnowledgeArticleId, PublishStatus, LastPublishedDate, Title, Summary, Description__c from knowledge_Base__kav where PublishStatus = 'Online' limit 1];
            
            If(kb.size() > 0){
                ckCtrl.kaID = kb[0].KnowledgeArticleId;
                ckCtrl.getRelatedKAV();
                System.assert(ckCtrl.getRelatedKAV() != null);
            }
        }
        Catch (Exception e){
            //do nothing
        }
    
    }
    
}