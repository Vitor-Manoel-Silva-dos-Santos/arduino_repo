<h1 align = "center"> :house: :computer: Projeto Domus :computer: :house: </h1>

<h4> Introdução ao projeto: </h4>
<p align  = "justify"> Cada vez mais tem se falado em traduzir os avanços tecnológicos em casas ou um 
estilo de vida mais inteligente. Fazendo uso de aparatos eletrônicos alinhados com 
estruturas de software inteligentes, existem inúmeros investimentos feitos na área da 
domótica; palavra cunhada de “Domus” que significa casa e “Robótica”, conciliando a 
ideia de automatização dentro da esfera domiciliar. Dessa forma, busca-se nesse 
trabalho aplicar os conceitos aprendidos em sala de aula e fora do ambiente 
acadêmico para elaboração de uma maquete de um cômodo residencial contendo 
sensores inteligentes conversando entre si e com controladores através de protocolos 
de comunicação. O projeto tem o escopo de um ano, sendo esperado a construção 
de uma miniatura, a construção de uma interface em um aplicativo, o planejamento 
da equipe e organização. </p>

<h4> Proposta escolhida: </h4>
<p align  = "justify"> Projetamos, combinando eletrônica e programação, um sistema interligado de 
sensores, microcontroladores e aparelhos eletrônicos para analisar as variações de 
temperatura e umidade em um cômodo, processar essas informações e, por fim, 
regular o clima na casa, criando um ambiente climatizado de forma rápida, precisa e 
eficiente - afetando positivamente a saúde do habitante e reduzindo complicações 
causadas pelo tempo seco e temperatura elevadas. 
O sistema interage com ventiladores, janelas e umidificadores de ar em todo o 
cômodo, ligando ou desligando cada um deles de acordo com a necessidades ou 
preferências do morador, que pode alterar os parâmetros de trabalho do sistema no 
aplicativo dele. </p>

<h4> Idéias Projetadas: </h4>
<p align  = "justify"> <b>:droplet: Janela: </b>Construimos uma janela que fecha sozinha, a partir da leitura de um sensor de chuva, ao cair agua no sensor a passagem de energia é pormitida, assim, utilizamos um pino do arduino para leitura, via código ativamos e desativamos a janela. </p>

<p align  = "justify"> <b>:fire: Umidificador: </b>Construimos um umidificador que liga sozinho, de acordo com a leitura de um sensor de umidade dht11, assim, utilizamos um pino do arduino para leitura e comparamos com uma umidade limite, caso esteja acima da limitação ativamos e desativamos o umidificador. </p>

<p align  = "justify"> <b>:fire: Ventilador: </b>Construimos um ventilador automático utilizando o mesmo sensor (dht11), podemos ler a temperatura ambiente, assim, utilizamos um pino do arduino para leitura e comparamos com uma temperatura limite, caso esteja acima da limitação ativamos e desativamos o ventilador. </p>

<p align  = "justify"> <b>:bulb: Iluminação: </b>Construimos um sistema de iluminação utilizando um led rgb para simulação, podendo então controlar diferentes cores no ambiente via aplicativo. </p>

<p align  = "justify"> <b>:sleeping: Cama: </b>Desenvolvemos uma cama com o foco de iluminação em periodos noturnos, a mesma possui um sensor que ao levantar da cama durante a madruga (periodos noturnos), a iluminação (moderada) ativa automaticamente, auxiliando o usuario a caminhar com visão sobre a casa. </p>

<h4> Ferramentas e componentes: </h4>
<h5> Softwares utilizados: </h5>

<p align  = "justify"> <b>Jira: </b> Utilizado para organização das tarefas a serem feitas devido à sua facilidade e objetividade quanto à adoção de 
uma metodologia como o Scrum. </p>

<p align  = "justify"> <b>Tinkercad: </b>Este programa possui ferramentas e componentes eletrônicos (incluindo 
microcontroladores) prontos para prototipagem de circuitos eletrônicos. Além disso, possui a facilidade e vantagem de escrever e simular o código do projeto utilizando a  metodologia de programação em blocos e código. </p>

<p align  = "justify"> <b>Sketchup: </b>O programa possui todas as ferramentas de desenhos técnicos. O software 
em si traz ferramentas e utilidades para tornar a construção de projetos mais fáceis. 
Além das ferramentas originais do software, pode-se fazer a instalação de 
ferramentas e projetos prontos adicionais, sendo, então, uma plataforma 
opensource. </p>

<p align  = "justify"> <b>Figma: </b>O Figma é uma ferramenta de design versátil bastante popular entre os 
designers. Ele é uma das maiores referências no mercado hoje quando o assunto é 
construção de interfaces digitais combinando a acessibilidade da web com as 
funcionalidades de um aplicativo nativo. Sendo muito usado para a prototipação para 
websites e aplicativos, seja wireframes ou designs com a cara do produto final.</p>

<h4> Hardware: </h4>
<h5> Placas de prótotipagem: </h5>
<p align  = "justify"> <b>Arduino: </b>Arduino é uma plataforma de prototipagem eletrônica utilizada por estudantes, 
empresas e profissionais de diversas áreas, além de ser visto como um hobby. O 
objetivo do Arduino é facilitar a prototipagem eletrônica, barata e flexível.</p>

<p align  = "justify"> <b>Esp32: </b>é altamente integrado com interruptores de antena 
embutidos, balun de RF, amplificador de potência, amplificador de recepção de 
baixo ruído, filtros e módulos de gerenciamento de energia. Possuindo, também, 
suporte híbrido para wifi e bluetooth.</p>

<h5> Sensores e componentes: </h5>
<ol>
<li>Relé Mini 5v 10a Com 5 Terminais</li>
<li>Motor Dc Com Reducao Met. Reversivel Jgy370 12v 150 Rpm 07kg</li>
<li>Módulo Sensor De Luz Ldr Digital/analógico</li>
<li>Kit Mini Umidificador De Ar Usb</li>
<li>Sensor De Temperatura E Umidade Dht11</li>
<li>Sensor de Chuva</li>
<li>Led RGB</li>
<li>...</li>
</ol>

<h4> Codificação: </h4>

<p align  = "justify"> <b>Arduino: </b> A linguagem utilizada 
nesse microcontrolador é uma versão com pequenas modificações da linguagem 
C++. O código usado no projeto foi escrito para cumprir a função de tratar os dados 
lidos pelos sensores e atribuir uma ação adequada para os equipamentos da casa.</p>

<p align  = "justify"> <b>Esp32: </b> A linguagem utilizada 
nesse microcontrolador é uma versão com pequenas modificações da linguagem 
C++. O código usado no projeto foi desenvolvido com o objetivo de receber informações do arduino e enviar para a API, da mesma forma receber informações de outra API e transmitir para o Arduino.</p>

<p align  = "justify"> <b>Servidor: </b> Para gerenciar a comunicação entre o aplicativo e o Arduino, foi construído 
uma aplicação utilizando o micro framework Flask da linguagem Python, usando a 
plataforma do Heroku para manter em cloud o micro serviço de uma API REST no 
formato JSON, definindo quais informações serão trafegadas por meio de chaves.
</p>
<p align  = "justify"> <b>Interface: </b> Para integrar todas as funcionalidades do projeto, sentimos a necessidade 
desenvolver aplicações, de forma rápida, multiplataforma e com simplicidade ao 
programar. Com o objetivo de solucionar estas questões, utilizamos o Flutter 
como framework de desenvolvimento, pois reúne todas as facilidades que 
desejavamos, além de entregar alta performance ao modelo final.
</p>



