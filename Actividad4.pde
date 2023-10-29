// Authors: 
// Julián Rodríguez
// Ximo Casanova

import fisica.*;

final int tamTableroX = 10;
final int tamTableroY = 120;
final int Longitud_Mastil = 300;
final int Tam_shuriken = 60;

int SizeX = 1000;
int SizeY = 1000;

boolean fullscreen = false;

int puntos = 0;

FWorld _world;
FCircle shuriken;
FBox madero;
FRevoluteJoint joint;

PImage shurikenB;
PImage tronco;
String texturaB = "shuriken.png";
String texturaT = "tronco.png";

boolean dragged = false;

int torque = 200;


void settings()
{
  if(fullscreen)
  {
    fullScreen();
    SizeX = width;
    SizeY = height;
  }
  else
    size(SizeX, SizeY);
}


void setup()
{
  
  smooth();
 
  shurikenB = loadImage(texturaB);
  shurikenB.resize(Tam_shuriken,Tam_shuriken);
  
  tronco = loadImage(texturaT);
  tronco.resize(130,50);

  initSimulation();
}

void initSimulation()
{
  Fisica.init(this);
  _world = new FWorld();
  _world.setEdges();
  
  shuriken = new FCircle(Tam_shuriken);

  int posX = width/2;
  int posY = height - Tam_shuriken;
  
   shuriken.setPosition(posX,posY);
   shuriken.setDensity(10.0);
   shuriken.setRestitution(1);
   shuriken.setFriction(2);
   shuriken.setAngularDamping(1);
   shuriken.setDamping(0.5); 
   shuriken.attachImage(shurikenB);
  
  
  FBox Enganche = new FBox(tamTableroX,tamTableroY-40);
  Enganche.setPosition(width - 10, height - 420);
  Enganche.setDensity(10.0);
  Enganche.setStatic(true);
  
  _world.add(shuriken);
  _world.add(Enganche);
   
   madero = new FBox(130,50);
   madero.setPosition(3*width/4 - 55, height - 420);
   madero.setDensity(0);
   madero.attachImage(tronco);
   
   _world.add(madero);
   
   joint = new FRevoluteJoint(madero,Enganche);
   
   joint.setEnableLimit(true);
   joint.setLowerAngle(0);
   joint.setUpperAngle(0);
   
   _world.add(joint);
   
}

void draw() 
{
  background(42,111,55);
  _world.step();  
  
  Punto();
  
  DibujaEscenario();
  
  _world.draw();
  
  DibujaMarcador();
  
}

void Punto()
{
  
  if(!dragged)
  {
    
    if(madero.isTouchingBody(shuriken) && shuriken.getY() < madero.getY())
    {
      
        shuriken.setPosition(width/2 , height - Tam_shuriken);
        puntos++;
        
    }
    
  }
  
}

void DibujaMarcador()
{
  
  fill(0);
  textSize(32);
  text( puntos, width/2 - 8,height/6 + 35);
}

void DibujaEscenario()
{
  

  fill(155,103,60);
  rect(0,5*height/6 + 40, width, 125);
  
  textSize(32);
  fill(0);
  text( "PUNTOS", width/2 - 60,height/6 - 10);
  stroke(0);
  strokeWeight(3);
  fill(255);
  
  beginShape(QUAD_STRIP);
  vertex(width/2 - 50, height/6);
  vertex(width/2 + 50, height/6);
  
  vertex(width/2 + 50, height/6);
  vertex(width/2 + 50, height/6 + 50);
  
  vertex(width/2 + 50, height/6 + 50);
  vertex(width/2 - 50, height/6 + 50);
  
  vertex(width/2 - 50, height/6 + 50);
  vertex(width/2 - 50, height/6 );
  

  textSize(14);
  fill(0);
  text("Para una partida nueva pulse 'r' o 'R'", 100,100);
  text("Para salir pulse 'q' o 'Q'", 100, 125);
}

void reset()
{
  _world.clear();
  
  puntos = 0;
  
  initSimulation();
}

void keyPressed()
{
  if(key == 'r' || key == 'R')
  {
    
    reset();
    
  }
  
  if(key == 'q' || key == 'Q')
  
    exit();
}

void mouseDragged()
{
  
  dragged = true;
  
}

void mouseReleased()
{
  
  shuriken.addTorque(torque);
  dragged = false;
  
}
