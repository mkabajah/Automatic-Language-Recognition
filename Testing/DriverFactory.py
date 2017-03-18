from selenium.webdriver.support.ui import WebDriverWait
from selenium import webdriver
from selenium.webdriver import FirefoxProfile
import os

class DriverFactory():

    def __init__(self):
        #os.environ["webdriver.gecko.driver"]="C:\\geckodriver-v0.14.0-win64"
        fireFoxProfile=FirefoxProfile("C:\\\CustomProfle\\")
        try:
            print("Initializing webdriver")
            self.driver = webdriver.Firefox(fireFoxProfile)
            print("Done initializing webdriver")
        except:
            print("Adding geckodriver executable to system path variable")
            command="set PATH=%PATH%;C:\\geckodriver-v0.14.0-win64\\"
            os.system(command)
            self.driver =  webdriver.Firefox(fireFoxProfile)

        self.driver.implicitly_wait(15)
        self.wait = WebDriverWait(self.driver, 80)
