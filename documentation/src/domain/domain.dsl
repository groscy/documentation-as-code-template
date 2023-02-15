workspace "kiBon" "System zur Berechnung von Betreuungsgutscheinen" {

    model {
        # stakeholders
        parent = person "Gesuchsteller" "Ein Erziehungsberechtigter eines Kindes, welcher ein BG beantragen oder eine TS-Anmeldung erfassen will\n\n//Benutzer//" "customer, rel"
        commune = person "Gemeinde" "Sachbearbeiter einer Gemeinde, welche BGs ausstellt\n\n//Benutzer//" "customer, rel"
        admin = person "Admin" "System Administrator\n\n//Benutzer//" "customer, rel"
        mandant = person "Mandant" "Auftraggeber\nVerwalter seiner Mitglieder\n\n//Benutzer//" "customer, rel"
        institution = person "Institution" "Ein Mitarbeiter einer Institution für die Betreuung von Kindern (Kita, TS)\n\n//Benutzer//" "customer, rel"
        benutzer = person "Benutzer" "Ein Benutzer von kiBon (kann die Rollen Gesuchsteller, Gemeinde, Admin, Mandant oder Institution haben)" "customer, allgemein"

        #umsysteme
        IAM = softwaresystem "IAM" "System zur Identitäts- und Zugriffskontrolle" "umsystem, rel"
        
        enterprise "DV Bern" {
            kibon = softwaresystem "kiBon System" "System zum Abwickeln des Prozesses der Ausgabe von Betreuungsgutscheinen" "kibon" {
                ebeguWeb = container "kibon-frontend" "Enthält die Logik zur Interaktion mit dem Benutzer des Systems via Browser" "JavaScript und Angular" "Web Browser"{
                    serviceRS = component "RequestService"
                    viewComponent = component "ViewComponent"
                    routingModule = component "RoutingModule"
                    loginController = component "LoginController"
                    uiView = component "UIView"
                }
                ebeguServer = container "kibon-backend" "Enthält die Logik zur Abwicklung des gesamten Prozesses der Ausgabe von Betreuungsgutscheinen durch die Gemeinden" "Java" {
                    restResource = component "kibon-rest"
                    entityService = component "kibon-server"
                    loginProviderInfoRestService = component "LoginProviderInfoRestService
                }
                loginconnector = container "kibon-belogin-connector" "Bildet die Schnittstelle zwischen dem IAM und dem kiBon-System" {
                    fedletServlet = component "FedletServlet"
                    connectorService = component "EbeguConnectorService"
                }
                database = container "Datenbank" "" "Maria DB" "Datenbank"
               
            }
        }

        # relationships between stakeholder and software systems
        parent -> kibon "Gesuch erfassen und einreichen" "" "rs"
        commune -> kibon "Gesuch erfassen, korrigieren und verfügen" "" "rs"
        mandant -> kibon "Mitglieder verwalten, Statistiken generieren" "" "rs"
        institution -> kibon "Plätze und Anmeldungen bestätigen" "" "rs"
        admin -> kibon "Systemeinstellungen vornehmen" "" "rs"
     
        kibon -> IAM "Abfrage zur Authentisierung und Autorisierung eines Benutzer" "" "rs"
    
        # relationships to/from containers
        benutzer -> ebeguWeb "" "" "rs"        
        ebeguWeb -> ebeguServer "" "" "rs"
        ebeguServer -> database "" "" "rs"
        
        IAM -> loginconnector "" "" "noContext"
        loginconnector -> ebeguServer "" "" "rs"
        
        #components
        
        # web
        benutzer -> uiView
        uiView -> routingModule
        
        routingModule -> viewComponent 
        routingModule -> loginController
        viewComponent -> serviceRS
        serviceRS -> ebeguServer
        
        loginController -> serviceRS
        loginController -> IAM
        
        # server
        ebeguWeb -> restResource
        restResource -> loginProviderInfoRestService
        restResource -> entityService
        entityService -> database 
       
        #loginconnector 
        IAM -> fedletServlet
        fedletServlet -> connectorService
        connectorService -> ebeguServer

    }

    views {
        systemlandscape "SystemLandscape" {
            include *
            exclude "relationship.tag==noContext"
            exclude "element.tag==allgemein"
            autoLayout
        }

        systemcontext kibon "SystemContext" {
            include *
            exclude "relationship.tag==noContext"
            exclude "element.tag==allgemein"
        }
    

        container kibon "Containers" {
            include *
            animation {
                ebeguServer
                ebeguWeb
                database
            }
            autoLayout lr
        }

        component ebeguWeb "ebeguWeb-Components" {
            include *
            autoLayout lr
        }

        component ebeguServer "ebeguSever-Components" {
            include *
            autoLayout lr
        }
        
         component loginconnector "loginConnector-Components" {
            include *
            autoLayout lr
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "customer" {
                background #08427b
            }

            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "umsystem" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Mobile App" {
                shape MobileDeviceLandscape
            }
            element "Datenbank" {
                shape Cylinder
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }
            relationship "rs" {
                routing Direct
            }
        }
    }
}