from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement
from selenium.common.exceptions import StaleElementReferenceException

class Portals(BaseElement):
    wapperFinderCssSelector = ".guestAccessMainRHSTableContent"

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait)
        print("waiting for Portals section appears")
        self.wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR,self.wapperFinderCssSelector)))
        self.wrapper=self.driver.find_element_by_css_selector(self.wapperFinderCssSelector)


    def getPortalsList(self):
        portalsFinderClassName="ciscoNavigationItem"
        self.wait.until(EC.visibility_of_element_located((By.CLASS_NAME,portalsFinderClassName)))
        return self.getWrapper().find_elements_by_class_name(portalsFinderClassName)

    def selectPortalByName(self,name):
        try:
            print("Select %s portal" %name)
            portalFinder="//div[@class='ciscoNavigationItem']//span[contains(text(),'%s')]/../.." %name
            self.wait.until(EC.visibility_of_element_located((By.XPATH, portalFinder)))
            self.getWrapper().find_element_by_xpath(portalFinder).click()
        except StaleElementReferenceException:
            pass

    def verifyPortalByName(self,name):
        try:
            print("verifying portal %s" %name)
            portalFinder = "//div[@class='ciscoNavigationItem']//span[contains(text(),'%s')]/../.." % name
            self.wait.until(EC.visibility_of_element_located((By.XPATH, portalFinder)))
        except:
            print("Failed to verify portal")

    def getWrapper(self):

        try:
            if self.wrapper is not None and self.doesWrapperApppear():
                return self.wrapper
            else:
                self.wrapper=self.driver.find_element_by_css_selector(self.cssSelectorForActionsBar)
        except:
            self.wrapper = self.driver.find_element_by_css_selector(self.cssSelectorForActionsBar)

        finally:
            return self.wrapper