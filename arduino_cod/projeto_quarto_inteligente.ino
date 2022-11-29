#include <Arduino_JSON.h> //Lib para leitura e tratamento de JSON
#include <dht.h> // Lib para sensor dht11
// Pinos arduino:
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

dht DHT11; //definição dht11 como dht, assim podemos usar os metodos do dht11

// dados de leitura do arduino definidos no escopo global
int visualizando_cama; 
int vTemperaturaDentro;
int vUmidificador;
int vis_sin_janela, vis_sinal_aberta, vis_sinal_fechada;
int vis_sin_iluminacao;

// declaração dos metodos
void metodo_ventilador();
void janela();
void metodo_ventilador();
void metodo_umidificador();
void metodo_cama();
void iluminacao();
void enviarDadosArduino();
void ledDadosEsp();
void setColor(int red, int green, int blue);

// configuracoes:
void setup()
{
  Serial.begin(9600); // definimos 9600 para comunicacao
  // pinos arduino definidos como OUTPUT (saida)
  // pinos arduino definidos como INPUT (entrada)
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

int SEGUNDOS = 20; //declaração time
/*A comunicacao entre ESP e Arduino nao poderia ser ao mesmo tempo, entao necessitavamos  
 * enviar dados do arduino para o esp e do esp para arduino, para isso construimos um 
 * sistema aonde enviamos dados em um tempo especifico do Arduino para o ESP e do ESP 
 para o Arduino em outro tempo.*/
void loop()
{ 
 
  /*millis devolve um valor que representa o número de milissegundos transcorridos 
  desde que o Arduino foi ligado*/
  if (millis() % (SEGUNDOS * 1000) < (SEGUNDOS / 2)*1000) { 
    // de acordo com o tempo acima o arduino envia dados
    enviarDadosArduino();
    delay(500); // a cada meio segundo o arduino executa novamente
  }
  else {
    // caso nao esteja no tempo do arduino enviar os dados, ele passa a receber os dados do ESP
    String leitura_dados =  Serial.readString(); // le os dados e armazena em uma string
    // Abaixo verificamos se realmente arduino está lendo os dados
    
    /*if (leitura_dados[0] == '0') {
      delay(1500);
      Serial.println("Arduino lendo dados ESP...");
    }*/
  }

// todas as funções que o hardware está executando:
  // chamamos os metodos que variam a cor do led (R,G,B) a cada meio segundo
  /*setColor(255, 0, 0); 
  delay(500);
  setColor(0, 255, 0);
  delay(500); 
  setColor(0, 0, 255);
  delay(500);
  setColor(255, 255, 0); 
  delay(500); 
  setColor(80, 0, 80); 
  delay(500); 
  setColor(0, 255, 255);
  delay(500);*/
  // chamada do metodo que faz a janela funcionar 
  janela();
  // chamada do metodo que faz o ventilador funcionar 
  metodo_ventilador();
  // chamada do metodo que faz o umidificador funcionar 
  metodo_umidificador();
  // chamada do metodo que faz a cama funcionar, para isso chamamos ao mesmo tempo a funcao
  // iluminacao, pois determinada funcao faz a leitura de luminosidade no ambiente. 
  metodo_cama();
  iluminacao();
  
}
/*O Arduino e o Esp somente permitem envio de 64 bits pela comunicacao UART, entao 
nao podiamos enviar uma string com todo o JSON que seria enviado ao servidor, assim, 
colocamos todos nossos dados em uma unica string sequencial de 11 caracteres, permitindo
a comunicacao. */
void enviarDadosArduino(){
  // JSON que seria recebido pela API
  String dados_sensores = "{\"iluminacao\":" + String(vis_sin_iluminacao) + ",\"pressao\":" + String(visualizando_cama) + ",\"temperatura\":" + String(vTemperaturaDentro) + ",\"umidade\": " + String(vUmidificador) + " }";
  String dados_motores = "{\"janela_aberta\":" + String(vis_sinal_aberta) + ", \"umidificador_igado\":" + String(vis_sinal_aberta) + ",\"ventilador_ligado\":" + String(vis_sinal_aberta) + " }";
  //Indexamos os dados: 
  int I_vez_do_esp = 0; // vez do esp: 0 ou 1
  int I_iluminacao = 1; // iluminacacao: o sensor de luminosidade varia ate um pouco mais que 900
  int I_pressao = 4; // pressao: 0 ou 1
  int I_temperatura = 5; // temperatura: 0 ate 90
  int I_umidade = 7; // **na pressa, cometemos um erro aqui** umidade vai de 0 ate 90 (porem arrumamos mais a frente)
  int I_janela_aberta = 8;  // janela aberta: 0 ou 1
  int I_umidificador_ligado = 9; // umidificador ligado: 0 ou 1
  int I_ventilador_ligado = 10; // ventilador ligado: 0 ou 1

  char buf[7]; // o maximo de valores que poderiamos ter seriam 7, entao utilizamos essa variavel para formatar dados
  char StringRes[11]; // StringRes armazena todos os dados que iram ser enviados
  StringRes[I_vez_do_esp] = '1';// vez do ESP = 1
  sprintf(buf, "%i", vis_sin_iluminacao); // temos todos os dados de iluminacao
  StringRes[I_iluminacao] = buf[0] ? buf[0] : 'x'; // fazemos uma comparacao, caso falso iluminacao na posicao 0 = x
  StringRes[I_iluminacao + 1] = buf[1] ? buf[1] : 'x';// fazemos uma comparacao, caso falso iluminacao na posicao 1 = x
  StringRes[I_iluminacao + 2] = buf[2] ? buf[2] : 'x';// fazemos uma comparacao, caso falso iluminacao na posicao 2 = x
  StringRes[I_pressao] = visualizando_cama ? '1' : '0';// dado desnecessario
  sprintf(buf, "%i", vTemperaturaDentro);// temos todos os dados de temperatura
  StringRes[I_temperatura] = buf[0] ? buf[0] : 'x'; // fazemos uma comparacao, caso falso temperatura na posicao 0 = x
  StringRes[I_temperatura + 1] = buf[1] ? buf[1] : 'x';// fazemos uma comparacao, caso falso temperatura na posicao 1 = x
  sprintf(buf, "%i", vUmidificador);// temos todos os dados de umidificador
  StringRes[I_umidade] = buf[0] ? buf[0] : 'x'; // fazemos uma comparacao, caso falso umidificador na posicao 0 = x
  StringRes[I_umidade + 1] = buf[1] ? buf[1] : 'x';// fazemos uma comparacao, caso falso umidificador na posicao 1 = x
  StringRes[I_janela_aberta] = visualizando_cama ? '1' : '0';
  StringRes[I_umidificador_ligado] = vis_sinal_aberta ? '1' : '0';
  StringRes[I_ventilador_ligado] = vis_sinal_aberta ? '1' : '0';
  
  Serial.println(StringRes); // enviamos os dados
}
/*metodo que faz ventilador funcionar*/
void metodo_ventilador() {
  DHT11.read11(DHT11PIN); // chamamos uma funcao da lib para poder ler os dados do sensor
 
  vTemperaturaDentro = DHT11.temperature;//chamamos o metodo que analisa a temperatura do sensor
  //delay(1500);
  //Serial.print("Temperature (C): ");
  //Serial.println(vTemperaturaDentro); //podemos visualizar a temperatura aqui
  //delay(2000);
  if (vTemperaturaDentro >= 20){ // se a temperatura lida pelo sensor for >= 20 
     digitalWrite(VENTILADOR,HIGH); //  ventilador se ativa (nivel logico auto)
     //delay(1500);
     //Serial.print("Ventilador ligado");
  }
  else{ // caso contrario 
     digitalWrite(VENTILADOR,LOW); // ventilador se desativa (nivel logico baixo)
     //delay(1500);
     //Serial.print("Ventilador desligado");
  }
}
/*metodo que umidificador funcionar*/
void metodo_umidificador(){
  DHT11.read11(DHT11PIN);// chamamos uma funcao da lib para poder ler os dados do sensor
  
  vUmidificador = DHT11.humidity;//chamamos o metodo que analisa a umidade do sensor
  //delay(1500);
  //Serial.print("Humidity (%): ");
  //Serial.println(DHT11.humidity);//podemos visualizar a umidade aqui
    
    if(vUmidificador >= 30){ // se a umidade lida pelo sensor for >= 30
      digitalWrite(UMIDIFICADOR,HIGH); // umidificador se ativa (nivel logico auto)
      //delay(1500);
      ///Serial.println("umidificador ligado");
    }
    else{
      digitalWrite(UMIDIFICADOR,LOW); //umidificador se desativa (nivel logico baixo)
      //delay(1500);
      //Serial.println("umidificador desligado");
    }
  
}
/*metodo que faz cama funcionar*/
void metodo_cama(){ 
  visualizando_cama = digitalRead(CAMA); // fazemos a leitura do circuito que fica na cama
  //delay(1500);
  //Serial.print("Sinal da CAMA: ");
  //Serial.println(visualizando_cama); //podemos visualizar se possui alguem em cima da cama aqui
}
/*metodo que faz janela funcionar*/
void janela(){
  
  vis_sin_janela = digitalRead(SENSORCHUVA); // atraves do sensor de chuva, visualizamos se esta chovendo ou nao (0 ou 1)
  vis_sinal_fechada = digitalRead(JANELAFECHADA);// atraves de um botao, visualizamos se a janela esta fechada (0 ou 1)
  vis_sinal_aberta = digitalRead(JANELAABERTA);// atraves de um botao, visualizamos se a janela esta aberta (0 ou 1)
  
  //delay(1500);
  //Serial.print("Sinal da janela: ");
  //Serial.println(vis_sin_janela); 
  //delay(1500);
  //Serial.print("Sinal da janela FECHADA: ");
  //Serial.println(vis_sinal_fechada);
  //delay(1500);
  //Serial.print("Sinal da janela ABERTA: ");
  //Serial.println(vis_sinal_aberta);

  // vis_sin_janela == 1 (com chuva) ou 0 (sem chuva)
  // vis_sinal_fechada == 1 (aberta) ou 0  (fechada)
  // vis_sinal_aberta == 1 (fechada) ou 0  (aberta)
  if (vis_sin_janela == 1 && vis_sinal_fechada == 1){ // caso esteja chovendo e janela aberta
    // o motor da janela se mantem ligado ate que ela feche
    while(true){ 
      vis_sinal_fechada = digitalRead(JANELAFECHADA);
        digitalWrite(FECHAJANELAATIVAR,HIGH); 
        //Serial.println("Janela fechando");
        if(vis_sinal_fechada == 0){
            digitalWrite(FECHAJANELAATIVAR,LOW);
            //Serial.println("Janela fechada");
            break;
          }
      }
  }
  else{ // caso nao esteja chovendo e janela esteja fechada
    if (vis_sin_janela == 0 && vis_sinal_aberta == 1){
      while(true){
        vis_sinal_aberta = digitalRead(JANELAABERTA);
        digitalWrite(ABRIRJANELAATIVAR,HIGH);
        //Serial.println("Janela abrindo");
        if(vis_sinal_aberta == 0){
          digitalWrite(ABRIRJANELAATIVAR,LOW);
          //Serial.println("Janela aberta");
          break;
        }
      }
    }
  }
}
/*metodo que faz cama funcionar*/
void iluminacao(){

  vis_sin_iluminacao = analogRead(LDR); //leitura do sensor de luminosidade 
 // delay(1500);
  //Serial.print("Visualizando sinal LDR: ");
  //Serial.println(vis_sin_iluminacao);
  if (vis_sin_iluminacao > 600 && visualizando_cama == 1){ // caso o sensor de luminosidade detecte iluminacao superior a 600 e nao esteja ninguem na cama
    setColor(0,0, 255);  // cor amarelo se ativa
  }
  else{// caso contrario
    setColor(255, 255, 255); // cor desativa
  }
}
/*metodo que faz cores funcionar*/
void setColor(int red, int green, int blue){ //recebe os parametros de 0 a 255
  red = 255 - red; // calcula a quantidade de vermelho
  green = 255 - green; // calcula a quantidade de verde
  blue = 255 - blue; // calcula a quantidade de azul
  analogWrite(PINORED, red);  // insere quantidade de vermelho, controle analogico de tensao
  analogWrite(PINOGREEN, green); // insere quantidade de verde, controle analogico de tensao
  analogWrite(PINOBLUE, blue); // insere quantidade de azul, controle analogico de tensao
}
