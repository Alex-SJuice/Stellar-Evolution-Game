import java.util.ArrayList;

//int screen;
//int difficulty; //0 = low/medium mass, 1 = high mass

//int numBackgroundStars;
//int[] backgroundStarX;
//int[] backgroundStarY;

//int textTimer;

int aCount = 10;
float diameter = 30;
ArrayList<Atom> atoms;
ArrayList<Integer> atomDestroy;
ArrayList<PVector> atomMake;

//Text texts[] = {new Text("Your star began in a nebula, where a cloud of dust and gas",400,200),new Text("was squeezed together by gravity.",400,250),new Text("Over time, the pressure caused your star reach",400,300),new Text("a temperature of 1,000 degrees Kelvin.",400,350)};
  
void setup(){
  size(800,800);
  //screen = 0;
  //textTimer = 0;
  //numBackgroundStars = 100;
  //backgroundStarX = new int[numBackgroundStars];
  //backgroundStarY = new int[numBackgroundStars];
  //initBackground();
  
  atoms = new ArrayList<Atom>();
  for(int i = 0; i < aCount; i++){
    float dir = random(2*PI);
    //pv(diameter*cos(dir),diameter*sin(dir)),pv(diameter*cos(dir),diameter*sin(dir))
    //dir = random(2*PI);
    atoms.add(new Atom(1,1,pv(10*cos(dir),10*sin(dir)),pv(random(-width/2,width/2),random(-height/2,height/2)),diameter));
    atomDestroy = new ArrayList<Integer>();
    atomMake = new ArrayList<PVector>();
  }  
}

void draw(){
  background(0);

  for(int a = 0; a < aCount; a++){
    for(int b = 0; b < aCount; b++){
      if(a == b){continue;}
      if(atoms.get(a).collision(atoms.get(b)) && !atomDestroy.contains(a) && !atomDestroy.contains(b)){
        atomMake.add(pv(a,b));
        atomDestroy.add(a);
        atomDestroy.add(b);
      }
    }
  }
  for(int i = 0; i < atomMake.size(); i++) {
    Atom a = atoms.get((int)atomMake.get(i).x);
    Atom b = atoms.get((int)atomMake.get(i).y);
    
    Particle[] particles = new Particle[a.total+b.total];
    System.arraycopy(a.particles, 0, particles, 0, a.particles.length);
    System.arraycopy(b.particles, 0, particles, a.particles.length, b.particles.length);
    
    atoms.add(new Atom(particles, diameter));
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
  
  //if(screen == 0){
  //  displayBackground();
  //  textAlign(CENTER);
  //  textSize(80);
  //  fill(255);
  //  text("The Life Cycle of a Star:",400,150);
  //  text("Fusion Minigame",400,225);
  //  fill(0,255,0);
  //  rectMode(CENTER);
  //  rect(400,400,200,100);
  //  fill(0);
  //  textSize(40);
  //  text("Play!",400,412);
  //  if(mousePressed && mouseX >= 200 && mouseX <= 600 && mouseY >= 300 && mouseY <= 500){
  //    screen = 1;
  //  }
  //} else if(screen == 1){
  //  textTimer++;
  //  background(0);
  //  textAlign(CENTER);
  //  textSize(25);
  //  fill(255);
  //  for(int i = 0; i <texts.length; i++){
  //    if(i == 0){
  //      texts[0].displayText();
  //    }else if(texts[(i-1)].checkDone()){
  //      texts[i].displayText();        
  //    }
  //  }
  //  text("Now fusion can begin.",400,450);
  //  textSize(20);
  //  text("Press the space bar to continue",400,500);
  //} else if(screen == 2){
  //  displayBackground();
  //  text("Choose a difficulty:",400,300);
  //  fill(0,227,255);
  //  rect(400,400,200,100);
  //  fill(255,0,0);
  //  rect(400,575,200,100);
  //} else if(screen == 3){
  //  
  //}
}

//void mousePressed(){ //<>//
//}

//void keyPressed(){
//  if(key == ' '){
//    if(screen == 1){
//      screen = 2;
//    }
//  }
//}



//void initBackground(){
//  for(int i = 0; i<numBackgroundStars; i++){
//    backgroundStarX[i] = (int)random(0,801);
//    backgroundStarY[i] = (int)random(0,801);
//  }
//}

//void displayBackground(){
//  background(0);
//  fill(255);
//  for(int i = 0; i<numBackgroundStars; i++){
//    rect(backgroundStarX[i],backgroundStarY[i],5,5);
//  }
//}
