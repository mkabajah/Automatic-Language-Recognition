from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import StaleElementReferenceException
from Workcenter.GuestAccess.PortalsComponents import LeftSideBar
from Workcenter.GuestAccess.PortalsComponents import Portals
from Workcenter.GuestAccess.PortalsComponents import Actions
from Workcenter.GuestAccess.PortalsComponents import InnerPortalPage
from Workcenter.GuestAccess.GuestAccess import GuestAccess


class Components(GuestAccess):
    leftSide = None
    portals = None
    actions = None
    innerPage=None


    def __init__(self,driver,wait=None):
        super().__init__(driver, wait)
        print("PortalsComponents")

        self.refreshPage()


    def goToPortalType(self,name):
        print("Redirecting to %s" %name)
        try:
            self.leftSide.clickOnButtonByName(name)
            self.refreshPage()
            self.wait.until(EC.visibility_of(self.portals.getWrapper()))
            self.wait.until(EC.visibility_of(self.actions.getWrapper()))
            self.wait.until(EC.visibility_of_element_located((By.XPATH,"//span[@class='portalsTitle' and contains(text(),'%s')]" % name)))
        except StaleElementReferenceException:
            print("Failed to click on %s due to stale element exception" % name)

    def getHeader(self):
        return self.driver.find_element_by_class_name("portalsTitle").getText()


    def refreshPage(self):
        self.leftSide = LeftSideBar.LeftSideBar(self.driver, self.wait)
        self.portals = Portals.Portals(self.driver, self.wait)
        self.actions = Actions.Actions(self.driver, self.wait)
        self.innerPage = InnerPortalPage.InnerPortalPage(self.driver, self.wait)

