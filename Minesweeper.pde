import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(500, 500);
    textAlign(CENTER,CENTER);
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        buttons[i][j] = new MSButton(i, j);
    mines = new ArrayList <MSButton>();    
    setMines();
}
public void setMines()
{
    for(int i = 0; i < (NUM_ROWS*NUM_COLS)/10; i++){
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      while(mines.contains(buttons[row][col])){
        row = (int)(Math.random()*(NUM_ROWS));
        col = (int)(Math.random()*(NUM_COLS));
      }
      mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
    if(isLost() == true)
        displayLosingMessage();    
}
public boolean isWon()
{
    int count  = 0;
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        if(buttons[i][j].clicked == true && buttons[i][j].flagged == false)
          count++;
    if(count == NUM_ROWS*NUM_COLS-mines.size())
      return true;
    return false;
}
public boolean isLost()
{
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        if(buttons[i][j].clicked == true && mines.contains(buttons[i][j]) == true)
          return true;
    return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j].setLabel("");
        if(mines.contains(buttons[i][j]) && buttons[i][j].clicked == false)
          buttons[i][j].mousePressed();
          }
    }
    noLoop();
}
public void displayWinningMessage()
{
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        buttons[i][j].setLabel(":)");
    noLoop();
}
public boolean isValid(int row, int col)
  {
    if (row>=0 && row<NUM_ROWS && col>=0 && col<NUM_COLS)
      return true;
    else
      return false;
  }
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i <= row+1; i++)
      for(int j = col-1; j <= col+1; j++)
        if(isValid(i, j))
          if(mines.contains(buttons[i][j]))
            numMines++;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged,shown;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 500/NUM_COLS;
        height = 500/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(mouseButton == CENTER)
          return; 
      if(mouseButton == LEFT){
          clicked = true;
          shown = true;
        }
       if(mouseButton == RIGHT && shown == false){
          flagged = !flagged;
          if(flagged == false)
            clicked = false;
        }
        else if(flagged == true);
        else if(mines.contains( this ));
          //displayLosingMessage();
        else if(countMines(myRow, myCol) > 0 && flagged == false)
          setLabel(countMines(myRow, myCol));
        else{  
          for(int i = myRow-1; i <= myRow+1; i++)
            for(int j = myCol-1; j <= myCol+1; j++)
              if(isValid(i, j))
                if(!(mines.contains(buttons[i][j])) && buttons[i][j].clicked == false && buttons[i][j].flagged == false)
                  buttons[i][j].mousePressed(); 
                }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
