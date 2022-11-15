# hello.py
import json
from flask import Flask, jsonify, request
from threading import Semaphore

sem = Semaphore()

app = Flask(__name__)

@app.route("/")
def hello_world():
    return """<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Página inicio</title>
  </head>
  <body
    style="
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      overflow: hidden;
    "
  >
    <h1 style="max-width: 50%; text-align: center">
      API Arduino, use /motores ou /sensores por favor.
    </h1>
  </body>
</html>
"""


@app.route('/motores')
def get_motores():
    with open('info.json', 'r') as info:
        server_json = json.load(info)
    return jsonify(server_json['motores'])


@app.route('/motores', methods=['POST'])
def atualizar_motores():
    sem.acquire()
    with open('info.json', 'r') as info:
        server_json = json.load(info)
    motores = server_json['motores']
    request_json:dict = request.get_json()
    for chave, valor in request_json.items():
        if chave in motores.keys():
            if type(valor) == dict:
                for subchave, subvalor in valor.items():
                    if subchave == "luz_horario" and chave == "iluminacao":
                        for horario, cor in subvalor.items():
                            if horario.isnumeric() and horario in motores["iluminacao"]["luz_horario"].keys():
                                motores["iluminacao"]["luz_horario"][horario] = cor
                    elif subchave in motores[chave].keys():
                        motores[chave][subchave] = subvalor
    server_json['motores'] = motores
    with open("info.json", "w") as outfile:
        json.dump(server_json, outfile)
    
    sem.release()
    return '', 204

@app.route('/sensores')
def get_sensores():
    with open('info.json', 'r') as info:
        server_json = json.load(info)
    return jsonify(server_json['sensores'])


@app.route('/sensores', methods=['POST'])
def atualizar_sensores():
    sem.acquire()
    with open('info.json', 'r') as info:
        server_json = json.load(info)
    sensores = server_json['sensores']
    request_json:dict = request.get_json()
    parametros_predefinidos = [
        'umidade',
        'temperatura',
        'pressao',
        'iluminacao'
    ]
    for parametro in parametros_predefinidos:
        if valor := request_json.get(parametro):
            sensores[parametro] = valor
    server_json['sensores'] = sensores
    with open("info.json", "w") as outfile:
        json.dump(server_json, outfile)
    sem.release()
    return '', 204



# if __name__ == '__main__':
#     #app.run(host='0.0.0.0', port=5000)
#     #app.run(host='192.168.15.125', port=5000)
#     #app.run(host='172.28.98.246')
#     app.run(host='172.29.240.1')
