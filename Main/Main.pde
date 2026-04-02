

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
    background(0);
    textAlign(CENTER);
    textSize(25);
    fill(255);
    text("Your star began in a nebula, where a cloud of dust and gas",400,150);
    text("were squeezed together by density compressional waves.",400,225);
    text("Over time, gravitational heating helped your star reach",400,300);
    text("a temperature of 1,000 degrees Kelvin.",400,375);
    text("now fusion can begin.",400,450);
    textSize(20);
    text("Press the space bar to continue",400,500);
  } else if(screen == 2){
    text("Now you must choose a path:",400,300);
    fill(0,227,255);
    rect(400,400,200,100);
    fill(255,0,0);
    rect(400,575,200,100);
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
  if(key == ' '){
    if(screen == 1){
      screen = 2;
    }
  }
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
