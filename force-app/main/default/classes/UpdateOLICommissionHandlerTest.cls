@isTest
public class UpdateOLICommissionHandlerTest {
    
    @TestSetup static void TestData(){
        
        Product2 prod = new Product2(Name='product1');
        insert prod;

    }
    
    @isTest static void runTests(){
        
        Product2 pr = [select id from Product2 where Name = 'product1'];
        pr.Name = 'product2';
        
        Test.startTest();
        update pr;
        Test.stopTest();
    }
}