from flask import Flask, render_template, request, json
from gpiozero import LED
from gpiozero.pins.pigpio import PiGPIOFactory
from prometheus_flask_exporter import PrometheusMetrics

#Define the factory and led
factory = PiGPIOFactory(host='192.168.1.99')
led = LED(17, pin_factory=factory)

#Define the app and connect to the metrics
app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Register default metrics
metrics.register_default(
    metrics.counter(
        'by_path_counter', 'Request count by request paths',
        labels={'path': lambda: request.path}
    )
)

# Apply the same metric to all of the endpoints
endpoint_counter = metrics.counter(
    'endpoint_counter', 'Request count by endpoints',
    labels={'endpoint': lambda: request.endpoint}
)

# Define our routes
@app.route('/')
@endpoint_counter
def index():
    return render_template('led.html')

@app.route('/status')
@endpoint_counter
def healthcheck():
    response = app.response_class(
            response=json.dumps({"result":"OK - healthy"}),
            status=200,
            mimetype='application/json'
    )
    app.logger.info('Status request successfull')
    return response

@app.route('/on')
@endpoint_counter
def on():
    led.on()
    return render_template('led.html')

@app.route('/off')
@endpoint_counter
def off():
    led.off()
    return render_template('led.html')

#Run the app
if __name__ == '__main__':
    app.run(host='0.0.0.0')
