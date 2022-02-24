
/*
la massima estensione del robot la si raggiunge a 
z= 50,77; 
x = 669.984;
*/





//parametro visuale
float eyeY=0;

//coordinate del link 1 del robot
float xBase;
float yBase;
float zBase;

// link 0 base fissa del robot // opzionale ma fa figo
float b0x = 200; // lungo x
float b0y = 20; // lungo y
float b0z = 200; // lungo z

// dimensioni link 1: giunto rotoidale su theta 1 
float d0x = 150; // lungo x
float d0y = 50; // lungo y
float d0z = 150; // lungo z

// dimensioni link 2 : giunto rotoidale su theta 2
float d1x = 200; // lungo x
float d1y = 30; // lungo y
float d1z = 30; // lungo z

// dimensioni link 3 : giunto rotoidale su theta 3
float d2x = 200; // lungo x
float d2y = 30; // lungo y
float d2z = 30; // lungo z

// dimensioni link 4 : giunto rotoidale su theta 4
float d3x = 200; // lungo x
float d3y = 30; // lungo y
float d3z = 30; // lungo z

// dimensioni link 5 PINZA : giunto rotoidale pinza
float d4x = 30; // lungo x
float d4y = 60; // lungo y
float d4z = 60; // lungo z

// dimensioni link 5 FORCHE PINZA
float d5x = 40; // lungo x
float d5y = 20; // lungo y
float d5z = 10; // lungo z

// parametri giunto (theta1, theta2, theta3 , theta4 ,theta 5)
float theta[] = {0,0,0,0,0}; 
float posPinza = 0;


// Parte per il progetto:  

float x_des = 200;  // X deiderata
float y_des = 0;  // y desiderata
float z_des = 200 ;  // z desiderata
float beta_des;  
float omega_des; // angolo omega di rollio 
float x_0 = xBase; // terna di riferimento 
float y_0 = yBase; 
float z_0 = 0; 


// step di incremento 
float step_5 = 1; // velocita di rotazione angolo theta_5
float step_x = 1 ;  // velocita incremento x_des
float step_y = 1 ;  // velocita incremento y_des
float step_z = 1 ;  // velocita incmento z_des
float step_beta = 1 ; // velocita incremento angolo di beccheggio desiderato



// elementi della matrice di rortazione 
float r11;
float r21;
float r31;

float r12;
float r22;
float r32;

float r13;
float r23;
float r33;


float precisione = 0.00001;
float l1=d0x/2-d1y/2;
float l2 = d1x-d1y/2;
float l3 = d2x-d2y;
float d1 = d0y;
float d5 = d3x+d4x+d5x-d2y/2;
float Xpolso;
float Ypolso;
float Zpolso;
float A1;
float A2;
float argAcos; // argomento del arcocoseno per theta 3
float kp = 1;
int orientamento = 1;// robot proteso in avanti
float C2;
float S2;
float argcos;
int k;


// CILINDRO 
float bottom = 23;
float top =23; 
float h =120; // ALTEZZA POLIGONO 
int lati = 64; // NUMERI DI ANGOLI DEL POLIGONO 



int flag = 0 ; 

void setup()
{

  size(1500,800,P3D);
  stroke(255);
  strokeWeight( 1);
 
  xBase=width/2;
  yBase=height/2+200;
  smooth();
}

