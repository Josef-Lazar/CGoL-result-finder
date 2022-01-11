/**
 * Josef Lazar
 * 12/24/2021
 * CMSC 210
 * Final_Project
 * Collaboration Statement:
   
     I used the following websites:
     
     https://www.tutorialkart.com/java/how-to-check-if-arraylist-is-empty-in-java/
     https://www.conwaylife.com/wiki/Spaceship
     https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
     https://en.wikipedia.org/wiki/Spaceship_(cellular_automaton)
     https://en.wikipedia.org/wiki/Glider_(Conway%27s_Life)
     https://beltoforion.de/en/game_of_life/
  
     https://processing.org/reference/for.html
     https://processing.org/reference/color_.html
     https://processing.org/reference/Array.html
     https://processing.org/reference/String.html
     https://processing.org/reference/keyCode.html
     https://processing.org/reference/max_.html
     https://processing.org/reference/ArrayList.html
     https://processing.org/reference/Array.html
     https://processing.org/reference/strconvert_.html
     https://processing.org/reference/String.html
     https://processing.org/reference/append_.html
     https://processing.org/reference/int.html
     https://processing.org/reference/IntList.html
   
 */




GameOfLife GoL;
ArrayList<boolean[][]> allGrids;
ArrayList<GameOfLifeMap> allGridsmap;
ArrayList<GameOfLifeMap> emptyGridsmap;
ArrayList<GameOfLifeMap> stillLifeGridsmap;
ArrayList<GameOfLifeMap> oscillatorGridsmap;
ArrayList<GameOfLifeMap> bigGridsmap;
ArrayList<GameOfLifeMap> spaceShipGridsmap;
boolean[][] initialGrid;
int initialGridColumns = 3;
int initialGridRows = 3;
int gridIndex;
int step = 0;

GameOfLifeMap testMap;
boolean skip = false;
int mapIndex;
Button All;
Button Empty;
Button StillLifes;
Button Oscillators;
Button Bigs;
Button SpaceShips;
Button[] buttons;
int buttonIndex = 0;
color regularColor = color(255, 150, 150);
color mouseOnColor = color(255, 200, 200);
color pressedColor = color(150, 50, 50);
color mouseOnSelected = color(200, 130, 130);
color selectedColor = color(200, 100, 100);
boolean mPressed;


void setup() {
  
  frameRate(100);
  size(1000, 1000);
  background(255);
  
  GoL = new GameOfLife(5, 5);
  allGrids = new ArrayList<boolean[][]>();
  allGridsmap = new ArrayList<GameOfLifeMap>();
  emptyGridsmap = new ArrayList<GameOfLifeMap>();
  stillLifeGridsmap = new ArrayList<GameOfLifeMap>();
  oscillatorGridsmap = new ArrayList<GameOfLifeMap>();
  bigGridsmap = new ArrayList<GameOfLifeMap>();
  spaceShipGridsmap = new ArrayList<GameOfLifeMap>();
  initialGrid = new boolean[initialGridColumns][initialGridRows];
  
  testMap = new GameOfLifeMap(new boolean[1][1], new boolean[1][1], "test", 1);
  mapIndex = 0;
  
  All = new Button("All", 80, 850, 50, 50, regularColor, mouseOnColor, pressedColor, mouseOnSelected, selectedColor, allGridsmap);
  Empty = new Button("Empty", 180, 850, 90, 50, regularColor, mouseOnColor, pressedColor, mouseOnSelected, selectedColor, emptyGridsmap);
  StillLifes = new Button("Still Lifes", 320, 850, 110, 50, regularColor, mouseOnColor, pressedColor, mouseOnSelected, selectedColor, stillLifeGridsmap);
  Oscillators = new Button("Oscillators", 480, 850, 120, 50, regularColor, mouseOnColor, pressedColor, mouseOnSelected, selectedColor, oscillatorGridsmap);
  Bigs = new Button("Bigs", 650, 850, 65, 50, regularColor, mouseOnColor, pressedColor, mouseOnSelected, selectedColor, bigGridsmap);
  SpaceShips = new Button("Space Ships", 765, 850, 140, 50, regularColor, mouseOnColor, pressedColor, mouseOnSelected, selectedColor, spaceShipGridsmap);
  buttons = new Button[6];
  buttons[0] = All;
  buttons[1] = Empty;
  buttons[2] = StillLifes;
  buttons[3] = Oscillators;
  buttons[4] = Bigs;
  buttons[5] = SpaceShips;
  
  //putts every possible combination of live and dead cells in a 3 by 3 grid into allGrids
  allGrids.add(initialGrid); //the first grid, which is empty, should be in the list, but the 'if' statement in the 'for' loop bellow filters it out
  for (;GoL.cellsAlive(initialGrid) != initialGridColumns * initialGridRows;) {
    if (GoL.columnAlive(initialGrid, 0) && GoL.rowAlive(initialGrid, 0)) { //enures that combination where cells are positioned the same relative to each other, but in a different location on the grid aren't repeated in the ArrayList 
      allGrids.add(initialGrid);
    }
    initialGrid = nextGrid(initialGrid);
  }
  allGrids.add(initialGrid); //the last grid, where all the cells are alive, should also be in the list, but it triggers the condition that terminates the 'for' loop above
  
  gridIndex = 0;
  GoL.grid = allGrids.get(gridIndex);
  GoL.display();
  
}



