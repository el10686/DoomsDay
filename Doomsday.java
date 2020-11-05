import java.io.*;

public class Doomsday
{
    
    public static void main(String[] args) throws FileNotFoundException, IOException{
        Queue<Node> Q=new Queue<>();
                FileReader fr = new FileReader(args[0]);
                BufferedReader sc = new BufferedReader(fr);

                boolean doomsday = false;
        int i=0, j=0, k=0, l=0, time=-1, t=0; 
                String line;
        
                char c;
                char[][] buff = new char[1000][1000];
                char[][] positive_grid = new char[1000][1000];
                char[][] negative_grid = new char[1000][1000];
        while ((line = sc.readLine()) != null)
        {
                        for(int chr=0;chr < line.length();chr++)
                        {
                            c = line.charAt(chr);
                            buff[i][chr] = c;
                            if (c == '+' || c == '-')
                            {
                                    Node newNode = new Node(i,chr,t,c);
                                    Q.enqueue(newNode);

                                    if(c == '+')
                                            positive_grid[i][chr] = '+';
                                    else if(c == '-')
                                            negative_grid[i][chr] = '-';
                            }
                            
                        }
                        i++;  
                        l = line.length();

        }
                k=i;
        /*
        for(i=0; i<k; i++)
                {
                    for(j=0; j<l; j++)
                    {	
                        System.out.print(buff[i][j]);
                    }
                    System.out.print("\n");
                }
                */
        int up=0, down=0, right=0, left=0;
        
        Node elem;
                elem = Q.dequeue();
                
        while(elem != null)
        {
            c = elem.getsymbol();
            i = elem.getx();
            j = elem.gety();
            t = elem.gettime();

            if((doomsday) && (time < t)){
                //printf("Broke loop\n");
                break;
            }

            if(((c == '-') && (buff[i][j] == '+')) || ((c == '+') && (buff[i][j] == '-')))
            {
                buff[i][j] = '*';
                if (!doomsday) {
                    doomsday = true; 	
                    time = t;
                }
            }
            else if (buff[i][j] != '*') {
                if ((time == -1) || (t <= time)) {
                    buff[i][j] = c;

                    up = i - 1;
                    down = i + 1;
                    right = j + 1;
                    left = j - 1;

                    if ((up >= 0) && (buff[up][j] != 'X') && (buff[up][j] != c)) {
                        if ((c == '+') && (positive_grid[up][j] != '+')) {
                            positive_grid[up][j] = '+';	
                            Node newNode = new Node(up,j,t+1,c);
                            Q.enqueue(newNode);
                        }
                        if ((c == '-') && (negative_grid[up][j] != '-')) {
                            negative_grid[up][j] = '-';
                            Node newNode = new Node(up,j,t+1,c);
                            Q.enqueue(newNode);
                        }
                        //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,up,j,t+1);
                    }

                    if ((down <= k-1) && (buff[down][j] != 'X') && (buff[down][j] != c)) {
                        if ((c == '+') && (positive_grid[down][j] != '+')) {
                            positive_grid[down][j] = '+';
                            Node newNode = new Node(down,j,t+1,c);
                            Q.enqueue(newNode);
    
                        }
                        if ((c == '-') && (negative_grid[down][j] != '-')) {
                            negative_grid[down][j] = '-';
                            Node newNode = new Node(down,j,t+1,c);
                            Q.enqueue(newNode);
                            
                        }
                        //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,down,j,t+1);
                    }

                    if ((right <= l-1) && (buff[i][right] != 'X') && (buff[i][right] != c)){
                        if ((c == '+') && (positive_grid[i][right] != '+')) {
                            positive_grid[i][right] = '+';	
                            Node newNode = new Node(i,right,t+1,c);
                            Q.enqueue(newNode);
                        }
                        if ((c == '-') && (negative_grid[i][right] != '-')) {
                            negative_grid[i][right] = '-';
                            Node newNode = new Node(i,right,t+1,c);
                            Q.enqueue(newNode);
                        }
                        //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,up,j,t+1);
                    }

                    if ((left >= 0) && (buff[i][left] != 'X') && (buff[i][left] != c)){
                        if ((c == '+') && (positive_grid[i][left] != '+')) {
                            positive_grid[i][left] = '+';
                            Node newNode = new Node(i,left,t+1,c);
                            Q.enqueue(newNode);
                        }
                        if ((c == '-') && (negative_grid[i][left] != '-')) {
                            negative_grid[i][left] = '-';
                            Node newNode = new Node(i,left,t+1,c);
                            Q.enqueue(newNode);
                        }
                        //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,up,j,t+1);
                    }

                    //		free(elem);
                }
            }
            elem = Q.dequeue();
        }
            
        if(doomsday)
            System.out.println(time);
        else
            System.out.println("the world is saved");

        for(i=0; i<k; i++)
        {
            for(j=0; j<l; j++)
            {	
                System.out.print(buff[i][j]);
            }
            System.out.print("\n");
        }
    }    
}        
