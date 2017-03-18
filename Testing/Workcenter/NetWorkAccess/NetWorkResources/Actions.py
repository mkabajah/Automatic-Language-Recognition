from selenium.webdriver.common.by import By
from selenium.common.exceptions import StaleElementReferenceException
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement

class Actions(BaseElement):
    ActionsBarID="netDevContext"

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait)

        print("waiting for Actions bar appears")
        self.wait.until(EC.visibility_of_element_located((By.ID,self.ActionsBarID)))
        self.wrapper=self.driver.find_element_by_id(self.ActionsBarID)

    def clickOnButtonByName(self,name):
        try:
            print("Click %s" % name)
            ButtonXpath="//button//span[contains(text(),'%s')]" % name
            self.wait.until(EC.visibility_of_element_located((By.XPATH,ButtonXpath)))
            self.wait.until(EC.element_to_be_clickable((By.XPATH,ButtonXpath)))
            self.getWrapper().find_element_by_xpath(ButtonXpath).click()
        except StaleElementReferenceException:
            print("Failed to click on %s due to stale element exception" % name)



    def getWrapper(self):
        return super().getWrapper(By.ID, self.ActionsBarID)