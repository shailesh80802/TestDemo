@IsTest
private class TEST_AwesomeProductController {
    
    static {
        insert new Product__c(
        	name='Shirt',
            color__c='blue',
            description__c='awesome shirt',
            points__c=1,
            photo__c='http://www.appirio.com'
        );
    }
    
    static testMethod void testMe() {
        System.assertEquals(1, AwesomeProductController.getProducts().size());
        System.assertEquals('Shirt', AwesomeProductController.getProductByName('Shirt').Name);
    }

}