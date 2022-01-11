class GameOfLifeMap {
  
  boolean[][] gridInput;
  boolean[][] gridOutput;
  String type;
  boolean[][] displayGridOutput;
  int evolutions;
  int countDown;
  
  GameOfLifeMap(boolean[][] gridInput_, boolean[][] gridOutput_, String type_, int evolutions_) {
    
    gridInput = gridInput_;
    gridOutput = gridOutput_;
    type = type_;
    if ((type.equals("oscillator") || type.equals("space ship"))) {
      displayGridOutput = GoL.minimalize(gridOutput);
    }
    evolutions = evolutions_;
    countDown = 100;
    
  }
  
  
  
  void display() {
    
    //stating the type and how many evolutions it took
    fill(0);
    textSize(25);
    text(type, 425, 200);
    text("it took " + evolutions + " evolutions", 425, 250);
    
    //drawing the first grid
    fill(0, 100, 255);
    stroke(0);
    strokeWeight(2);
    rect(45, 295, 410, 410);
    displayGrid(gridInput, 50, 300, 400, 400);
    
    //drawing the second grid
    fill(0, 100, 255);
    stroke(0);
    strokeWeight(2);
    rect(545, 295, 410, 410);
    if ((type.equals("oscillator") || type.equals("space ship"))) {
      if (countDown < 1) {
        displayGridOutput = GoL.evolve(displayGridOutput);
        if (type.equals("space ship")) displayGridOutput = GoL.minimalize(displayGridOutput);
        countDown = 100;
      }
      countDown--;
      displayGrid(displayGridOutput, 550, 300, 400, 400);
    } else {
      displayGrid(gridOutput, 550, 300, 400, 400);
    }
    
    //arrow between grids
    stroke(0);
    strokeWeight(5);
    line(475, 500, 525, 500);
    line(500, 475, 525, 500);
    line(500, 525, 525, 500);
    
  }
  
  
  //displays an inputed grid in the locations that are apecified with x, y, w and h
  void displayGrid(boolean[][] inputedGrid, int x, int y, int w, int h) {
    
    int gW = inputedGrid.length;
    int gH = inputedGrid[0].length;

    //variables that calculate and store how wide each cell should be
    float cellW = w / gW;
    float cellH = h / gH;
    
    if (cellW > 10 && cellH > 10) {
      strokeWeight(1);
      stroke(100);
    } else {
      noStroke();
    }

    for (int column = 0; column < gW; column++) {
      for (int row = 0; row < gH; row++) {
        fill(inputedGrid[column][row] ? 255 : 0); //if the cell is dead, it is collored black, else it is colored white
        rect(x + column * cellW, y + row * cellH, cellW, cellH);
      }
    }
    
  }
  
}
