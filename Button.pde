class Button {
  
  String banner;
  int x, y, w, h;
  color regularColor;
  color mouseOnColor;
  color pressedColor;
  color mouseOnSelectedColor;
  color selectedColor;
  boolean selected;
  boolean reset;
  
  ArrayList<GameOfLifeMap> map;
  
  
  Button(String banner_, int x_, int y_, int w_, int h_, color regularColor_, color mouseOnColor_, color pressedColor_, color mouseOnSelectedColor_, color selectedColor_, ArrayList<GameOfLifeMap> map_) {
    
    banner = banner_;
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    regularColor = regularColor_;
    mouseOnColor = mouseOnColor_;
    pressedColor = pressedColor_;
    mouseOnSelectedColor = mouseOnSelectedColor_;
    selectedColor = selectedColor_;
    selected = false;
    reset = true;
    
    map = new ArrayList<GameOfLifeMap>(map_);
    
  }
  
  
  
  void display() {
    
    if (mouseOn(x, y, w, h) && mPressed) {
      fill(pressedColor);
      if (reset) {
        if (selected) {
          deselectButtons();
        } else {
          deselectButtons();
          selected = true;
          for (int i = 0; i < buttons.length; i++) {
            if (buttons[i].selected) buttonIndex = i;
          }
          mapIndex = 0;
        }
        reset = false;
      }
    } else if (mouseOn(x, y, w, h) && selected) {
      fill(mouseOnSelectedColor);
      reset = true;
    } else if (mouseOn(x, y, w, h)) {
      fill(mouseOnColor);
      reset = true;
    } else if (selected) {
      fill(selectedColor);
      reset = true;
    } else {
      fill(regularColor);
      reset = true;
    }
    
    stroke(0);
    strokeWeight(3);
    rect(x, y, w, h);
    
    fill(0);
    textSize(20);
    text(banner, x + 10, y + h / 2 + 10);
    
  }
  
  
  
  void addMap(GameOfLifeMap m) {
    map.add(m);
  }
  
  
  void deselect() {
    selected = false;
  }
  
  
}
