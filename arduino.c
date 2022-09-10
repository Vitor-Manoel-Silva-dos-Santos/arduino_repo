#include <dht.h>

#define DHT11PIN A0
#define VENTILADOR 2
dht DHT11;

int vJanelaLig = 1;
int vUmidificadorLig = 1;
int vVentiladorLig = 1;
int vDespertadorLig = 1;
int vIluminacaoLig = 1;

void mJanela();
void mUmidificador();
void mVentilador();
void mDespertador();
void mIluminacao();

void setup()
{
  Serial.begin(9600);
  pinMode(VENTILADOR, OUTPUT);
}

void loop()
{
  if (vJanelaLig) mJanela();
  if (vUmidificadorLig) mUmidificador();
  if (vVentiladorLig) mVentilador();
  if (vDespertadorLig) mDespertador();
  if (vIluminacaoLig) mIluminacao();
}

void mVentilador() {
  Serial.println();
  DHT11.read11(DHT11PIN);
  float vTemperaturaDentro;
  Serial.print("Humidity (%): ");
  Serial.println(DHT11.humidity);
  
  vTemperaturaDentro = DHT11.temperature;
  Serial.println(vTemperaturaDentro);
  
  Serial.print("Temperature (C): ");
  Serial.println(DHT11.temperature);
  delay(2000);
  if (vTemperaturaDentro >= 26){
     digitalWrite(VENTILADOR,HIGH);
  }
  else{
     digitalWrite(VENTILADOR,LOW);
  }
}