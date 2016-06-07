import processing.serial.*;
Serial myPort;
int current;
float temperature, pressure, humidity;
 
int NrOfSamples = 800;
int[] tempBuff = new int[NrOfSamples];
int[] presBuff = new int[NrOfSamples];
int[] humBuff = new int[NrOfSamples];
String[] fields;

int tLimL = 20,    tLimH = 60,
    pLimL = 900,   pLimH = 1100,
    hLimL = 0,     hLimH = 100;
 
void setup()
{
  size(840, 804);  //NrOfSamples + text size; 256 + 2 + 5*2*3
  background(55);
  strokeWeight(3);
  smooth(); // or noSmooth();
  frameRate(30);
  
  String portName = Serial.list()[2];            //Change here the port!
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
  
  //Draw Labels
  pushMatrix();
  translate(0, 0);
  rotate(-HALF_PI);
  text("Temperature", -170, 20);
  text("Pressure",-430, 20);
  text("Humidity",-700, 20);
  popMatrix();
  
  //Prepare for drawing instant values
  textSize(26);
  textAlign(RIGHT);
}

//ensure values from 0 to 255 in the data field
void plot(int xPos, int yPos, int[] data){
  rect(xPos, yPos, NrOfSamples + 2, 255 + 2);
  stroke(220, 75, 75);
  for(int i = 1; i < NrOfSamples; i++) {
      line(i + xPos, yPos + 256 - data[i - 1], 
           i + xPos + 1, yPos + 256 - data[i]);
      //point(i + xPos + 1, yPos + 256 - data[i]);
    }
}
 
void draw()
{
    //Draw the plots
    fill(255);
    plot(30, 5, tempBuff);
    plot(30, 273, presBuff);
    plot(30, 541, humBuff);
        
    //Draw the current value
    if(fields != null) {
      fill(0, 0, 255);
      text(fields[0], 810, 30);
      text(fields[1], 810, 298);
      text(fields[2], 810, 566);
    }
}

void serialEvent(Serial sPort) {
  try{
    String inString = sPort.readStringUntil('\n');
   
    if(inString != null){
      inString = trim(inString);
      fields = split(inString, ' ');
      
      //Extract the values for the current sample
      temperature = float(fields[0]);
      pressure    = float(fields[1]);
      humidity    = float(fields[2]);
    
      //Shift the buffer
      for(int i = 1; i < NrOfSamples; i++)
        tempBuff[i-1] = tempBuff[i];    
      for(int i = 1; i < NrOfSamples; i++)
        presBuff[i-1] = presBuff[i];
      for(int i = 1; i < NrOfSamples; i++)
        humBuff[i-1] = humBuff[i];
      
      //Scale the new sample to fit the graph
      tempBuff[NrOfSamples-1] = int(map(temperature, tLimL, tLimH, 0, 255));
      presBuff[NrOfSamples-1] = int(map(pressure,    pLimL, pLimH, 0, 255));
      humBuff[NrOfSamples-1]  = int(map(humidity,    hLimL, hLimH, 0, 255));
    }
  }
  catch(RuntimeException e) {
    e.printStackTrace();
  }
}
