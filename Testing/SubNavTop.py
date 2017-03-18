from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement
from selenium.common.exceptions import NoSuchElementException

class SubNavTop(BaseElement):
    wrapperID = "sub-navigation"

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait)
        self.wait.until(EC.visibility_of_element_located((By.ID,self.wrapperID)))
        self.wrapper = self.driver.find_element_by_id(self.wrapperID)


    def getWrapper(self):
        return super().getWrapper(By.ID, self.wrapperID)


    def clickOnButtonByName(self,buttonName,subButtonName=False):
        try:
            self.getWrapper().find_element_by_xpath("//a[contains(text(),'%s')]" % buttonName).click()
            if subButtonName:
                try:
                    self.getWrapper().find_element_by_xpath("//ul//a[contains(text(),'%s')]" % subButtonName).click()
                except NoSuchElementException:
                    raise ("Element %s not found" % subButtonName)

        except NoSuchElementException:
            raise("Element %s not found" %buttonName)


