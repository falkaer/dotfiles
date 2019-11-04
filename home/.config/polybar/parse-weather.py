#!/usr/bin/env python3

import sys
import os
import requests

icons = {
    '01d': '',
    '01n': '',
    
    '02d': '',
    '02n': '',
    
    '03d': '',
    '03n': '',
    
    '04d': '',
    '04n': '',
    
    '09d': '',
    '09n': '',
    
    '10d': '',
    '10n': '',
    
    '11d': '',
    '11n': '',
    
    '13d': '',
    '13n': '',
    
    '50d': '',
    '50n': ''
    
}

def get_key(path):
    with open(path, 'r') as f:
        return f.read()

def get_weather(forecast):
    request_type = 'forecast' if forecast else 'weather'
    return requests.get('{}/{}'.format(API, request_type), REQUEST_PARAMS).json()

# TODO: format humidity in forecast?
# TODO: format uncertainty on temperature in forecast?
# TODO: format wind speed (and possibly direction?) in forecast?
def format_message(d):
    print(d)
    
    temp = d['main']['temp']
    icon = icons.get(d['weather'][0]['icon'], '')
    temp = round(temp)
    
    out = '%{{T4}}{} %{{T-}}{}°'.format(icon, temp)
    
    if 'rain' in d:
        precip = d['rain']
        sym = ''
    elif 'snow' in d:
        precip = d['snow']
        sym = ''
    else:
        precip = None
        sym = None
    
    if precip is not None:
        
        val = precip['3h'] if '3h' in precip else precip['1h'] if '1h' in precip else 0
        
        if val > 0.05:
            out = '%{{T4}}{} %{{T-}}{}mm '.format(sym, val) + out
    
    return out

KEY_PATH = os.path.join(os.path.expanduser('~'), '.config/polybar/openweather-key.txt')
API = 'https://api.openweathermap.org/data/2.5'

REQUEST_PARAMS = {
    'appid': get_key(KEY_PATH),
    'lat'  : 55.78,  # latitude
    'lon'  : 12.52,  # longitude
    'units': 'metric'
}

if __name__ == '__main__':
    
    # TODO: add UV-index https://openweathermap.org/api/uvi#current
    
    if len(sys.argv) < 2 or sys.argv[1] == 'current':
        print(format_message(get_weather(False)))
    elif len(sys.argv) == 2 and sys.argv[1] == 'forecast':
        print(format_message(get_weather(True)['list'][0]))
