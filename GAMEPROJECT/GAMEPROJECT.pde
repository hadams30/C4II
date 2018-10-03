import SimpleOpenNI.*;
import oscP5.*;
import netP5.*;
String add1 = "/example/1/position";
String add2 = "/example/2/position"; 
String add3 = "/example/3/position";
float none = 1;
PVector nothing = new PVector(0,0,0);
SimpleOpenNI kinect = new SimpleOpenNI(this);
OscP5 oscP5; //create osc object
//NetAddress myremotelocation = new NetAddress("172.16.222.118",6666);//defining remote IP address
NetAddress myremotelocation = new NetAddress("172.16.212.175",7000);//defining remote IP address

void setup(){
 kinect.enableDepth();
 kinect.enableUser();
 kinect.setMirror(false);
 noStroke();
 size(630,420); 
 oscP5 = new OscP5(this, 7000);//initializing, connecting to port

}


void draw(){
 background(0);
 kinect.update();
 image(kinect.userImage(),0,0);//you don't have to print this image 
  
 IntVector userList = new IntVector(); //array for the user lists: storing information about each individual
 kinect.getUsers(userList);//look for users IDs
 
 
 
 if(userList.size()>0){
   int userId = userList.get(0);//first cell of array in userId variable
   kinect.startTrackingSkeleton(userId);
   drawJoint(userId, SimpleOpenNI.SKEL_TORSO, 0);
  
  if(userList.size()>1){
    int userId2 = userList.get(1);//first cell of array in userId variable
    kinect.startTrackingSkeleton(userId2);
    drawJoint(userId2, SimpleOpenNI.SKEL_TORSO, 1);
  }
  
  if(userList.size()>2){
    int userId3 = userList.get(2);//first cell of array in userId variable
    kinect.startTrackingSkeleton(userId3);
    drawJoint(userId3, SimpleOpenNI.SKEL_RIGHT_HAND, 2);
  }
 }
 

}


void drawJoint(int userId, int jointId, int user){
   PVector newJoint = new PVector();//hosting new vector that can include all x,y info for a specific joint
   kinect.getJointPositionSkeleton(userId, jointId, newJoint);//use documentation to find names of each joint
   
   PVector convertedNewJoint = new PVector();//convert coordinates from connect to processing
   kinect.convertRealWorldToProjective(newJoint, convertedNewJoint);
   
   
   fill(255,0,0);
   textSize(60);
   if(user==0){
     text("0",convertedNewJoint.x, convertedNewJoint.y);
   }
   if(user==1){
     text("1",convertedNewJoint.x, convertedNewJoint.y);
   }
   if(user==2){
     text("2",convertedNewJoint.x, convertedNewJoint.y);
   }
   //ellipse(convertedNewJoint.x, convertedNewJoint.y,40,40);
   println("x:  " + newJoint.x);
   println("y:  " + newJoint.y);
   println("z:  " + newJoint.z);

   delay(30);
   if((convertedNewJoint.x>0)&&(convertedNewJoint.y>0)){
   sendOSC(userId, convertedNewJoint, user);
   }
}

void sendOSC(int userId, PVector convertedNewJoint, int user){
OscMessage mymessage1 = new OscMessage(add2);
OscMessage mymessage2 = new OscMessage(add1);
OscMessage mymessage3 = new OscMessage(add3);
  
  if(user==0){
      //mymessage.add(add2);
      mymessage1.add(-25.16);
      mymessage1.add(1.91);
      //mymessage.add(1.91);
      float sendjoint1 = map(convertedNewJoint.x,0,650,-8,8);
      mymessage1.add(sendjoint1);
  }
  if(user==1){
      //mymessage.add(add1);
      mymessage2.add(25.12);
      mymessage2.add(1.91);
      float sendjoint2 = map(convertedNewJoint.x,0,650,-8,8);
      mymessage2.add(sendjoint2);
  }
  if(user==2){
      //mymessage.add(add3);
      mymessage3.add(none);
      mymessage3.add(none);
      float sendjoint3 = map(convertedNewJoint.x,0,400,-50,50);
      mymessage3.add(sendjoint3);
  }
  
  oscP5.send(mymessage1, myremotelocation);
  oscP5.send(mymessage2, myremotelocation);
  oscP5.send(mymessage3, myremotelocation);
  
}
