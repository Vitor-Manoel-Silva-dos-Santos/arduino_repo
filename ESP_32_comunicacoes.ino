#define RXp2 16 // pino rx do ESP para comunicacao UART
#define TXp2 17 // pino tx do ESP para comunicacao UART

#include <stdio.h> // Lib Input e output
#include <Arduino.h>
#include <Arduino_JSON.h>
// para ESP32
#include <HTTPClient.h>
#include <WiFi.h>

const char *ssid = "Katia_lara_vitor"; //nome da rede para conexao wifi
const char *password = "Vitoria555"; //senha da rede para conexao wifi
bool comecar_esp; // variavel que define quem inicia a comunicao ESP ou Arduino
/*Declaramos as funções*/
void enviarDados();
String receberDados();
void lerDadosArduino();
void enviarDadosEsp();
/*configuracoes: */
void setup()
{
    Serial.begin(9600, SERIAL_8N1, RXp2, TXp2); // velocidade de comunicacao mesma que arduino 9600, parametro de comunicacao e os pinos de comunicacao

    WiFi.begin(ssid, password); // configuracao de comunicacao de rede, recebe os parametros nome rede e senha 

    Serial.println("Conectando..");
    while (WiFi.status() != WL_CONNECTED) // checa a conexao
    { 
        delay(1500);
        Serial.print(".");
    }
    
    Serial.println("Conectado con exito, meu IP e: "); // se conectado, retornamos o ip.
    Serial.println(WiFi.localIP()); // ip
    //enviarDados();
    receberDados(); // recebemos dados da API
 
    comecar_esp = true;// esp inicia a tranferencia de dados 
}

/*metodo que faz a interpretacao dos dados recebidos*/
void lerDadosArduino(String dados_string){
  // os dados abaixo sao os dados que queremos enviar para API
  //void enviarDados(int iluminacao, int pressao, int temperatura, int umidade) 
  // definimos para tratar os dados:
  char buf[3]; 
  char buf2[2];
  char buf3[2];
  
  int valor; // todos nossos dados sao inteiros, entao tratamos e inserimos em um espaço na memoria de tipo int:
  buf[0] = dados_string[1]; // comecamos com dados_string na posicao 1 pois a posicao [0] especifica quem esta enviando dados
  buf[1] = dados_string[2];
  buf[2] = dados_string[3];
  sscanf(buf, "%d", &valor); // armazenamos os dados em um inteiro
  int iluminacao = valor; // passamos os dados de iluminacao para iluminacao
  
  int pressao = dados_string[4] == '0' ? 0 : 1; // apesar de nao vamos enviar os dados de pressao, passamos ele para a variavel correspondente
  // tratamos os dados de temperatura
  buf2[0] = dados_string[5]; 
  buf2[1] = dados_string[6];
  sscanf(buf2, "%d", &valor);// armazenamos os dados em um inteiro
  int temperatura = valor;// passamos os dados de temperatura para temperatura
  // tratamos os dados de umidade
  buf3[0] = dados_string[11];
  buf3[1] = dados_string[12];
  sscanf(buf3, "%d", &valor); // armazenamos os dados em um inteiro
  int umidade = valor;// - (valor % 1000); // passamos os dados de umidade para umidade
  //corrigimos um erro visto no codigo do arduino
  umidade -= (umidade % 1000);
  umidade /= 1000;
  

  /*Serial.print("Buf1: ");
  Serial.print(buf);
  Serial.print("Buf2: ");
  Serial.print(buf2);
  Serial.print("Buf3: ");
  Serial.print(buf3);*/
  
  enviarDados(iluminacao, pressao, temperatura, umidade); // chamamos a funcao que envia dados ao servidor
}

