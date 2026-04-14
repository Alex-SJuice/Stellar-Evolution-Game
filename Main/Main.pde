// >w<
import java.util.ArrayList;

int screen;
int difficulty; //-1 low, 0 medium, 1 = high mass

int numBackgroundStars;
int[] backgroundStarX;
int[] backgroundStarY;

int aCount = 100;
float diameter = 20;
float strength;
ArrayList<Atom> atoms;
ArrayList<Integer> atomDestroy;
ArrayList<PVector> atomMake;
ArrayList<Element> fuseable;

float pressure;
float pressureRate;
boolean refill = true;
boolean threshhold = false;
int stage = 0;

boolean skip;

int textTimer;
int cutsceneTimer;

PFont font;

Text texts1[] = {new Text("Your star began in a nebula, where a cloud of dust and gas", 400, 200), new Text("was squeezed together by density compressional waves", 400, 250), new Text("to form a protostar. Over time, gravitational heating", 400, 300), new Text("helped your star reach a temperature of 15 million", 400, 350), new Text("degrees Kelvin. Now fusion can begin.", 400, 400)};
Text texts2[] = {new Text("As your star runs out of hydrogen,",400,200),new Text("the core is no longer able to fuse. Gravity crushes the core,",400,250),new Text("making it hot enough to fuse helium.",400,300)};
Text texts2Low[] = {new Text("You are now a red giant.",400,350)};
Text texts2High[] = {new Text("You are now a red supergiant.",400,350)};

void setup() {
  size(800, 800);
  screen = 0;
  textTimer = 0;
  numBackgroundStars = 100;
  backgroundStarX = new int[numBackgroundStars];
  backgroundStarY = new int[numBackgroundStars];
  initBackground();
  font = createFont("Pixelon.otf", 16);
  textFont(font);
  skip = false;
}

