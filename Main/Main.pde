

int screen;
int difficulty; //0 = low/medium mass, 1 = high mass

int numBackgroundStars;
int[] backgroundStarX;
int[] backgroundStarY;

int textTimer;

Atom a;

Text texts1[] = {new Text("Your star began in a nebula, where a cloud of dust and gas",400,200),new Text("was squeezed together by density compressional waves.",400,250),new Text("Over time, gravitational heating helped your star reach",400,300),new Text("a temperature of 1,000 degrees Kelvin.",400,350),new Text("Now fusion can begin.",400,400)};
  
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
    if(mouseX >= 300 && mouseX <= 500 && mouseY >= 350 && mouseY <= 450){
      stroke(255,226,0);
      strokeWeight(10);
    }
    textAlign(CENTER);
    fill(67,0,255);
    rectMode(CENTER);
    rect(400,400,200,100);
    textSize(80);
    fill(255);
    text("The Life Cycle of a Star:",400,150);
    text("Fusion Minigame",400,225);
    fill(0);
    textSize(40);
    text("Play!",400,412);
    if(mousePressed && mouseX >= 300 && mouseX <= 500 && mouseY >= 350 && mouseY <= 450){
      screen = 1;
    }
  } else if(screen == 1){
    textTimer++;
    displayBackground();
    textAlign(CENTER);
    textSize(25);
    fill(255);
    for(int i = 0; i <texts1.length; i++){
      if(i == 0){
        texts1[0].displayText();
      }else if(texts1[(i-1)].checkDone()){
        texts1[i].displayText();        
      }
    }
    textSize(20);
    text("Press the space bar to continue",400,500);
  } else if(screen == 2){
    displayBackground();
    noStroke();
    textSize(80);
    textAlign(CENTER);
    text("Choose a difficulty:",400,150);
    fill(0,227,255);
    rect(400,325,200,100);
    fill(255,0,0);
    rect(400,475,200,100);
    fill(0);
    textSize(20);
    text("High Mass Star",400,310);
    text("(Hard)",400,340);
    if(mouseX >= 300 && mouseX <= 500 && mouseY >= 275 && mouseY <= 375){
      stroke(255,226,0);
      strokeWeight(10);
      fill(0,227,255);
      rect(400,325,200,100);
      fill(0);
      textSize(20);
      text("High Mass Star",400,310);
      text("(Hard)",400,340);
      if(mousePressed == true){
        difficulty = 1;
        screen = 3;
      }
    }
    text("Low/Medium Mass Star",400,460);
    text("(Easy)",400,490);
    if(mouseX >= 300 && mouseX <= 500 && mouseY >= 425 && mouseY <= 525){
      stroke(255,226,0);
      strokeWeight(10);
      fill(255,0,0);
      rect(400,475,200,100);
      fill(0);
      textSize(20);
      text("Low/Medium Mass Star",400,460);
      text("(Easy)",400,490);
      if(mousePressed){
        difficulty = 0;
        screen = 3;
      }
    }
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
  noStroke();
  for(int i = 0; i<numBackgroundStars; i++){
    rect(backgroundStarX[i],backgroundStarY[i],5,5);
  }
}
