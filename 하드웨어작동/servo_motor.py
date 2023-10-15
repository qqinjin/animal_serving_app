import RPi.GPIO as GPIO
import time

servo_pin1 = 18
servo_pin2 = 12

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(servo_pin1, GPIO.OUT)
GPIO.setup(servo_pin2, GPIO.OUT)

pwm1 = GPIO.PWM(servo_pin1, 50)
pwm2 = GPIO.PWM(servo_pin2, 50)

pwm1.start(0)
pwm2.start(0)

servo_min_duty = 3
servo_max_duty = 12

def rotate_servo(pwm, degree):
    degree = max(0, min(180, degree))
    duty_cycle = servo_min_duty + (degree / 180.0) * (servo_max_duty - servo_min_duty)
    pwm.ChangeDutyCycle(duty_cycle)
    time.sleep(0.5)
    pwm.ChangeDutyCycle(0)