void draw() {
  
  background(255);
  
  if (gridIndex < allGrids.size() && !skip) { //showing the grids simulate
    
    GoL.evolve();
    step++;
    GoL.display();
    fill(0, 100, 255);
    textSize(25);
    text("Press 's' to view maps", 50, 50);
    if ((GoL.oscillationg() || GoL.gridW() > 150 || GoL.gridH() > 150 || (GoL.gridW() < 10 && GoL.gridH() < 10 && GoL.spaceShip())) && gridIndex < allGrids.size()) {
      if (GoL.cellsAlive(GoL.grid) == 0) {
        All.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "empty", step));
        Empty.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "empty", step));
      } else if (GoL.stillLife()) {
        All.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "still life", step));
        StillLifes.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "still life", step));
      } else if (GoL.oscillationg()) {
        All.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "oscillator", step));
        Oscillators.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "oscillator", step));
      } else if (GoL.gridW() > 150 || GoL.gridH() > 150) {
        All.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "big", step));
        Bigs.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "big", step));
      } else if (GoL.spaceShip()) {
        All.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "space ship", step));
        SpaceShips.addMap(new GameOfLifeMap(allGrids.get(gridIndex), GoL.grid, "space ship", step));
      }
      GoL.catalog.clear();
      GoL.catalogMinimalized.clear();
      gridIndex++;
      if (gridIndex < allGrids.size()) {
        GoL.grid = allGrids.get(gridIndex);
        println(gridIndex);
        step = 0;
      }
    }
    
  }
  
  else { //showing the output of each grid
    
    //testMap.displayGrid(allGrids.get(200), 100, 100, 300, 300);
    //testMap.display();
    if (buttons[buttonIndex].map.isEmpty()) {
      textSize(25);
      text("Grid 0 out of 0", 160, 750);
    } else {
      buttons[buttonIndex].map.get(mapIndex).display();
      text("Grid " + str(mapIndex + 1) + " out of " + buttons[buttonIndex].map.size(), 160, 750);
    }
    textSize(25);
    fill(0, 100, 255);
    if (All.map.size() == allGrids.size() /*All.map.size() % 2 == 0*/) {
      text("Use arrow keys to view maps", 550, 50);
    } else {
      text("Press 'c' to continue simulation", 50, 50);
      text("Use arrow keys to view maps", 550, 50);
    }
    fill(0);
    textSize(20);
    text("total: " + All.map.size(), 75, 90);
    text("empty: " + Empty.map.size(), 75, 120);
    text("still lives: " + StillLifes.map.size(), 75, 150);
    text("oscillators: " + Oscillators.map.size(), 75, 180);
    text("bigs: " + Bigs.map.size(), 75, 210);
    text("space ships: " + SpaceShips.map.size(), 75, 240);
    
    All.display();
    Empty.display();
    StillLifes.display();
    Oscillators.display();
    Bigs.display();
    SpaceShips.display();
    
  }
  
}



void deselectButtons() {
  for (Button b : buttons) {
    b.deselect();
  }
}



//takes a boolean grid as inpute and returns a list of booleans where the rows from the grid are stacked up next to each other 
boolean[] gridToRow(boolean[][] inputedGrid) {
  
  boolean[] outputRow = new boolean[inputedGrid.length * inputedGrid[0].length];
  for (int column = 0; column < inputedGrid.length; column++) {
    for (int row = 0; row < inputedGrid[0].length; row++) {
      outputRow[row * inputedGrid.length + column] = inputedGrid[column][row];
    }
  }
  return outputRow;
  
}