void enviarDadosEsp(){
  
  JSONVar dados_json = JSON.parse(receberDados()); // converte os dados recebidos do servidor em um tipo JSON
 //Indexamos os dados: 
  int I_vez_do_esp = 0;
  int I_iluminacao_economia_inteligente = 1;
  int I_iluminacao_de_ativacao = 2;
  int I_cor_iluminacao = 5;
  int I_iluminacao_manual = 12;
  int I_janela_aberta = 13;
  int I_janela_manual = 14;
  int I_janela_temperatura_de_ativacao = 15;
  int I_janela_umidade_de_ativacao = 17;
  int I_umidificador_ligado = 19;
  int I_umidificador_manual = 20;
  int I_umidificador_temperatura_de_ativacao = 21;
  int I_umidificador_umidade_de_ativacao = 23;
  int I_ventilador_ligado = 25;
  int I_ventilador_manual = 26;
  int I_ventilador_temperatura_de_ativacao = 27;
  int I_ventilador_umidade_de_ativacao = 29;

  char buf[7];
  char StringRes[30];// inserimos todos os dados recebidos pelo servidor em um char de 30 caracteres, pois temos uma limitacao de comunicacao de hardware para hardware de 64 bits
  StringRes[I_vez_do_esp] = '0';
  StringRes[I_iluminacao_economia_inteligente] = (bool) dados_json["iluminacao"]["economia_inteligente"] ? '1' : '0';
  sprintf(buf, "%i", (int) dados_json["iluminacao"]["iluminacao_de_ativacao"]);
  StringRes[I_iluminacao_de_ativacao] = buf[0] ? buf[0] : 'x';
  StringRes[I_iluminacao_de_ativacao + 1] = buf[1] ? buf[1] : 'x';
  StringRes[I_iluminacao_de_ativacao + 2] = buf[2] ? buf[2] : 'x';
  
  StringRes[I_cor_iluminacao] = '#';
  StringRes[I_cor_iluminacao + 1] = 'x';
  StringRes[I_cor_iluminacao + 2] = 'x';
  StringRes[I_cor_iluminacao + 3] = 'x';
  StringRes[I_cor_iluminacao + 4] = 'x';
  StringRes[I_cor_iluminacao + 5] = 'x';
  StringRes[I_cor_iluminacao + 6] = 'x';
  StringRes[I_iluminacao_manual] = (bool) dados_json["iluminacao"]["manual"] ? '1' : '0';
  StringRes[I_janela_aberta] = (bool) dados_json["janela"]["aberta"] ? '1' : '0';
  StringRes[I_janela_manual] = (bool) dados_json["janela"]["manual"] ? '1' : '0';
  sprintf(buf, "%i", (int) dados_json["janela"]["temperatura_de_ativacao"]);
  StringRes[I_janela_temperatura_de_ativacao] = buf[0] ? buf[0] : 'x';
  StringRes[I_janela_temperatura_de_ativacao + 1] = buf[1] ? buf[1] : 'x';
  sprintf(buf, "%i", (int) dados_json["janela"]["umidade_de_ativacao"]);
  StringRes[I_janela_umidade_de_ativacao] = buf[0] ? buf[0] : 'x';
  StringRes[I_janela_umidade_de_ativacao + 1] = buf[1] ? buf[1] : 'x';
  
  StringRes[I_umidificador_ligado] = (bool) dados_json["umidificador"]["ligado"] ? '1' : '0';
  StringRes[I_umidificador_manual] = (bool) dados_json["umidificador"]["manual"] ? '1' : '0';
  sprintf(buf, "%i", (int) dados_json["umidificador"]["temperatura_de_ativacao"]);
  StringRes[I_umidificador_temperatura_de_ativacao] = buf[0] ? buf[0] : 'x';
  StringRes[I_umidificador_temperatura_de_ativacao + 1] = buf[1] ? buf[1] : 'x';
  sprintf(buf, "%i", (int) dados_json["umidificador"]["umidade_de_ativacao"]);
  StringRes[I_umidificador_umidade_de_ativacao] = buf[0] ? buf[0] : 'x';
  StringRes[I_umidificador_umidade_de_ativacao + 1] = buf[1] ? buf[1] : 'x';
  
  StringRes[I_ventilador_ligado] = (bool) dados_json["ventilador"]["ligado"] ? '1' : '0';
  StringRes[I_ventilador_manual] = (bool) dados_json["ventilador"]["manual"] ? '1' : '0';
  sprintf(buf, "%i", (int) dados_json["ventilador"]["temperatura_de_ativacao"]);
  StringRes[I_ventilador_temperatura_de_ativacao] = buf[0] ? buf[0] : 'x';
  StringRes[I_ventilador_temperatura_de_ativacao + 1] = buf[1] ? buf[1] : 'x';
  sprintf(buf, "%i", (int) dados_json["ventilador"]["umidade_de_ativacao"]);
  StringRes[I_ventilador_umidade_de_ativacao] = buf[0] ? buf[0] : 'x';
  StringRes[I_ventilador_umidade_de_ativacao + 1] = buf[1] ? buf[1] : 'x';
  
  Serial.println(StringRes); // enviamos os dados para o Arduino
  
}
/*metodo que envia dados para a API*/
void enviarDados(int iluminacao, int pressao, int temperatura, int umidade)
{
    
    HTTPClient http;
    //podemos verificar os parametros recebidos na funcao
    /*Serial.println("Dados recebidos: ");
    Serial.println(iluminacao);
    Serial.println(pressao);
    Serial.println(temperatura);
    Serial.println(umidade);*/
    
    //adicionamos os dados em uma string com formatacao JSON:
    String datos_a_enviar = "{\"iluminacao\":" + String(iluminacao) + ",\"pressao\":" + String(pressao) + ",\"temperatura\":" + String(temperatura) + ",\"umidade\": " + String(umidade) + " }";

    // configuracoes de envio
    http.begin("https://arduino-unip.herokuapp.com/sensores"); // Indicamos o destino
    http.addHeader("Content-Type", "application/json");        // Preparamos o header text/plain 

    int codigo_respuesta = http.POST(datos_a_enviar); // Enviamos o post passando os dados que queremos enviar. (esta funcao nos devolve um codigo que armazenamos em um inteiro)
    
    if (codigo_respuesta > 0)
    {
        Serial.println("Código HTTP ► " + String(codigo_respuesta)); // retorna o codigo da requisicao

        if (codigo_respuesta == 200) // codigo 204 deu certo
        {
            String cuerpo_respuesta = http.getString();
            Serial.println("O servidor respondeu ▼ ");
            Serial.println(cuerpo_respuesta);
        }

        else if (codigo_respuesta != 204) // retorna um erro caso o codigo seja diferente de 204
        {

            Serial.print("Erro enviando POST, código: ");
            Serial.println(codigo_respuesta);
        }

        http.end(); // libera recursos
    }
    else
    {
        Serial.println("Erro na conexao WIFI");
    }
    delay(1500);
}
/*metodo que recebe dados da API*/
String receberDados()
{
    String payload = " ";
    HTTPClient https;
    https.begin("https://arduino-unip.herokuapp.com/motores"); // Indicamos o destino
    if (https.GET() > 0)
    {
       payload = https.getString(); // pegamos os dados
    }
    return payload; // retornamos os dados
}

int SEGUNDOS = 20; //declaração time
/*A comunicacao entre ESP e Arduino nao poderia ser ao mesmo tempo, entao necessitavamos  
 * enviar dados do arduino para o esp e do esp para arduino, para isso construimos um 
 * sistema aonde enviamos dados em um tempo especifico do Arduino para o ESP e do ESP 
 para o Arduino em outro tempo.*/
void loop()
{
  if (millis() % (SEGUNDOS * 1000) >= (SEGUNDOS / 2)*1000) {
    enviarDadosEsp();
    delay(500);
  }
  else {
    String leitura_dados =  Serial.readString();
    if (leitura_dados[0] == '1') {
      lerDadosArduino(leitura_dados);
      delay(1500);
      //Serial.println("ESP lendo dados arduino...");
    }
  }
}
