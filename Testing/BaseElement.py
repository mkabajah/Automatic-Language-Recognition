from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import StaleElementReferenceException
from selenium.webdriver.common.by import By

class BaseElement():

    def __init__(self,driver,wait=None,wrapper=None):
        self.driver=driver if driver else None
        self.wait = wait if wait else WebDriverWait(self.driver, 60)
        self.wrapper=wrapper if wrapper else None


    def getWrapper(self,by=False,Value=False):
        '''
        :param finder: for Example By.Xpath,"//div[@id='aaa']"
        :return:wrapper
        '''
        if by and Value:
            try:
                if self.wrapper is not None and self.doesWrapperApppear():
                    return self.wrapper
                else:
                    self.wrapper = self.driver.find_element(by,Value)
            except StaleElementReferenceException:
                self.wait.until(EC.visibility_of_element_located((by,Value)))
                self.wrapper = self.driver.find_element(by,Value)
            except:
                pass

        return self.wrapper

    def doesWrapperApppear(self):
        return self.wrapper.is_displayed()


    def searchForText(self,text):
        print("Searching for %s" % text)
        finder = "//*[contains(text(),'%s')]" % text
        WebDriverWait(self.wrapper, 80).until((EC.visibility_of_element_located((By.XPATH, finder))))