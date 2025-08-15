#!/usr/bin/python3
from flask import Flask, request, redirect

app = Flask(__name__)
NUMBER_FILE = "/tmp/kf-number.txt"

def load_number():
    try:
        with open(NUMBER_FILE, 'r') as f:
            return f.read().strip()
    except:
        return None

def save_number(number):
    with open(NUMBER_FILE, 'w') as f:
        f.write(number)

@app.route('/kf')
def handle_request():
    number = request.args.get('number')
    
    if number:
        save_number(number)
        return f"Number {number} saved"
    else:
        saved_number = load_number()
        if saved_number:
            return redirect(f"http://www.karafun.com/{saved_number}")
        else:
            return "No number provided and none saved"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)