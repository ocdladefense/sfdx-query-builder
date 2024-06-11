public class QueryCondition {
    
    private String field;
    
    private String alias;
    
    private Object value;
    
    private String op;
    
    
    
    public QueryCondition(String field, Object value) {
        String[] fa = field.split(' ');
        this.field = fa[0];
        this.alias = fa.size() > 1 ? fa[1] : fa[0];
        this.op = '=';
        this.value = value;
    }
    
    public QueryCondition(String field, Object value, String op) {
        String[] fa = field.split(' ');
        this.field = fa[0];
        this.alias = fa.size() > 1 ? fa[1] : fa[0];
        this.op = '=';
        this.value = value;
    }
    
    public QueryCondition(String field, String alias, Object value, String op) {
        this.field = field;
        this.alias = alias;
        this.value = value;
        this.op = null == op ? '=' : op;
    }
    
    public String getField() {
        return this.field;
    }
    
    public Object getValue() {
        return this.value;
    }
    
    public String getAlias() {
        return null != this.alias ? this.alias : this.field;
    }
    
    public String getOperator() {
        return this.op;
    }
}