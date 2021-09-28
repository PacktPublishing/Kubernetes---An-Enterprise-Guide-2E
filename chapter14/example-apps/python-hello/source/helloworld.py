from flask import Flask
import os
import socket
import json

app = Flask(__name__)

@app.route('/')
def hello():
    retVal = {
        "msg":"hello world!",
        "host":"%s" % socket.gethostname()

    }
    return json.dumps(retVal)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)