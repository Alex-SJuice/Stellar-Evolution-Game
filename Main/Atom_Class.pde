enum Element {
  H,He,C,Na,Si,Fe
}
class Particle {
  PVector pos;
  PVector prevPos;
  PVector vel;
  color c;
  
  public Particle (PVector pos, PVector vel, color c){
    this.pos = pos;
    this.vel = vel;
    this.c = c;
    this.prevPos = pos.sub(vel);
  }
}
class Atom { 
  Particle [] particles;
  float diameter;
  private int grabbed = -1;
  int total;
  PVector avgPos;
  PVector avgVel;
  Element e;
  
  public Atom (Element e, PVector vel, PVector pos, float diameter) {
    this.diameter = diameter;
    this.e = e;
    switch(e) {
      case H: this.total = 1;break;
      case He: this.total = 4;break;
      case C: this.total = 12;break;
      case Na: this.total = 22;break;
      case Si: this.total = 28;break;
      case Fe: this.total = 52;break;
    }
    
    PVector sum = pv(0,0);
    particles = new Particle[this.total];
    for(int i = 0; i < this.total; i++){
      PVector p = pos.copy().add(pv(random(-0.1,0.1),random(-0.1,0.1)));
      particles[i] = new Particle(p.copy(), vel.copy(), i < (int)(total/2.0+0.5)? color(255,0,0) : color(255,255,255));
      sum.add(p.copy());
    }
    avgPos = sum.copy();
    avgVel = vel.copy();
  }
  
  public void display() {
    for(int i = 0; i < total; i++){
      fill(particles[i].c);
      cir(particles[i].pos,diameter);
    }
  }
  
  public boolean collision(Atom other) {
    if(calcDst(other.avgPos,this.avgPos) > (other.diameter*other.total + this.diameter*this.total)/2.0){return false;}
    for(int t = 0; t < this.total; t++){
      for(int o = 0; o < other.total; o++) {
        if(calcDst(this.particles[t].pos,other.particles[o].pos) < (other.diameter + this.diameter)/2) {
          
          PVector offset = this.particles[t].pos.copy().sub(other.particles[o].pos).setMag((other.diameter+this.diameter)/2 - calcDst(this.particles[t].pos,other.particles[o].pos));
          if(offset.mag() <= 30){
            this.particles[t].vel.add(offset.copy().setMag(other.particles[o].vel.copy().dot(offset.copy().normalize())));
            other.particles[o].vel.sub(offset.copy().setMag(this.particles[t].vel.copy().dot(offset.copy().normalize())));
            for(int j = 0; j < this.total; j++){
              this.particles[j].vel.add(offset.copy().setMag(other.particles[o].vel.copy().dot(offset.copy().normalize())).div(other.total*10));
            }
            for(int j = 0; j < other.total; j++){
              other.particles[j].vel.sub(offset.copy().setMag(this.particles[t].vel.copy().dot(offset.copy().normalize())).div(this.total*10));
            }
            other.particles[o].pos.sub(offset.copy().div(2));
            this.particles[t].pos.add(offset.copy().div(2));
          } else {
            for(int j = 0; j < this.total; j++){
              this.particles[j].vel = pv(0,0);
            }
            for(int j = 0; j < other.total; j++){
              other.particles[j].vel = pv(0,0);
            }
            other.particles[o].pos.sub(offset.copy().div(2));
            this.particles[t].pos.add(offset.copy().div(2));
          }
        }
      }
    }
    
    PVector dir = this.avgPos.copy().sub(other.avgPos).normalize();
    if(other.avgVel.copy().dot(dir) - this.avgVel.copy().dot(dir) >= (this.total+other.total+5)*2){
      return true;
    }
    return false;
  }
  
