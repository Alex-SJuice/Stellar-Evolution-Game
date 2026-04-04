class Atom {  
  private class Particle {
    PVector pos;
    PVector prevPos;
    PVector vel;
    int type;
    
    public Particle (PVector pos, PVector vel, int type){
      this.pos = pos;
      this.vel = vel;
      this.type = type;
      this.prevPos = pos.sub(vel);
    }
  }
  Particle [] particles;
  float radius;
  int grabbed;
  int total;
  PVector avgPos;
  PVector avgVel;
  
  public Atom (int protons, int neutrons, PVector vel, PVector pos, float radius) {
    this.radius = radius;
    this.total = protons + neutrons;
    
    PVector sum = pv(0,0);
    particles = new Particle[total];
    for(int i = 0; i < total; i++){
      int rndm = (int)random(protons + neutrons);
      PVector rd = pv(1,1).setMag(radius).setHeading(random(2*PI));
      particles[i] = new Particle(pos.copy().add(rd),vel,rndm < protons? 0 : 1);
      if(rndm < protons){protons--;} else {neutrons--;}
      sum.add(particles[i].pos.copy());
    }
    avgPos = sum.div(total);
    avgVel = vel.copy();
  }
  
  public void display() {
    for(int i = 0; i < total; i++){
      fill(particles[i].type == 0? color(255,0,0):color(255,255,255));
      cir(particles[i].pos,radius);
      fill(0);
      text(i,convert(particles[i].pos).x,convert(particles[i].pos).y);
    }
  }
  
  //public boolean collision(Atom other) {
    
  //}
  
  public void update() {
   
    for(int p = 0; p < total; p++){
      particles[p].prevPos = particles[p].pos.copy();
    }
    
    PVector sum = pv(0,0);
    for(int p = 0; p < total; p++){
      particles[p].pos.add(particles[p].vel);
      
      sum.add(particles[p].pos.copy());
    }
    avgPos = sum.div(total);
    //println(avgVel.x + " " + avgVel.y);
    sum = pv(0,0);
    for(int p = 0; p < total; p++){
      particles[p].vel = particles[p].pos.copy().sub(particles[p].prevPos);
      sum.add(particles[p].vel.copy());
    }
    avgVel = sum.div(total);
    for(int p = 0; p < total; p++){
      for(int i = 0; i < total; i++){
          if(i==p){continue;}
          if(calcDst(particles[p].pos,particles[i].pos) < radius){
            PVector offset = particles[p].pos.copy().sub(particles[i].pos.copy()).setMag(radius - calcDst(particles[p].pos.copy(),particles[i].pos.copy()));
            particles[i].pos.sub(offset.copy().div(3));
            particles[p].pos.add(offset.copy().div(3));
          } else {
            PVector offset = particles[p].pos.copy().sub(particles[i].pos.copy()).setMag(calcDst(particles[p].pos.copy(),particles[i].pos.copy())/2-radius/2);
            particles[p].pos.sub(offset.copy().div(2));
            particles[i].pos.add(offset.copy().div(2));
          }
        }
    }
    for(int p = 0; p < total; p++){  
      PVector mouse = pv(mouseX-width/2,-mouseY+height/2);
      if(p == grabbed){
        if(calcDst(mouse, particles[p].pos) > radius || !mousePressed){
          grabbed = -1;
        } else {
          PVector prevAvgPos = avgPos.copy();
          avgPos = mouse.copy().sub(particles[p].pos.copy().sub(prevAvgPos.copy()));
          avgVel = avgPos.copy().sub(prevAvgPos.copy());
          
          for(int i = 0; i < total; i++){
            particles[i].pos = avgPos.copy().add(particles[i].pos.copy().sub(prevAvgPos.copy()));
            particles[i].vel = avgVel.copy().add(particles[i].vel);
          }
        }
      } 
      if(calcDst(mouse, particles[p].pos) <= radius && mousePressed && grabbed == -1){
        particles[p].pos = mouse.copy();
        grabbed = p;
      }
      
      if(particles[p].pos.x > width/2 - radius/2) {
        particles[p].pos.x = width/2 - radius/2;
        particles[p].vel.x *= -1;
      } else if(particles[p].pos.x < -width/2 + radius/2) {
        particles[p].pos.x = -width/2 + radius/2;
        particles[p].vel.x *= -1;
      }
      if(particles[p].pos.y > height/2 - radius/2) {
        particles[p].pos.y = height/2 - radius/2;
        particles[p].vel.y *= -1;
      } else if(particles[p].pos.y < -height/2 + radius/2) {
        particles[p].pos.y = -height/2 + radius/2;
        particles[p].vel.y *= -1;
      }
      
    }
    

  }
}