void draw()
{
  
  int k=0;
  background(0);
  lights();
  camera((width/2.0), height/2 - eyeY, (height/2.0) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);


  if(mousePressed){
      xBase=mouseX;
      yBase=mouseY;
  }
  
  if(keyPressed){
  
  if(keyCode == UP)
    eyeY += 5;  
  
  
  if(keyCode == DOWN)
    eyeY -= 5;
  
  
  if(key == 'k'){
    kp -= .01;
    if(kp < .01)
      kp = .01;
    
  }
  
  if(key == 'K'){
    kp += .01;
    if(kp > 1)
      kp = 1;
    
  }
  
  if (key == 'o' || key == 'O') // apertura pinza
    {
      if (posPinza<d4z/2-d5z)
         posPinza += 1;
    }
    if (key == 'c' || key == 'C') // chiusura pinza
    {
      if (posPinza>0)
        posPinza -= 1;
    }
  
  if(key == 'x')
    x_des -= kp*step_x;
  
  if(key == 'X')
    x_des += kp*step_x;
  
  if(key == 'y')
    y_des -= kp*step_y;
  
  if(key == 'Y')
    y_des += kp*step_y;
  
  if(key == 'z')
    z_des -= kp*step_z;
  
  if(key == 'Z')
    z_des += kp*step_z;
  
  if(key == 'w')
    omega_des -= kp*step_5;
    
  
  if(key == 'W')
    omega_des += kp*step_5;
    
  
  if(key == 'b')
    beta_des -=kp* .1;
   
  if(key == 'B')
    beta_des += kp*.1;
  
  if( key == '1')
    orientamento = 1;
  
  if (key == '2')
     orientamento = -1;
     
     
     
  if (key == '3'){
     flag = 1;
     k=1;
  }
  if (key == '4'){
     flag = 0;
       k=2;
  }

}  

      
       if(flag == 1){
         
         // soluzione all indietro 
         theta[0] = atan2(y_des,x_des)+PI;
         theta[4]=omega_des+PI;
         if(k==1){
           beta_des=-beta_des+PI;
           k=0;
         }
       }else{
         
         // soluzione classica 
         
         theta[0] = atan2(y_des,x_des);
         theta[4]=omega_des;
        if(k==2){
           beta_des=-beta_des-PI;
           k=0;
        }
           
       }
   
       A1 = x_des*cos(theta[0]) + y_des*sin(theta[0]) - d5*cos(-beta_des) - l1;
       A2 = d1 - z_des - d5*sin(-beta_des);
       argcos = (pow(A1,2) + pow(A2,2) - pow(l2,2) - pow(l3,2))/(2*l2*l3);
       theta[1] = atan2( (l2+l3*cos(theta[2]))*A2-l3*sin(theta[2])*A1, (l2+l3*cos(theta[2]))*A1 + l3*sin(theta[2])*A2);
       theta[3] = (beta_des - theta[1] - theta[2] - PI/2);
       if( argcos <= 1 && argcos >= -1 ){
           theta[2] = orientamento*acos(argcos);
           
          
           
       }else{
           text("Fuori dallo spazio di lavoro", width/2+100, height-40);
           println(argcos);
       }
    
      r11= cos(theta[0])*cos(theta[1]+theta[2]+theta[3])*cos(theta[4])+sin(theta[0])*sin(theta[4])+precisione; 
      r21= sin(theta[0])*cos(theta[1]+theta[2]+theta[3])*cos(theta[4])-cos(theta[0])*sin(theta[4])+precisione; 
      r31= -sin(theta[1]+theta[2]+theta[3])*cos(theta[4])+precisione;
      
      r12= -cos(theta[0])*cos(theta[1]+theta[2]+theta[3])*sin(theta[4])+sin(theta[0])*cos(theta[4])+precisione; 
      r22= -sin(theta[0])*cos(theta[1]+theta[2]+theta[3])*sin(theta[4])-cos(theta[0])*cos(theta[4])+precisione;
      r32= sin(theta[1]+theta[2]+theta[3])*sin(theta[4])+precisione;
      
      r13= -cos(theta[0])*sin(theta[1]+theta[2]+theta[3])+precisione;
      r23= -sin(theta[0])*sin(theta[1]+theta[2]+theta[3])+precisione;
      r33= -cos(theta[1]+theta[2]+theta[3])+precisione;


   //limiti(); // inserimento periodicita angoli da 0 a 360
   Testi(); // inserimento testi
   scorbot(); // disegno robot 
}



