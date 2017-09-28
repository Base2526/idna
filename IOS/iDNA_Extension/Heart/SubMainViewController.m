//
//  SubMainViewController.m
//  SidebarDemo
//
//  Created by Somkid on 10/3/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import "SubMainViewController.h"
#import "MyWebViewViewController.h"
#import "Configs.h"

@interface SubMainViewController ()
{
    NSMutableArray *listItems;
}

@end

@implementation SubMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    listItems = [[NSMutableArray alloc] init];
    
    PhotoGalleryThread *photoGallery = [[PhotoGalleryThread alloc] init];
    [photoGallery setCompletionHandler:^(NSString *data) {
        NSLog(@"");
        // [SVProgressHUD dismiss];
        
        // [SVProgressHUD showSuccessWithStatus:@"Send Success"];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        // NSLog(@"%@", jsonDict);
        
        NSLog(@"result : %@", [jsonDict objectForKey:@"result"]);
        NSLog(@"data : %@", [jsonDict objectForKey:@"data"]);
        
        listItems =[jsonDict objectForKey:@"data"];
        
        [self._table reloadData];
        
        NSLog(@"");
        
    }];
    
    [photoGallery setErrorHandler:^(NSString *data) {
        NSLog(@"");
        // [SVProgressHUD dismiss];
        
        // [SVProgressHUD showErrorWithStatus:@"Error"];
    }];
    
    [photoGallery start:self._category];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"webV"]) {
        
        NSIndexPath *indexPath = [self._table indexPathForSelectedRow];
        
        MyWebViewViewController* webV = segue.destinationViewController;
       //[NSString stringWithFormat:@"%d", indexPath.row];
        
        if([self._category isEqualToString: @"0"]){
            webV.urlString = [NSString stringWithFormat:@"%@/process_picture_activity/%@", [Configs sharedInstance].API_URL, [[listItems objectAtIndex:indexPath.row] valueForKey:@"nid"]];
        }else {
             webV.urlString = [NSString stringWithFormat:@"%@/node/%@", [Configs sharedInstance].API_URL, [[listItems objectAtIndex:indexPath.row] valueForKey:@"nid"]];
        }
        
    }
}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  [listItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextView *text = (UITextView *)[cell viewWithTag:10];
    text.userInteractionEnabled = NO;
    
    [text setText:[[listItems objectAtIndex:indexPath.row] valueForKey:@"title"]];
//
//    switch (indexPath.row) {
//            
//        case 0:{
//            text.text = @"ข่าวประชาสัมพันธ์";
//        }
//            break;
//            
//        case 1:{
//            text.text = @"ประกาศจัดซื้อจัดจ้าง";
//            
//        }
//            break;
//            
//        case 2:{
//            text.text = @"ประกาศรับสมัครงาน"; // ประกาศรับสมัครงาน
//        }
//            break;
//            
//        case 3:{
//            text.text = @"ประกาศจดหมายผู้ปกครอง";
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    return cell;
}

@end
