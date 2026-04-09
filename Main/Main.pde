import java.util.ArrayList;

int screen;
int difficulty; //0 = low/medium mass, 1 = high mass

int numBackgroundStars;
int[] backgroundStarX;
int[] backgroundStarY;

int aCount = 100;
float diameter = 20;
ArrayList<Atom> atoms;
ArrayList<Integer> atomDestroy;
ArrayList<PVector> atomMake;
ArrayList<Element> fuseable;

float pressure;
float pressureRate;

int textTimer;
int cutsceneTimer;

PFont font;

Text texts1[] = {new Text("Your star began in a nebula, where a cloud of dust and gas",400,200),new Text("was squeezed together by density compressional waves.",400,250),new Text("Over time, gravitational heating helped your star reach",400,300),new Text("a temperature of 1,000 degrees Kelvin.",400,350),new Text("Now fusion can begin.",400,400)};
  
void setup(){
  size(800,800);
  screen = 0;
  textTimer = 0;
  numBackgroundStars = 100;
  backgroundStarX = new int[numBackgroundStars];
  backgroundStarY = new int[numBackgroundStars];
  initBackground();
  font = createFont("Pixelon.otf",16);
  textFont(font);
    
  atoms = new ArrayList<Atom>();
  for(int i = 0; i < aCount; i++){
    float dir = random(2*PI);
    atoms.add(new Atom(Element.H,pv(0.5*cos(dir),0.5*sin(dir)),pv(random(-width/2,width/2),random(-height/2,height/2)),diameter));
  }  
  atomDestroy = new ArrayList<Integer>();
  atomMake = new ArrayList<PVector>();
  fuseable  = new ArrayList<Element>();
  fuseable.add(Element.H);
  fuseable.add(Element.He);
  fuseable.add(Element.C);
  fuseable.add(Element.Na);
  fuseable.add(Element.Si);
  pressure = 100;
  pressureRate = 1;
}

void draw(){
  if(screen == 0){
    displayBackground();
    textAlign(CENTER);
    fill(67,0,255);
    rectMode(CENTER);
    rect(400,400,200,100);
    textSize(60);
    fill(255);
    text("The Life Cycle of a Star:",400,150);
    text("Fusion Minigame",400,225);
    fill(0);
    textSize(40);
    text("Play!",400,412);
    if(mouseX >= 300 && mouseX <= 500 && mouseY >= 350 && mouseY <= 450){
      stroke(255,226,0);
      strokeWeight(10);
      fill(67,0,255);
      rectMode(CENTER);
      rect(400,400,200,100);
      textSize(45);
      fill(0);
      text("Play!",400,412);
    }
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
    textSize(60);
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
      textSize(22);
      text("High Mass Star",400,310);
      text("(Hard)",400,340);
      if(mousePressed == true){
        difficulty = 1;
        cutsceneTimer = millis();
        screen = 3;
      }
    }
    textSize(15);
    text("Low/Medium Mass Star",400,460);
    textSize(20);
    text("(Easy)",400,490);
    if(mouseX >= 300 && mouseX <= 500 && mouseY >= 425 && mouseY <= 525){ 
      stroke(255,226,0);
      strokeWeight(10); //<>// //<>//
      fill(255,0,0);
      rect(400,475,200,100);
      fill(0);
      textSize(16);
      text("Low/Medium Mass Star",400,460);
      textSize(22);
      text("(Easy)",400,490);
      if(mousePressed){
        difficulty = 0; //<>//
        cutsceneTimer = millis();
        screen = 3;
        pressureRate = 0.5; //half rate because protostar is basically tutorial
      }
    }
  } else if(screen == 3){
    if(millis()-cutsceneTimer <= 8000){ //last number is in milliseconds, change as needed
      background(0);
      fill(Math.min(255*8-(millis()-cutsceneTimer)*255/1000,255));
      textSize(60);
      textAlign(CENTER);
      text("Protostar Phase",400,400);
      textSize(20); //<>// //<>//
      text("Throw hydrogen atoms at each other to fuse them.",400,450);
      text("Don't let your pressure meter expire, or gravity will crush you!",400,500);
    } else {
      background(0);
      rectMode(CORNER);
      fill(255);
      rect(200,100,400,50);   
      fill(0,255,0);
      rect(200,100,(pressure/100)*400,50);
      for(int a = 0; a < aCount; a++){
        for(int b = 0; b < aCount; b++){
          if(a == b){continue;}
          if(atoms.get(a).collision(atoms.get(b)) && !atomDestroy.contains(a) && !atomDestroy.contains(b) && atoms.get(a).e == atoms.get(b).e && fuseable.contains(atoms.get(a).e)){
            atomMake.add(pv(a,b));
            atomDestroy.add(a);
            atomDestroy.add(b);
          }
        }
      }
      for(int i = 0; i < atomMake.size(); i++) {
        Atom a = atoms.get(0);
        Atom b = atoms.get(0);
        try{
          a = atoms.get((int)atomMake.get(i).x);
          b = atoms.get((int)atomMake.get(i).y);
        } catch (Exception e){
          atomDestroy.remove(atomDestroy.indexOf((int)atomMake.get(i).x));
          atomDestroy.remove(atomDestroy.indexOf((int)atomMake.get(i).y));
          atomMake.remove(i);
          continue;
        }
        switch(a.e){
          case H:
            atoms.add(new Atom(Element.He, pv(0,0),a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
            pressure += 8;
            break;
          case He:
            atoms.add(new Atom(Element.C, pv(0,0),a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
            pressure += 10;
            break;
          case C:
            atoms.add(new Atom(Element.Na, pv(0,0),a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
            pressure += 16;
            break;
          case Na:
            atoms.add(new Atom(Element.Si, pv(0,0),a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
            pressure += 32;
            break;
          case Si:
            atoms.add(new Atom(Element.Fe, pv(0,0),a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
            pressure += 64;
            break;
          default:
            break;
        }
        
        
        atomDestroy.remove(atomDestroy.indexOf((int)atomMake.get(i).x));
        atomDestroy.remove(atomDestroy.indexOf((int)atomMake.get(i).y));
        atoms.remove(a);
        atoms.remove(b);
        atomMake.remove(i);
        i--;
        aCount--;
      }
      
      for(int a = 0; a < aCount; a++){
        atoms.get(a).update();
      }
      for(int a = 0; a < aCount; a++){
        atoms.get(a).display();
      }
      fill(255);
      textSize(10);
      text("Hand-crafted, Artisianal",mouseX,mouseY-10); 
      text("Partical Accelerator",mouseX,mouseY);
      if(pressure > 100){
        pressure = 100;
      }
      pressure -= (pressure/frameRate/30)*pressureRate;
      println(pressure);
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
  for(int i = 0; i<numBackgroundStars;i++){
    backgroundStarX[i] = (int)random(0,801);
    backgroundStarY[i] = (int)random(0,801);
  }
}

void displayBackground(){
  background(0);
  fill(255);
  noStroke();
  for(int i = 0; i<numBackgroundStars; i++){
    ellipse(backgroundStarX[i],backgroundStarY[i],5,5);
  }
}
