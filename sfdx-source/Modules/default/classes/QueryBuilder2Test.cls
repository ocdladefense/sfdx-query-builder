@isTest(SeeAllData=True)
public class QueryBuilder2Test {


    

    @isTest(SeeAllData=True)
    private static void testQueryBuilder() {

        Date asOf = Date.newInstance(2020, 1, 1);

        QueryBuilder2 past = new QueryBuilder2();
        past.setObject('OrderItem');
        past.setFields(new List<String>{'Id', 'Order.EffectiveDate'});
        past.addCondition('Product2.Family productFamily', 'Memberships');
        past.addCondition('Order.Status status != A');
        past.addCondition('Order.EffectiveDate','startDate', asOf, '<');
        past.orderBy('Order.EffectiveDate','DESC');

        
        for(SObject line :past.query()) {
            // this.results.put(line.Contact__c, True);
        }
    }    
}