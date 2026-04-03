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
  
  public Atom (int protons, int neutrons, PVector vel, PVector pos, float radius) {
    this.radius = radius;
    particles = new Particle[protons + neutrons];
    for(int i = 0; i < protons; i++){
      PVector rd = pv(1,1).setMag(radius).setHeading(random(2*PI));
      particles[i] = new Particle(pos.add(rd),vel,0);
    }
    for(int i = protons; i < protons + neutrons; i++){
      PVector rd = pv(1,1).setMag(radius).setHeading(random(2*PI));
      particles[i+protons] = new Particle(pos.add(rd),vel,0);
    }
  }
  
  public void display() {
    for(Particle p : particles){
      fill(p.type == 0? color(255,0,0):color(255,255,255));
      cir(p.pos,radius);
    }
  }
  
  public void update() {
    for(Particle p : particles){
        p.prevPos = p.pos.copy();
    }
    for(Particle p : particles){
      for(Particle i : particles){
        if(p.equals(i)) {continue;}
        PVector offset = p.pos.copy().sub(i.pos).normalize();
        offset.setMag(calcDst(p.pos,i.pos)/2 - radius);
        i.pos.add(offset);
        p.pos.sub(offset);
      }
    }
    for(Particle p : particles){
      PVector mouse = pv(mouseX-width/2,-mouseY+height/2);
      if(calcDst(mouse, p.pos) > radius || !mousePressed){
        p.pos.add(p.vel);
      } else {
        println("hi");
        PVector diff = p.pos.copy().sub(mouse);
        p.pos = mouse.add(diff);
      }
    }
    for(Particle p : particles){
      p.vel = p.pos.copy().sub(p.prevPos);
    }
  }
}