void Testi()
{
  //Inserimento testi 
  textSize(25);
  fill(255,0,0);
  
  //KP di controllo;
  text("kp = ",10, 30);
  text(kp,60,30);
  
  //Angoli
  text("theta1 = ",10,70); 
  text(theta[0]*180/PI,120,70);
  
  text("theta2 = ",10,120); 
  text(theta[1]*180/PI,120,120);
  
  text("theta3 = ",10,170); 
  text(theta[2]*180/PI,120,170);
  
  text("theta4 = ",10,220); 
  text(theta[3]*180/PI,120,220);
 
  text("theta5 = ",10,270); 
  text(theta[4]*180/PI,120,270);
  
    
  
  // terna di riferimento 
  text("x_0 = ",10,330); 
  text(x_0,90,330);
  text("y_0 = ",10,365); 
  text(y_0,90,365);
  text("z_0 = ",10,400); 
  text(z_0,90,400);
  
  

  fill(0,255,0);  
  text("coordinata y vista = ",600,30); 
  text(eyeY,900,30);
  text("percentuale apertura pinza = ",600,80); 
  text(round(100*posPinza/(d4x/2-d5x)),980,80);
  text("%",1050,80);

  textSize(25);
  fill(255,0,0);
  
  text("x_des =  ",320,20); 
  text(x_des,430,20);
  
  text("y_des = ",320,70); 
  text(y_des,430,70);
  
  text("z_des = ",320,120); 
  text(z_des,430,120);
  
  text("beta_des  = ",320,170); 
  text((beta_des)*180/PI,470,170);
  
  text("omega_des = ",320,220); 
  text((theta[4])*180/PI,500,220);
 
  if (orientamento == -1)
  {
    fill(0,255,0);
    text("Gomito Basso",width-170,height-40); 
  }
  else
  {
    fill(0,255,0);
    text("Gomito Alto",width-170,height-40); 
  } 
  
  if (flag == 1)
    text("Robot Rivolto all INDIETRO", width-1050, height-40);
  else
    text("Robot Rivolto in AVANTI ", width-1050, height-40);
  
  
  // scrivo la matrice di rotazione 
  
    fill(#052CEA);
    text("Matrice di rotazione R-05",width-1460,height-200);
    text(r11,width-1460,height-150); 
    text(r12,width-1340,height-150); 
    text(r13,width-1220,height-150); 
  
    text(r21,width-1460,height-100); 
    text(r22,width-1340,height-100); 
    text(r23,width-1220,height-100); 
  
    text(r31,width-1460,height-50); 
    text(r32,width-1340,height-50); 
    text(r33,width-1220,height-50); 
  
}

void scorbot(){
  
 // sist di riferimento iniziale
 x_0 = mouseX - xBase;
 y_0 = zBase;
 z_0 = yBase - mouseY;

 // inizio inserimento del robot
 // link 0 base fissa del robot
 
 translate(xBase,yBase,zBase);  
 riferimento_iniziale(); // disegno sistema di riferimento iniziale 
 Base(); // DISEGNA LA BASE DEL ROBOT
 
 fill(#F07400);
 //link1 base
 translate(0,-(d0y)/2,0);
 rotateY(theta[0]);
 box(d0x,d0y,d0z);
   
 // Link 2 (si muove con THETA 2 = theta[1]) 
 translate((d0x/2)-d1y/2,-d0y/2,0); 
 rotateZ(theta[1]-PI);  // asse di rotazione
 cilindro(); // disegno cilindri su i giunti rotoidali 
 translate(-(d0x+d0y)/2,0,0);// translate(-(d0x)/2,0,0); //;
 box(d1x,d1y,d1z); // crea il poligono

  
 
 // Link 3 (si muove con THETA 3 = theta[2])
 translate(-(d1x-d1y)/2,0,0); // sposto il primo asse di rotazione 
 rotateZ(theta[2]+PI); // compio la rotazione
 cilindro();
 translate((d1x-d1z)/2,0,0);
 box(d2x,d2y,d2z);  

 // Link 4 (si muove con THETA 4 = theta[3])
 translate(-(d2x-d2y)/2+(d2x-d2y),0,0); // sposto il primo asse di rotazione 
 rotateZ(theta[3]+PI/2);
 cilindro();
 translate((d2x-d2z)/2,0,0);
 box(d3x,d3y,d3z);
 
 
 
 // Link 5 PINZA (si muove con THETA 5 = theta[4])
 fill(255,0,0); // Colore della pinza
 rotateX(theta[4]);
 translate(d3x/2+d3y/2,0,0);  
 box(d4x,d4y,d4z);
 
  
 riferimento_finale(); // disegno sistema di riferimento finale 
 Pinza(); // disegno pinza 

}  

void Pinza(){

     // Pinza FORCHE PINZA
 pushMatrix(); // Memorizzo il sistema attuale
 translate(d4x+d5z/2,0,-d5z/2-posPinza);  
 box(d5x,d5y,d5z); // Disegno il primo elemento della pinza
 popMatrix();  // Ritorno al sistema di riferimento memorizzato
 translate(d4x+d5z/2,0,d5z/2+posPinza);  
 box(d5x,d5y,d5z); // Disegno il secondo elemento della pinza
   
}

void Base()
{
 pushMatrix();
 fill(#89847F);
 translate(0,b0y/2,0);
 box(b0x,b0y,b0z);
 popMatrix();

}

void riferimento_iniziale()
{

   // SISTEMA DI RIFERIMENTO 0
   fill(#03834D);
   text("Z_0",-50,-120,0);
   line(0, 0, 0, 0, -120, 0);
   text("Y_0",-20,20,200);
   line(0, 0, 0, 200, 0, 0);
   text("X_0",210,0,0);
   line(0, 0, 0, 0, 0,200);
}

void riferimento_finale()
{

  pushMatrix(); // Memorizzo il sistema attuale
  fill(#03834D);
  translate(d4x/2+d5x,0,0);
  
  text("X_5",10,-100,0);
  line(0, 0, 0, 0, -100, 0); 

  text("Z_5",100,-10,0);
  line(0, 0, 0, 100, 0, 0); 
  
  text("Y_5",20,0,-100);
  line(0, 0, 0, 0, 0,-100); 
  popMatrix();  // Ritorno al sistema di riferimento memorizzato
}

void  limiti()
{
  
  if (beta_des > 2*PI || beta_des < -2*PI )
          
          
          beta_des=0;
  
 if (omega_des >= 2*PI || omega_des <= -2*PI )
          omega_des=0;
          
 if ( theta[4] >= 2*PI || theta[4] <= -2*PI )
          theta[4]=0; 
}

void cilindro()
{
  pushMatrix();
  noStroke();
  rotateX(PI/2);
 
  float angoli;
  float x[] = new float[lati+1];
  float z[] = new float[lati+1];
  
  float x2[] = new float[lati+1];
  float z2[] = new float[lati+1];
 
  //get the x and z position on a circle for all the sides
  for(int i=0; i < x.length; i++){
    angoli = 2*PI / (lati) * i;
    x[i] = sin(angoli) * bottom;
    z[i] = cos(angoli) * bottom;
  }
  
  for(int i=0; i < x.length; i++){
    angoli = TWO_PI / (lati) * i;
    x2[i] = sin(angoli) * top;
    z2[i] = cos(angoli) * top;
  }
 
  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN);
 
  vertex(0,   -h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
  }
 
  endShape();
 
  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
    vertex(x2[i], h/2, z2[i]);
  }
 
  endShape();
 
  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN); 
 
  vertex(0,   h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x2[i], h/2, z2[i]);
  }
 
  endShape();
  stroke(255);
  strokeWeight( 1);
  popMatrix();
}


   
