//>w< AwA
import java.util.ArrayList;

int screen;
int difficulty; //-1 low, 0 medium, 1 = high mass

PImage bg;
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
int stage; //0 = main sequence, 1 = giants, 2 = supernova/black hole

boolean skip;
boolean skipSupernova;

boolean cap;

int textTimer;
int cutsceneTimer;

PFont font;
PFont hkFont;

Text texts1[] = {new Text("Your star began in a nebula, where a cloud of dust and gas", 400, 200), new Text("was squeezed together by density compressional waves", 400, 250), new Text("to form a protostar. Over time, gravitational heating", 400, 300), new Text("helped your star reach a temperature of 15 million", 400, 350), new Text("degrees Kelvin. Now fusion can begin.", 400, 400)};
Text texts2[] = {new Text("As your star runs out of hydrogen,",400,200),new Text("the radiation pressure drops. Gravity crushes the core,",400,250),new Text("making it hot enough to fuse heavier elements.",400,300)};
Text texts2Low[] = {new Text("You are now a red giant.",400,350)};
Text texts2High[] = {new Text("You are now a red supergiant.",400,350)};
Text textsSupernova[] = {new Text("Iron builds up in the core of your star, making it harder for",400,200), new Text("your star to produce outward pressure with fusion.",400,250), new Text("Eventually, there is too little fusion to stop gravity",400,300), new Text("and the core collapses, creating a violent explosion known as a ",400,350)};
Text textsHighEnd[] = {new Text("There are two fates of a high mass star:    ",400, 200), new Text("The star collapses into a point of",200,400), new Text("infinite density. It has so much", 200, 450), new Text ("gravity, even light cannot escape.", 200, 500), new Text("The star collapses, but neutron", 600, 400), new Text("degeneracy pressure keeps the", 600, 450), new Text("star from contracting further", 600, 500)};
Text textsMedDwarf[] = {new Text("As your star runs out of elements to fuse,",400,200),new Text("the core begins to fall apart. The outer layers",400,250), new Text("lift off to form a planetary nebula, and",400,300),new Text("left behind is the core itself, known as a white dwarf,",400,350),new Text("where electron degeneracy pressure keeps the dwarf from collapsing further",400,400),};

void setup() {
  size(800, 800);
  bg = loadImage("bg1.png");
  imageMode(CENTER);
  screen = 0;
  textTimer = 0;
  stage = 0;
  font = createFont("Pixelon.otf", 16);
  hkFont = createFont("Perpetua.otf",16);
  textFont(font);
  skip = false;
  skipSupernova = false;
  cap = true;
}

