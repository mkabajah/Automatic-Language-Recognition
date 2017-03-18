from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement
from selenium.common.exceptions import NoSuchElementException,ElementNotVisibleException

class SubNavLower(BaseElement):
    wrapperID = "sub-navigation2"

    def __init__(self, driver, wait=None):
        super().__init__(driver, wait)
        self.wait.until(EC.visibility_of_element_located((By.ID, self.wrapperID)))
        self.wrapper = self.driver.find_element_by_id(self.wrapperID)

    def getWrapper(self):
        return super().getWrapper(By.ID, self.wrapperID)


    def clickOnButtonByXpath(self,xpathForElement):
        try:
            self.getWrapper().find_element_by_xpath(xpathForElement).click()
        except ElementNotVisibleException:
            print("Element not visible %s" % xpathForElement)
            self.driver.find_element_by_xpath(xpathForElement).click()

        except NoSuchElementException:
            raise ("Element %s not found" % str(xpathForElement))


