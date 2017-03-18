class GlobalFinders():


    innerPageFinders={"HTTPS port":"httpsPort","Gigabit Ethernet 0":"ethernet0","Gigabit Ethernet 1":"ethernet1",
             "Gigabit Ethernet 2":"ethernet2","Gigabit Ethernet 3":"ethernet3",
             "Gigabit Ethernet 4": "ethernet4", "Gigabit Ethernet 5": "ethernet5",
             "Bond 0": "bond0", "Bond 1": "bond1", "Bond 2": "bond2",
             "Certificate group tag": "certificate", "Authentication method": "identitySourceSequence",
             "Employees using this portal as guests inherit login options from": "guestType",
             "Use browser locale": "userBrowserLocale", "Fallback language": "fallbackLanguage",
             "Always use": "AlwaysUse", "Always use Language": "alwaysUseLanguage", "Require an access code": "accessCode",
             "Access Code Value": "codeValue", "Maximum failed login attempts before rate limiting": "maxFailedValue",
             "Time between login attempts when rate limiting": "minsBtwAttemptsValue", "Include an AUP": "includeAupPageInLogin", "Aup Location": "aupLocation",
             "Require acceptance": "requireToAcceptAUPInLogin", "Allow guests to create their own accounts": "enableSelfReg", "Allow guests to change password after login": "guestChangePassword",
             "Allow the following identity-provider guest portal to be used for login": "allowIDPLoginsCheckbox",
             }

    portalNameTextBoxFinders={"Guest Portals":"portalName","Guest Types":"guestTypeStub.name",
                              "Sponsor Groups":"sponsorGroupName","Sponsor Portals":"spName"}
    portalDescTextBoxFinders={"Guest Portals":"portalDescription","Guest Types":"guestTypeStub.description",
                              "Sponsor Groups":"sponsorGroupDescription","Sponsor Portals":"spDescription"}


    @staticmethod
    def getInnerPageFindersValue(key):
        return GlobalFinders.innerPageFinders[key]


    @staticmethod
    def getPortalNameTextBoxFinder(key):
        return GlobalFinders.portalNameTextBoxFinders[key]

    @staticmethod
    def getPortalDescTextBoxFinder(key):
        return GlobalFinders.portalDescTextBoxFinders[key]