  public void update() {
    
    for(int p = 0; p < total; p++){
      particles[p].prevPos = particles[p].pos.copy();
    }
    
    for(int p = 0; p < total; p++){
      particles[p].pos.add(particles[p].vel);
    }
    
    PVector sum = pv(0,0);
    //println(avgVel.x + " " + avgVel.y);
    for(int p = 0; p < total; p++){
      for(int i = 0; i < total; i++){
          if(i==p){continue;}
          if(calcDst(particles[p].pos,particles[i].pos) < diameter){
            PVector offset = particles[p].pos.copy().sub(particles[i].pos.copy()).setMag(diameter - calcDst(particles[p].pos.copy(),particles[i].pos.copy()));
            particles[i].pos.sub(offset.copy().div(2));
            particles[p].pos.add(offset.copy().div(2));
          } else {
            PVector offset = particles[p].pos.copy().sub(particles[i].pos.copy()).setMag(calcDst(particles[p].pos.copy(),particles[i].pos.copy())/2-diameter/2).div(pow(total,2)).mult(calcDst(particles[p].pos,particles[i].pos)/30);
            particles[p].pos.sub(offset.copy().div(2));
            particles[i].pos.add(offset.copy().div(2));
          }
       }
       if(p == grabbed){
         sum.add(particles[p].pos.copy());
       }
       sum.add(particles[p].pos.copy());
    }
    avgPos = sum.div(total);
    
    sum = pv(0,0);
    for(int p = 0; p < total; p++){
      particles[p].vel = particles[p].pos.copy().sub(particles[p].prevPos);
      sum.add(particles[p].vel.copy());
    }
    avgVel = sum.div(total);
    
    for(int p = 0; p < total; p++){
      PVector mouse = pv(mouseX-width/2,-mouseY+height/2);
      if(p == grabbed){
        if(!mousePressed){
          grabbed = -1;
          PVector prevAvgPos = avgPos.copy();
          avgPos = mouse.copy().sub(particles[p].pos.copy().sub(prevAvgPos.copy().mult(1.0)));
          avgVel.add(avgPos.copy().sub(prevAvgPos.copy()).mult(0.5));
          
          for(int i = 0; i < total; i++){
            particles[i].pos = avgPos.copy().add(particles[i].pos.copy().sub(prevAvgPos.copy()));
            particles[i].vel = avgVel.copy().add(particles[i].vel).add(pv(1,1).setHeading(random(2*PI)).setMag(Math.min(millis()/1000,30)));
          }
        } else {
          grabbed = p;
          particles[p].pos = mouse.copy();
        }
      } else if(calcDst(mouse, particles[p].pos) <= diameter/2 && mousePressed && grabbed == -1){
        particles[p].pos = mouse.copy();
        grabbed = p;
      }    
    }
    //println(particles[0].vel);
    for(int p = 0; p < total; p++){
      if(particles[p].pos.x > width/2 -diameter/2) {
        particles[p].pos.x = width/2 -diameter/2;
        particles[p].vel.x *= -0.5;
      } else if(particles[p].pos.x < -width/2 +diameter/2) {
        particles[p].pos.x = -width/2 +diameter/2;
        particles[p].vel.x *= -0.5;
      }
      if(particles[p].pos.y > height/2 -diameter/2) {
        particles[p].pos.y = height/2 -diameter/2;
        particles[p].vel.y *= -0.5;
      } else if(particles[p].pos.y < -height/2 +diameter/2) {
        particles[p].pos.y = -height/2 +diameter/2;
        particles[p].vel.y *= -0.5;
      }
    }
    
    if(Float.isNaN(avgPos.x) || Float.isNaN(avgPos.y) || Float.isNaN(avgPos.z)){
      avgPos = pv(random(-width/2,width/2),random(-height/2,height/2));
      avgVel = pv(0,0);
      for(int i = 0; i < this.total; i++){
        PVector p = avgPos.copy().add(pv(random(-0.1,0.1),random(-0.1,0.1)));
        particles[i].pos = p.copy();
        particles[i].vel = avgVel.copy();
        particles[i].prevPos = p.copy();
      }
    }
  }
}
class LMAtom { 
  Particle [] particles;
  float diameter;
  private int grabbed = -1;
  int total;
  PVector avgPos;
  PVector avgVel;
  Element e;
  
  public LMAtom (Element e, PVector vel, PVector pos, float diameter) {
    this.diameter = diameter;
    this.e = e;
    switch(e) {
      case H: this.total = 1;break;
      case He: this.total = 4;break;
      case C: this.total = 12;break;
      case Na: this.total = 22;break;
      case Si: this.total = 28;break;
      case Fe: this.total = 52;break;
    }
    
    PVector sum = pv(0,0);
    particles = new Particle[this.total];
    for(int i = 0; i < this.total; i++){
      PVector p = pos.copy().add(pv(random(-0.1,0.1),random(-0.1,0.1)));
      particles[i] = new Particle(p.copy(), vel.copy(), i < (int)(total/2.0+0.5)? color(255,0,0) : color(255,255,255));
      sum.add(p.copy());
    }
    avgPos = sum.copy();
    avgVel = vel.copy();
  }
  
  public void display() {
    for(int i = 0; i < total; i++){
      fill(particles[i].c);
      cir(particles[i].pos,diameter);
    }
  }
  
