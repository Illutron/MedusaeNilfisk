struct color HSVToRGB(float H, float S, float V, int white) ;

// pins
int DMX = 3;
int CAM_BLUE = 4;
int CAM_GREEN = 3;
int PINDS = 5;
int CAM_RED = 2;
int DIODE_GREEN = 6;
int DIODE_RED = 7;
// 18 -25 rel? udgange
int bang_gas = 19;
int bang_fire = 18;

int dmx[50];
int dmx_channel[12] = {7,8,9,10,6,5,4,3,19,20,21,22};
boolean debug = true;


struct particle
{

  int end[4];
  int pos[4];
  long starttime;
  long time;
  int bang_gas_delay;
  int bang_gas_time;

};

struct color
{
  int red;
  int green;
  int blue; 
  int white;
};

int num_gobbles = 3;
int num_channels = 4;
int p_current[3] = {
  0,0,0};
int p_last[3] = {
  0,0,0};
int p_last_added[3] = {
  0,0,0};

struct particle particles[12][3];

int MAX = 10;
int spos[3] = {
  0,0,0};
int rpos[3] = {
  0,0,0};




// ########################################################################
// PLAYGROUND - THIS IS THE ART
// ########################################################################

int color =0;
void give_me_something_to_do(int gobble)
{
  color = random(360);
  for (int i =0; i < 10;i++)
  {

    ps_add_particle(HSVToRGB(color,random(20,100),random(20,100),0),random(200,500),gobble,0,0);
  }



}

void pind_animation()
{

  for (int g = 0; g < num_gobbles;g++)
  {
    qclear(g);
    ps_add_particle(HSVToRGB(100,0,100,255),5000,g,0,0); 
    ps_add_particle(HSVToRGB(0,0,0,0),5000,g,1000,500);

    qnext(g);

  }
}

 
 
// ########################################################################
// CORE SYSTEM
// ########################################################################



void ps_init()
{
  pinMode(DIODE_RED, OUTPUT);
  pinMode(DIODE_GREEN, OUTPUT);

  digitalWrite(DIODE_RED,HIGH);
  digitalWrite(DIODE_GREEN,LOW);
  // Set gas!!!;
  for (int i = 18; i < 26; i ++)
  {
    pinMode(i, OUTPUT); 
    digitalWrite(i, LOW);
  }

  for (int g = 0; g < num_gobbles; g ++)
  {
    ps_add_particle(HSVToRGB(0,100,100,0),500,g,0,0);
    ps_add_particle(HSVToRGB(0,100,100,0),500,g,0,0);
    ps_add_particle(HSVToRGB(120,100,100,0),500,g,0,0);
    ps_add_particle(HSVToRGB(240,100,100,0),500,g,0,0);
  
    qnext(g);
  }

}

//pind


long sum=0;
int counter = 0;
int counter_num = 50;

long last_time_there_was_fire =0;
int fire_delay = 4000;

void ps_pind()
{
  if (did_millis_overflow())
  {
    last_time_there_was_fire = millis();
  }

  counter = counter + 1;
   if (counter > counter_num)
  {
    counter = 0;
    sum = 0; 
  }
  
  int val = analogRead(PINDS);  // read the value of analog pin 0 


  sum = sum+ val;
  if (counter_num == counter)
  {
 // Serial.println(sum / counter );
  }

 
  if (millis() - last_time_there_was_fire >= fire_delay)
  {
    digitalWrite(DIODE_GREEN,HIGH);
    digitalWrite(DIODE_RED,LOW);



    if (counter_num == counter && sum / counter  > 500)
    {
        if (debug)
        {
          Serial.println("pind high");
          delay(5);
        }
      last_time_there_was_fire = millis();
      pind_animation();
     
    }

  }
  else
  {

    digitalWrite(DIODE_RED,HIGH);
    digitalWrite(DIODE_GREEN,LOW);

  }
 
}

void ps_add_particle(struct color current_color,int time,int gobble, int bang_gas_time,int bang_gas_delay)
{
  struct particle particle_temp;
 
  particle_temp.starttime = 0;

  particle_temp.time  = time;

  particle_temp.end[0]  = current_color.red;
  particle_temp.end[1]  = current_color.green;
  particle_temp.end[2]  = current_color.blue;
  particle_temp.end[3]  = current_color.white;
  particle_temp.bang_gas_time = bang_gas_time;
  particle_temp.bang_gas_delay = bang_gas_delay;
  qstore(particle_temp,gobble);
}


