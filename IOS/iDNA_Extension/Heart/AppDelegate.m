//
//  AppDelegate.m
//  Heart
//
//  Created by somkid simajarn on 8/25/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "AppDelegate.h"
#import "Configs.h"
#import "AppConstant.h"
#import "TokenThread.h"

#import "PreLogin.h"
//#import <Firebase/Firebase.h>

// @import FirebaseAnalytics;
// @import FirebaseInstanceID;


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

//@import Firebase;
//@import FirebaseMessaging;

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate , FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@interface AppDelegate (){
    NSMutableArray *childObservers;
}


@end

@implementation AppDelegate
@synthesize ref;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Cache
    NSString *documentdictionary;
    NSArray *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdictionary = [Path objectAtIndex:0];
    documentdictionary = [documentdictionary stringByAppendingPathComponent:@"D8_cache/"];
    self.obj_Manager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:500];
    
    HJMOFileCache *fileCache = [[HJMOFileCache alloc] initWithRootPath:documentdictionary];
    self.obj_Manager.fileCache=fileCache;
    
    fileCache.fileCountLimit=10000;
    fileCache.fileAgeLimit=60*60*24*7;
    [fileCache trimCacheUsingBackgroundThread];
    // Cache
    
    
    // Firebase Config
    // [FIRApp configure];


    // [FIRApp configure];

    
    // Register for remote notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }
             ];
            
            // For iOS 10 display notification (sent via APNS)
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            // For iOS 10 data message (sent via FCM)
            
            // [[FIRMessaging messaging] setRemoteMessageDelegate:self];
            
            //[FIRMessaging messaging].delegate = self;

#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    
    ref = [[FIRDatabase database] reference];
    // Firebase Config
    
    // Observers
    childObservers = [[NSMutableArray alloc] init];
    
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (![[Configs sharedInstance] isLogin]){
        PreLogin *preLogin = [storyboard instantiateViewControllerWithIdentifier:@"PreLogin"];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:preLogin];
        
        self.window.rootViewController = navCon;
        [self.window makeKeyAndVisible];

    }else{
        tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        // UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:preLogin];
        
        self.window.rootViewController = tabBar;
        [self.window makeKeyAndVisible];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ManageTabBar:)
                                                 name:@"ManageTabBar"
                                               object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    if([[Configs sharedInstance] isLogin]){
        
        // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
        __block NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/data/devices/%@/", [[Configs sharedInstance] getUIDU], [[Configs sharedInstance] getUniqueDeviceIdentifierAsString]];

        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            for(FIRDataSnapshot* snap in snapshot.children){
                if ([snap.key isEqualToString:@"online"]) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                    [ref updateChildValues:childUpdates];
                    
                    break;
                }
            }
        }];
    }
}

/*
 App ถูกปิดแต่ค้างอยู่ใน Task
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"");
}

/* 
 เมือ เปิด App ที่ค้างอยู่ใน Task แล้วจะไป call applicationDidBecomeActive เป้น function ถัดไป
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"");
}

/*
 App ถูกเปิด
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self connectToFcm];
    
    if([[Configs sharedInstance] isLogin]){
        // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        __block NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/data/devices/%@/", [[Configs sharedInstance] getUIDU], [[Configs sharedInstance] getUniqueDeviceIdentifierAsString]];

        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            NSLog(@"%@", snapshot.key);
            for(FIRDataSnapshot* snap in snapshot.children){
                NSLog(@">%@", snapshot.key);
                if ([snap.key isEqualToString:@"online"]) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                    [ref updateChildValues:childUpdates];
                    
                    break;
                }
            }
        }];
    }
}

/*
  App โดน quit ออกจาก Task
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    for (FIRDatabaseReference *ref in childObservers) {
        [ref removeAllObservers];
    }
}


// Firebase
// [START receive_message]
// To receive notifications for iOS 9 and below.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    //    NSDictionary *response = [[NSDictionary alloc] initWithObjectsAndKeys:@"test1", @"title", @"test1", @"body", nil];
    //    DebugLog(@"message id to respond?: %@, response: %@", userInfo[@"message_id"], response);
    //    [self connectToFcm];
    //
    //    [[FIRMessaging messaging] sendMessage:response to:@"----@gcm.googleapis.com." withMessageID:userInfo[@"message_id"]  timeToLive: 108];
}
// [END receive_message]


// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Pring full message.
    NSLog(@"%@", userInfo);
}

// Receive data message on iOS 10 devices.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif
// [END ios_10_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    if (refreshedToken != nil) {
        if ([[Configs sharedInstance] isLogin]) {
            
            TokenThread *tokenThread = [[TokenThread alloc] init];
            [tokenThread setCompletionHandler:^(NSString *data) {
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                }else{
                }
            }];
            
            [tokenThread setErrorHandler:^(NSString *error) {
            }];
            [tokenThread start:refreshedToken];

        }
    }
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}


// [END connect_to_fcm]
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [self connectToFcm];
//}
//
//// [START disconnect_from_fcm]
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[FIRMessaging messaging] disconnect];
//    NSLog(@"Disconnected from FCM");
//}
//// [END disconnect_from_fcm]


// Firebase

//http://stackoverflow.com/questions/2191594/send-and-receive-messages-through-nsnotificationcenter-in-objective-c
- (void) ManageTabBar:(NSNotification *) notification
{
    /*
     Ex. การส่ง
     // set your message properties
     NSDictionary *dict =  @{
     @"function" : @"badge",
     @"tabN" : @"1",
     @"value" : @"100",
     };
     
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
     */
    
    /*
     NSDictionary *dict =  @{
     @"function" : @"badge",
     @"tabN" : @"1",
     @"value" : @"100",
     };
     */
    
    if ([[notification name] isEqualToString:@"ManageTabBar"]){
        
        NSDictionary* userInfo = notification.userInfo;
        
        if ([userInfo[@"function"] isEqualToString:@"badge"]) {
            UIViewController *view = [[tabBar viewControllers] objectAtIndex:[userInfo[@"tabN"] integerValue]];
            
            if ([userInfo[@"value"] isEqualToString:@"0"]) {
                [view.tabBarItem setBadgeValue:nil];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }else{
                [view.tabBarItem setBadgeValue:userInfo[@"value"]];
                
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[userInfo[@"value"] integerValue]];
            }
        }else if ([userInfo[@"function"] isEqualToString:@"reset"]){
            [tabBar setSelectedIndex:0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFIRInstanceIDTokenRefreshNotification object:nil userInfo:nil];
        }
    }
}

@end
