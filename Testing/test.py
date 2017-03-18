from DriverFactory import DriverFactory
from LoginPage import LoginPage
from PageFactory import PageFactory

if __name__=="__main__":
    print("###################### Test Start #########################")
    driverFactory=DriverFactory()
    driver=driverFactory.driver
    wait=driverFactory.wait
    loginPage=LoginPage(driver,wait)
    loginPage.clickLogin(True)
    portalsComponents= PageFactory(driver,wait).getWorkCenters().getGuestAccess()
    portalsComponents.clickOnButtonByName("Portals & Components")
    portalsComponents=portalsComponents.getPortalsComponents()
    portalType="Guest Portals"
    portalName="testingAutomating"
    portalsComponents.leftSide.clickOnButtonByName(portalType)
    portalsComponents.actions.clickOnButtonByName("Create","Self-Registered Guest Portal")
    portalsComponents.innerPage.setTextboxValueByName(portalType,"Name",portalName)
    portalsComponents.innerPage.setTextboxValueByName(portalType,"Description","desc")
    portalsComponents.innerPage.clickOnButtonByName("Portal Settings")
    portalsComponents.innerPage.setValueOfInputByName("HTTPS port","8445")
    portalsComponents.innerPage.clickOnButtonByName("Login Page Settings")
    portalsComponents.innerPage.setValueOfInputByName("Include an AUP",True)
    portalsComponents.innerPage.clickOnButtonByName("Save")
    portalsComponents.innerPage.clickOnButtonByName("Close")
    portalsComponents.portals.verifyPortalByName(portalName)
    driver.close()
    print("###################### Test End #########################")
