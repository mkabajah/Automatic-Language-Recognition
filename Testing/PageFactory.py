from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement
from selenium.common.exceptions import NoSuchElementException
from SubNavLower import SubNavLower
from SubNavTop import SubNavTop
from selenium.webdriver.support.ui import WebDriverWait



class PageFactory(BaseElement):
    wrapperID = "bs-example-navbar-collapse-1"

    def __init__(self, driver, wait=None, subNavBarTop=False, subNavBarLower=False):
        super().__init__(driver, wait)

        self.wait.until(EC.visibility_of_element_located((By.ID,self.wrapperID)))
        self.wrapper = self.driver.find_element_by_id(self.wrapperID)

        if subNavBarTop:
            self.subBarTop = SubNavTop(driver, wait)

        if subNavBarLower:
            self.subBarLower = SubNavLower(driver, wait)


    def getElementByName(self,name):
        finder="//ul[@id='main-navigation']//a[contains(text(),'%s')]" %name
        try:
            return self.getWrapper().find_element_by_xpath(finder)

        except NoSuchElementException:
            raise ("Element %s not found" %name)


    def clickOnElementByName(self,name):
        finder = "//ul[@id='main-navigation']//a[contains(text(),'%s')]" % name
        try:
            self.getWrapper().find_element_by_xpath(finder).click()

        except NoSuchElementException:
            raise ("Element %s not found" %name)

    def getWrapper(self, by=False, value=False):
        if by and value:
            return super().getWrapper(by,value)
        return super().getWrapper(By.ID, self.wrapperID)

    def searchForText(self,text):
        print("Searching for %s" %text)
        finder="//*[contains(text(),'%s')]" %text
        WebDriverWait(self.driver, 80).until((EC.visibility_of_element_located((By.XPATH,finder))))


    def getWorkCenters(self,):
        from WorkCenters import WorkCenters
        return WorkCenters(self.driver,self.wait)





