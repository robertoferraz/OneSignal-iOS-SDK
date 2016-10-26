/**
 * Modified MIT License
 *
 * Copyright 2015 OneSignal
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * 1. The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * 2. All copies of substantial portions of the Software may only be used in connection
 * with services provided by OneSignal.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // TODO: Test before;
    // center.delegate = self;
    
    // Eanble logging to help debug issues. visualLevel will show alert dialog boxes.
    [OneSignal setLogLevel:ONE_S_LL_INFO visualLevel:ONE_S_LL_INFO];
    
    [OneSignal initWithLaunchOptions:launchOptions appId:@"b2f7f966-d8cc-11e4-bed1-df8f05be55ba" handleNotificationReceived:^(OSNotification *notification) {
        NSLog(@"Received Notification - %@", notification.payload.notificationID);
    } handleNotificationAction:^(OSNotificationOpenedResult *result) {
        
        // This block gets called when the user reacts to a notification received
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString* messageTitle = @"OneSignal Example";
        NSString* fullMessage = [payload.body copy];
        
        if (payload.additionalData) {
            
            if(payload.title)
                messageTitle = payload.title;
            
            if (result.action.actionID)
                fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", result.action.actionID]];
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:messageTitle
                                                            message:fullMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil, nil];
        [alertView show];

    } settings:@{kOSSettingsKeyInAppAlerts : @NO, kOSSettingsKeyAutoPrompt : @NO}];
    
    [OneSignal IdsAvailable:^(NSString *userId, NSString *pushToken) {
        if(pushToken) {
            NSLog(@"Received push token - %@", pushToken);
            NSLog(@"User ID - %@", userId);
        }
    }];
    
    // TODO: Test After;
    // center.delegate = self;
    
    /*
    // iOS 10 ONLY - Add category for the OSContentExtension
    // Make sure to add UserNotifications framework in the Linked Frameworks & Libraries.
     
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
        
        UNNotificationAction* myAction = [UNNotificationAction actionWithIdentifier:@"action0" title:@"Hit Me!" options:UNNotificationActionOptionForeground];
        UNNotificationCategory* myCategory = [UNNotificationCategory categoryWithIdentifier:@"myOSContentCategory" actions:@[myAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet* mySet = [[NSSet alloc] initWithArray:@[myCategory]];
        
        //Add existing cateogories
        mySet = [mySet setByAddingObjectsFromSet:categories];
        
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:mySet];
    }];
    */
    
    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification  withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog( @"for handling push in foreground" );
    // Your code
    NSLog(@"%@", notification.request.content.userInfo); //for getting response payload data
}

@end