void qclear(int gobble)
{
  spos[gobble] =rpos[gobble];
}

void qstore(struct particle q, int gobble)
{
  if(spos[gobble]+1==rpos[gobble] || (spos[gobble]+1==MAX && !rpos[gobble])) {
    // printf("List Full\n");
    return;
  }
  particles[spos[gobble]][gobble] = q;
  p_last_added[gobble] = spos[gobble];
  spos[gobble]++;
  if(spos[gobble]==MAX) spos[gobble] = 0; /* loop back */
}


void qnext(int gobble)
{
   if (debug)
   {
      Serial.print("particle next");
      Serial.println(gobble);
      delay(5);
   }
  digitalWrite(gobble*2+bang_gas, LOW);
  digitalWrite(gobble*2+bang_fire, LOW);
  if(rpos[gobble]==MAX) rpos[gobble] = 0; /* loop back */
  if(rpos[gobble]==spos[gobble]) give_me_something_to_do(gobble);
  p_last[gobble] = p_current[gobble];

  rpos[gobble]++;
  p_current[gobble] = rpos[gobble]-1;

  particles[p_current[gobble]][gobble].starttime = millis();
} 

void ps_move()
{
  if (did_millis_overflow())
  {
    for(int g=0; g < num_gobbles;g++)
    {
      qnext(g);
    }
  }  
  // move the shit
  for(int g=0; g < num_gobbles;g++)
  {

    // check to see if we are at the end pos
    if (millis() >= (particles[p_current[g]][g].starttime + particles[p_current[g]][g].time))
    {
      if (particles[p_current[g]][g].bang_gas_delay >0 && particles[p_current[g]][g].bang_gas_time > 0)
      { 
        digitalWrite(g*2+bang_gas, HIGH);
        if (debug)
        {
          Serial.print("gas high ");
          Serial.println(g);
          delay(5);
        }
        if(millis() >= (particles[p_current[g]][g].time   + particles[p_current[g]][g].starttime + 250))
        {
           
          if (debug)
          {
            Serial.print("gas blink high ");
            Serial.println(g);
            delay(5);
          }
          digitalWrite(g*2+bang_gas, LOW);
          digitalWrite(g*2+bang_gas, HIGH);
        }
        if (millis() >= (particles[p_current[g]][g].time   + particles[p_current[g]][g].starttime + particles[p_current[g]][g].bang_gas_delay))
        {
          digitalWrite(g*2+bang_fire, HIGH);
          if (debug)
          {
            Serial.print("gas ignition");
            Serial.println(g);
            delay(5);
          }
        }

      }
      if (millis() >= particles[p_current[g]][g].starttime + particles[p_current[g]][g].time + particles[p_current[g]][g].bang_gas_time)
      {
        qnext(g);

      }


    }


    float  time_percent = float(millis() - particles[p_current[g]][g].starttime)/float(particles[p_current[g]][g].time) * 100;
    if( time_percent > 100)
    {
      time_percent = 100;
    }
    if (time_percent < 0)
    {
      time_percent = 0;
    }
    float pos_percent = 50*(sin((PI* time_percent)/100 - PI/2)+1);
    int pos =0;
    for(int c=0; c < num_channels; c++)
    {

      particles[p_current[g]][g].pos[c] = round(float(particles[p_last[g]][g].pos[c]) + (float(particles[p_current[g]][g].end[c]) - float(particles[p_last[g]][g].pos[c])) * pos_percent/100);
      dmx[dmx_channel[g*4+c]] =round(long(particles[p_current[g]][g].pos[c]) * 0.90 + 255 * 0.05);
    //   Serial.println(dmx[dmx_channel[g*4+c]]);
    }

  }

  // set dmx


}

long millis_last_time = 0;
boolean did_millis_overflow()
{
  if(millis_last_time > millis())
  {
     millis_last_time = millis();
     return true; 
    
  }
  else
  {
     millis_last_time = millis();
     return false; 
  }
}

