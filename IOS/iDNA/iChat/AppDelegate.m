//
//  AppDelegate.m
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import "AppDelegate.h"
#import "MessageRepo.h"
#import "PreLogin.h"
#import "MainTabBarController.h"
#import "FriendProfileRepo.h"
#import "GroupChatRepo.h"
#import "GroupChat.h"

#import "MyApplicationsRepo.h"
#import "MyApplications.h"

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
    NSMutableArray *childObservers, *childObserver_Friends;
}

@end

@implementation AppDelegate
@synthesize ref /*, friendsProfile*/;

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
    
    
    // Firebase
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
    
    [FIRApp configure];
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    
    ref = [[FIRDatabase database] reference];
    // Firebase Config
    // Firebase
    
    
    // Observers
    childObservers = [[NSMutableArray alloc] init];
    
    
    // สร้าง friendsProfile
    // friendsProfile = [[NSMutableDictionary alloc] init];
    
    
    
    ///<----
    /*
     เช็ดก่อนว่ามีการ login แล้วหรือเปล่า ถ้า
     - true
        : เราจะวิ่งไปที่  MainTabBarController
     
     - false 
        : จะไปหน้า login 
     */
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (![[Configs sharedInstance] isLogin]){
        PreLogin *preLogin = [storyboard instantiateViewControllerWithIdentifier:@"PreLogin"];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:preLogin];
        
        self.window.rootViewController = navCon;
        [self.window makeKeyAndVisible];
        
    }else{
        MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
        self.window.rootViewController = mainTabBarController;
        [self.window makeKeyAndVisible];
    }
    //------>
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if([[Configs sharedInstance] isLogin]){
        __block NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
        
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            
            BOOL flag = true;
            for(FIRDataSnapshot* snap in snapshot.children){
                if ([snap.key isEqualToString:@"online"]) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                    [ref updateChildValues:childUpdates];
                    
                    flag = false;
                    break;
                }
            }
            
            /*
             กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
             */
            if (flag) {
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/online/", child]: @"0"};
                [ref updateChildValues:childUpdates];
            }
        }];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/*
 App ถูกเปิด
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self connectToFcm];
    
    if([[Configs sharedInstance] isLogin]){
        __block NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
        
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            // NSLog(@"%@", snapshot.key);
            // NSLog(@"%@", snapshot.children);
            // NSLog(@"%@", snapshot.value);
            BOOL flag = true;
            for(FIRDataSnapshot* snap in snapshot.children){
                // NSLog(@">%@", snapshot.key);
                // NSLog(@">%@", snap.key);
                // NSLog(@">%@", snap.value);
                if ([snap.key isEqualToString:@"online"]) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                    [ref updateChildValues:childUpdates];
                    
                    flag = false;

                    break;
                }
            }
            
            /*
             กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
             */
            if (flag) {
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/online/", child]: @"1"};
                [ref updateChildValues:childUpdates];
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
            
//            TokenThread *tokenThread = [[TokenThread alloc] init];
//            [tokenThread setCompletionHandler:^(NSString *data) {
//                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
//                
//                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                }else{
//                }
//            }];
//            
//            [tokenThread setErrorHandler:^(NSString *error) {
//            }];
//            [tokenThread start:refreshedToken];
            
            __block NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
            
            [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                FIRDatabaseReference *childRef = [ref child:child];
                [childObservers addObject:childRef];
                
                // NSLog(@"%@", snapshot.key);
                // NSLog(@"%@", snapshot.children);
                // NSLog(@"%@", snapshot.value);
                BOOL flag = true;
                for(FIRDataSnapshot* snap in snapshot.children){
                    // NSLog(@">%@", snapshot.key);
                    // NSLog(@">%@", snap.key);
                    // NSLog(@">%@", snap.value);
                    if ([snap.key isEqualToString:@"token"]) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: refreshedToken};
                        [ref updateChildValues:childUpdates];
                        
                        
                        flag = false;
                        
                        break;
                    }
                }
                
                /*
                 กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                 */
                if (flag) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/token/", child]: refreshedToken};
                    [ref updateChildValues:childUpdates];
                }
            }];
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

