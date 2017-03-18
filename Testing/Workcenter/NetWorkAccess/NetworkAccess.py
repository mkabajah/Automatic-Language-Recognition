from selenium.webdriver.common.by import By
from WorkCenters import WorkCenters



class NetworkAccess(WorkCenters):

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait,True,True)



    def clickOnButtonByName(self,name):
        print("Click %s" % name)
        xpath = "//div[@class='sub-navigation']//a[contains(text(),'%s')]" % name
        super().clickOnButtonByXpath((xpath))

    def getNetworkResources(self):
        from WorkCenter.NetWorkAccess.NetWorkResources.NetworkRecources import NetworkResources
        return NetworkResources(self.driver,self.wait)
