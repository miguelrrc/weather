# weather# Sypnosis
Small App to get the weather from different locations. The App uses http://www.worldweatheronline.com/ to retrieve the data.

In this version the App uses SQLite to save the data from cities and NSUserDefaults to save some settings by the user. By default the Temperature is Celsius and the Wind speed is Km/h.

#Version 
1.0.0

#Tech
Cocoapods
    AFNetworking (WebService)
    FMDB    (Database)
    JSONModel (Parse from JSON to Models)
    MBProgressHUD (Classic loading view)
    SWTableViewCell (Used for delete button on Forecast)

#TO-DO
Some refactoring and implementation of a layer between the Controllers /WS and the database.
Add animations.
