from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement

class GuestPortalsPopUp(BaseElement):
    wrapperID = "configurationTypeSelector"

    def __init__(self,driver,wait=None):
        super().__init__(driver,wait)
        self.wait.until(EC.visibility_of_element_located((By.ID, self.wrapperID)))
        self.wrapper = self.driver.find_element_by_id(self.wrapperID)


    def selectConfiguration(self,name):
        print("Selecting %s configuration" %name)
        configureFinder="//b[contains(text(),'%s')]/../..//input" %name
        self.wait.until(EC.visibility_of_element_located((By.XPATH, configureFinder)))
        self.getWrapper().find_element_by_xpath(configureFinder).click()
        continueFinder="//span[contains(text(),'Continue...')]"
        self.wait.until(EC.visibility_of_element_located((By.XPATH, continueFinder)))
        self.getWrapper().find_element_by_xpath(continueFinder).click()
        saveFinder="//span[contains(text(),'Save')]"
        self.wait.until(EC.visibility_of_element_located((By.XPATH, saveFinder)))
        self

    def getWrapper(self):
        return super().getWrapper(By.ID, self.wrapperID)