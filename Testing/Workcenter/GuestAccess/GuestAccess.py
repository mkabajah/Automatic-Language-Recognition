from WorkCenters import WorkCenters



class GuestAccess(WorkCenters):

    def __init__(self,driver,wait=None):
        super().__init__(driver, wait,True,True,False)


    def clickOnButtonByName(self,name):
        print("Click %s" %name)
        xpath="//div[@class='sub-navigation']//a[contains(text(),'%s')]" %name
        super().clickOnButtonByXpath((xpath))



    def getPortalsComponents(self):
        from Workcenter.GuestAccess.PortalsComponents.ComponentsPage import Components
        return Components(self.driver,self.wait)