//takes a list of booleans and cuts it up into rows that form a grid. Each row conatins gridW elements
boolean[][] rowToGrid(boolean[] inputedRow, int gridW) {
  
  boolean[][] outputGrid = new boolean[gridW][inputedRow.length / gridW];
  for (int column = 0; column < outputGrid.length; column++) {
    for (int row = 0; row < outputGrid[0].length; row++) {
      outputGrid[column][row] = inputedRow[row * outputGrid.length + column];
    }
  }
  return outputGrid;
  
}



//check out the "next row function" picture in the folder to see how it works 
boolean[] nextRow(boolean[] inputedRow) {
  
  if (!inputedRow[inputedRow.length - 1]) { //if the last cell in the row is not alive
    int lastCell = -1; //assuming there are no living cells in the row
    for (int i = 0; i < inputedRow.length; i++) {
      if (inputedRow[i]) {
        lastCell = i;
      }
    }
    
    if (lastCell == -1) { //if there are no living cells in the row
      inputedRow[0] = true;
      return inputedRow; //makes the first cell of the row alive and returns it
    } else { //if the last cell in the row is not alive and there are living cells in the row
      inputedRow[lastCell] = false;
      inputedRow[lastCell + 1] = true;
      return inputedRow; //moves the last cell one position to the right and returns the row
    }
  }
  
  else { //if the last cell in the row is alive
    boolean allAlive = true; //assuming all the cells in the row are alive
    for (int i = 0; i < inputedRow.length; i++) {
      if (!inputedRow[i]) {
        allAlive = false;
      }
    }
    
    if (allAlive) {
      return inputedRow; //if all the cells in the row are alive, then the row is returned unchanged
    }
    
    else { //if there is at least one dead cell in the row
      int cellsAtEnd = 0;
      for(int i = inputedRow.length - 1; inputedRow[i]; i--) { //goes through the row from the end, increasing cellsAtEnd for each living cell and killing it, until it finds a cell that is already dead
        cellsAtEnd++;
        inputedRow[i] = false;
      }
      int lastCell = -1; //assuming there are no living cells left in the row
      for (int i = 0; i < inputedRow.length; i++) {
        if (inputedRow[i]) {
          lastCell = i; //sets lastCell to the index of the cell that is closses to the end of the row
        }
      }
      
      if (lastCell == -1) { //if there are no living cells left
        for (int i = 0; i <= cellsAtEnd; i++) {
          inputedRow[i] = true; //the amount of cells that were at the end + 1 is added to the front of the row
        }
        return inputedRow;
      }
      
      else { //if there were living cells appart from those pressed against the end of the row
        inputedRow[lastCell] = false;
        lastCell++;
        inputedRow[lastCell] = true; //moves the cell closes to the end one element to the right
        for (int i = 0; i < cellsAtEnd; i++) {
          inputedRow[lastCell + 1 + i] = true; //moves the cells that were bunched up against the end of the row to the spaces to the right of the cell nearnest to the end of the row
        }
        return inputedRow;
      }
    }
  }
  
}


//works like the nextRow function but on grids
boolean[][] nextGrid(boolean[][] inputedGrid) {
  
  int w = inputedGrid.length;
  boolean[] row = gridToRow(inputedGrid);
  row = nextRow(row);
  inputedGrid = rowToGrid(row, w);
  return inputedGrid;
  
}



//checks if the mouse is within the inputed coordinates
boolean mouseOn(int x, int y, int w, int h) {
  if (x <= mouseX && mouseX <= x + w && y < mouseY && mouseY <= y + h) return true;
  return false;
}


void mousePressed() {
  mPressed = true;
}

void mouseReleased() {
  mPressed = false;
}


