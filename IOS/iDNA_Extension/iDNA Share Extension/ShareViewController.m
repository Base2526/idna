//
//  ShareViewController.m
//  iDNA Share Extension
//
//  Created by Somkid on 4/21/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ShareViewController.h"
#import "Configs.h"
#import "AddPostThread.h"

@interface ShareViewController (){

    NSString *selected;
}
@end

@implementation ShareViewController

SLComposeSheetConfigurationItem *item, *item2;
ItemViewController *vc;

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    /*
     var userDefaults = NSUserDefaults(suiteName: "group.com.company.myApp")
     if let testUserId = userDefaults?.objectForKey("userId") as? String {
     print("User Id: \(testUserId)")
     }
    */
    selected = @"0";
    
    NSString*user = [[Configs sharedInstance] getUIDU];
    
    NSLog(@"");
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    
    // self.extensionContext.
    NSArray *items = self.extensionContext.inputItems;
    
    // ข้อความที่อยู่ใน dialogbox
    NSString* contentText = self.contentText;
    if ([contentText rangeOfString:@"www.youtube.com"].location != NSNotFound) {
        NSLog(@"string contains bla!");
        //กรณีถูก share จาก youtubue
        [self saveData:[[NSURL alloc] initWithString:contentText]];
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    } else {
        NSLog(@"string does not contain bla");
        /*
         กรณี share จาก browser
         */
        NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
        NSItemProvider *itemProvider = item.attachments.firstObject;
        if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"]) {
            [itemProvider loadItemForTypeIdentifier:@"public.url"
                                            options:nil
                                  completionHandler:^(NSURL *url, NSError *error) {
                                      // Do what you want to do with url
                                      
                                      [self saveData:url];
                                      [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
                                    
                                  }];
        }
    }
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
    NSDictionary* my_applications = [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"data"]] objectForKey:@"my_applications"];
    NSArray *keys = [my_applications allKeys];
    id aKey = [keys objectAtIndex:selected.integerValue];
    id anObject = [my_applications objectForKey:aKey];
    
    item = [[SLComposeSheetConfigurationItem alloc] init];
    // Give your configuration option a title.
    [item setTitle:@"iDNA"];
    // Give it an initial value.
    [item setValue:[anObject objectForKey:@"name"]];
    // Handle what happens when a user taps your option.
    [item setTapHandler:^(void){
        // Create an instance of your configuration view controller.
        
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"MainInterface" bundle:nil];
        
        // [storybrd instantiateViewControllerWithIdentifier:@"CreateMyCardSelectEmail"];
        
        vc = [storybrd instantiateViewControllerWithIdentifier:@"ItemViewController"];//[[ItemViewController alloc] init];
        vc.selected = selected;
        
        vc.delegate = self;
        // vc.text = @"Test";
        // Transfer to your configuration view controller.
        [self pushConfigurationViewController:vc];
    }];
    // Return an array containing your item.
    
    return @[item];
}

-(void) sendingViewController:(ItemViewController *)controller sentItem:(NSString *)retItem {
    
    selected = retItem;
    
    
    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
    NSDictionary* my_applications = [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"data"]] objectForKey:@"my_applications"];
    NSArray *keys = [my_applications allKeys];
    id aKey = [keys objectAtIndex:selected.integerValue];
    id anObject = [my_applications objectForKey:aKey];
    
    // Set the configuration item's value to the returned value
    [item setValue:[anObject objectForKey:@"name"]];
    // Pop the configuration view controller to return to this one.
    [self popConfigurationViewController];
}

-(void) saveData:(NSURL *)uri{
    
    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
    NSDictionary* my_applications = [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"data"]] objectForKey:@"my_applications"];
    NSArray *keys = [my_applications allKeys];
    id aKey = [keys objectAtIndex:selected.integerValue];
    id anObject = [my_applications objectForKey:aKey];
    
    AddPostThread *apTrd = [[AddPostThread alloc] init];
    [apTrd setCompletionHandler:^(NSString *data) {
        
        NSLog(@"");
    }];
    
    [apTrd setErrorHandler:^(NSString *error) {
        // [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        NSLog(@"");
    }];
    
    [apTrd start:@"1":[anObject objectForKey:@"item_id"] :@"" :[UIImage imageNamed:@"icon_extension.png"] :[uri absoluteString] :[uri absoluteString]];
}

@end
