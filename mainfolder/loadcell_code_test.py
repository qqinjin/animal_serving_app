# loadcell_code_test.py

import RPi.GPIO as GPIO
from hx711 import HX711
import time

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

# HX711 circuit wiring
DOUT_PIN = 20
PD_SCK_PIN = 16

hx = HX711(dout_pin=DOUT_PIN, pd_sck_pin=PD_SCK_PIN)

def setup():
    hx.zero()

def calibrate():
    global loadcellValue
    loadcellValue = 90550

def convert_to_weight(raw_value):
    global loadcellValue
    return raw_value / loadcellValue

def get_weight_from_loadcell():
    #setup()  # Initialize the load cell
    raw_value = hx.get_weight_mean(20)
    weight = convert_to_weight(raw_value)

    # 현재 무게를 계산합니다 (단위: g).
    weight_in_grams = weight * 453

    return weight_in_grams

def main():
    setup()  # Move the zeroing to the main function
    while True:
        raw_value = hx.get_weight_mean(20)
        weight = convert_to_weight(raw_value)

        # 출력
        time.sleep(1)
        print('무게: {:.2f} g'.format(weight*453))

        # 무게가 1000g 이상인 경우 종료
        if weight >= 1000:
            print('무게가 1000g 이상입니다. 측정을 종료합니다.')
            break

        time.sleep(1)

    hx.power_down()
    hx.power_up()
    GPIO.cleanup()