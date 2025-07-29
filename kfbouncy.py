#!/usr/bin/python3
from flask import Flask, request, redirect

app = Flask(__name__)
saved_number = None

@app.route('/kf')
def handle_request():
    global saved_number
    number = request.args.get('number')
    
    if number:
        saved_number = number
        return f"Number {number} saved"
    elif saved_number:
        return redirect(f"http://www.karafun.com/{saved_number}")
    else:
        return "No number provided and none saved"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