void keyPressed() {
  
  if (key == 'k') {
    //int column = int(random(0, GoL.gridW()));
    //int row = int(random(0, GoL.gridH()));
    //GoL.kill(column, row);
    GoL.catalog.clear();
  } else if (key == 'r') {
    //int column = int(random(0, GoL.gridW()));
    //int row = int(random(0, GoL.gridH()));
    //GoL.revive(column, row);
    //GoL.catalog.clear();
  } else if (key == 'a') {
    //GoL.grid = GoL.contractGridToAdjust(GoL.grid);
    //GoL.grid = GoL.minimalize(GoL.grid);
  } else if (key == 'e') {
    //GoL.evolve();
  } else if (key == 'o') {
    if (GoL.oscillationg()) {
      println("oscillationg!");
    } else {
      println("not oscillationg");
    }
  } else if (key == 's') {
    //if (GoL.spaceShip()) {
    //  println("space ship!");
    //} else {
    //  println("no space ship");
    //}
    skip = true;
  } else if (key == 'c') {
    skip = false;
  } else if (key == 'm') {
    //GoL.grid = GoL.minimalize(GoL.grid);
  } else if (key == '1') {
    //if (GoL.gridW(GoL.grid) < 5) {
    //  GoL.grid = GoL.getGrid(GoL.grid, 0, 0, 5, GoL.gridH(GoL.grid));
    //}
    //if (GoL.gridH(GoL.grid) < 5) {
    //  GoL.grid = GoL.getGrid(GoL.grid, 0, 0, GoL.gridW(GoL.grid), 5);
    //}
    //GoL.grid[1][1] = true;
    //GoL.grid[2][1] = true;
    //GoL.grid[3][1] = true;
    //GoL.grid[1][2] = true;
    //GoL.grid[2][3] = true;
  } else if (key == '2') {
    //if (GoL.gridW(GoL.grid) < 7) {
    //  GoL.grid = GoL.getGrid(GoL.grid, 0, 0, 7, GoL.gridH(GoL.grid));
    //}
    //if (GoL.gridH(GoL.grid) < 6) {
    //  GoL.grid = GoL.getGrid(GoL.grid, 0, 0, GoL.gridW(GoL.grid), 6);
    //}
    //GoL.grid[2][1] = true;
    //GoL.grid[5][1] = true;
    //GoL.grid[1][2] = true;
    //GoL.grid[1][3] = true;
    //GoL.grid[5][3] = true;
    //GoL.grid[1][4] = true;
    //GoL.grid[2][4] = true;
    //GoL.grid[3][4] = true;
    //GoL.grid[4][4] = true;
  } else if (key == '3') {
    //if (GoL.gridW(GoL.grid) < 10) {
    //  GoL.grid = GoL.getGrid(GoL.grid, 0, 0, 10, GoL.gridH(GoL.grid));
    //}
    //if (GoL.gridH(GoL.grid) < 14) {
    //  GoL.grid = GoL.getGrid(GoL.grid, 0, 0, GoL.gridW(GoL.grid), 14);
    //}
    //GoL.grid[2][1] = true;
    //GoL.grid[3][1] = true;
    //GoL.grid[6][1] = true;
    //GoL.grid[7][1] = true;
    //GoL.grid[4][2] = true;
    //GoL.grid[5][2] = true;
    //GoL.grid[4][3] = true;
    //GoL.grid[5][3] = true;
    //GoL.grid[1][4] = true;
    //GoL.grid[3][4] = true;
    //GoL.grid[6][4] = true;
    //GoL.grid[8][4] = true;
    //GoL.grid[1][5] = true;
    //GoL.grid[8][5] = true;
    //GoL.grid[1][7] = true;
    //GoL.grid[8][7] = true;
    //GoL.grid[2][8] = true;
    //GoL.grid[3][8] = true;
    //GoL.grid[6][8] = true;
    //GoL.grid[7][8] = true;
    //GoL.grid[3][9] = true;
    //GoL.grid[4][9] = true;
    //GoL.grid[5][9] = true;
    //GoL.grid[6][9] = true;
    //GoL.grid[4][11] = true;
    //GoL.grid[5][11] = true;
    //GoL.grid[4][12] = true;
    //GoL.grid[5][12] = true;
  } else if (key == ' ') {
    //GoL.grid = nextGrid(GoL.grid);
  } else if (key == 'd') {
    println(GoL.gridW() + " " + GoL.gridH());
  } else if (key == CODED) {
    if (keyCode == RIGHT) {
      mapIndex++;
      if (mapIndex > buttons[buttonIndex].map.size() - 1) mapIndex = 0;
      //GoL.grid = GoL.expandRight(GoL.grid);
      //GoL.grid = GoL.contractRight(GoL.grid);
      //GoL.grid = GoL.contractRightColumnToAdjust(GoL.grid);
    } else if (keyCode == LEFT) {
      mapIndex--;
      if (mapIndex < 0) mapIndex = buttons[buttonIndex].map.size() - 1;
      //GoL.grid = GoL.expandLeft(GoL.grid);
      //GoL.grid = GoL.contractLeft(GoL.grid);
      //GoL.grid = GoL.contractLeftColumnToAdjust(GoL.grid);
    } else if (keyCode == UP) {
      //GoL.grid = GoL.expandUp(GoL.grid);
      //GoL.grid = GoL.contractUp(GoL.grid);
      //GoL.grid = GoL.contractTopRowToAdjust(GoL.grid);
    } else if (keyCode == DOWN) {
      //GoL.grid = GoL.expandDown(GoL.grid);
      //GoL.grid = GoL.contractDown(GoL.grid);
      //GoL.grid = GoL.contractBottomRowToAdjust(GoL.grid);
    }
  }
  
}
