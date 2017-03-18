from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from Workcenter.GuestAccess.GuestAccess import GuestAccess
from Workcenter.GuestAccess.PortalsComponents import GlobalsFinders
from Workcenter.GuestAccess.PortalsComponents import LeftSideBar
from selenium.webdriver.common.keys import Keys

class InnerPortalPage(GuestAccess):

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait)
        print("initializing Inner page")
        self.leftSide=LeftSideBar.LeftSideBar(self.driver,self.wait)



    def setTextboxValueByName(self,portalType,fieldName,value):
        self.waitUntilPageLoad()
        globalFinder=GlobalsFinders.GlobalFinders
        IDFinder=globalFinder.getPortalNameTextBoxFinder(portalType) if "Name" in fieldName else globalFinder.getPortalDescTextBoxFinder(portalType)  if "Desc" in fieldName else ""
        self.wait.until(EC.visibility_of_element_located((By.ID, IDFinder)))
        self.driver.find_element_by_id(IDFinder).send_keys(Keys.CONTROL+ "a")
        self.driver.find_element_by_id(IDFinder).send_keys(value)


    def clickOnButtonByName(self,name):
        self.waitUntilPageLoad()
        print("Click on %s" %name)
        buttonFinder="//span[contains(text(),'%s')]" %name
        divFinder="//div[contains(text(),'%s')]" %name
        xpathFinder=buttonFinder if "Save" in name or "Close" in name else divFinder
        self.wait.until(EC.visibility_of_element_located((By.XPATH, xpathFinder)))
        self.driver.find_element_by_xpath(xpathFinder).click()
        if name=="Save":
            self.verifySaveMessage()

    def setValueOfInputByName(self,name,value):

        print("Setting value %s for %s" %(value,name))
        IdFinder=GlobalsFinders.GlobalFinders.getInnerPageFindersValue(name)
        self.wait.until(EC.visibility_of_element_located((By.ID, IdFinder)))
        element=self.driver.find_element_by_id(IdFinder)
        tagName=element.get_attribute("type")
        if tagName=="checkbox" or tagName=="radio":
            if value==True and not element.is_selected():
                 element.click()
            if value==False and element.is_selected():
                element.click()
        elif tagName=="text":
            element.send_keys(Keys.CONTROL+ "a")
            element.send_keys(value)
        elif element.tagName=="select":
            element.click()
            try:
                element.find_element_by_xpath("//option [contains(text(),'%s')]" %value).click()
            except:
                raise "Element is not clickAble !!"

    def verifySaveMessage(self):
        print("Verify save success message")
        self.wait.until(EC.visibility_of_element_located((By.XPATH, "//div[@class='xwt-success-message']")))

    def waitUntilPageLoad(self):
        saveFinder = "//span[contains(text(),'Save')]"
        self.wait.until(EC.element_to_be_clickable((By.XPATH, saveFinder)))







