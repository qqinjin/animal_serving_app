# AI 비전을 이용한 반려동물 스마트 배식기
여러 반려동물을 키우는 사용자들을 위한 스마트 반려동물 배식기 프로젝트입니다. 애플리케이션을 통해 반려동물 정보 입력 후, 실시간 탐지로 개나 고양이 등의 반려동물의 종을 구분해 적절한 사료 배분이 가능합니다. 남은 사료량과 반려동물의 무게 및 온도를 측정하는 기능을 통해 실시간으로 반려동물의 건강상태도 체크할 수 있습니다.

## 서비스 흐름도
![배식기흐름도](https://github.com/qqinjin/animal_serving_app/assets/99711238/731fd991-e174-4e74-8556-6ebd2094415c)

## 하드웨어 
<table>
  <tr>
    <th>라즈베리파이</th>
    <th>로드셀</th>
    <th>HX711</th>
    <th>mlx90614</th>
    <th>웹캠</th>
  </tr>
  <tr>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/a7b6d898-bfbc-48cc-b7d9-d658015ba933" alt="라즈베리파이" width="200" height="200"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/e1de1b9b-ff66-4db4-ade3-91e7aa755af6" alt="로드셀" width="200" height="200"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/79eb0745-bb54-4540-8d3d-133fbdcefcfb" alt="HX711" width="200" height="200"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/e810f456-c532-4d84-8b2a-3f63cd5a76ea" alt=mlx90614" width="200" height="200"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/3d5f6be0-aa42-4e04-baa8-6e898a7ff24e" alt="웹캠" width="200" height="200"/></td>
  </tr>
</table>

- 객체 탐지: 카메라를 통해 반려동물을 탐지하고 분류
- 사료 배식: 서보모터를 이용하여 반려동물에게 알맞은 양의 사료를 배식
- 무게 체크: 로드셀을 통해 배식된 사료의 양과 반려동물의 무게를 정밀하게 측정
- 온도 모니터링: mlx90614 센서를 통해 반려동물의 체온을 실시간으로 모니터링하며, 이를 통해 건강 상태를 확인 가능

## 소프트웨어
<table>
  <tr>
    <th>DB 구성도</th>
    <th>하드웨어 플로우차트</th>
    <th>소프트웨어 플로우차트</th>
  </tr>
  <tr>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/340a8b22-8f8d-413a-a73a-3c8ac08749f9" alt="배식디디비" width="300"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/18472f0f-e026-465a-a1ce-d0334fac80bf" alt="배식기하드웨어" width="300"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/e961a78d-0515-4c79-9a2e-6d5e08066a6e" alt="배식기앱"/></td>
  </tr>
</table>

- flutter와 firebase 사용
- 다양한 반려동물 관리: 사용자는 앱 내에서 여러 반려동물의 정보를 입력하고 관리
- 객체 탐지 및 알림: 하드웨어가 탐지한 반려동물의 종류에 따른 알림을 받아, 적절한 사료 배식이 가능
- 실시간 모니터링: 앱을 통해 실시간으로 반려동물의 상황을 확인 가능
- 건강상태 체크: 반려동물의 무게와 온도를 시간별로 기록하여, 그래프나 통계로 건강상태를 확인 가능

## 인공지능 
![욜로아키텍쳐](https://github.com/qqinjin/animal_serving_app/assets/99711238/c0e024aa-3d0b-40cd-a3f8-0e12bfb4f7b9)
YOLO(You Only Look Once)는 실시간 객체 탐지를 위한 딥러닝 아키텍처입니다.

- 이미지 전체를 한 번만 처리하여 객체의 위치와 클래스를 동시에 예측
- 기존의 R-CNN이나 Fast R-CNN 같은 모델들은 여러 단계의 연산과 이미지에 대한 반복적인 스캔이 필요하여 연산과 시간적인 한계 존재
- 이러한 이유로, 더 빠르고 효율적인 YOLO 모델을 선정

### Yolo 학습 결과
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
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/c945dfc9-5c08-4e55-99e8-3d3a48b8db2b" alt="고양이" width="300 height=300"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/2c956aff-aecb-4017-8295-135c75d3af9a" alt="강아지" width="300 height=300"/></td>
  </tr>
</table>

## 실사 사진
#### 배식기

![배식기실물](https://github.com/qqinjin/animal_serving_app/assets/99711238/91f678f9-19d0-4bf8-81b4-f3dc8ea9787d)

#### 애플리케이션

<table>
  <tr>
    <th>메인페이지</th>
    <th>배식페이지</th>
    <th>무게체크페이지</th>
  </tr>
  <tr>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/5b11c8a0-de21-4216-84a9-2f30957ae47f" alt="어플메인"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/59279079-2bc7-43f5-bb58-f1686a1bf659" alt="어플밥주기"/></td>
    <td><img src="https://github.com/qqinjin/animal_serving_app/assets/99711238/de66dfd6-24e2-46d6-9cad-881e9b63bcb1" alt="어플헬스케어"/></td>
  </tr>
</table>

## 사용 기술
#### 개발환경
- Vscode
- Android Studio
- Google Colab (GPU Standard)
- Linux
  
#### 하드웨어 
- Raspberry Pi 4 Model B 
- loadcell (무게센서)
- mlx90614 (온도센서)
- 서보모터
- 웹캠

#### 소프트웨어 및 언어
- Python
- Flutter (Dart)
- Firebase


## 파일 
- 하드웨어작동 폴더: 라즈베리파이 관련 파일 저장
- 인공지능 폴더: YOLO 작동코드
- 나머지: Flutter (Dart) 코드 저장


