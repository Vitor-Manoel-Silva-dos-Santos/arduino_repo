#include <LiquidCrystal_I2C.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h> 
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <Wire.h>
 
LiquidCrystal_I2C lcd(0x27, 16, 2);
 
const char * ssid = "SEU_SSID";
const char * password = "SENHA_DA_REDE";
byte grau[8] ={ B00001100,
                B00010010,
                B00010010,
                B00001100,
                B00000000,
                B00000000,
                B00000000,
                B00000000,};
                 
void setup() {
 
  //configura a comunicação serial, LCD 
  Serial.begin(115200);
  WiFi.begin(ssid, password);
 
  Wire.begin(D2, D1); 
  lcd.begin(20, 4);
 
  lcd.backlight();
  lcd.home();
  //Cria o caractere customizado com o simbolo do grau
  lcd.createChar(0, grau);
   
 
  //limpa o tela e escreve os textos iniciais 
  lcd.clear();    
  lcd.setCursor(1,1);
  lcd.print("SSID: ");
 
  lcd.setCursor(7,1);
  lcd.print(ssid);
     
  lcd.setCursor(1,2);
  lcd.print("Conectando...");  
 
  //Verifica se o esp está conectado na rede, caso contrário realiza a tentaiva a cada 2 seg.
  while (WiFi.status() != WL_CONNECTED) {  
    delay(2000);
    Serial.println(WiFi.status());
  }
}
 
void loop() {
 
  // Verifica se o esp está conectado
  if (WiFi.status() == WL_CONNECTED) {  
     
    //cria a requisição http passando o URL da api node
    HTTPClient http;
    http.begin("URL_DA_API");    
    int httpCode = http.GET();    
    if (httpCode > 0) {      
 
      //difinindo o tamanho do buffer para o objeto json
      const size_t bufferSize = JSON_OBJECT_SIZE(3);
     
      //realizando o parse do json para um JsonObject
      DynamicJsonBuffer jsonBuffer(bufferSize);
      JsonObject & root = jsonBuffer.parseObject(http.getString());
 
      //carregando os valores nas variaveis 
      const char * temp = root["temperature"];
      const char * city = root["city"];
      const char * humidity = root["humidity"];
 
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print(city);
      
      //criando a string que irá exibir os dados da temperatura e umidade
      String message = "Temperatura: ";
      message += temp;
      lcd.setCursor(0, 2);
      lcd.print(message);
      //Mostra o simbolo do grau formado pelo array
      lcd.write((byte)0);      
      message = "Umidade: ";
      message += humidity;
      message += "%";
      lcd.setCursor(0, 3);
      lcd.print(message);
    }    
    //fechando a conexão
    http.end();
  }
  delay(60000);
}