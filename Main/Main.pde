

int screen;
int difficulty; //0 = low/medium mass, 1 = high mass

int numBackgroundStars;
int[] backgroundStarX;
int[] backgroundStarY;

int textTimer;

Atom a;

Text textOne = new Text("Over time, gravitational heating helped your star reach",400,300);
Text textTwo = new Text("a temperature of 1,000 degrees Kelvin.",400,350);

void setup(){
  size(800,800);
  screen = 0;
  textTimer = 0;
  numBackgroundStars = 100;
  backgroundStarX = new int[numBackgroundStars];
  backgroundStarY = new int[numBackgroundStars];
  initBackground();
  a = new Atom(0,1,pv(1,0),pv(0,0), 30);
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
    if(mousePressed && mouseX >= 200 && mouseX <= 600 && mouseY >= 300 && mouseY <= 500){
      screen = 1;
    }
  } else if(screen == 1){
    textTimer++;
    background(0);
    textAlign(CENTER);
    textSize(25);
    fill(255);
    if(textOne.displayText()){
      textTwo.displayText();
    }
    //text("Over time, gravitational heating helped your star reach",400,300);
    //text("a temperature of 1,000 degrees Kelvin.",400,375);
    text("now fusion can begin.",400,450);
    textSize(20);
    text("Press the space bar to continue",400,500);
  } else if(screen == 2){
    displayBackground();
    text("Choose a difficulty:",400,300);
    fill(0,227,255);
    rect(400,400,200,100);
    fill(255,0,0);
    rect(400,575,200,100);
  } else if(screen == 3){
    background(0);
    a.update();
    a.display();
  }
}

void mousePressed(){ //<>//
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
