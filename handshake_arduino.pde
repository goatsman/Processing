import processing.serial.*;

Serial mySerialPort;       // Create object from Serial class
String serialPortData;     // Data received from the serial port
// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
boolean firstContact = false;

void setup(){
  
  size(500,500);
  String portName = Serial.list()[2];  //change the 0 to a 1 or 2 etc. to match your port
  mySerialPort = new Serial(this, portName, 9600); 
  mySerialPort.bufferUntil('\n'); 
}

void draw(){
    
}

void serialEvent( Serial myPort) {
//put the incoming data into a String - 
//the '\n' is our end delimiter indicating the end of a complete packet
serialPortData = myPort.readStringUntil('\n');
//make sure our data isn't empty before continuing
if (serialPortData != null) {
  //trim whitespace and formatting characters (like carriage return)
  serialPortData = trim(serialPortData);
  println(serialPortData);

  //look for our 'A' string to start the handshake
  //if it's there, clear the buffer, and send a request for data
  if (firstContact == false) {
    if (serialPortData.equals("A")) {
      myPort.clear();
      firstContact = true;
      myPort.write("A");
      println("contact");
    }
  }
  else { //if we've already established contact, keep getting and parsing data
    println(serialPortData);

    if (mousePressed == true) 
    {                           //if we clicked in the window
      myPort.write('1');        //send a 1
      println("1");
    }

    // when you've parsed the data you have, ask for more:
    myPort.write("A");
    }
  }
}
