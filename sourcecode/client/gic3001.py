import serial
import time
import binascii
import random

utdata = {}
utdata['00'] = 0
utdata['01'] = 0
utdata['02'] = 0
utdata['03'] = 0
utdata['04'] = 0
utdata['05'] = 0
utdata['06'] = 0
utdata['07'] = 0
utdata['08'] = 0
utdata['09'] = 0
utdata['0A'] = 0
utdata['0B'] = 0
utdata['0C'] = 0
utdata['0D'] = 0
utdata['0E'] = 0

enhet = [	['00',1,'test'],
			['00',2,'test2'],
			['00',3,'test3'],
			['00',4,'test4'],
			['00',5,'test5'],
			['00',6,'test6'],
			['01',1,'test7'],
			['01',2,'test8'],
			['01',3,'test9'],
			['01',4,'test10']
		]
			
ser = serial.Serial('COM3', 38400, timeout=0)
i = 4
while 1:
	i = random.randint(0,9)
	temp = enhet[i]
	utdata[temp[0]] = utdata[temp[0]] ^ (2**temp[1])
	temp2 = '0' + hex(utdata[temp[0]])[2:]
	ser.write( binascii.unhexlify(temp[0]) + binascii.unhexlify(temp2[-2:]))
	print temp[2]
	time.sleep(random.randint(5,20))


print ser.write(b'\x04\xa3')