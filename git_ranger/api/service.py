from src.json2xml import Json2xml
from pathlib import Path
from os import listdir
from django.conf import settings
import os
import pyAesCrypt


# or using an access token

class Service:

    def __init__(self):
        pass

    def encrypt(self, xmlfilename):
        password = os.environ.get('ENCRYPT_PASSWORD')
        bufferSize = 64 * 1024
        pyAesCrypt.encryptFile('.'+xmlfilename, '.'+xmlfilename+".aes", password, bufferSize)
        os.remove('.'+xmlfilename)


    def decrypt(self):
        try:
            for file in listdir('.'+settings.MEDIA_URL):
                if file.endswith('.aes'):
                    xmlfilename = '.' + settings.MEDIA_URL + '' + str(Path(file).with_suffix(''))
                    password = os.environ.get('ENCRYPT_PASSWORD')
                    bufferSize = 64 * 1024
                    pyAesCrypt.decryptFile('.'+settings.MEDIA_URL+''+file, xmlfilename, password, bufferSize)
                    os.remove('.'+settings.MEDIA_URL+''+file)
        except Exception as e:
            return e

    def converttoxml(self, filename):
        try:
            data = Json2xml.fromjsonfile('.'+filename).data
            xmlfilename = Path(filename).with_suffix('')
            xmlfilename = str(xmlfilename)+'.xml'
            data_object = Json2xml(data)
            xmlObj = data_object.json2xml()
            xmlfile = open('.'+xmlfilename, "w")
            xmlfile.write(str(xmlObj))
            xmlfile.close()
            self.encrypt(xmlfilename)
            self.send(xmlfilename)
            return "Done"
        except Exception as e:
            return e

    def send(self, xmlfilename):
        os.system("sshpass -p "
                  + os.environ.get('HOST_PASSWORD')
                  + " scp -o StrictHostKeyChecking=no "
                  + '.'+xmlfilename+".aes "
                  + os.environ.get('HOST_USERNAME')
                  + "@" + os.environ.get('HOST_NAME')
                  + ":" + os.environ.get('FILE_PATH'))
        os.remove('.'+xmlfilename+'.aes')