void draw() {
  if (screen == 0) {
    displayBackground();
    textAlign(CENTER);
    fill(67, 0, 255);
    rectMode(CENTER);
    rect(400, 400, 200, 100);
    textSize(60);
    fill(255);
    text("The Life Cycle of a Star:", 400, 150);
    text("Fusion Minigame", 400, 225);
    fill(0);
    textSize(40);
    text("Play!", 400, 412);
    if (mouseX >= 300 && mouseX <= 500 && mouseY >= 350 && mouseY <= 450) {
      stroke(67,0,255);
      strokeWeight(10);
      fill(67, 0, 255);
      rectMode(CENTER);
      rect(400, 400, 200, 100);
      textSize(45);
      fill(0);
      text("Play!", 400, 412);
    }
    if (mousePressed && mouseX >= 300 && mouseX <= 500 && mouseY >= 350 && mouseY <= 450) {
      screen = 1;
    }
  } else if (screen == 1) {
    textTimer++;
    displayBackground();
    textAlign(CENTER);
    textSize(25);
    fill(255);
    runText(texts1);
    textSize(20);
    text("Press the space bar to continue", 400, 500);
  } else if (screen == 2) {
    displayBackground();
    noStroke();
    textSize(60);
    textAlign(CENTER);
    text("Choose a difficulty:", 400, 150);
    fill(0, 227, 255);
    rect(400, 325, 200, 100);
    fill(250,222, 3);
    rect(400, 475, 200, 100);
    fill(250,0,0);
    rect(400,625,200,100);
    fill(0);
    textSize(20);
    text("High Mass Star", 400, 310);
    text("(Hard)", 400, 340);
    if (mouseX >= 300 && mouseX <= 500 && mouseY >= 275 && mouseY <= 375) {
      stroke(0,227,255);
      strokeWeight(10);
      fill(0, 227, 255);
      rect(400, 325, 200, 100);
      fill(0);
      textSize(22);
      text("High Mass Star", 400, 310);
      text("(Hard)", 400, 340);
      if (mousePressed == true) {
        difficulty = 1;
        pressure = 100;
        cutsceneTimer = millis();
        screen = 3;
        initSim(aCount);
        pressureRate = 0.025;
        strength = 20;
        skip = false;
      }
    } //<>//
    textSize(20);
    text("Medium Mass Star", 400, 460);
    text("(Medium)", 400, 490);
    if (mouseX >= 300 && mouseX <= 500 && mouseY >= 425 && mouseY <= 525) {
      stroke(250,222,3);
      strokeWeight(10);
      fill(250,222,3);
      rect(400, 475, 200, 100); //<>//
      fill(0);
      textSize(22);
      text("Medium Mass Star", 400, 460);
      text("(Medium)", 400, 490);
      if (mousePressed) {
        difficulty = 0;
        pressure = 100;
        cutsceneTimer = millis();
        screen = 3;
        initSim(aCount);
        pressureRate = 0.025;
        strength = 20;
        skip = false; //<>// //<>// //<>//
      }
    }
    textSize(20);
    text("Low Mass Star",400,610);
    text("(Easy)",400,640);
    if(mouseX >= 300 && mouseX <= 500 && mouseY >= 575 && mouseY <= 675){
      stroke(250,0,0);
      strokeWeight(10);
      fill(250,0,0);
      rect(400,625,200,100);
      fill(0);
      textSize(22);
      text("Low Mass Star",400,610);
      text("(Easy)",400,640);
      if(mousePressed){
        difficulty = -1;
        pressure = 100;
        cutsceneTimer = millis();
        screen = 3;
        initSim(aCount);
        pressureRate = 0.025;
        strength = 20;
        skip = false;
      }
    }
  } else if (screen == 3) {
    if(millis()-cutsceneTimer <= 8000 && !skip) { //last number is in milliseconds, change as needed
      background(0);
      fill(Math.min(255*8-(millis()-cutsceneTimer)*255/1000, 255));
      textSize(60);
      textAlign(CENTER);
      text("Main Sequence", 400, 400);
      textSize(20);
      text("Throw hydrogen atoms at each other to fuse them.", 400, 450);
      text("Don't let your pressure meter expire, or gravity will crush you!", 400, 500);
      textSize(20);
      text("Press the space bar to skip",400,550);
      if(keyPressed && key == ' '){
        skip = true;
      }
    } else if(millis()-cutsceneTimer >8000 || skip) {
      game();
    }
  } else if(screen == 4){
    textTimer++;
    displayBackground();
    textAlign(CENTER);
    textSize(25);
    fill(255);
    runText(texts2);
    if(texts2[texts2.length-1].checkDone()){
      if(difficulty == 0){
        runText(texts2Low);
      } else if(difficulty == 1){
        runText(texts2High);
      }
    }
    textSize(20);
    text("Press space to continue",400,500);
    if(keyPressed && key == ' '){
      stage = 1;
      pressure = 50;
      screen = 3;
      cutsceneTimer = millis();
      strength = 30;
      skip = true;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    if (screen == 1) {
      screen = 2;
    }
  }
}

void initBackground() {
  for (int i = 0; i<numBackgroundStars; i++) {
    backgroundStarX[i] = (int)random(0, 801);
    backgroundStarY[i] = (int)random(0, 801);
  }
}

void displayBackground() {
  background(0);
  fill(255);
  noStroke();
  for (int i = 0; i<numBackgroundStars; i++) {
    ellipse(backgroundStarX[i], backgroundStarY[i], 5, 5);
  }
}

void game() {
  background(0);
  for (int a = 0; a < aCount; a++) {
    for (int b = 0; b < aCount; b++) {
      if (a == b) {
        continue;
      }
      if (atoms.get(a).collision(atoms.get(b), strength) && fuseable.contains(atoms.get(a).e) && atoms.get(a).e == atoms.get(b).e && !atomDestroy.contains(a) && !atomDestroy.contains(b)) {
        atomMake.add(pv(a, b));
        atomDestroy.add(a);
        atomDestroy.add(b);
      }
    }
  }
  for (int i = 0; i < atomMake.size(); i++) {
    Atom a = atoms.get(0);
    Atom b = atoms.get(0);
    try {
      a = atoms.get((int)atomMake.get(i).x);
      b = atoms.get((int)atomMake.get(i).y);
    }
    catch (Exception e) {
      atomDestroy.remove(atomDestroy.indexOf((int)atomMake.get(i).x));
      atomDestroy.remove(atomDestroy.indexOf((int)atomMake.get(i).y));
      atomMake.remove(i);
      continue;
    }
    switch(a.e) {
    case H:
      atoms.add(new Atom(Element.He, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 8;
      break;
    case He:
      atoms.add(new Atom(Element.C, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 10;
      break;
    case C:
      atoms.add(new Atom(Element.Na, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 16;
      break;
    case Na:
      atoms.add(new Atom(Element.Si, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 32;
      break;
    case Si:
      atoms.add(new Atom(Element.Fe, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
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

  for (int a = 0; a < aCount; a++) {
    if(atoms.get(a).update(refill)){
      if(atoms.get(a).e == Element.C){
        atoms.remove(a);
        a--;
        aCount--;
        continue;
      }
      if(atoms.size() < aCount){
        atoms.add(new Atom(Element.H, pv(0,0), atoms.get(a).avgPos.copy().add(pv(random(-0.1,0.1),random(-0.1,0.1))), diameter));
        aCount++;
      }  
    }
  }
  for (int a = 0; a < aCount; a++) {
    atoms.get(a).display();
  }
  strokeWeight(5);
  if(difficulty == 0){
    if(stage == 0){
      stroke(255,255,0);
      fill(255,255,0);      
      ellipse(150, 150, 200,200);
      fill(255,183,0);      
    } else if(stage == 1){
      stroke(255,0,0);
      fill(255,0,0);
      ellipse(150,150,200,200);
      fill(255,166,0);
    }
  } else if(difficulty == 1){
    if(stage == 0){
      stroke(3,206,255);
      fill(3,206,255);
      ellipse(150,150,200,200);
      fill(3,97,255);
    } else if(stage == 1){
      stroke(255,0,0);
      fill(255,0,0);
      ellipse(150,150,200,200);
      fill(255,166,0);
    }
  } else if(difficulty == -1){
    stroke(255,0,0);
    fill(255,0,0);
    ellipse(150,150,200,200);
    fill(250,131,3);
  }
  if (pressure >= 100) {
    pressure = 100;
  }
  noStroke();
  ellipse(150, 150, (pressure/100)*200,(pressure/100)*200);
  fill(255);
  textSize(10);
  text("Hand-crafted, Artisanal", mouseX, mouseY-10);
  text("Particle Accelerator", mouseX, mouseY);
  pressure -= pressureRate;
  if(pressure <= 0){
    switch(difficulty){
      case -1:
      noLoop(); //insert black hole or whatever tf happens to low mass after death here im too lazy for ts
      background(255,0,0);
      break;
      case 0:
      if(stage == 1){
        noLoop();
        background(255,0,0); //same thing here go to next stage
      }
      break;
      case 1:
      if(stage == 1){
        noLoop();
        background(255,0,0); //you know the drill atp
      }
      break;
    }
  }
  println(pressure);
  println(fuseable);
  if(pressure <= 10 && difficulty != -1 && !threshhold) {
    if(!fuseable.contains(Element.He)){
      refill = false;
      fuseable.add(Element.He);
      threshhold = true;
      stage++;
      pressureRate+=0.025;
      screen = 4;
    } else if(!fuseable.contains(Element.C)){
      fuseable.add(Element.C);
      threshhold = true;
    } else if(!fuseable.contains(Element.Na)){
      fuseable.add(Element.Na);
      threshhold = true;
    } else if(!fuseable.contains(Element.Si)){
      fuseable.add(Element.Si);
      threshhold = true;
    }
  }
  if(pressure > 40){
    threshhold = false;
  }
}

void runText(Text[] tempTexts){
  for (int i = 0; i <tempTexts.length; i++) {
    if (i == 0) {
      tempTexts[0].displayText();
    } else if (tempTexts[i-1].checkDone()) {
      tempTexts[i].displayText();
    }
  }
}
