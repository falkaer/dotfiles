#!/usr/bin/env python3

import argparse
import subprocess
import time
import sys
import os
import os.path as osp

from bluepy import btle
from bluepy.btle import Scanner, BTLEManagementError

import Xiaomi_Scale_Body_Metrics

MISCALE_MAC = '5C:CA:D3:80:9A:A1'
HCI_DEV = '0'

HEIGHT = 178
AGE = 24
SEX = 'male'

CACHE_LOCATION = osp.join(osp.expanduser('~'), '.cache', 'miscale.txt')

def parse_data(data):
    data2 = bytes.fromhex(data[4:])
    ctrlByte1 = data2[1]
    is_stabilized = ctrlByte1 & (1<<5)
    has_impedance = ctrlByte1 & (1<<1)

    measunit = data[4:6]
    measured = int((data[28:30] + data[26:28]), 16) * 0.01
    unit = ''
    if measunit == "03": unit = 'lbs'
    if measunit == "02": unit = 'kg' ; measured = measured / 2
    impedance = str(int((data[24:26] + data[22:24]), 16)) if has_impedance else 0
    
    if unit == "lbs": calcweight = round(measured * 0.4536, 2)
    if unit == "jin": calcweight = round(measured * 0.5, 2)
    if unit == "kg": calcweight = measured
    
    if unit and is_stabilized:
        return Xiaomi_Scale_Body_Metrics.bodyMetrics(calcweight, HEIGHT, AGE, SEX, int(impedance))
    else:
        return None

def write_cache(data):
    with open(CACHE_LOCATION, 'w') as f:
        f.write(data)

def read_cache():
    if not osp.exists(CACHE_LOCATION):
        return
    with open(CACHE_LOCATION, 'r') as f:
        return f.read()

class MiScaleDelegate:
    def __init__(self):
        self.prevdata = read_cache()
    
    def handleDiscovery(self, dev, device_new, data_new):
        if dev.addr == MISCALE_MAC.lower() and device_new:
            for sdid, desc, data in dev.getScanData():
                if data.startswith('1b18') and sdid == 22:
                    # guard against double measurement
                    if self.prevdata == data[22:]:
                        continue
                    
                    metrics = parse_data(data)
                    if metrics:
                        title = 'MiScale measurement'
                        msg =  '{:.2f} kg\n'.format(metrics.weight)
                        msg += '{:.2f}% body fat\n'.format(metrics.getFatPercentage())
                        msg += '{:.2f} visceral fat level\n'.format(metrics.getVisceralFat())
                        msg += '{:.2f} kg muscle mass\n'.format(metrics.getMuscleMass())
                        msg += '{:.2f} kg lean body mass\n'.format(metrics.getLBMCoefficient())
                        msg += '{:.2f} kg bone mass\n'.format(metrics.getBoneMass())
                        msg += '{:.2f} kcal basal metabolism\n'.format(metrics.getBMR())
                        msg += '{:.2f}% protein\n'.format(metrics.getProteinPercentage())
                        subprocess.call(['notify-send', '-t', '0', title, msg])
                        # sys.stdout.write(msg)
                        # sys.stdout.flush()
                        
                        self.prevdata = data[22:]
                        write_cache(self.prevdata)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', type=float, default=5, help='seconds to wait between updates')
    args = parser.parse_args()
    
    try:
        delegate = MiScaleDelegate()
        while True:
            try:
                scanner = btle.Scanner(HCI_DEV).withDelegate(delegate)
                scanner.scan(5) # passive=True?
                time.sleep(args.n)
            except BTLEManagementError:
                subprocess.call(['bluetoothctl', 'power', 'on'],
                    stdout=subprocess.DEVNULL)
    except KeyboardInterrupt:
        sys.exit(0)
