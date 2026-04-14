import java.util.ArrayList;

int state = 0;
int difficulty; //2 low, 1 medium, 0 high mass

int aCount = 100;
ArrayList<Atom> atoms;
ArrayList<Integer> atomDestroy;
ArrayList<PVector> atomMake;
ArrayList<Element> fuseable;

float pressure;
float pressureRate;
boolean refill = true;

boolean skip;
int textTimer;

Text intro[] = {new Text("Your star began in a nebula, where a cloud of dust and gas", 400, 200), new Text("was squeezed together by density compressional waves", 400, 250), new Text("to form a protostar. Over time, gravitational heating", 400, 300), new Text("helped your star reach a temperature of 15 million", 400, 350), new Text("degrees Kelvin. Now fusion can begin.", 400, 400)};
Text helium[] = {new Text("As your star runs out of hydrogen,",400,200),new Text("the radiation pressure drops. Gravity crushes the core,",400,250),new Text("making it hot enough to fuse helium.",400,300)};
Text texts2Low[] = {new Text("You are now a red giant.",400,350)};
Text texts2High[] = {new Text("You are now a red supergiant.",400,350)};

void setup() {
  size(800, 800);
  state = 0;
  textTimer = 0;
  skip = false;
  load("Stellar_Evolution.txt","Pixelon.otf");
}

void draw() {
  background(0);
  switch(state){
    case 0:
      textSize(60);
      fill(255);
      text("The Life Cycle of a Star:", 400, 150);
      text("Fusion Minigame", 400, 225);
      displayAll();
      for(int i = 0; i < buttons.size(); i++){
        if(buttons.get(i).update()){
          state = 1;
          difficulty = i;
        }
      }
      break;
    case 1: 
      fill(255);
      textSize(10);
      text("Hand-crafted, Artisanal", mouseX, mouseY-10);
      text("Particle Accelerator", mouseX, mouseY);
      break;
  }
}

void runSim() {
  background(0);
  for (int a = 0; a < aCount; a++) {
    for (int b = 0; b < aCount; b++) {
      if (a == b) {
        continue;
      }
      if (atoms.get(a).collision(atoms.get(b)) && fuseable.contains(atoms.get(a).e) && atoms.get(a).e == atoms.get(b).e && !atomDestroy.contains(a) && !atomDestroy.contains(b)) {
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
      atoms.add(new Atom(Element.He, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), 20));
      pressure += 6;
      break;
    case He:
      atoms.add(new Atom(Element.C, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), 20));
      pressure += 10;
      break;
    case C:
      atoms.add(new Atom(Element.Na, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), 20));
      pressure += 16;
      break;
    case Na:
      atoms.add(new Atom(Element.Si, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), 20));
      pressure += 32;
      break;
    case Si:
      atoms.add(new Atom(Element.Fe, pv(0, 0), a.avgPos.copy().add(b.avgPos.copy()).div(2), 20));
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
 //<>//
  for (int a = 0; a < aCount; a++) {
    if(atoms.get(a).update(refill)){
      if(atoms.get(a).e == Element.C){
        atoms.remove(a);
        a--;
        aCount--;
        continue;
      }
      if(atoms.size() < aCount){ //<>//
        atoms.add(new Atom(Element.H, pv(0,0), atoms.get(a).avgPos.copy().add(pv(random(-0.1,0.1),random(-0.1,0.1))), 20));
        aCount++;
      }  
    }
  }
  for (int a = 0; a < aCount; a++) {
    atoms.get(a).display();
  }
}
 //<>//
void runText(Text[] tempTexts){
  for (int i = 0; i < tempTexts.length; i++) {
    if (i == 0) { //<>//
      tempTexts[0].displayText(); //<>//
    } else if (tempTexts[i-1].checkDone()) {
      tempTexts[i].displayText();
    }
  }
}
