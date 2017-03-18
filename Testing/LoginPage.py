from Globals import  GlobalsParams,LoginParams
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from BaseElement import BaseElement

class LoginPage(BaseElement):

    def __init__(self,driver,wait=None):
        super().__init__(driver,wait)
        URL=GlobalsParams.URL
        print("Redirection to %s" %URL)
        self.driver.get(URL)


    def getTextBoxByName(self,name):
        print("Get %s textbox" %name)
        finder="//td[@class='userFormLabel' and contains(text(),'%s')]/..//input" %name
        self.wait.until(EC.visibility_of_element_located((By.XPATH,finder)))
        return self.driver.find_element_by_xpath(finder)

    def setTextboxValueByName(self,name,value):
        print("set value %s for %s textbox" %(value,name))
        finder = "//td[@class='userFormLabel' and contains(text(),'%s')]/..//input" % name
        self.wait.until(EC.visibility_of_element_located((By.XPATH,finder)))

        self.driver.find_element_by_xpath(finder).send_keys(value)

    def clickLogin(self,defaultValues=False):


        if defaultValues:
            print("Setting default values for username & password textbox")
            finder = "//td[@class='userFormLabel' and contains(text(),'Username')]/..//input"
            self.wait.until(EC.visibility_of_element_located((By.XPATH,finder)))
            self.driver.find_element_by_xpath(finder).send_keys(LoginParams.ADMIN_USERNAME)
            finder = "//td[@class='userFormLabel' and contains(text(),'Password')]/..//input"
            self.wait.until(EC.visibility_of_element_located((By.XPATH,finder)))
            self.driver.find_element_by_xpath(finder).send_keys(LoginParams.ADMIN_PASSWORD)

        loginID="loginPage_loginSubmit"
        self.wait.until(EC.visibility_of_element_located((By.ID,loginID)))
        print("Click Login")
        self.driver.find_element_by_id(loginID).click()
        self.skipPopUp()
        print("Waiting Until page load")
        self.wait.until(EC.visibility_of_element_located((By.ID,"bs-example-navbar-collapse-1")))




    def skipPopUp(self):
        print("Skipping popups")
        XpathForPopUp = "//div [@class='modal-content']"
        self.wait.until(EC.visibility_of_element_located((By.XPATH,XpathForPopUp)))
        FinderForNext = "carousel-next"
        try:
            while (self.driver.find_element_by_id(FinderForNext).is_displayed()):
                self.driver.find_element_by_id(FinderForNext).click()
        except:
            pass
        print("Done skipping popups")
