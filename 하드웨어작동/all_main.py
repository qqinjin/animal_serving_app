import servo_motor
import firebase_foodgram
import time
import loadcell_code_test
import loadcell_code_2
import loadcell_code_3
#import yolo_gogo
#import multiprocessiong

loadcell_code_test.calibrate()
loadcell_code_test.setup()

loadcell_code_2.calibrate()
loadcell_code_2.setup()

loadcell_code_3.calibrate()
loadcell_code_3.setup()

try:
    #yolo_process = multiprocessing.Process(target=yolo_gogo.run_yolo)
    #yolo_process.start()
    while True:
        # food_check 필드가 1인 pet의 이름을 가져옵니다.
        petnames_to_feed = firebase_foodgram.get_petnames_to_feed()

        for petname_value in petnames_to_feed:
            pet_type = firebase_foodgram.get_pet_type(petname_value)  # get pet type

            if pet_type is None: 
                continue
            
            food_gram = int(firebase_foodgram.get_food_gram(petname_value))

            if food_gram is not None:
                print(f"{petname_value}의 배식을 시작합니다.")

                if pet_type == 'cat':
                    servo_motor.rotate_servo(servo_motor.pwm1, 160)
                    loadcell_module = loadcell_code_2
                    pwm = servo_motor.pwm1
                    
                    time.sleep(1)

                    loadcell_value = 0
                    animal_loadcell_value = 0

                    while loadcell_value < food_gram:  # 로드셀의 무게가 설정된 food_gram 미만이면 계속해서 로드셀의 값을 확인
                        
                        loadcell_value = loadcell_code_2.get_weight_from_loadcell()
                        firebase_foodgram.animal_weight(petname_value, loadcell_value)  # 현재 무게를 Firestore에 업데이트
                        
                        animal_loadcell_value = loadcell_code_test.get_weight_from_loadcell()
                        #time.sleep(1)
                        
                        print("cat_loadcell = ",loadcell_value)
                        print("cat_weight_loadcell = ", animal_loadcell_value)
                        print(food_gram)
                    
                    if loadcell_value >= food_gram:
                        print("배식이 완료되었습니다.")
                        
                        servo_motor.rotate_servo(servo_motor.pwm1, 130)
                        time.sleep(5)  # 10초 후 다음 루프를 시작
                        
                        loadcell_value = loadcell_code_2.get_weight_from_loadcell()
                        firebase_foodgram.animal_weight(petname_value, loadcell_value)  # 현재 무게를 Firestore에 업데이트
                        
                        animal_loadcell_value = loadcell_code_test.get_weight_from_loadcell()
                        firebase_foodgram.animal_health(petname_value,animal_loadcell_value,34)
                       
                        
                        print("cat_loadcell = ", loadcell_value)
                        print("cat_weight_loadcell = ", animal_loadcell_value)
                        print(food_gram)


                elif pet_type == 'dog':
                    
                    servo_motor.rotate_servo(servo_motor.pwm2, 160)
                    loadcell_module = loadcell_code_3  
                    pwm = servo_motor.pwm2
                    
                    time.sleep(1)

                    loadcell_value = 0
                    animal_loadcell_value = 0
                    
                    while loadcell_value < food_gram:  # 로드셀의 무게가 설정된 food_gram 미만이면 계속해서 로드셀의 값을 확인
                        
                        loadcell_value = loadcell_code_3.get_weight_from_loadcell()
                        firebase_foodgram.animal_weight(petname_value, loadcell_value)  # 현재 무게를 Firestore에 업데이트
                        
                        animal_loadcell_value = loadcell_code_test.get_weight_from_loadcell()
                        #time.sleep(1)
                        
                        print("dog_loadcell = ",loadcell_value)
                        print("dog_weight_loadcell = ", animal_loadcell_value)
                        print(food_gram)
                    
                    if loadcell_value >= food_gram:
                        print("배식이 완료되었습니다.")
                        
                        servo_motor.rotate_servo(servo_motor.pwm2, 130)
                        time.sleep(5)  # 10초 후 다음 루프를 시작
                        
                        loadcell_value = loadcell_code_3.get_weight_from_loadcell()
                        firebase_foodgram.animal_weight(petname_value, loadcell_value)  # 현재 무게를 Firestore에 업데이트
                        
                        animal_loadcell_value = loadcell_code_test.get_weight_from_loadcell()
                        firebase_foodgram.animal_health(petname_value,animal_loadcell_value,34)
                       
                        print("dog_loadcell = ",loadcell_value)
                        print("dog_weight_loadcell = ", animal_loadcell_value)
                        print(food_gram)


except KeyboardInterrupt:
    pass

servo_motor.pwm1.stop()
servo_motor.pwm2.stop()
RPi.GPIO.cleanup()