void draw() {
  switch(screen){
    case 0:
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
      break;
      
    case 1:
      
      displayBackground();
      textAlign(CENTER);
      textSize(25);
      fill(255);
      runText(texts1);
      textSize(20);
      text("Press the space bar to continue", 400, 500);
      if(keyPressed && key == ' '){
        for(int i = 0; i<texts1.length;i++){
          texts1[i].reset();
        }
        screen = 2;
      }
      break;
      
    case 2:
      displayBackground();
      noStroke();
      fill(255);
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
        strokeWeight(10); //<>//
        fill(0, 227, 255); //<>// //<>// //<>// //<>//
        rect(400, 325, 200, 100); //<>//
        fill(0); //<>// //<>// //<>// //<>// //<>//
        textSize(22);  //<>// //<>// //<>// //<>//
        text("High Mass Star", 400, 310); //<>//
        text("(Hard)", 400, 340);  //<>// //<>// //<>// //<>//
        if (mousePressed == true) { 
          difficulty = 1;
          pressure = 100;  //<>//
          cutsceneTimer = millis(); //<>// //<>// //<>// //<>//
          screen = 3; //<>//
          initSim(aCount); //<>// //<>// //<>// //<>//
          pressureRate = 0.1; //<>//
          strength = 20; //<>// //<>// //<>// //<>//
          skip = false;
        }
      } 
      textSize(20);
      text("Medium Mass Star", 400, 460); //<>//
      text("(Medium)", 400, 490); //<>// //<>// //<>// //<>//
      if (mouseX >= 300 && mouseX <= 500 && mouseY >= 425 && mouseY <= 525) { //<>//
        stroke(250,222,3); //<>// //<>// //<>// //<>// //<>//
        strokeWeight(10);  //<>// //<>// //<>// //<>// //<>//
        fill(250,222,3); //<>// //<>// //<>// //<>// //<>//
        rect(400, 475, 200, 100);  //<>// //<>// //<>// //<>// //<>//
        fill(0);  //<>// //<>// //<>// //<>// //<>//
        textSize(22);  //<>// //<>// //<>// //<>//
        text("Medium Mass Star", 400, 460); 
        text("(Medium)", 400, 490); 
        if (mousePressed) { 
          difficulty = 0;
          pressure = 100;
          cutsceneTimer = millis();
          screen = 3;
          initSim(aCount);
          pressureRate = 0.075;
          strength = 20;
          skip = false;
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
          pressureRate = 0.05;
          strength = 30;
          skip = false;
          aCount = 50;
        }
      }
      break;
      
    case 3:
      if(millis()-cutsceneTimer <= 8000 && !skip) { //last number is in milliseconds, change as needed
        displayBackground();
        fill(Math.min(255*8-(millis()-cutsceneTimer)*255/1000, 255));
        textSize(60);
        textAlign(CENTER);
        text("Main Sequence", 400, 400);
        textSize(20);
        text("Throw hydrogen atoms at each other to fuse them.", 400, 450);
        text("Don't let your pressure meter expire, or gravity will crush you!", 400, 500);
        textSize(20);
        text("Press the space bar to play",400,550);
        if(keyPressed && key == ' '){
          skip = true;
        }
      } else {
        game();
      }
      break;
      
    case 4:
      if(stage == 0){
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
          skip = true;
          stage = 1;
          pressure = 100;
          screen = 3;
          cutsceneTimer = millis();
          strength = 30;
          for(int i = 0; i<texts2.length;i++){
            texts2[i].reset();
          }
          texts2Low[0].reset();
          texts2High[0].reset();
        }
      }
      break;
      
    case 5:
      if(keyPressed && key == ' '){skip = true;}else{skip = false;}
      if(!skip){
        if(millis()-cutsceneTimer <= 25000 && millis()-cutsceneTimer >= 20000) { //last number is in milliseconds, change as needed
          int shakeX;
          int shakeY;
          float intensity;
          if(millis()-cutsceneTimer <= 20000){
            intensity = 1.0;
          } else if(millis()-cutsceneTimer <= 22000){
            intensity = 0.5;
          } else if(millis()-cutsceneTimer <= 24000){
            intensity = 0.25;
          } else {
            intensity = 0;
          }
          background(255,74,3);
          fill(0);
          textFont(hkFont);
          textAlign(CENTER);
          textSize(80);
          shakeX = (int)random(-11*intensity,11*intensity);
          shakeY = (int)random(-11*intensity,11*intensity);
          text("Supernova",400+shakeX,400+shakeY);
        } else if (millis()-cutsceneTimer <= 20000){
          background(255,74,3);
          fill(0);
          textFont(font);
          textSize(20);
          runText(textsSupernova);
          text("Press space to skip",400,600);
        } else{
          screen = 6;
          pressureRate = 0;
          textFont(font);
        }
      } else {
        skip = true;
        screen = 6;
        pressureRate = 0;
        textFont(font);
      }
      break;
      
    case 6:
      if(millis()-cutsceneTimer >= 7000){
        displayBackground();
        fill(255);
        textFont(hkFont);
        textAlign(CENTER);
        textSize(40);
        if(textsHighEnd[0].textDone){
          text("Black Hole",200,350);
        }
        if(textsHighEnd[2].textDone){
          text("Neutron Star",600,350);
        }
        textFont(font);
        textSize(20);
        runText(textsHighEnd);
        text("Press space to go back to the menu",400,600);
        if(keyPressed && key == ' '){
          screen = 0;
          textTimer = 0;
          stage = 0;
          skip = false;
          cap = true;
          for(int i = 0; i < texts1.length; i++){
            texts1[i].reset();
          }
          for(int i = 0; i < texts2.length; i++){
            texts2[i].reset();
          }
          for(int i = 0; i < texts2Low.length; i++){
            texts2Low[i].reset();
          }
          for(int i = 0; i < texts2High.length; i++){
            texts2High[i].reset();
          }
          for(int i = 0; i < textsSupernova.length; i++){
            textsSupernova[i].reset();
          }
          for(int i = 0; i < textsHighEnd.length; i++){
            textsHighEnd[i].reset();
          }
        }
      }
      break;
      
      case 7:
      displayBackground();
      textTimer++;
      runText(textsMedDwarf);
      text("Press space to continue",400,500);
      if(keyPressed && key == ' '){
        
      }
      break;
  }
  textTimer++;
  textTimer = textTimer%100000000;
}

