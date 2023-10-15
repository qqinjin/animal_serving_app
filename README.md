# AI 비전을 이용한 반려동물 스마트 배식기
여러 반려동물을 키우는 사용자들을 위한 스마트 반려동물 배식기 프로젝트입니다. 애플리케이션을 통해 반려동물 정보 입력 후, 실시간 탐지로 개나 고양이 등의 반려동물의 종을 구분해 적절한 사료 배분이 가능합니다. 무게와 온도 측정 기능을 통해 실시간으로 반려동물의 건강상태도 체크할 수 있습니다.

## 하드웨어 
![하드웨어사진](https://github.com/qqinjin/animal_serving_app/assets/99711238/924b0f28-83f8-46b8-87dd-08cda7b65cbc)
- 객체 탐지: 카메라를 통해 반려동물을 탐지하고 분류합니다.
- 사료 배식: 서보모터를 이용하여 반려동물에게 알맞은 양의 사료를 배식합니다.
- 무게 체크: 로드셀을 통해 배식된 사료의 양과 반려동물의 무게를 정밀하게 측정합니다.
- 온도 모니터링: mlx90614 센서를 통해 반려동물의 체온을 실시간으로 모니터링하며, 이를 통해 건강 상태를 확인할 수 있습니다.

## 소프트웨어
- android studio
<table>
  <tr>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/340a8b22-8f8d-413a-a73a-3c8ac08749f9" alt="배식디디비" width="300"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/18472f0f-e026-465a-a1ce-d0334fac80bf" alt="배식기하드웨어" width="300"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/e961a78d-0515-4c79-9a2e-6d5e08066a6e" alt="배식기앱"/></td>
  </tr>
</table>


- 다양한 반려동물 관리: 사용자는 앱 내에서 여러 반려동물의 정보를 입력하고 관리할 수 있습니다.
- 객체 탐지 및 알림: 하드웨어가 탐지한 반려동물의 종류에 따른 알림을 받아, 적절한 사료 배식이 가능합니다.
- 실시간 모니터링: 앱을 통해 실시간으로 반려동물의 상황을 확인할 수 있습니다.
- 건강상태 체크: 반려동물의 무게와 온도를 시간별로 기록하여, 그래프나 통계로 건강상태를 확인할 수 있습니다.

## 인공지능 
![욜로아키텍쳐](https://github.com/qqinjin/animal_serving_app/assets/99711238/c0e024aa-3d0b-40cd-a3f8-0e12bfb4f7b9)
- YOLO(You Only Look Once)는 실시간 객체 탐지를 위한 딥러닝 아키텍처입니다. 이미지 전체를 한 번만 처리하여 객체의 위치와 클래스를 동시에 예측하는 특징이 있습니다. 이에 YOLO모델을 선정
  
|         | Yolov5s | Yolov7-tiny | Yolov8s |
|:-------:|:-------:|:-----------:|:-------:|
| mAP@0.5 |  0.922  |    0.933    |  0.935  |

- 데이터 출처: 데이터는 roboflow 플랫폼을 사용
- 데이터 수량: 개와 고양이 이미지를 각각 3,000장씩 사용
- 데이터 분할: 학습, 검증, 테스트 세트로 데이터를 7:2:1의 비율로 분할
- 학습 설정:
  - Batch Size: 128
  - Epochs: 300
  - 학습 환경: Google Colab의 GPU(Standard) 환경에서 학습

#### 학습 결과 
 <table>
  <tr>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/c945dfc9-5c08-4e55-99e8-3d3a48b8db2b" alt="고양이" width="300, height=300"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/0c7cd829-35d7-42d2-85d5-ffeb0892c0dc" alt="강아지" width="300, height=300"/></td>
  </tr>
</table>

## 실사 사진
![배식기실물](https://github.com/qqinjin/animal_serving_app/assets/99711238/91f678f9-19d0-4bf8-81b4-f3dc8ea9787d)

## 개발환경
#### 하드웨어 
- Raspberry Pi 4 Model B - Linux
- 
#### 소프트웨어 및 언어
- Python
- Flutter (Dart)
- Firebase
- Android Studio
- Google Colab 

## 파일 
- 하드웨어작동 폴더: 라즈베리파이 관련 파일 저장
- 인공지능 폴더: YOLO 작동코드
- 나머지: Flutter (Dart) 코드 저장