char command='*';
char data;
char red,green,blue;
char ready=0;

/*
void process_serial(void)
{
  while(Serial.available())
  {
    data=Serial.read();
    if(command!='*')
    {
      
      switch(command)
      {
        case 'R': red=data;break;
        case 'G': green=data;break;
        case 'B': blud=data;break;
        case 'X': ready=1;      
      }
      command='*';    
    }
    else
      command=data;  
  }
}*/
// ########################################################################
// DMX SYSTEM
// ########################################################################
void dmx_init()
{
  pinMode(0, OUTPUT);
  for (int i= 0; i > 50;i++)
  {
    dmx[i] = 0;
  }

  pinMode(3, OUTPUT);
  digitalWrite(3, LOW);
  int baudrate = 250000;
  uint16_t t;
  t = ((CPU_FREQ % (16L*baudrate) >= (16L*baudrate)/2) ? (CPU_FREQ / (16L*baudrate)) : (CPU_FREQ / (16L*baudrate)) - 1);

  UBRR1H  = (t >> 8) & 0xff;
  UBRR1L  = t & 0xff;
  UBRR1L=3  ;
  UBRR1H=0;


}

void dmx_send(void)
{
  
  digitalWrite(3, LOW);
  
  UCSR1B&=0XF7;    
  delay(1);   
  UCSR1B|=0X08;

  int i;
  for(i=0;i<50;i++)
  {
    UDR1=dmx[i];
    while(!(UCSR1A&0x40))
    {
      
      
      
      
     
    };
    UCSR1A|=0x40;
    delayMicroseconds(8);
  }

  
  digitalWrite(3, HIGH);
}

// ########################################################################
// SETUP / LOOP
// ########################################################################

void setup() {
  pinMode(48, OUTPUT); 
  digitalWrite(48, HIGH);



  dmx_init();
  ps_init();
  Serial.begin(9600); 
  Serial.println("hello world");

}


void loop()  {
  
  dmx_send();
  ps_pind();
  dmx_send();
  ps_move(); 
  //process_serial();


}




// ########################################################################
// COLOR CONVERTER
// ########################################################################


void RGBToHSV (float R,float G, float B) {
                float V,S,H;
		 float mymax = max(R,max(G,B));
		float mymin = min(R,max(G,B));
		float delta = mymax-mymin;
		V = round((mymax / 255) * 100);
		if(mymax != 0){
			S = round(delta/mymax * 100);
		}else{
			S = 0;
		}
		
		if(S == 0){
			H = 0;
		}else{
			if(R == mymax){
				H = (G - B)/delta;
			}else if(G == mymax){
				H = 2 + (B - R)/delta;
			}else if(B == mymax){
				H = 4 + (R - G)/delta;
			}
			H = round(H * 60);
			if(H > 360){
				H = 360;
			}
			if(H < 0){
				H += 360;
			}
		}
	
	}
struct color HSVToRGB(float H, float S, float V,int white) 
{
  float F,P,Q,T;
  H = H/360;
  S = S/100;
  V = V/100;
  struct color current_color;
  if (S <= 0) {
    V =round(V*255);
    current_color.red = V;
    current_color.green = V;
    current_color.blue = V;
  } 
  else {

    if (H >= 1.0) {
      H = 0;
    }
    H = 6 * H;
    F = H - int(H);
    P = round(255 * V * (1.0 - S));
    Q = round(255 * V * (1.0 - (S * F)));
    T = round(255 * V * (1.0 - (S * (1.0 - F))));
    V = round(255 * V);
    switch (int(H)) {
    case 0:
      current_color.red = V;
      current_color.green = T;
      current_color.blue = P;
      break;
    case 1:
      current_color.red = Q;
      current_color.green = V;
      current_color.blue = P;
      break;
    case 2:
      current_color.red = P;
      current_color.green = V;
      current_color.blue = T;
      break;
    case 3:
      current_color.red = P;
      current_color.green = Q;
      current_color.blue = V;
      break;
    case 4:
      current_color.red = T;
      current_color.green = P;
      current_color.blue = V;
      break;
    case 5:
      current_color.red = V;
      current_color.green = P;
      current_color.blue = Q;
      break;
    }
  }
  current_color.white = white;
  return current_color;
}

