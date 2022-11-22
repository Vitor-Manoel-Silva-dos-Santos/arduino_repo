#define RXp2 16
#define TXp2 17
void lerDadosArduino();
void enviarDadosEsp();
void setup()
{
    // put your setup code here, to run once:
    Serial.begin(9600, SERIAL_8N1, RXp2, TXp2);
}
void loop()
{
    lerDadosArduino();
    // enviarDadosEsp();
}

void lerDadosArduino()
{
    // Serial.print("Message Received: ");
    String vetor_valores_recebidos[7];
    for (int j = 0; j < 7; j++)
    {
        vetor_valores_recebidos[j] = Serial2.readString();
        // delay(1500);
    }
    for (int j = 0; j < 7; j++)
    {
        // Serial.write("numero mensagem: ");
        Serial.print(vetor_valores_recebidos[j]);
        // delay(1500);
    }
    Serial.println("fim mensagem");
    // delay(200);
}
void enviarDadosEsp()
{
    int vetor[7] = {2, 2, 2, 2, 2, 2, 2};
    for (int k = 0; k < 7; k++)
    {
        Serial.println(vetor[k]);
        delay(1500);
    }
}
