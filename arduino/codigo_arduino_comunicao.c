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

int visualizando_cama;
int vTemperaturaDentro;
int vUmidificador;
int vis_sin_janela, vis_sinal_aberta, vis_sinal_fechada;
int vis_sin_iluminacao;

void metodo_ventilador();
void janela();
void metodo_ventilador();
void metodo_umidificador();
void metodo_cama();
void iluminacao();
void enviarDadosESP();
void lerDadosESP();
void setColor(int red, int green, int blue);

void setup()
{
    Serial.begin(9600, SERIAL_8N1, 0, 1);
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
    // janela();
    // metodo_ventilador();
    // metodo_umidificador();
    // metodo_cama();
    // iluminacao();
    enviarDadosESP();
    // lerDadosESP();
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
    // Serial.println("hello boss");
    // delay(1500);
    // Serial.println("Sinal da CAMA: ");
    // Serial.println("how are you");
}
void lerDadosESP()
{
    String vetor_valores_recebidos[7];
    for (int j = 0; j < 7; j++)
    {
        vetor_valores_recebidos[j] = Serial.readString();
        // delay(1500);
        for (int j = 0; j < 7; j++)
        {
            // Serial.write("numero mensagem: ");
            // Serial.print(vetor_valores_recebidos[j]);
            Serial.print(vetor_valores_recebidos[j]);
            // delay(1500);
        }
    }
}
void enviarDadosESP()
{
    int vetor[7] = {visualizando_cama, vTemperaturaDentro, vUmidificador, vis_sin_janela, vis_sinal_aberta, vis_sinal_fechada, vis_sin_iluminacao};
    for (int k = 0; k < 7; k++)
    {
        Serial.println(vetor[k]);
        delay(1500);
    }
}
void metodo_ventilador()
{
    // Serial.println();
    DHT11.read11(DHT11PIN);

    vTemperaturaDentro = DHT11.temperature;
    // delay(1500);
    // Serial.print("Temperature (C): ");
    // Serial.println(vTemperaturaDentro);
    // delay(2000);
    if (vTemperaturaDentro >= 20)
    {
        digitalWrite(VENTILADOR, HIGH);
        // delay(1500);
        // Serial.print("Ventilador ligado");
    }
    else
    {
        digitalWrite(VENTILADOR, LOW);
        // delay(1500);
        // Serial.print("Ventilador desligado");
    }
}

void metodo_umidificador()
{
    DHT11.read11(DHT11PIN);

    vUmidificador = DHT11.humidity;
    // delay(1500);
    // Serial.print("Humidity (%): ");
    // Serial.println(DHT11.humidity);

    if (vUmidificador >= 30)
    {
        digitalWrite(UMIDIFICADOR, HIGH);
        // delay(1500);
        /// Serial.println("umidificador ligado");
    }
    else
    {
        digitalWrite(UMIDIFICADOR, LOW);
        // delay(1500);
        // Serial.println("umidificador desligado");
    }
}

void metodo_cama()
{
    visualizando_cama = digitalRead(CAMA);
    // delay(1500);
    // Serial.print("Sinal da CAMA: ");
    // Serial.println(visualizando_cama);
}

void janela()
{

    vis_sin_janela = digitalRead(SENSORCHUVA);
    vis_sinal_fechada = digitalRead(JANELAFECHADA);
    vis_sinal_aberta = digitalRead(JANELAABERTA);

    // delay(1500);
    // Serial.print("Sinal da janela: ");
    // Serial.println(vis_sin_janela);
    // delay(1500);
    // Serial.print("Sinal da janela FECHADA: ");
    // Serial.println(vis_sinal_fechada);
    // delay(1500);
    // Serial.print("Sinal da janela ABERTA: ");
    // Serial.println(vis_sinal_aberta);

    if (vis_sin_janela == 1 && vis_sinal_fechada == 1)
    {
        while (true)
        {
            vis_sinal_fechada = digitalRead(JANELAFECHADA);
            digitalWrite(FECHAJANELAATIVAR, HIGH);
            // Serial.println("Janela fechando");
            if (vis_sinal_fechada == 0)
            {
                digitalWrite(FECHAJANELAATIVAR, LOW);
                // Serial.println("Janela fechada");
                break;
            }
        }
    }
    else
    {
        if (vis_sin_janela == 0 && vis_sinal_aberta == 1)
        {
            while (true)
            {
                vis_sinal_aberta = digitalRead(JANELAABERTA);
                digitalWrite(ABRIRJANELAATIVAR, HIGH);
                // Serial.println("Janela abrindo");
                if (vis_sinal_aberta == 0)
                {
                    digitalWrite(ABRIRJANELAATIVAR, LOW);
                    // Serial.println("Janela aberta");
                    break;
                }
            }
        }
    }
}
void iluminacao()
{

    vis_sin_iluminacao = analogRead(LDR);
    // delay(1500);
    // Serial.print("Visualizando sinal LDR: ");
    // Serial.println(vis_sin_iluminacao);
    if (vis_sin_iluminacao > 600 && visualizando_cama == 1)
    {
        setColor(0, 0, 255);
    }
    else
    {
        setColor(255, 255, 255);
    }
}
void setColor(int red, int green, int blue)
{
    red = 255 - red;
    green = 255 - green;
    blue = 255 - blue;
    analogWrite(PINORED, red);
    analogWrite(PINOGREEN, green);
    analogWrite(PINOBLUE, blue);
}

#include <SoftwareSerial.h>

SoftwareSerial portOne(0, 1);

void setup()
{
    Serial.begin(9600);
    // portOne.begin(9600);
    portOne.begin(115200);
}

void loop()
{
    portOne.listen();
    Serial.println("Data from port one:");
    while (portOne.available() > 0)
    {
        char inByte = portOne.read();
        Serial.write(inByte);
    }
}