void displayBackground() {
  background(0);
  image(bg, 150,400);
}

void game() {
  displayBackground();
  if(keyPressed && key == 'g'){pressureRate = 1;}
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
      pressure += 6;
      break;
    case He:
      atoms.add(new Atom(Element.C, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 16;
      break;
    case C:
      atoms.add(new Atom(Element.Na, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 32;
      break;
    case Na:
      atoms.add(new Atom(Element.Si, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 64;
      break;
    case Si:
      atoms.add(new Atom(Element.Fe, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), diameter));
      pressure += 80;
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
      fill(250,233,194);      
    } else if(stage == 1){
      stroke(255,0,0);
      fill(255,0,0);
      ellipse(150,150,250,250);
      fill(255,166,0);
    }
    noStroke();
    ellipse(150, 150, (pressure/100)*200,(pressure/100)*200);
  } else if(difficulty == 1){
    if(stage == 0){
      fill(3,206,255);
      ellipse(150,150,180,180);
      fill(3,46,255);
    } else if(stage == 1){
      fill(255,0,0);
      ellipse(150,150,225,225);
      fill(255,74,3);
    }
    noStroke();
    ellipse(150, 150, (pressure/100)*180,(pressure/100)*180);
  } else if(difficulty == -1 && stage != 2){
    fill(250,131,3);
    ellipse(150,150,200,200);
    fill(255,0,0);
    noStroke();
    ellipse(150, 150, (pressure/100)*100,(pressure/100)*100);
  }
  if (pressure >= 100 && cap) {
    pressure = 100;
  }
  
  fill(255);
  textSize(10);
  text("Hand-crafted, Artisanal", mouseX, mouseY-10);
  text("Particle Accelerator", mouseX, mouseY);
  pressure -= pressureRate;
  if(pressure <= 5){
    switch(difficulty){
      case -1:
      pressureRate = 5;
      pressure -= pressureRate;
      fill(250,131,3);
      ellipse(150,150,200*(pressure/100),200*(pressure/100));
      fill(255,0,0);
      noStroke();
      ellipse(150, 150, (pressure/100)*100,(pressure/100)*100);
      if(pressure <= -20 && pressure >= -40){
        cutsceneTimer = millis();
      } else if(pressure <= -40){
        screen = 6;
        stage = 2;
      }
      break;
      case 0:
      if(stage == 1){
        screen = 7;
        textTimer = 0;
      }
      break;
      case 1:
      if(stage == 1){
        pressureRate = -20;
        pressure -= pressureRate;
        cap = false;
        if(pressure > 1950 && pressure < 2000){
          cutsceneTimer = millis();
        } else if(pressure > 2000){
            screen = 5;
            stage = 2;
            //skip = false;
            textTimer = 0;
        }
      }
      break;
    }
  }
  if(pressure <= 20 && difficulty == 1 && stage == 1){
    //alert for low pressure idk supernova needs to be more dramatic
  }
  if(difficulty != -1 && !threshhold) {
    if(pressure <= 10 && (!fuseable.contains(Element.He) || difficulty == 1)){
      refill = false;
      fuseable.add(Element.He);
      threshhold = true;
      if(difficulty == 0){
        pressureRate = 0.05;
      } else if(difficulty == 1 && stage == 0){
        pressureRate = 0.06; //keeping it lower because we want them to get to iron
      }
      screen = 4;
    } else if(stage == 1 && pressure <= 70 && !fuseable.contains(Element.C)){
      fuseable.add(Element.C);
      threshhold = true;
    } else if(stage == 1 && pressure <= 50 && !fuseable.contains(Element.Na)){
      fuseable.add(Element.Na);
      threshhold = true;
    } else if(stage == 1 && pressure <= 40 && !fuseable.contains(Element.Si)){
      fuseable.add(Element.Si);
      threshhold = true;
    }
  }
  if(pressure > 40){
    threshhold = false;
  }
  if(pressure > 1950 && pressure < 2000 && difficulty == 1 && stage == 1){
          cutsceneTimer = millis();
        } else if(pressure > 2000){
          if(millis()-cutsceneTimer <= 5000) { //last number is in milliseconds, change as needed
            screen = 5;
          }
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
