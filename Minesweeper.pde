

import de.bezier.guido.*;
int NUM_ROWS = 40;
int NUM_COLS = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0; r<buttons.length; r++)
        for(int c=0; c<buttons[r].length; c++)
            buttons[r][c] = new MSButton(r,c);
        
    
    
    setBombs();
}
public void setBombs()
{
    for(int b = 0; b<250; b++){
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[row][col]))
            bombs.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            if(!buttons[r][c].isClicked() == true && !bombs.contains(buttons[r][c]))
                return false;
  return true;
}

public void displayLosingMessage()
{
    for(int r=0; r<NUM_ROWS; r++)
        for(int c=0; c<NUM_COLS; c++)
            if(!buttons[r][c].isClicked() && bombs.contains(buttons[r][c]))
             {   
                buttons[r][c].marked = false;
                buttons[r][c].clicked = true;
                buttons[20][17].setLabel("L");
                buttons[20][18].setLabel("o");
                buttons[20][19].setLabel("s");
                buttons[20][20].setLabel("e");
                buttons[20][21].setLabel("r");
                buttons[20][22].setLabel("!");
            }
}
public void displayWinningMessage()
{
    buttons[20][15].setLabel("C");
    buttons[20][16].setLabel("o");
    buttons[20][17].setLabel("n");
    buttons[20][18].setLabel("g");
    buttons[20][19].setLabel("r");
    buttons[20][20].setLabel("a");
    buttons[20][21].setLabel("t");
    buttons[20][22].setLabel("s");
    buttons[20][23].setLabel("!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if (mouseButton == LEFT && label.equals(""))
        {
          clicked = true;
        }
        if (mouseButton == RIGHT && label.equals("") && !clicked)
        {
            marked = !marked;
        }
        else if (bombs.contains(this) && !marked)
        {
            displayLosingMessage();
        }
        else if (countBombs(r, c) > 0)
        {
            label = "" + countBombs(r, c);
        }
        else
        {
            if (isValid(r,c-1) && !buttons[r][c-1].isClicked())
                buttons[r][c-1].mousePressed();
            if (isValid(r,c+1) && !buttons[r][c+1].isClicked())
                buttons[r][c+1].mousePressed();
            if(isValid(r-1,c) && !buttons[r-1][c].isClicked())
                buttons[r-1][c].mousePressed();
            if(isValid(r+1,c) && !buttons[r+1][c].isClicked())
                buttons[r+1][c].mousePressed();
            if(isValid(r-1,c-1) && !buttons[r-1][c-1].isClicked())
                buttons[r-1][c-1].mousePressed();
            if(isValid(r+1,c-1) && !buttons[r+1][c-1].isClicked())
                buttons[r+1][c-1].mousePressed();
            if(isValid(r+1,c+1) && !buttons[r+1][c+1].isClicked())
                buttons[r+1][c+1].mousePressed();
            if(isValid(r-1,c+1) && !buttons[r-1][c+1].isClicked())
                buttons[r-1][c+1].mousePressed();
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(#FAF142);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 170 );
        stroke(200);
        rect(x, y, width, height);
        fill(0);
        textSize(10);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r>=0&&r<NUM_ROWS&&c>=0&&c<NUM_COLS)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int r=row-1;r<row+2;r++)
            for(int c=col-1;c<col+2;c++)
                if(isValid(r,c))
                    if(bombs.contains(buttons[r][c]))
                        numBombs++;
        if(bombs.contains(buttons[row][col]))
            numBombs--;
        return numBombs;
    }
}

public void keyPressed(){
    if(key == 'r')
        for(int r = 0; r < NUM_ROWS; r++)
            for(int c = 0; c < NUM_COLS; c++)
            {
              bombs.remove(buttons[r][c]);
              buttons[r][c].setLabel("");
              buttons[r][c].marked = false;
              buttons[r][c].clicked = false;
            }
    setBombs(); 
    }


