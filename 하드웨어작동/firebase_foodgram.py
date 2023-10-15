import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime
import pytz
from google.cloud.firestore import ArrayUnion
import time


cred = credentials.Certificate("/home/rkrhdlf1546/serviceKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

collection_name = u'pet'

def get_food_gram(petname_value):  # petweight_value as argument
    docs = db.collection(collection_name).get()
    
    for doc in docs:
        petname = doc.get(u'petname')

        if 'food_check' not in doc.to_dict():
            continue  # Skip the document if it does not contain 'food_check' field.

        food_check = doc.get(u'food_check')
        if petname == petname_value and food_check == '1':  # Check against petweight_value argument
            food_gram_value = doc.get(u'food_gram')
            print(f'{petname_value = }', food_gram_value)
            doc.reference.update({u'food_check': '0'})  # Update 'food_check' field to '0'
            return food_gram_value

def get_petnames_to_feed():
    petnames_to_feed = []  # Return list
    docs = db.collection(collection_name).get()

    for doc in docs:
        # Skip the document if it does not contain 'food_check' field.
        if 'food_check' not in doc.to_dict():
            continue  

        petname = doc.get(u'petname')
        food_check = doc.get(u'food_check')

        # Check if food_check is '1', and if so, add petname to the return list
        if food_check == '1':
            petnames_to_feed.append(petname)

    return petnames_to_feed


def animal_check(animal_name):
    docs = db.collection(collection_name).get()

    for doc in docs:
        try:
            petvalue = doc.get(u'petvalue')
        except KeyError:
            petvalue = None
            
        if petvalue is None or 'animal_check' not in doc.to_dict():
            continue
        animal_check = doc.get(u'animal_check')
        if petvalue == animal_name and animal_check == '0':
            animal_check_value = doc.get(u'animal_check')
            doc.reference.update({u'animal_check': '1'})

    return None  # No matching document was found
    
def get_pet_type(petname):
    docs = db.collection(collection_name).get()

    for doc in docs:
        if doc.get(u'petname') == petname:
            pet_type = doc.get(u'petvalue') # petvalue is assumed to hold the pet type
            return pet_type

    return None  # No matching document was found


def animal_weight(petname, loadcell_value):
    docs = db.collection('pet').stream()

    for doc in docs:
        if doc.get('petname') == petname:  # Check if the 'petname' field matches the one you're looking for
            doc_ref = doc.reference  # Get the reference of the found document

            # 현재 타임스탬프를 가져옵니다.
            now = datetime.datetime.now(pytz.utc)

            # 'record' 컬렉션의 모든 문서를 가져옵니다.
            records = doc_ref.collection('record').stream()

            # 가장 가까운 날짜의 문서를 찾습니다.
            closest_record = min(records, key=lambda r: abs(r.to_dict()['배식량']['date'] - now))

            # 가장 가까운 날짜의 문서를 업데이트합니다.
            closest_record.reference.update({
                '남은배식량.date': now,
                '남은배식량.weight': loadcell_value
            })
            return

    print(f"pet 이름 {petname}으로 문서가 존재하지 않습니다.")

def animal_health(petname, loadcell_value, temperature_value):
    docs = db.collection('pet').stream()

    for doc in docs:
        if doc.get('petname') == petname:  # Check if the 'petname' field matches the one you're looking for
            doc_ref = doc.reference  # Get the reference of the found document

            # 현재 타임스탬프를 가져옵니다.
            now = datetime.datetime.now() 
            date_now = datetime.datetime.now(pytz.utc)
            
            # Create a document name based on the current time (year, month, day, hour, minute)
            doc_name = now.strftime("%Y년%m월%d일%H시%M분")

            # Create a new document in the 'health' collection
            health_doc_ref = doc_ref.collection('health').document(doc_name)

            # Add fields to the new document
            health_doc_ref.set({
                'date': date_now,
                'temperature': str(temperature_value),  # set the temperature value
                'weight': "default_weight_value"  # set this to your actual weight value
            })

            # Wait for 5 seconds before updating the weight field
            time.sleep(5)
            health_doc_ref.update({
                'weight': str(loadcell_value)
            })

            return

    print(f"pet 이름 {petname}으로 문서가 존재하지 않습니다.")




        