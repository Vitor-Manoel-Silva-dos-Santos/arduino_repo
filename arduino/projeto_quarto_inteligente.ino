#include <dht.h>

#define DHT11PIN A0
#define VENTILADOR 2
#define UMIDIFICADOR 3
#define CAMA 4
#define SENSORCHUVA 7
#define FECHAJANELAATIVAR 8
#define ABRIRJANELAATIVAR 9
#define JANELAFECHADA 10
#define JANELAABERTA 11
#define LDR A1
#define PINORED 12
#define PINOGREEN 13
#define PINOBLUE 5
dht DHT11;

void metodo_ventilador();
void Janela();
void metodo_ventilador();
void metodo_umidificador();
void metodo_cama();
void Iluminacao();
void setColor(int red, int green, int blue);
int visualizando_cama; 
void setup()
{
  Serial.begin(9600);
  pinMode(VENTILADOR, OUTPUT);
  pinMode(UMIDIFICADOR, OUTPUT);
  pinMode(CAMA, INPUT);
  pinMode(SENSORCHUVA, INPUT);
  pinMode(FECHAJANELAATIVAR, OUTPUT);
  pinMode(ABRIRJANELAATIVAR, OUTPUT);
  pinMode(JANELAFECHADA, INPUT);
  pinMode(JANELAABERTA, INPUT);
  pinMode(LDR, INPUT);
  pinMode(PINORED, OUTPUT); 
  pinMode(PINOGREEN, OUTPUT);
  pinMode(PINOBLUE, OUTPUT); 
}

void loop()
{
  Janela();
  metodo_ventilador();
  metodo_umidificador();
  metodo_cama();
  Iluminacao();
  setColor(255, 0, 0); 
  delay(1000);
  setColor(0, 255, 0);
  delay(1000); 
  setColor(0, 0, 255);
  delay(1000);
  setColor(255, 255, 0); 
  delay(1000); 
  setColor(80, 0, 80); 
  delay(5000); 
  setColor(0, 255, 255); 
  delay(1000);
}

void metodo_ventilador() {
  Serial.println();
  DHT11.read11(DHT11PIN);
  float vTemperaturaDentro;
  float vUmidificador;
  Serial.print("Humidity (%): ");
  Serial.println(DHT11.humidity);
  
  vTemperaturaDentro = DHT11.temperature;
 
  Serial.println(vTemperaturaDentro);
  
  Serial.print("Temperature (C): ");
  Serial.println(DHT11.temperature);
  //delay(2000);
  if (vTemperaturaDentro >= 40){
     digitalWrite(VENTILADOR,HIGH);
  }
  else{
     digitalWrite(VENTILADOR,LOW);
  }
}

void metodo_umidificador(){
  float vUmidificador;

    vUmidificador = DHT11.humidity;

    if(vUmidificador >= 80){
      digitalWrite(UMIDIFICADOR,HIGH);
    }
    else{
      digitalWrite(UMIDIFICADOR,LOW);
    }
  
}

void metodo_cama(){ 
  visualizando_cama = digitalRead(CAMA);
  delay(1000);
  Serial.print("Sinal da CAMA: ");
  Serial.println(visualizando_cama);
}

void Janela(){
  int vis_sin_janela, vis_sinal_aberta, vis_sinal_fechada;
  vis_sin_janela = digitalRead(SENSORCHUVA);
  vis_sinal_fechada = digitalRead(JANELAFECHADA);
  vis_sinal_aberta = digitalRead(JANELAABERTA);
  
  //delay(1000);  
  Serial.print("Sinal da janela: ");
  Serial.println(vis_sin_janela);
  
  Serial.print("Sinal da janela FECHADA: ");
  Serial.println(vis_sinal_fechada);

  Serial.print("Sinal da janela ABERTA: ");
  Serial.println(vis_sinal_aberta);
  
  if (vis_sin_janela == 1 && vis_sinal_fechada == 1){
    digitalWrite(FECHAJANELAATIVAR,HIGH);
  }
  else{
    digitalWrite(FECHAJANELAATIVAR,LOW);
  }
  if (vis_sin_janela == 0 && vis_sinal_aberta == 1){
    digitalWrite(ABRIRJANELAATIVAR,HIGH);
  }
  else{
    digitalWrite(ABRIRJANELAATIVAR,LOW);
  }
}

void Iluminacao(){
  int vis_sin_iluminacao = 0;

  vis_sin_iluminacao = analogRead(LDR);
  Serial.print("Visualizando sinal LDR: ");
  Serial.println(vis_sin_iluminacao);
  if (vis_sin_iluminacao > 600 && visualizando_cama == 1){
    setColor(0, 255, 255); 
  }
  else{
    setColor(255, 255, 255); 
  }
}
void setColor(int red, int green, int blue){
  red = 255 - red; 
  green = 255 - green;
  blue = 255 - blue;
  analogWrite(PINORED, red); 
  analogWrite(PINOGREEN, green); 
  analogWrite(PINOBLUE, blue); 
}
