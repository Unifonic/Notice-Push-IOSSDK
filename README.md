# UnifonicNoticeSDK

## Register app
`register(appId: String, completion: @escaping (_ sdkToken: String?, _ error: String?) -> ())`
### Register your app 
### appId - Application ID you get when you create Unifonic Notice account
### Returns:
### sdkToken - in case of success
### error - in case of an error, nil otherwise

## Save your push token
`saveToken(identifier: String, pushToken: String, completion: @escaping (_ status: Bool, _ error: String?) -> ())`
### Sends your push notification to Unifonic
### identifier - unique identifier 
### pushToken - your apns token
### Returns:
### status - true/false
### error - in case of an error, nil otherwise

## Mark a notification
`markNotification(type: NotificationReadType, userInfo: [String: Any], completion: @escaping (_ status: Bool, _ error: String?) -> ())`
### Mark a notification as either read or received
### type - read/received
### userInfo - payload dictionary
### Returns
### status - true/false
### error - in case of an error, nil otherwise 

## Disable notification
`disableNotification(identifier: String, completion: @escaping (_ status: Bool, _ error: String?) -> ())`
### Disables a notification if the user has turned off notifications from the settings app
### identifier - your unique identifier
### Returns:
### status - true/false
### error - in case of an error, nil otherwise

