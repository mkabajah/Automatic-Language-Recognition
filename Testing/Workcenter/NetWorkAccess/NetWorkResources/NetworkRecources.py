from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import StaleElementReferenceException
from Workcenter.LeftSideBar import LeftSideBar
from Workcenter.NetWorkAccess.NetworkAccess import NetworkAccess
from Workcenter.NetWorkAccess.NetWorkResources.Actions import Actions

class NetworkResources(NetworkAccess):


    def __init__(self, driver, wait=None):
        super().__init__(driver, wait)
        print("Network Resources")
        self.leftSideBar=LeftSideBar(self.driver, self.wait)
        self.actions=Actions(self.driver, self.wait)


    def clickOnButtonOnLeftSideBar(self,name):
        print("Redirecting to %s" %name)
        try:
            self.leftSide.clickOnButtonByName(name)
            self.wait.until(EC.visibility_of_element_located((By.XPATH,"//div[contains(@class,'cpmPageTitle') and contains(text(),'%s')]" % name)))
        except StaleElementReferenceException:
            print("Failed to click on %s due to stale element exception" % name)

    def getHeader(self):
        return self.driver.find_element_by_xpath("//div[contains(@class,'cpmPageTitle')]").getText()