- (void)observeEventType /* : (NSArray *)values*/{
    
    if (childObserver_Friends != nil) {
        for (FIRDatabaseReference *ref in childObserver_Friends) {
            [ref removeAllObservers];
        }
    }
    
    // Observers
    childObserver_Friends = [[NSMutableArray alloc] init];
    NSString *child = [NSString stringWithFormat:@"%@%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
    
    [[[ref child:child] child:@"friends"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        /*
         FriendProfileRepo *friendPRepo = [[FriendProfileRepo alloc] init];
         
         if (![friendPRepo check:parent]) {
         FriendProfile *friendProfile = [[FriendProfile alloc] init];
         friendProfile.friend_id = parent;
         
         NSError * err;
         NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:snapshot.value options:0 error:&err];
         friendProfile.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
         
         BOOL sv = [friendPRepo insert:friendProfile];
         
         NSLog(@"");
         }
         */
        
        FriendProfileRepo *friendPRepo = [[FriendProfileRepo alloc] init];
        
        if ([friendPRepo get:snapshot.key] == nil){
            NSString *fchild = [NSString stringWithFormat:@"%@%@/profiles", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], snapshot.key];
            
            // การดึง ข้อมูล profile friend มาครั้งแรก
            [[ref child:fchild] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snap) {
                
                NSString* parent = snap.ref.parent.key;
                NSLog(@"%@, %@, %@", parent, snap.key, snap.value);
                
                // [[Configs sharedInstance] saveData:parent :snapshot.value];
                
                FriendProfileRepo *friendPRepo = [[FriendProfileRepo alloc] init];
                
                FriendProfile *friendProfile = [[FriendProfile alloc] init];
                friendProfile.friend_id = parent;
                
                NSError * err;
                NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:snap.value options:0 error:&err];
                friendProfile.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                
                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                friendProfile.create    = [timeStampObj stringValue];
                friendProfile.update    = [timeStampObj stringValue];
                
                BOOL sv = [friendPRepo insert:friendProfile];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
            }];
            
//            //  กรณี friend_id มีการ change data เช่น online, offline
//            [[ref child:fchild] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//
//                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
//
//                // จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
//                NSString* parent = snapshot.ref.parent.key;
//
//                [childObserver_Friends addObject:[ref child:child]];
//                [self friendUpdateData:snapshot];
//
//            }];
        }
        
        
        
        NSDictionary *item = snapshot.value;
        /*
         เราจะ tage เฉพาะ profile friend เท่านั้น
         */
        NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], snapshot.key];
        
        
        [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            [self friendUpdateData:snapshot];
            NSLog(@"");
        }];
        
        //  กรณี friend_id มีการ change data เช่น online, offline
        [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            // จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
            NSString* parent = snapshot.ref.parent.key;
            
            
            [childObserver_Friends addObject:[ref child:child]];
            [self friendUpdateData:snapshot];
            
        }];
        
    
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
                
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                
                /*
                 ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
                 */
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }];
    
    /*
     กรณีมีการ ลบเพือน
     */
    [[[ref child:child] child:@"friends"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
        
        /* Update friend ของ friends */
        NSMutableDictionary *newFriends = [[NSMutableDictionary alloc] init];
        [newFriends addEntriesFromDictionary:friends];
        [newFriends removeObjectForKey:snapshot.key];
        
        /* Update friends ของ DATA */
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
        [newDict removeObjectForKey:@"friends"];
        [newDict setObject:newFriends forKey:@"friends"];
        [[Configs sharedInstance] saveData:_DATA :newDict];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
    }];
    
    
    // my_applications
    [[[ref child:child] child:@"my_applications"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@ -> %@", snapshot.key, snapshot.value, snapshot.ref);
        
        MyApplicationsRepo *myAppRepo = [[MyApplicationsRepo alloc] init];
        if([myAppRepo get:snapshot.key]== nil){
            MyApplications *myApp = [[MyApplications alloc] init];
            myApp.app_id = snapshot.key;
            
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:snapshot.value options:0 error:&err];
            myApp.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            myApp.create    = [timeStampObj stringValue];
            myApp.update    = [timeStampObj stringValue];
            
            BOOL sv = [myAppRepo insert:myApp];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_iDNA_reloadData" object:self userInfo:@{}];
        }
    }];
    [[[ref child:child] child:@"my_applications"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        MyApplicationsRepo *myAppRepo = [[MyApplicationsRepo alloc] init];
        
        MyApplications *myApp = [[MyApplications alloc] init];
        myApp.app_id = snapshot.key;
        
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:snapshot.value options:0 error:&err];
        myApp.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        BOOL sv = [myAppRepo update:myApp];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_iDNA_reloadData" object:self userInfo:@{}];
    }];
    
    [[[ref child:child] child:@"my_applications"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        MyApplicationsRepo *myAppRepo = [[MyApplicationsRepo alloc] init];
        [myAppRepo deleteMyApplication:snapshot.key];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_iDNA_reloadData" object:self userInfo:@{}];
    }];
    
    
    /*
     กรณี friend_id มีการ change data เช่น online, offline
     */
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
//        NSLog(@"");
        /*
         จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
         */
