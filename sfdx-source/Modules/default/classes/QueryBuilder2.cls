/**
 * Perform SOQL queries.
 */
public without sharing class QueryBuilder2 {
    
    private String[] fields = new String[]{};
    
    private String queryObject = null;
    
    private String orderByClause = '';
    
    private String limitClause = '';
    
    private String whereClause = null;
    
    private List<QueryCondition> conditions = new List<QueryCondition>();
    
    public enum NullProcessingInstruction {NULLS_FIRST, NULLS_LAST}

    
    public void setFields(String[] fields) {
        this.fields = fields;
    }
    
    
    public void setObject(String theObject) {
        this.queryObject = theObject;
    }
    
    public void setWhereClause(String whereClause) {
        this.whereClause = whereClause;
    }
      
    
    public String compile() {
        return this.buildSoqlQueryString();
    }
    
    public List<SObject> query() {
        
        String query = this.buildSoqlQueryString();
       	Map<String,Object> bindings = this.buildSoqlBindings();
        
        return Database.queryWithBinds(query, bindings, System.AccessLevel.SYSTEM_MODE);
    }
    
    public Map<String,Object> buildSoqlBindings() {
        Map<String,Object> binds = new Map<String,Object>();
        
        for(QueryCondition c : this.conditions) {
            binds.put(c.getAlias(),c.getValue());
        }
        
        return binds;
    }
    
    
    public String buildSoqlQueryString() {
        
        String[] parts = new String[]{'SELECT'};
        parts.add(String.join(this.fields, ', '));
        parts.addAll(new String[]{'FROM', this.queryObject, 'WHERE'});
        
        List<String> condList = new List<String>();
        String conds = '';
        
        for(QueryCondition cond : this.conditions) {
            Object[] params = new Object[]{cond.getField(),cond.getOperator(),cond.getAlias()};
            String c = String.format('{0} {1} :{2}',params);
            condList.add(c);
        }
        
        conds = String.join(condList, ' AND ');
        
        if(this.whereClause != null) {
            parts.add(this.whereClause);
        }
        parts.add(conds);
		parts.add(this.orderByClause);
		parts.add(this.limitClause);
        
        return String.join(parts,' ');
    }


    public void addCondition(String conditionString) {
    	String[] c = conditionString.split(' ');
        String field;
        String alias;
        Object value;
        String op;
        
        if(c.size() == 3) {
            field = c[0];
            alias = null;
            value = c[2];
            op = c[1];
        } else if(c.size() == 4) {
            field = c[0];
            alias = c[1];
            value = c[3];
            op = c[2];
        }


        this.conditions.add(new QueryCondition(field,alias,value,op));
    }
    
    
    public void addCondition(String field, Object value) {
        
        this.conditions.add(new QueryCondition(field,value));
    }

    
    public void addCondition(String field, String alias, Object value, String op) {    
        this.conditions.add(new QueryCondition(field,alias,value,op));
    }
    
    
    public void addCondition(String field, Object value, String op) {    
        
        this.conditions.add(new QueryCondition(field,value,op));
    }
    
    
    public void orderBy(String field, String ascOrDesc) {
        orderBy(field, ascOrDesc, NullProcessingInstruction.NULLS_LAST);
    }
    
    public void orderBy(String field, String ascOrDesc, NullProcessingInstruction handleNulls) {
        String[] parts = new String[]{'ORDER BY',field,ascOrDesc};   
            
        if(handleNulls == NullProcessingInstruction.NULLS_FIRST) {
            parts.add('NULLS FIRST');
        }
        else parts.add('NULLS LAST');
        
		this.orderByClause = String.join(parts,' ');
    }
    
    
    public void setLimit(Integer theLimit) {
        String[] parts = new String[]{'LIMIT', String.valueOf(theLimit)};
            
        this.limitClause = String.join(parts, ' ');
    }
    

}