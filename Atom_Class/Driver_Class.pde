

int screen;
int difficulty; //0 = low/medium mass, 1 = high mass

int numBackgroundStars;
int[] backgroundStarX;
int[] backgroundStarY;

void setup(){
  size(800,800);
  screen = 0;
  numBackgroundStars = 100;
  backgroundStarX = new int[numBackgroundStars];
  backgroundStarY = new int[numBackgroundStars];
  initBackground();
}

void draw(){
  if(screen == 0){
    displayBackground();
    textAlign(CENTER);
    textSize(80);
    fill(255);
    text("The Life Cycle of a Star:",400,150);
    text("Fusion Minigame",400,225);
    fill(0,255,0);
    rectMode(CENTER);
    rect(400,400,200,100);
    fill(0);
    textSize(40);
    text("Play!",400,412);
  } else if(screen == 1){
    displayBackground();
    textAlign(CENTER);
    textSize(40);
    fill(255);
  }
}

void mousePressed(){
  if(screen == 0){
    if(mouseX >= 200 && mouseX <= 600 && mouseY >= 300 && mouseY <= 500){
      screen = 1;
    }
  }
}

void keyPressed(){
  
}

void initBackground(){
  for(int i = 0; i<numBackgroundStars; i++){
    backgroundStarX[i] = (int)random(0,801);
    backgroundStarY[i] = (int)random(0,801);
  }
}

void displayBackground(){
  background(0);
  fill(255);
  for(int i = 0; i<numBackgroundStars; i++){
    rect(backgroundStarX[i],backgroundStarY[i],5,5);
  }
}
