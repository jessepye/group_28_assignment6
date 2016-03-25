player p;
int numEnemies=40;
ArrayList <Enemy> enemies = new ArrayList();

//The zoomed in "box" that the player actually views;
class ViewPort{
  float x, y; // Center of the view
  float x1, y1, x2, y2; // Corners of the view, size
  float size;
}

abstract class Entity{
  float x;
  float v_x;
  float y;
  float v_y;
  float speed;
  float direction;
  float size;
  
  Entity(){
    x=0;
    v_x=0;
    y=0;
    v_y=0;
    size=0;
    speed=0;
    direction=0;
  }
  
  void render(){
    ellipse(x,y,size,size);
  }
}

class player extends Entity{
  
  
  player(){
    
    x=width/2;
    y=height/2;
    speed=2;
    size=20;
  }
  
  void update(){
    float s; //because "speed" should not necessarily be changed after each update
    //Only move if the mouse is far away
    if(dist(x,y,mouseX,mouseY)<size*0.5) s=0;
    else s=speed;
    
    //Now figure out the direction of movement
    direction = atan((mouseY-y)/(mouseX-x));
    if(mouseX<x) direction += PI;
    direction=direction%(2*PI);
    
    //Finally, figure out the x and y components
    v_x=s*cos(direction);
    v_y=s*sin(direction);
    
    x+=v_x;  //TODO: make this dependent on time rather than frames
    y+=v_y;
    
    //Did we eat anyone??
    for(int i=0; i<enemies.size(); i++){
      Enemy e = enemies.get(i);
      if(dist(x,y,e.x,e.y)<(size/2)+(e.size/2)){
        if(size>e.size){
          size=2*sqrt(pow(size/2,2)+pow(e.size/2,2));
          enemies.remove(e);
          println(size);
        }
        else size=0; //TODO: make the player dead, not "small"
      }
    }
  }
  
  void render(){
    fill(#6F99FF);
    ellipse(x,y,size,size);
    line(x,y,x+size*0.75*cos(direction), y+size*0.75*sin(direction));
  }
  
}

class Enemy extends Entity{
  int id;
  float chaseDistance;
  float fleeDistance;
  Enemy(int _id){
    id=_id;
    x=random(width);
    y=random(height);
    chaseDistance=300;
    fleeDistance=400;
    if(id<10) size=10;
    else size=10+random(100);
    speed=10/size+0.1;
    direction=random(2*PI);
  }
  
  void update(){
    Entity closestSmaller = null;
    Entity closestLarger = null;
    if(p.size<size && dist(x,y,p.x,p.y)<chaseDistance){
      closestSmaller = p;
    }
    else if(p.size>size && dist(x,y,p.x,p.y)<fleeDistance){
      closestLarger = p;
    }
    
    //Simple wall detection
    //TODO: Find a better algorithm; something other than "run directly away from the wall"
    if(x<size/2) direction = 0;
    if(x+size/2>width) direction = PI;
    if(y<size/2) direction = HALF_PI;
    if(y+size/2>height) direction = 3*HALF_PI;
    
    //Finally, figure out the x and y components
    v_x=speed*cos(direction);
    v_y=speed*sin(direction);
    
    x+=v_x;  //TODO: make this dependent on time rather than frames
    y+=v_y;
  }
  
  void render(){
    fill(255);
    ellipse(x,y,size,size);
    line(x,y,x+size*0.75*cos(direction), y+size*0.75*sin(direction));
  }
}

void setup(){
  surface.setSize(1600,1000);
  background(192);
  p = new player();
  for (int i = 0; i < numEnemies; i++) {
    Enemy e = new Enemy(i);
    enemies.add(e);
  } 
}

void draw(){
  background(192);
  p.update();
  p.render();
  for(int i=0; i<enemies.size(); i++){
    enemies.get(i).update();
    enemies.get(i).render();
  }
  
}