//        NSString* parent = snapshot.ref.parent.key;
//        
//        // update profile friend
//        [[self friendsProfile] setObject:snapshot.value forKey:parent];
//        
//        [childObserver_Friends addObject:[ref child:child]];

        if ([snapshot.key isEqualToString:@"profiles"] || [snapshot.key isEqualToString:@"friends"]) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //load your data here.
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update UI in main thread.
                    
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
                    [newDict removeObjectForKey:snapshot.key];
                    
                    [newDict setObject:snapshot.value forKey:snapshot.key];
                    
                    [[Configs sharedInstance] saveData:_DATA :newDict];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
                    
                });
            });
            
        }else if([snapshot.key isEqualToString:@"invite_group"]){
            
            NSDictionary *invite_group = snapshot.value;
            
            for (NSString* id_invite_group in invite_group) {
                NSDictionary* value = [invite_group objectForKey:id_invite_group];
                NSString*owner_id = [value objectForKey:@"owner_id"];
                
                
                __block NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], owner_id, id_invite_group];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    
                    [childObserver_Friends addObject:[ref child:child]];
                    
                    NSLog(@"%@", snapshot.key);
                    NSLog(@"%@", snapshot.value);
                    NSLog(@"");
                
                    if (![snapshot.value isEqual:[NSNull null]]){
                        NSMutableDictionary *value = snapshot.value;
                        NSMutableDictionary *members = [[value objectForKey:@"members"] mutableCopy];
                        
                        NSMutableDictionary *newMembers = [[NSMutableDictionary alloc] init];
                        for (NSString* key in members) {
                            id _val = [members objectForKey:key];
                            // do stuff
                            
                            if([[_val objectForKey:@"status"] isEqualToString:@"pedding"]){
                                
                            }else{
                                [newMembers setObject:_val forKey:key];
                            }
                        }
                        
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:value];
                        [newDict removeObjectForKey:@"members"];
                        
                        [newDict setObject:newMembers forKey:@"members"];
                        
                        NSLog(@"");
                        // เป็นการเก้บข้อมูล ชื่อกลุ่ม, image_url ของกลุ่มที่ invite มาเราจะเก็บแบบชั่วคราวเท่านั้น
                        [[Configs sharedInstance] saveData:snapshot.key :snapshot.value];
                    }
                }];
                
                // do stuff
                NSLog(@"");
            }
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        }else if([snapshot.key isEqualToString:@"groups"]){
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            for (NSString* _id in snapshot.value) {
                NSDictionary* item = [snapshot.value objectForKey:_id];
                
                NSString *chat_id = [item objectForKey:@"chat_id"];
                
                NSString *multi_chat_message = [NSString stringWithFormat:@"toonchat_message/%@/", chat_id];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        }else if([snapshot.key isEqualToString:@"multi_chat"]){
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            for (NSString* _id in snapshot.value) {
                NSDictionary* item = [snapshot.value objectForKey:_id];
                
                NSString *chat_id = [item objectForKey:@"chat_id"];
                
                NSString *multi_chat_message = [NSString stringWithFormat:@"toonchat_message/%@/", chat_id];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        }
    }];
    
    
    // <---- Tag Groups
    [[[ref child:child] child:@"groups"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        // GroupChatRepo
        
        GroupChatRepo *groupChatRepo = [[GroupChatRepo alloc] init];
        if ([groupChatRepo get:snapshot.key] == nil){
            
            GroupChat *groupChat = [[GroupChat alloc] init];
            groupChat.group_id = snapshot.key;
            
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:snapshot.value options:0 error:&err];
            groupChat.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            groupChat.create    = [timeStampObj stringValue];
            groupChat.update    = [timeStampObj stringValue];
            
            BOOL sv = [groupChatRepo insert:groupChat];
            
        }else{
            GroupChat *groupChat = [[GroupChat alloc] init];
            groupChat.group_id = snapshot.key;
            
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:snapshot.value options:0 error:&err];
            groupChat.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            groupChat.create    = [timeStampObj stringValue];
            groupChat.update    = [timeStampObj stringValue];
            
            BOOL sv = [groupChatRepo update:groupChat];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
    }];
    
    [[[ref child:child] child:@"groups"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        GroupChatRepo *groupChatRepo = [[GroupChatRepo alloc] init];
        GroupChat *groupChat = [[GroupChat alloc] init];
        groupChat.group_id = snapshot.key;
        
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:snapshot.value options:0 error:&err];
        groupChat.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        groupChat.create    = [timeStampObj stringValue];
        groupChat.update    = [timeStampObj stringValue];
        
        BOOL sv = [groupChatRepo update:groupChat];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
    }];
    
    [[[ref child:child] child:@"groups"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        GroupChatRepo *groupChatRepo = [[GroupChatRepo alloc] init];
        
        if ([groupChatRepo get:snapshot.key] != nil) {
            [groupChatRepo deleteGroup:snapshot.key];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        }
    }];
    // ----> Tag Groups
    
    NSMutableDictionary *groups = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"groups"];
    for (NSString* key in groups) {
        NSDictionary *item = [groups objectForKey:key];
        
        NSLog(@"");
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        //        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        //
        //            [childObserver_Friends addObject:[ref child:child_cmessage]];
        //        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
               
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                
                /*
                 ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
                 */
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }
    
    NSMutableDictionary *multi_chat = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"multi_chat"];
    for (NSString* key in multi_chat) {
        NSDictionary *item = [multi_chat objectForKey:key];
        
        NSLog(@"");
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        //        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        //
        //            [childObserver_Friends addObject:[ref child:child_cmessage]];
        //        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            /*
             @property (nonatomic, strong) NSString *chat_id;
             @property (nonatomic, strong) NSString *object_id;
             @property (nonatomic, strong) NSString *text;
             @property (nonatomic, strong) NSString *type;
             
             @property (nonatomic, strong) NSString *sender_id;
             @property (nonatomic, strong) NSString *receive_id;
             
             @property (nonatomic, strong) NSString *status;
             @property (nonatomic, strong) NSString *create;
             @property (nonatomic, strong) NSString *update;
             */
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
                /*
                 "chat_id" = r1ibtvtq9LJpOzoOkmpy;
                 create = 1506680186063;
                 "object_id" = "-KvC7lffIPOBZ574Y8yQ";
                 "receive_id" = 1028;
                 "sender_id" = 1023;
                 status = send;
                 text = Err;
                 type = private;
                 update = 1506680186063;
                 */
                
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                
                /*
                 ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
                 */
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }
}

