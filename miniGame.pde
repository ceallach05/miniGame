import java.lang.reflect.*;
import java.util.*;
Player PlayerP;
Bar Bar;
Boolean IsAlive = false;
ArrayList<Button> Buttons = new ArrayList<Button>();
Object Main = this;
int score;




void setup() {
  windowResizable(true);
  size(200, 200);
  windowResize(width, height);
  PlayerP = new Player( width/2, height - 30);
  Bar = new Bar();
  DeathScreen();
}

void draw() {
  windowResize(width, height);
  if (IsAlive) {
    background(#D3D3D3);
    UpdateGame();
  } else {
    DeathScreen();
  }
}

void keyPressed() {
  if (key == 'a' || keyCode == LEFT) {
    PlayerP.decreaseX();
  }
  if (key == 'd' || keyCode == RIGHT) {
    PlayerP.increaseX();
  }
}

void mousePressed() {
  for (Button btn : Buttons) {
    btn.collision();
  }
}

void UpdateGame() {
  if (Bar.BarY >= height) {
    Bar.ResetBar();
  }
  PlayerP.setY(height -30);
  PlayerP.update();
  Bar.moveBar();
  drawScore();
}

void drawScore() {
  fill(#000000);
  textAlign(CENTER, CENTER);
  text(score, 20, (height*0.1));
  fill(#ffffff);
}

void DeathScreen() {
  background(#D3D3D3);
  fill(#000000);
  textAlign(CENTER, CENTER);
  text("Game over", width/2, (height/2) - 50);
  text(score, 20, (height*0.1));
  fill(#ffffff);
  new Button(width/2, height/2, 70, 30, "restart", "Restart");
  new Button((width/2), (height/2) + 50, 70, 30, "quit", "Quit");
}

void restart() {
  IsAlive = true;
  score = 0;
  Bar.ResetBar();
}

void quit() {
  exit();
}








class Bar {
  PShape BarShapeL, BarShapeR;
  public int BarY, BarShapeLW, BarShapeRW;

  Bar() {
    BarShapeLW = getRandomInt(height -20);
    BarY = 0;
    drawBar();
  }

  void ResetBar() {
    BarShapeLW = getRandomInt(height -20);
    BarY = 0;
    drawBar();
  }

  void drawBar() {
    BarShapeRW = width - (BarShapeLW + 30);
    BarShapeR = createShape(RECT, BarShapeLW + 30, BarY, BarShapeRW, 10);
    BarShapeL = createShape(RECT, 0, BarY, BarShapeLW, 10);
    shape(BarShapeL);
    shape(BarShapeR);
  }

  int getRandomInt(float top) {
    return(int(random(top)));
  }

  void moveBar() {
    delay(200);
    BarY += 5;
    drawBar();
    collision();
  }

  void collision() {
    int PX = PlayerP.getX();
    int PY = PlayerP.getY();
    if (PY - 10 <= (BarY + 10) && (PY + 10) >= BarY) {
      if ((PX -10) >= (BarShapeLW - 2) && PX + 10 <= (BarShapeLW + 32)) {
      } else {
        IsAlive = false;
      }
    }
    if (PY == BarY) {
      score += 1;
      println(score);
    }
  }
}




class Player {

  PShape PlayerShape;
  int PlayerX, PlayerY;

  Player(int PX, int PY) {
    PlayerX = PX;
    PlayerY = PY;
    PlayerShape = createShape(ELLIPSE, PlayerX, PlayerY, 20, 20);
    update();
  }

  void setX(int X) {
    PlayerX = X;
    PlayerShape = createShape(ELLIPSE, PlayerX, PlayerY, 20, 20);
    update();
  }

  void setY(int Y) {
    PlayerY = Y;
    PlayerShape = createShape(ELLIPSE, PlayerX, PlayerY, 20, 20);
    update();
  }

  void increaseX() {
    if (PlayerX < width - 10) {
      PlayerX += 10;
    }
    PlayerShape = createShape(ELLIPSE, PlayerX, PlayerY, 20, 20);
  }

  void decreaseX() {
    if (PlayerX > 10) {
      PlayerX -= 10;
    }
    PlayerShape = createShape(ELLIPSE, PlayerX, PlayerY, 20, 20);
  }

  void update() {
    shape(PlayerShape);
  }

  int getX() {
    return(PlayerX);
  }
  int getY() {
    return(PlayerY);
  }
}















// Why no native buttons in Processing ?

class Button {
  int PosX, PosY, Height, Width;
  String Click, Name;
  java.lang.reflect.Method method;
  Method click;

  Button(int X, int Y, int W, int H, String C, String N) {
    PosX = X - (W/2);
    PosY = Y - (H/2);
    Height =H;
    Width =W;
    Click = C;
    Name = N;
    rect(PosX, PosY, Width, Height);
    fill(#000000);
    textAlign(CENTER, CENTER);
    text(Name, PosX + (Width/2), PosY + (Height/2));
    fill(#ffffff);

    try {
      click = Main.getClass().getDeclaredMethod(Click);
    }
    catch(Exception e) {
      println("1 " + e);
    }
    Buttons.add(this);
  }

  void collision() {
    if (mouseX >= this.PosX && mouseX <= (this.PosX + Width)) {
      if (mouseY >= this.PosY && mouseY <= (this.PosY + Height)) {
        try {
          click.invoke(Main);
        }
        catch(Exception e) {
          println("2 " + e);
        }
      }
    }
  }
}
