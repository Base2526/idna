//
//  ItemViewController.m
//  Heart
//
//  Created by Somkid on 4/22/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ItemViewController.h"
#import "HJManagedImageV.h"
#import "Configs.h"

@interface ItemViewController (){
    NSDictionary *my_applications;
}
@end

@implementation ItemViewController
@synthesize selected;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // self.view.backgroundColor = [UIColor redColor];
    
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
    
    // labelText.text = self.text;
    
   //  self.content = @[@"Monday", @"Tuesday", @"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    
    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
    my_applications = [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"data"]] objectForKey:@"my_applications"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [my_applications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    HJManagedImageV* hjmImageV = [cell viewWithTag:10];
    UILabel *labelName         = [cell viewWithTag:11];
    
    NSArray *keys = [my_applications allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [my_applications objectForKey:aKey];

    NSMutableDictionary *picture = [anObject valueForKey:@"picture"];
    
    [hjmImageV clear];
    if ([picture count] > 0 ) {
        
        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [[Configs sharedInstance] API_URL], [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [hjmImageV setUrl:[NSURL URLWithString:url]];
    }else{
        [hjmImageV setImage:[UIImage imageNamed:@"character_borring_half.png"]];
    }
    [[self obj_Manager] manage:hjmImageV ];
    
    labelName.text = [anObject objectForKey:@"name"];
    
    if (indexPath.row == selected.integerValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// [delegate sendingViewController:self sentItem:(item you want to send back)];

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate sendingViewController:self sentItem:[NSString stringWithFormat:@"%d", indexPath.row]];
}

@end
