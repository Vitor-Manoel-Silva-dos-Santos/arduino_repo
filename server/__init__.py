# hello.py

from flask import Flask, jsonify, request

app = Flask(__name__)

motores = {
    "janela": {
        "manual": False,
        "aberta": False,
        "temperatura_de_ativacao": 25,
        "umidade_de_ativacao": 40
    },
    "ventilador": {
        "manual": False,
        "ligado": False,
        "temperatura_de_ativacao": 25,
        "umidade_de_ativacao": 40
    },
    "umidificador": {
        "manual": False,
        "ligado": False,
        "temperatura_de_ativacao": 25,
        "umidade_de_ativacao": 40
    },
    # International Standard ISO 8601 where Monday is the first day 
    # Sunday as the seventh and final day
    "despertador": {
        "ligado": False,
        "dias_semana": {
            1: {
                "hora": 00,
                "minuto": 00
            },
            2: {
                "hora": 00,
                "minuto": 00
            },
            3: {
                "hora": 00,
                "minuto": 00
            },
            4: {
                "hora": 00,
                "minuto": 00
            },
            5: {
                "hora": 00,
                "minuto": 00
            },
            6: {
                "hora": 00,
                "minuto": 00
            },
            7: {
                "hora": 00,
                "minuto": 00
            }
        }
    },
    "iluminacao": {
        "manual": False,
        "economia_inteligente": False,
        "iluminacao_de_ativacao": 40,
        "luz_horario": {
            0: "#000000",
            1: "#000000",
            2: "#000000",
            3: "#000000",
            4: "#000000",
            5: "#000000",
            6: "#000000",
            7: "#000000",
            8: "#000000",
            9: "#000000",
            10: "#000000",
            11: "#000000",
            12: "#000000",
            13: "#000000",
            14: "#000000",
            15: "#000000",
            16: "#000000",
            17: "#000000",
            18: "#000000",
            19: "#000000",
            20: "#000000",
            21: "#000000",
            22: "#000000",
            23: "#000000"
        }
    },
}

sensores = {
    "umidade": 40,
    "temperatura": 25,
    "pressao": 40,
    "iluminacao": 40
}

@app.route("/")
def hello_world():
    return "Hello, World!"


@app.route('/motores')
def get_motores():
    return jsonify(motores)


@app.route('/sensores')
def get_sensores():
    return jsonify(sensores)


@app.route('/sensores', methods=['POST'])
def atualizar_sensores():
    json:dict = request.get_json()
    parametros_predefinidos = [
        'umidade',
        'temperatura',
        'pressao',
        'iluminacao'
    ]
    for parametro in parametros_predefinidos:
        if valor := json.get(parametro):
            sensores[parametro] = valor
    return '', 204

# if __name__ == '__main__':
#     #app.run(host='0.0.0.0', port=5000)
#     #app.run(host='192.168.15.125', port=5000)
#     #app.run(host='172.28.98.246')
#     app.run(host='172.29.240.1')