from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement
from selenium.common.exceptions import StaleElementReferenceException

class LeftSideBar(BaseElement):
    wrapperFinder = "sidenav"

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait)

        print("waiting for Left Side appears")
        self.wait.until(EC.visibility_of_element_located((By.ID,self.wrapperFinder)))
        self.wrapper =self.driver.find_element_by_id(self.wrapperFinder)


    def clickOnButtonByName(self,name):
        try:
            print("Click on %s" %name)
            finderOfButton="//div[@title='%s']" %name
            self.wait.until(EC.visibility_of_element_located((By.XPATH,finderOfButton)))
            self.wait.until(EC.element_to_be_clickable((By.XPATH, finderOfButton)))
            self.getWrapper().find_element_by_xpath(finderOfButton).click()
        except StaleElementReferenceException:
            print("Failed to click on %s due to stale element exception" % name)

    def getWrapper(self):
        return super().getWrapper(By.ID, self.wrapperFinder)