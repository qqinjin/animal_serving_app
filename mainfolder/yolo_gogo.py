import cv2
import time
from ultralytics import YOLO
import firebase_foodgram

def main():
    model = YOLO('/home/rkrhdlf1546/ultralytics/최종_best.pt')

    cap = cv2.VideoCapture(0)

    start_time = time.time()

    while cap.isOpened():
        success, frame = cap.read()

        if success:        

            if time.time() - start_time >= 5:
                start_time = time.time()

                results = model(frame)

                for result in results:
                    for c in result.boxes.cls:
                        detected_class_name = model.names[int(c)]
                        print('class num = ' , int(c), ' , class_name =', detected_class_name)
                        
                        if detected_class_name in ['cat', 'dog']:
                            firebase_foodgram.animal_check(detected_class_name)
                            time.sleep(5)

                annotated_frame = results[0].plot()

                cv2.imshow("YOLOv8 Inference", annotated_frame)

            if cv2.waitKey(1) & 0xFF == ord("q"):
                break
        else:
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