  public boolean collision(Atom other) {
    if(calcDst(other.avgPos,this.avgPos) > (other.diameter*other.total + this.diameter*this.total)/2.0){return false;}
    for(int t = 0; t < this.total; t++){
      for(int o = 0; o < other.total; o++) {
        if(calcDst(this.particles[t].pos,other.particles[o].pos) < (other.diameter + this.diameter)/2) {
          
          PVector offset = this.particles[t].pos.copy().sub(other.particles[o].pos).setMag((other.diameter+this.diameter)/2 - calcDst(this.particles[t].pos,other.particles[o].pos));
          if(offset.mag() <= 1000){
            this.particles[t].vel.add(offset.copy().setMag(other.particles[o].vel.copy().dot(offset.copy().normalize())));
            other.particles[o].vel.sub(offset.copy().setMag(this.particles[t].vel.copy().dot(offset.copy().normalize())));
            for(int j = 0; j < this.total; j++){
              this.particles[j].vel.add(offset.copy().setMag(other.particles[o].vel.copy().dot(offset.copy().normalize())).div(other.total*10));
            }
            for(int j = 0; j < other.total; j++){
              other.particles[j].vel.sub(offset.copy().setMag(this.particles[t].vel.copy().dot(offset.copy().normalize())).div(this.total*10));
            }
            other.particles[o].pos.sub(offset.copy().div(2));
            this.particles[t].pos.add(offset.copy().div(2));
          }
        }
      }
    }
    
    PVector dir = this.avgPos.copy().sub(other.avgPos).normalize();
    if(other.avgVel.copy().dot(dir) - this.avgVel.copy().dot(dir) >= (this.total+other.total+10)*3){
      return true;
    }
    return false;
  }
  
  public void update() {
    
    for(int p = 0; p < total; p++){
      particles[p].prevPos = particles[p].pos.copy();
    }
    
    for(int p = 0; p < total; p++){
      particles[p].pos.add(particles[p].vel);
    }
    
    PVector sum = pv(0,0);
    //println(avgVel.x + " " + avgVel.y);
    for(int p = 0; p < total; p++){
      for(int i = 0; i < total; i++){
          if(i==p){continue;}
          if(calcDst(particles[p].pos,particles[i].pos) < diameter){
            PVector offset = particles[p].pos.copy().sub(particles[i].pos.copy()).setMag(diameter - calcDst(particles[p].pos.copy(),particles[i].pos.copy()));
            particles[i].pos.sub(offset.copy().div(2));
            particles[p].pos.add(offset.copy().div(2));
          } else {
            PVector offset = particles[p].pos.copy().sub(particles[i].pos.copy()).setMag(calcDst(particles[p].pos.copy(),particles[i].pos.copy())/2-diameter/2).div(pow(total,2)).mult(calcDst(particles[p].pos,particles[i].pos)/30);
            particles[p].pos.sub(offset.copy().div(2));
            particles[i].pos.add(offset.copy().div(2));
          }
       }
       if(p == grabbed){
         sum.add(particles[p].pos.copy());
       }
       sum.add(particles[p].pos.copy());
    }
    avgPos = sum.div(total);
    
    sum = pv(0,0);
    for(int p = 0; p < total; p++){
      particles[p].vel = particles[p].pos.copy().sub(particles[p].prevPos);
      sum.add(particles[p].vel.copy());
    }
    avgVel = sum.div(total);
    
    for(int p = 0; p < total; p++){
      PVector mouse = pv(mouseX-width/2,-mouseY+height/2);
      if(p == grabbed){
        if(!mousePressed){
          grabbed = -1;
          PVector prevAvgPos = avgPos.copy();
          avgPos = mouse.copy().sub(particles[p].pos.copy().sub(prevAvgPos.copy().mult(1.0)));
          avgVel.add(avgPos.copy().sub(prevAvgPos.copy()).mult(0.5));
          
          for(int i = 0; i < total; i++){
            particles[i].pos = avgPos.copy().add(particles[i].pos.copy().sub(prevAvgPos.copy()));
            particles[i].vel = avgVel.copy().add(particles[i].vel).add(pv(1,1).setHeading(random(2*PI)).setMag(Math.min(millis()/1000,30)));
          }
        } else {
          grabbed = p;
          particles[p].pos = mouse.copy();
        }
      } else if(calcDst(mouse, particles[p].pos) <= diameter/2 && mousePressed && grabbed == -1){
        particles[p].pos = mouse.copy();
        grabbed = p;
      }    
    }
    for(int p = 0; p < total; p++){
      if(particles[p].pos.x > width/2 +1) {
        particles[p].pos.x = width/2 +1;
        particles[p].vel.x *= -0.5;
      } else if(particles[p].pos.x < -width/2 -1) {
        particles[p].pos.x = -width/2 -1;
        particles[p].vel.x *= -0.5;
      }
      if(particles[p].pos.y > height/2 +1) {
        particles[p].pos.y = height/2 +1;
        particles[p].vel.y *= -0.5;
      } else if(particles[p].pos.y < -height/2 -1) {
        particles[p].pos.y = -height/2 -1;
        particles[p].vel.y *= -0.5;
      }
    }
    
    if(Float.isNaN(avgPos.x) || Float.isNaN(avgPos.y) || Float.isNaN(avgPos.z)){
      avgPos = pv(random(-width/2,width/2),random(-height/2,height/2));
      avgVel = pv(0,0);
      grabbed = -1;
      for(int i = 0; i < this.total; i++){
        PVector p = avgPos.copy().add(pv(random(-0.1,0.1),random(-0.1,0.1)));
        particles[i].pos = p.copy();
        particles[i].vel = avgVel.copy();
        particles[i].prevPos = p.copy();
      }
    }
  }
}
