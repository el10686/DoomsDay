public class Node{
    private int x,y,time;
    private char symbol;
    
    public Node (int x,int y,int time,char symbol){
        this.x=x;
        this.y=y;
        this.time=time;
        this.symbol=symbol;
    }
    
    public int getx(){
        return x;
    }
    
    public int gety(){
        return y;
    }
    
    public int gettime(){
        return time;
    }
    
    public char getsymbol(){
        return symbol;
    }
}
