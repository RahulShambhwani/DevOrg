public class Qus4 {
    List<Object> stack=new List<Object>();
    Integer top=0;
    public void push(Object val){
        stack.add(val);
        top++;
    }
    public void pop(){
        stack.remove(top);
        top--;
    }
    public void displayStackValues(){
        for(Object obj: stack)
            System.debug(obj);
    }
    
}