-(void)friendUpdateData:(FIRDataSnapshot *) snapshot{
    
    if([snapshot.key isEqualToString:@"image_url"] || [snapshot.key isEqualToString:@"mail"] || [snapshot.key isEqualToString:@"name"] || [snapshot.key isEqualToString:@"online"] || [snapshot.key isEqualToString:@"platform"] || [snapshot.key isEqualToString:@"status_message"] || [snapshot.key isEqualToString:@"udid"] || [snapshot.key isEqualToString:@"version"]){
     
        NSLog(@"%@, %@, %@",snapshot.ref.parent.parent.key,snapshot.key, snapshot.value);
        FriendProfileRepo *friendPRepo = [[FriendProfileRepo alloc] init];
        FriendProfile *friendProfile = [[FriendProfile alloc] init];
        
        NSString* parent = snapshot.ref.parent.parent.key;
        
        NSArray *fprofile = [friendPRepo get:parent];
        NSData *data =  [[fprofile objectAtIndex:[friendPRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data == nil) {
            return;
        }
        NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if([[f objectForKey:snapshot.key] isEqualToString:snapshot.value]){
            return;
        }
        
        //*** update field ที่มีการ update
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
        [newDict removeObjectForKey:snapshot.key];
        [newDict setObject:snapshot.value forKey:snapshot.key];
        //****
        
        friendProfile.friend_id = parent;
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newDict options:0 error:&err];
        friendProfile.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        friendProfile.create    = [timeStampObj stringValue];
        friendProfile.update    = [timeStampObj stringValue];
        
        BOOL sv = [friendPRepo update:friendProfile];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
    }
}

@end
