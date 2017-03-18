from NavBarFinders import Finders
from PageFactory import PageFactory
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

class WorkCenters(PageFactory):

    def __init__(self,driver,wait=None,subNavTop=False,subNavLower=False,navigate=True):
        super().__init__(driver, wait, subNavTop, subNavLower)
        finder = Finders.workCenterXpath
        self.wrapper=self.driver.find_element_by_xpath(finder)
        if navigate:
            print("Click Work Centers")
            self.getWrapper().find_element_by_xpath(finder).click()





    def getWrapper(self):
        return super().getWrapper(By.XPATH, Finders.workCenterXpath)

    def getNetworkAccess(self):
        from Workcenter.NetWorkAccess.NetworkAccess import NetworkAccess
        return NetworkAccess(self.driver,self.wait)

    def getGuestAccess(self):
        from Workcenter.GuestAccess.GuestAccess import GuestAccess
        print("Click Guest Access")
        guestAccessFinder=Finders.guestAccessFinder
        self.wait.until(EC.visibility_of_element_located((By.XPATH,guestAccessFinder)))
        self.getWrapper().find_element_by_xpath(guestAccessFinder).click()
        return GuestAccess(self.driver,self.wait)

    def clickOnButtonByXpath(self, xpath):
        self.wait.until(EC.visibility_of_element_located((By.XPATH,xpath)))
        self.subBarLower.clickOnButtonByXpath(xpath)
