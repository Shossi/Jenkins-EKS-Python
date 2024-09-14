import requests
import configparser  # used to parse the config and load it into the script.
import json
import boto3
from botocore.exceptions import ClientError
"""
This portion of the code is the way the app reads the api key from the config file.
"""

# config = configparser.ConfigParser()
# config.read('key.config')
# key = config['KEYS']['key']

def get_secret():

    secret_name = "api_key"
    region_name = "eu-central-1"

    client = boto3.client('secretsmanager', region_name=region_name)

    try:
        response = client.get_secret_value(SecretId=secret_name)
        secret = response['SecretString']
        secret_dict = json.loads(secret)
        return secret_dict['key']
    except Exception as e:
        raise Exception(f"Error retrieving secret: {e}")


def valid_input(location):
    """
    Function that checks that the users input is valid.
    uses isalpha to check if it has anything other than chars
    and replace to remove whitespaces.
    """
    return location.replace(" ", "").isalpha()


def api_call(location):
    """
    this function is the api call, it takes the input, sends a get request to the api
    and returns the data in json format.
    there's also a check to see wether the data retrival went fluently.
    :param location: - user input from the web app -
    :return: data - api data in json format
    """
    url = f"https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/{location}/?key={key}&unitGroup=metric"
    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        return data
    except requests.exceptions.RequestException:
        return False

