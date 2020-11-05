#include <stdio.h>
#include <stdlib.h>

struct element{
    char symbol;
    int x;
    int y;
    int time;
};

struct node {
    struct element *elem;
    struct node *next;
};

struct queue {
    struct node *first, *last;
};

void enqueue(struct queue *q, char c, int x, int y, int t) {
    struct node *new_node = malloc(sizeof(struct node));
    if (!new_node) {
        perror("Error: ");
        return;
    }
    struct element *elem = malloc(sizeof(struct element));
    if(!elem) {
        perror("Error: ");
        return;
    }
    new_node->elem = elem;

    new_node->elem->symbol = c;
    new_node->elem->x = x;
    new_node->elem->y = y;
    new_node->elem->time = t;
    new_node->next = NULL;

    if (q->last)
        q->last->next = new_node;
    else
        q->first = new_node;
    q->last = new_node;
}

struct element *dequeue(struct queue *q) {
    if (q->first == NULL) return NULL; //-1;

    struct element *ret = q->first->elem;

    struct node *tmp = q->first;

    q->first = q->first->next;
    if (!q->first) {
        q->last = NULL;
    }
    tmp->next = NULL;
    free(tmp);

    return ret;
}

int main(int argc, char **argv) 
{ 
    if (argc != 2) 
    {	
        printf("Usage: ./doomsday text_file\n");
        return -1;
    }

    FILE *fp;	
    int i=0, j=0, k=0, l=0, time=-1, t=0, doomsday=0;
    char c, buff[1000][1000],positive_grid[1000][1000], negative_grid[1000][1000];
    struct queue *q;
    q = malloc(sizeof(struct queue));
    q->first = q->last = NULL;

    fp = fopen(argv[1], "r");
    if (fp == NULL)
    {
        perror("Error: ");
        return -1;
    }

    c = getc(fp) ;
    while (c != EOF)
    {
        buff[i][j] = c;

        if (c == '+' || c == '-'){
            enqueue(q, c, i, j, t);
            //printf("%c %d %d %d\n", c,i,j,t);
            if(c == '+')
                positive_grid[i][j] = '+';
            else if(c == '-')
                negative_grid[i][j] = '-';
        }

        j++;
        c = getc(fp);

        if(j == 1000)
        {
            i++;
            k=i;
            l=j;
            j=0;
        }

        if(c == '\n')
        {
            i++;
            k=i;
            l=j;
            j=0;
            while(c == '\n')
                c = getc(fp);
        }
    }	

    /*	for(i=0; i<k; i++)
        {
        for(j=0; j<l; j++)
        {	
        printf("%c", buff[i][j]);e
        }
        printf("\n");
        } */

    int up=0, down=0, right=0, left=0;

    struct element *elem;
    elem = dequeue(q);

    while(elem)
    {
        c = elem->symbol;
        i = elem->x;
        j = elem->y;
        t = elem->time;

        if((doomsday) && (time < t)){
            //printf("Broke loop\n");
            break;
        }

        if(((c == '-') && (buff[i][j] == '+')) || ((c == '+') && (buff[i][j] == '-')))
        {
            buff[i][j] = '*';
            if (!doomsday) {
                doomsday = 1; 	
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
                        enqueue(q, c, up, j, t+1);
                    }
                    if ((c == '-') && (negative_grid[up][j] != '-')) {
                        negative_grid[up][j] = '-';
                        enqueue(q, c, up, j, t+1);
                    }
                    //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,up,j,t+1);
                }

                if ((down <= k-1) && (buff[down][j] != 'X') && (buff[down][j] != c)) {
                    if ((c == '+') && (positive_grid[down][j] != '+')) {
   			positive_grid[down][j] = '+';	
                        enqueue(q, c, down, j, t+1);
                    }
                    if ((c == '-') && (negative_grid[down][j] != '-')) {
                        negative_grid[down][j] = '-';
                        enqueue(q, c, down, j, t+1);
                    }
                    //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,down,j,t+1);
                }

                if ((right <= l-1) && (buff[i][right] != 'X') && (buff[i][right] != c)){
                    if ((c == '+') && (positive_grid[i][right] != '+')) {
   			positive_grid[i][right] = '+';	
                        enqueue(q, c, i, right, t+1);
                    }
                    if ((c == '-') && (negative_grid[i][right] != '-')) {
                        negative_grid[i][right] = '-';
                        enqueue(q, c, i, right, t+1);
                    }
                    //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,up,j,t+1);
                }

                if ((left >= 0) && (buff[i][left] != 'X') && (buff[i][left] != c)){
                    if ((c == '+') && (positive_grid[i][left] != '+')) {
   			positive_grid[i][left] = '+';	
                        enqueue(q, c, i, left, t+1);
                    }
                    if ((c == '-') && (negative_grid[i][left] != '-')) {
                        negative_grid[i][left] = '-';
                        enqueue(q, c, i, left, t+1);
                    }
                    //printf("%c (%d,%d) -> (%d,%d) %d\n", c,i,j,up,j,t+1);
                }

                //		free(elem);
            }
        }
        free(elem);
        elem = dequeue(q);
    }

    free(elem);

    if(doomsday)
        printf("%d\n", time);
    else
        printf("the world is saved\n");

    for(i=0; i<k; i++)
    {
        for(j=0; j<l; j++)
        {	
            printf("%c", buff[i][j]);
        }
        printf("\n");
    }

    fclose(fp);

    //destroy(queue);
    return 0;
} 
