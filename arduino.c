#include <dht.h>

#define DHT11PIN A0
#define VENTILADOR 2
dht DHT11;

void setup()
{
  Serial.begin(9600);
  pinMode(VENTILADOR, OUTPUT);
}
void loop()
{
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