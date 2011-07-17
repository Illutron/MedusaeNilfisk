
  
  // pins
  int DMX = 3;
  int CAM_BLUE = 4;
  int CAM_GREEN = 3;
  int SKUMRINGSFOELER = 5;
  int CAM_RED = 2;
  int DIODE_GREEN = 6;
  int DIODE_RED = 7;
  // 18 -25 rel¾ udgange
  
  
  
  // pins end
  int MAX = 50;
int spos = 0;
int rpos = 0;
  
  
  int dmx[50];
  int red = 4;
  int green = 2;
  int blue = 3;


   struct particle
   {
      
       float pos[3];
       float end[3];
       long starttime; 
       long time;
       boolean bang;
       struct particle *next;
       struct particle *before;

   } ;
   
   struct particle *particle_current[1];
   struct particle *particle_last[1];
   
   struct color
   {
      float red;
      float green;
      float blue; 
   };
   
  int num_gobbles = 1;
  int num_channels = 4;
  


struct color HSVToRGB(float H, float S, float V) 
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
	} else {
		
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
    return current_color;
  }
boolean init = true;
void ps_add_particle(struct color current_color,int time,int gobble)
{
  
      
       struct particle *particle_temp = (particle*) malloc(sizeof(particle));
     //  free(particle_temp);
     
     // clear everything
     
          for (int c=0;c < num_channels;c++)
          {
            particle_temp->end[0] =0;
            particle_temp->pos[0] =0;
        //    particle_temp->start[0]=0;
          }
        
       particle_temp->starttime = millis();
       particle_temp->time  = time;
       particle_temp->end[0]  = current_color.red;
       particle_temp->end[1]  = current_color.green;
       particle_temp->end[2]  = current_color.blue;
       particle_temp->next = null;
       if (init)
       {
         init = false;
     
         particle_current[gobble] = particle_temp;
    
          particle_last[gobble] = particle_temp;
   
       }
       else
       {
    
         particle_last[gobble]->next = particle_temp;
         particle_temp->before = particle_last[gobble];
         particle_last[gobble] = particle_temp;
       }
      
        
     
       
}

void  ps_add_random_pos(int gobble)
  {
       struct color current_color = HSVToRGB(round(random(360)),100,100);
       int time = random(2000,5000);
       ps_add_particle(current_color,time,gobble);
  }

 //ps_add_random_pos(gobble);

void qnext(int gobble)
{
  if (particle_current[gobble] -> next == null)
  {
    ps_add_random_pos(gobble);
    // ps_add_extra(gobble);
    
  }
  
   
  particle_current[gobble] = particle_current[gobble]->next;
  
  particle_current[gobble]->starttime = millis();
  Serial.println(int(particle_current[gobble]->end[0]));
}

void ps_add_extra(int gobble)
{
    struct color a;
    a.red = 255;
    a.green = 255;
    a.blue = 255;
    
    struct color b;
    b.red = 0;
    b.green = 0;
    b.blue =0;
    ps_add_particle(a,5000,0);
    ps_add_particle(b,5000,0);
}

//####

// ######## Particle system #######
  

  void ps_move()
  {
    
 
     
     // move the shit
     for(int g=0; g < num_gobbles;g++)
     {
       // check to see if we are at the end pos
       
         if (millis() >= ( particle_current[g]->starttime +  particle_current[g]->time))
         {
           qnext(g);
         }
         
        
       float  time_percent = float(millis() -  particle_current[g]->starttime)/float(particle_current[g]->time) * 100;
       if( time_percent > 100)
       {
        time_percent = 100;
       }
       if (time_percent < 0)
       {
         time_percent = 0;
       }
       // time_percent = 50;
       float pos_percent = 50*(sin((PI* time_percent)/100 - PI/2)+1);
      
       for(int c=0; c < num_channels; c++)
       {
       particle_current[g]->pos[c] =0 + (particle_current[g]->end[c] -0) * pos_percent/100;
      
         
       }
       
       dmx[red] =int(particle_current[g]->pos[0]);
       dmx[green] = int(particle_current[g]->pos[1]);
       dmx[blue] = int(particle_current[g]->pos[2]);
       
     }
     
     // set dmx
     

  }
  
  void ps_init()
  {
     for(int g=0; g < num_gobbles;g++)
     {
      
     // particles[g] = ps_get_random_pos(particles_current[g]);
     }
  }
  
  

        

// ######### DMX OUTPUT ###########


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
     UCSR1B&=0XF7;    
   delay(1);   
   UCSR1B|=0X08;
   
    int i;
    for(i=0;i<50;i++)
    {
      UDR1=dmx[i];
      while(!(UCSR1A&0x40));
      UCSR1A|=0x40;
      delayMicroseconds(8);
    }
    

}


//### core

void setup() {
  pinMode(48, OUTPUT); // sets the digital pin as output
  digitalWrite(48, HIGH);
     Serial.begin(9600); 

  dmx_init();
  delay(20);
  ps_add_extra(0);
  
  qnext(0);

}


void loop()  {

 ps_move();
 dmx_send();

 }

 
 
