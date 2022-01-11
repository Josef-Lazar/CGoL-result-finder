class GameOfLife {

  //stores IntLists that are the columns of the grid
  boolean[][] grid;

  //used when adding rows and columns to the grid
  boolean[][] newGrid;

  //used for evolving the game
  boolean[][] nextGrid;
  int neighbors;

  //used for tracking past states of the game
  ArrayList<boolean[][]> catalog;
  ArrayList<boolean[][]> catalogMinimalized;



  GameOfLife(int columns, int rows) {

    //setting up the initial grid
    grid = new boolean[columns][rows];
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        grid[column][row] = false;
      }
    }

    //used for trackig past states of the game
    catalog = new ArrayList<boolean[][]>();
    catalogMinimalized = new ArrayList<boolean[][]>();
  }



  //draws the grid
  void display() {

    if (gridW() < 100 && gridH() < 100) {
      strokeWeight(1);
      stroke(100);
    } else {
      noStroke();
    }

    //variables that calculate and store how wide each cell should be
    float cellW = width / gridW();
    float cellH = height / gridH();

    for (int column = 0; column < gridW(); column++) {
      for (int row = 0; row < gridH(); row++) {
        fill(grid[column][row] ? 255 : 0); //if the cell is dead, it is collored black, else it is colored white
        rect(column * cellW, row * cellH, cellW, cellH);
      }
    }
  }



  //makes the game of life move to the next generation
  void evolve() {
    
    grid = evolve(grid);
    catalog.add(grid);
    if (catalog.size() > 20) catalog.remove(0);
    catalogMinimalized.add(minimalize(grid));
    if (catalogMinimalized.size() > 15) catalogMinimalized.remove(0);
    
  }
  
  
  boolean[][] evolve(boolean[][] inputedGrid) {
    
    inputedGrid = deadEdge(inputedGrid);
    
    //sets nextGrid to the same parameters as the current grid 
    nextGrid = new boolean[gridW(inputedGrid)][gridH(inputedGrid)];
    for (int column = 0; column < gridW(inputedGrid); column++) {
      for (int row = 0; row < gridH(inputedGrid); row++) {
        if (countNeighbors(inputedGrid, column, row) == 3 || (countNeighbors(inputedGrid, column, row) == 2 && inputedGrid[column][row])) {
          nextGrid[column][row] = true;
        } else {
          nextGrid[column][row] = false;
        }
      }
    }
    nextGrid = deadEdge(nextGrid);
    
    return nextGrid;
    
  }



  //returns the amount of neighbors next to the cell at the inputed coordinates 
  int countNeighbors(int column, int row) {

    countNeighbors(grid, column, row);
    return neighbors;
    
  }
  

  //returns the amount of neighbors next to the cell at the inputed coordinates 
  int countNeighbors(boolean[][] inputedGrid, int column, int row) {
    
    neighbors = 0;
    neighbors += getCell(inputedGrid, column - 1, row - 1) ? 1 : 0;
    neighbors += getCell(inputedGrid, column, row - 1) ? 1 : 0;
    neighbors += getCell(inputedGrid, column + 1, row - 1) ? 1 : 0;
    neighbors += getCell(inputedGrid, column - 1, row) ? 1 : 0;
    neighbors += getCell(inputedGrid, column + 1, row) ? 1 : 0;
    neighbors += getCell(inputedGrid, column - 1, row + 1) ? 1 : 0;
    neighbors += getCell(inputedGrid, column, row + 1) ? 1 : 0;
    neighbors += getCell(inputedGrid, column + 1, row + 1) ? 1 : 0;
    return neighbors;
    
  }
  
  
  //returns the subection of the inputed grid marked out by the inputed cooridenates. if the coordinates go beyond the inputed grid, then the outlying cells are filled in as dead
  boolean[][] getGrid(boolean[][] inputedGrid, int x, int y, int w, int h) {
    
    boolean[][] outputGrid = new boolean[max(w - x, 1)][max(h - y, 1)];
    for (int column = 0; column < gridW(outputGrid); column++) {
      for (int row = 0; row < gridH(outputGrid); row++) {
        outputGrid[column][row] = getCell(inputedGrid, column + x, row + y);
      }
    }
    
    return outputGrid;
    
  }



  //returns true if there is a living cell in the right most column, else returns false
  boolean columnAlive(boolean[][] inputedGrid, int column) {
    for (int row = 0; row < gridH(inputedGrid); row++) {
      if (inputedGrid[column][row]) {
        return true;
      }
    }
    return false;
  }


  //returns true if there is a living cell in the top row of the grid, else returns false
  boolean rowAlive(boolean[][] inputedGrid, int row) {
    for (int column = 0; column < gridW(inputedGrid); column++) {
      if (inputedGrid[column][row]) {
        return true;
      }
    }
    return false;
  }
  
  
  
  //returns the amount of living cells in a grid
  int cellsAlive(boolean[][] inputedGrid) {
    
    int cells = 0;
    for (int column = 0; column < gridW(inputedGrid); column++) {
      for (int row = 0; row < gridH(inputedGrid); row++) {
        if (inputedGrid[column][row]) {
          cells++;
        }
      }
    }
    
    return cells;
    
  }
  
  
  
  //returns true if all the edge cells are dead, and there is at least one living cell in the rows and columns just within the dead outer layer; else it returns false
  boolean minimalized(boolean[][] inputedGrid) {
    if (gridW(inputedGrid) >= 3 && gridH(inputedGrid) >= 3) {
      if (!columnAlive(inputedGrid, 0) && columnAlive(inputedGrid, 1) &&
          columnAlive(inputedGrid, gridW(inputedGrid) - 2) && !columnAlive(inputedGrid, gridW(inputedGrid) - 1) &&
          !rowAlive(inputedGrid, 0) && rowAlive(inputedGrid, 1) &&
          rowAlive(inputedGrid, gridH(inputedGrid) - 2) && !rowAlive(inputedGrid, gridH(inputedGrid) - 1)) {
        return true;
        } else {
          return false;
        }
    } else if (!columnAlive(inputedGrid, 0) && !columnAlive(inputedGrid, gridW(inputedGrid) - 1) &&
               !rowAlive(inputedGrid, 0) && !rowAlive(inputedGrid, gridH(inputedGrid) - 1)) {
      return true;
    } else {
      //println("column 1:     " + columnAlive(inputedGrid, 0));
      //println("column 2:     " + columnAlive(inputedGrid, 1));
      //println("column n - 1: " + columnAlive(inputedGrid, gridW(inputedGrid) - 2));
      //println("column n:     " + columnAlive(inputedGrid, gridW(inputedGrid) - 1));
      //println("row 1:        " + rowAlive(inputedGrid, 0));
      //println("row 2:        " + rowAlive(inputedGrid, 1));
      //println("row n - 1:    " + rowAlive(inputedGrid, gridH(inputedGrid) - 2));
      //println("row n:        " + rowAlive(inputedGrid, gridH(inputedGrid) - 1));
      return false;
    }
    
  }
  
  
  //minimalizes an inputed grid an returns it
  boolean[][] minimalize(boolean[][] inputedGrid) {
    
    for (int i = 0; i < gridW(inputedGrid); i++) {
      inputedGrid = deadEdge(inputedGrid);
      inputedGrid = contractRightColumnToAdjust(inputedGrid);
      inputedGrid = deadEdge(inputedGrid);
      inputedGrid = contractLeftColumnToAdjust(inputedGrid);
      inputedGrid = deadEdge(inputedGrid);
      inputedGrid = contractTopRowToAdjust(inputedGrid);
      inputedGrid = deadEdge(inputedGrid);
      inputedGrid = contractBottomRowToAdjust(inputedGrid);
      inputedGrid = deadEdge(inputedGrid);
    }
    return inputedGrid;
    
  }



  //if there are any living cells on the edge of the inputed grid, expandGridToAdjust() will expand the inputed grid until there are only dead cells along the grids edge
  boolean[][] deadEdge(boolean[][] inputedGrid) {

    if (columnAlive(inputedGrid, gridW(inputedGrid) - 1)) {
      inputedGrid = expandRight(inputedGrid);
    }
    if (columnAlive(inputedGrid, 0)) {
      inputedGrid = expandLeft(inputedGrid);
    }
    if (rowAlive(inputedGrid, 0)) {
      inputedGrid = expandUp(inputedGrid);
    }
    if (rowAlive(inputedGrid, gridH(inputedGrid) - 1)) {
      inputedGrid = expandDown(inputedGrid);
    }

    return inputedGrid;
    
  }


  //subracts right columns grom the inputed grid until the right most cell is on the edge of the grid
  boolean[][] contractRightColumnToAdjust(boolean[][] inputedGrid) {
    for (int column = gridW(inputedGrid) - 1; cellsAlive(inputedGrid) == cellsAlive(getGrid(inputedGrid, 0, 0, column, gridH(inputedGrid))) && column >= 1; column--) {
      inputedGrid = getGrid(inputedGrid, 0, 0, column, gridH(inputedGrid));
    }
    return inputedGrid;
  }


  //subracts the left column of the inputed grid if all its cells are dead
  boolean[][] contractLeftColumnToAdjust(boolean[][] inputedGrid) {
    for (int column = gridW(inputedGrid) - 1; cellsAlive(inputedGrid) == cellsAlive(getGrid(inputedGrid, 1, 0, column, gridH(inputedGrid))) && column >= 2; column--) {
      inputedGrid = getGrid(inputedGrid, 1, 0, column, gridH(inputedGrid));
    }
    return inputedGrid;
  }


  //subracts the top row of the inputed grid if all its cells are dead
  boolean[][] contractTopRowToAdjust(boolean[][] inputedGrid) {
    for (int row = gridH(inputedGrid) - 1; cellsAlive(inputedGrid) == cellsAlive(getGrid(inputedGrid, 0, 1, gridW(inputedGrid), row)) && row >= 2; row--) {
      inputedGrid = getGrid(inputedGrid, 0, 1, gridW(inputedGrid), row);
    }
    return inputedGrid;
  }


  //subracts the bottom row from the inputed grid if all its cells are dead, and does it over and over again until there is at least one living cell in the bottom row
  boolean[][] contractBottomRowToAdjust(boolean[][] inputedGrid) {
    for (int row = gridH(inputedGrid) - 1; cellsAlive(inputedGrid) == cellsAlive(getGrid(inputedGrid, 0, 0, gridW(inputedGrid), row)) && row >= 1; row--) {
      inputedGrid = getGrid(inputedGrid, 0, 0, gridW(inputedGrid), row);
    }
    return inputedGrid;
  }





  //adds a new column to the right side of the grid, whose cells are all dead
  boolean[][] expandRight(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, 0, 0, gridW(inputedGrid) + 1, gridH(inputedGrid));
  }


  //adds a new column to the left side of the grid, whose cells are all dead
  boolean[][] expandLeft(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, -1, 0, gridW(inputedGrid), gridH(inputedGrid));
  }


  //adds a new row to the top of the grid, whose cells are all dead
  boolean[][] expandUp(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, 0, -1, gridW(inputedGrid), gridH(inputedGrid));
  }


  //adds a new row to the bottom of the grid by appending each column by 0
  boolean[][] expandDown(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, 0, 0, gridW(inputedGrid), gridH(inputedGrid) + 1);
  }


  //subtracts a column from the right side of the inputed grid
  boolean[][] contractRight(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, 0, 0, gridW(inputedGrid) - 1, gridH(inputedGrid));
  }


  //subtracts a column from the left side of the inputed grid
  boolean[][] contractLeft(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, 1, 0, gridW(inputedGrid), gridH(inputedGrid));
  }


  //subtracts a row from the top of the inputed grid
  boolean[][] contractUp(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, 0, 1, gridW(inputedGrid), gridH(inputedGrid));
  }


  //subtracts a row from the bottom of the inputed grid
  boolean[][] contractDown(boolean[][] inputedGrid) {
    return getGrid(inputedGrid, 0, 0, gridW(inputedGrid), gridH(inputedGrid) - 1);
  }


  
  //checks if two grids are the same
  boolean gridsEqual(boolean[][] grid1, boolean[][] grid2) {
    
    if (gridW(grid1) != gridW(grid2) || gridH(grid1) != gridH(grid2)) {
      return false;
    } else {
      for (int column = 0; column < gridW(grid1); column++) {
        for (int row = 0; row < gridH(grid2); row++) {
          if (grid1[column][row] != grid2[column][row]) {
            return false;
          }
        }
      }
      return true;
    }
    
  }
  
  
  
  //checks if the current state evolves into itself
  boolean stillLife() {
    
    if (gridsEqual(minimalize(grid), minimalize(evolve(grid)))) {
      return true;
    }
    return false;
    
  }
  
  
  //checks if current state has appeared in the past
  boolean oscillationg() {
    
    for (int catalogIndex = 0; catalogIndex < catalog.size() - 1; catalogIndex++) {
      if (gridsEqual(grid, catalog.get(catalogIndex))) {
        return true;
      }
    }
    return false;
    
  }


  //checks if current state has appeared in the past
  boolean oscillationg2() {
    
    int w = gridW();
    int h = gridH();
    boolean[][] cGrid;
    int cw;
    int ch;
    
    boolean match;
    for (int catalogIndex = 0; catalogIndex < catalog.size() - 1; catalogIndex++) { //check current grid against every grid in the catalog
      cGrid = catalog.get(catalogIndex);
      cw = gridW(cGrid);
      ch = gridH(cGrid);
      if (cw == w && ch == h) { //checks if the grids are the same size
        match = true; //assumes the grids match and then lookes for differences
        for (int column = 0; column < w; column++) {
          for (int row = 0; row < h; row++) {
            if (cGrid[column][row] != grid[column][row]) {
              match = false;
            }
          }
        }
        if (match) { //if no difference is found between the current grid and some grid in the past, then the function returnes true
          return true;
        }
      }
    }
    return false; //if there is no grid in the catalog that is the same as the current grid, then the function returns false
  }
  
  
  
  boolean spaceShip() {
    
    boolean[][] mGrid = minimalize(grid);
    for (int catalogIndex = 0; catalogIndex < catalogMinimalized.size() - 1; catalogIndex++) { //check current grid against every grid in the catalog
      if (gridsEqual(mGrid, catalogMinimalized.get(catalogIndex))) {
        return true;
      }
    }
    return false;
    
  }
  
  
  //checks if the current state is a spcaship by checking if it has appeared in the past at a different location, and that it is not an oscillator 
  boolean spaceShip2() {
    
    boolean[][] mGrid = minimalize(grid);
    boolean[][] cmGrid;
    int mGridW = gridW(mGrid);
    int mGridH = gridH(mGrid);
    int cmGridW;
    int cmGridH;
    
    boolean match;
    for (int catalogIndex = 0; catalogIndex < catalogMinimalized.size() - 1; catalogIndex++) { //check current grid against every grid in the catalog
      cmGrid = catalogMinimalized.get(catalogIndex);
      cmGridW = gridW(cmGrid);
      cmGridH = gridH(cmGrid);
      if (cmGridW == mGridW && cmGridH == mGridH) { //checks if the grids are the same size
        match = true; //assumes the grids match and then lookes for differences
        for (int column = 0; column < mGridW; column++) {
          for (int row = 0; row < mGridH; row++) {
            if (cmGrid[column][row] != mGrid[column][row]) {
              match = false;
            }
          }
        }
        if (match && !oscillationg()) { //if no difference is found between the current grid and some grid in the past, then the function returnes true
          return true;
        }
      }
    }
    return false; //if there is no grid in the catalog that is the same as the current grid, then the function returns false
  }



  //checks if the current state is a spaceship by checking if it has appeared in the past at a different location
  boolean spaceShip3() {
    
    boolean match;
    for (int catalogIndex = 0; catalogIndex < catalog.size() - 1; catalogIndex++) { //checks for each grid in the catalog
      if (gridW(minimalize(grid)) == gridW(minimalize(catalog.get(catalogIndex))) && gridH(minimalize(grid)) == gridH(minimalize(catalog.get(catalogIndex)))) { //if it is the same size as the current grid
      match = true;
        for (int column = 0; column < gridW(minimalize(grid)); column++) {
          for (int row = 0; row < gridH(minimalize(grid)); row++) {
            if (minimalize(grid)[column][row] != minimalize(catalog.get(catalogIndex))[column][row]) {
              match = false;
            }
          }
        }
        if (match && !oscillationg()) {
          return true;
        }
      }
    }
    return false;
    
  }



  //makes the cell at x & y become alive 
  void revive(int column, int row) {
    grid[column][row] = true;
  }

  //makes the cell at x & y become dead
  void kill(int column, int row) {
    grid[column][row] = false;
  }

  //makes the cell at x & y on the next grid become alive
  void reviveNext(int column, int row) {
    nextGrid[column][row] = true;
  }

  //makes the cell at x & y on the next grid become dead
  void killNext(int column, int row) {
    nextGrid[column][row] = false;
  }

  //like grid[column][row], but returns flase if column or row are out of bounds
  boolean getCell(boolean[][] inputedGrid, int column, int row) {
    if (0 <= column && column < gridW(inputedGrid) && 0 <= row && row < gridH(inputedGrid)) {
      return inputedGrid[column][row];
    } else {
      return false;
    }
  }


  //returns the amount of columns in the grid
  int gridW() {
    return grid.length;
  }

  //returns the amount of columns in some inputed grid
  int gridW(boolean[][] inputedGrid) {
    return inputedGrid.length;
  }

  //returns the amount of rows in the grid
  int gridH() {
    return grid[0].length;
  }

  //returns the amount of rows in some inputed grid
  int gridH(boolean[][] inputedGrid) {
    return inputedGrid[0].length;
  }



}
