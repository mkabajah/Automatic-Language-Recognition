from selenium.webdriver.common.by import By
from WorkCenters import WorkCenters


class TrustSec(WorkCenters):

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait)


    def clickOnButtonByName(self,name):
        super().clickOnButtonByXpath("//a[contains(text(),'%s')]" %name)