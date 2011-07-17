struct color HSVToRGB(float H, float S, float V, int white) ;
//void //print_debug(String txt, int value, int gobble);

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
boolean debug = false;


struct particle
{

  int end[4];
  int pos[4];
  int start[4];
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

struct particle particles[3];







// ########################################################################
// PLAYGROUND - THIS IS THE ART
// ########################################################################

int color[3] ={0,0,0};





int step[3] = {0,0,0};
int mode[3] = {-1,-1,-1};


void give_me_something_to_do(int gobble)
{
//print_debug("step", step[gobble], gobble);
  switch(mode[gobble])
      {
        case -1: // startup rgb test
        {
          
          
          ps_set_particle(HSVToRGB(step[gobble] * 120,100,100,0),2000,gobble,0,0);
   
          if (step[gobble] == 3)
          {
            ps_set_particle(HSVToRGB(0,0,0,255),2000,gobble,0,0);
          }
          if (step[gobble] == 4)
          {
             set_mode(0,gobble); 
          }
          break;
        }
        case 0:  // deault random colors
        {

          if (step[gobble] == 0 || step[gobble] == 10 )
          {
            color[gobble] = random(360);
            
          }
          ps_set_particle(HSVToRGB(color[gobble],random(20,80),random(50,100),0),random(1000,2000),gobble,0,0);
          
          break;
        }
        case 1: // fire
        {
           //print_debug("FIREMODE step:", step[gobble], gobble); 
           
           if (step[gobble] == 0)
           {
             ps_set_particle(HSVToRGB(100,0,0,255),2000,gobble,0,0); 
           }
           if (step[gobble] == 1)
           {
             ps_set_particle(HSVToRGB(0,0,0,0),1000,gobble,1000,1);
           }
           
          
           if (step[gobble] >= 1)
           {
            set_mode(0,gobble); 
           }
           break;
        }
     }
     
    

    
    step[gobble]++;
    if (step[gobble] == 20)
    {
      step[gobble]  = 0;
    }

}


 
 
// ########################################################################
// CORE SYSTEM
// ########################################################################
void force_do()
{
      for (int g = 0; g < num_gobbles; g ++)
      {
        give_me_something_to_do(g);
     }
}

void set_mode(int mode_set, int gobble)
{
  //print_debug("set mode", mode_set, gobble);
 

    if (gobble >= 0)
    {
      
          step[gobble] = 0;
          mode[gobble] = mode_set;
    }
    else
    {
      for (int g = 0; g < num_gobbles; g ++)
      {
        step[g] = 0;
        mode[g] = mode_set;
        
      }
    }
}

void ps_init()
{
  pinMode(DIODE_RED, OUTPUT);
  pinMode(DIODE_GREEN, OUTPUT);
pinMode(39, OUTPUT);
  digitalWrite(DIODE_RED,HIGH);
  digitalWrite(DIODE_GREEN,LOW);
  // Set gas!!!;
  for (int i = 18; i < 26; i ++)
  {
    pinMode(i, OUTPUT); 
    digitalWrite(i, LOW);
  }

  set_mode(-1,-1);
  force_do();

}

//pind


long sum=0;
int counter = 0;
int counter_num = 200;

long last_time_there_was_fire =0;
long fire_delay = 100000;
long fire_mini_delay =10000;
int fire_count = 0;
int fire_count_max = 4;
boolean what_to_do = false;
 int high = 0;
 int low = 0;
void ps_pind()
{
  long sum2 = 0;
  for (int i =0; i < 20; i++)
  {
   
     digitalWrite(39,HIGH);
     delayMicroseconds(5);
     high = analogRead(0);
  
    digitalWrite(39,LOW);
    delayMicroseconds(5);
    low = analogRead(0);
    
    sum2 += (high - low);
  }

  if (millis() - last_time_there_was_fire >= fire_delay ||
      ( 
        fire_count < fire_count_max && 
        millis() - last_time_there_was_fire >=  fire_mini_delay
      )
     )
   {
    if (millis() - last_time_there_was_fire >= fire_delay)
    {
        fire_count = 0;
    }
    
    
    digitalWrite(DIODE_GREEN,HIGH);
    digitalWrite(DIODE_RED,LOW);


  
    if (float(sum2)/20 > 40)
    {
        fire_count++;
      last_time_there_was_fire = millis();
     set_mode(1,-1);
      force_do();
    }

  }
  else
  {

    digitalWrite(DIODE_RED,HIGH);
    digitalWrite(DIODE_GREEN,LOW);

  }
 
}

void ps_set_particle(struct color current_color,int time,int gobble, int bang_gas_time,int bang_gas_delay)
{
  digitalWrite(gobble*2+bang_gas, LOW);
  digitalWrite(gobble*2+bang_fire, LOW);
  
  struct particle particle_temp;
 
  particle_temp.starttime = millis();

  particle_temp.time  = time;

  particle_temp.end[0]  = current_color.red;
  particle_temp.end[1]  = current_color.green;
  particle_temp.end[2]  = current_color.blue;
  particle_temp.end[3]  = current_color.white;
  for (int c = 0; c < num_channels;c++)
  {
     particle_temp.start[c] = particles[gobble].pos[c];
     particle_temp.pos[c] = particles[gobble].pos[c];
  }
  particle_temp.bang_gas_time = bang_gas_time;
  particle_temp.bang_gas_delay = bang_gas_delay;
  particles[gobble] = particle_temp;
}




void ps_move( int g)
{
  if (did_millis_overflow(1))
  {

      give_me_something_to_do(g);

  }  


    // check to see if we are at the end pos
    if (millis() >= (particles[g].starttime + particles[g].time))
    {
      if (particles[g].bang_gas_time > 0)
      { 
        digitalWrite(g*2+bang_gas, HIGH);
        
      //  //print_debug("gas high", 0, g);
      
        if(millis() >= (particles[g].time   + particles[g].starttime + 250))
        {
        
          digitalWrite(g*2+bang_gas, LOW);
          digitalWrite(g*2+bang_gas, HIGH);
        }
        if (millis() >= (particles[g].time   + particles[g].starttime + particles[g].bang_gas_delay))
        {
          digitalWrite(g*2+bang_fire, HIGH);
      
        }
        if (millis() >= particles[g].starttime + particles[g].time + particles[g].bang_gas_time)
        {
          digitalWrite(g*2+bang_gas, LOW);
        }
        if (millis() >= particles[g].starttime + particles[g].time + particles[g].bang_gas_time + 1000)
        {
          give_me_something_to_do(g);
        }

      }
      else
      {
        give_me_something_to_do(g);
      }



    }
  

    float  time_percent = float(millis() - particles[g].starttime)/float(particles[g].time) * 100;
    //print_debug("time_percent", time_percent, g);
 //   Serial.println(int(time_percent));
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

      particles[g].pos[c] = round(float(particles[g].start[c]) + (float(particles[g].end[c]) - float(particles[g].start[c])) * pos_percent/100);
     
      dmx[dmx_channel[g*4+c]] =round(long(particles[g].pos[c]) * 0.90 + 255 * 0.05);
   
    }

}

long millis_last_time[3];
boolean did_millis_overflow(int num)
{
  if(millis_last_time[num] > millis())
  {
     millis_last_time[num] = millis();
     return true; 
    
  }
  else
  {
     millis_last_time[num] = millis();
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

  
  digitalWrite(3, LOW);
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
  
  for (int g = 0; g < num_gobbles; g ++)
  {
     dmx_send();
  ps_pind();
  ps_move(g); 
  }

  
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
/*
void print_debug(String txt, int value, int gobble)
{
   if (debug && gobble == 1)
        {
          Serial.print(txt);
          Serial.print(": ");
          Serial.print(value);
          Serial.print(" Gobble: ");
          Serial.println(gobble);
          delay(5);
        }
}
*/

