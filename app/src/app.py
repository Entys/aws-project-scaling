from flask import Flask, render_template, jsonify
import requests
import socket
import time

app = Flask(__name__)

def get_instance_metadata(path):
    try:
        r = requests.get(
            f"http://169.254.169.254/latest/meta-data/{path}",
            timeout=1
        )
        return r.text
    except:
        return "local-dev"

@app.route('/')
def index():
    return render_template('index.html',
        instance_id=get_instance_metadata('instance-id'),
        az=get_instance_metadata('placement/availability-zone'),
        private_ip=get_instance_metadata('local-ipv4'),
        hostname=socket.gethostname(),
        timestamp=time.strftime('%Y-%m-%d %H:%M:%S')
    )

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "instance_id": get_instance_metadata('instance-id'),
        "timestamp": time.time()
    })

@app.route('/cpu-intensive')
def cpu_burn():
    result = 0
    for i in range(10000000):
        result += i ** 2
    
    return jsonify({
        "computed": result,
        "instance_id": get_instance_metadata('instance-id'),
        "message": "CPU intensive task completed"
    })

@app.route('/metrics')
def metrics():
    instance_id = get_instance_metadata('instance-id')
    return f"""# HELP app_info Application info
# TYPE app_info gauge
app_info{{instance_id="{instance_id}"}} 1
"""

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)