//
//  MainViewController.m
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"

#import "PublicrelationsThread.h"

#import "SubMainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"ประชาสัมพันธ์";

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    /*
    PublicrelationsThread *public_relations = [[PublicrelationsThread alloc] init];
    [public_relations setCompletionHandler:^(NSString *data) {
        NSLog(@"");
        // [SVProgressHUD dismiss];
        
        // [SVProgressHUD showSuccessWithStatus:@"Send Success"];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        NSLog(@"%@", jsonDict);
        
        NSLog(@"%@", [jsonDict objectForKey:@"user"][@"uid"]);
        
    }];
    
    [public_relations setErrorHandler:^(NSString *data) {
        NSLog(@"");
        // [SVProgressHUD dismiss];
        
        // [SVProgressHUD showErrorWithStatus:@"Error"];
    }];
    
    [public_relations start];
     */
    
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
    
    // SubM
    
    
    if ([segue.identifier isEqualToString:@"SubM"]) {
        
        NSIndexPath *indexPath = [self._table indexPathForSelectedRow];
        
        SubMainViewController* subM = segue.destinationViewController;
        subM._category =[NSString stringWithFormat:@"%d", indexPath.row];
        
    }
}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:9];
    UILabel *text = (UILabel *)[cell viewWithTag:10];
    
    switch (indexPath.row) {
            
        case 0:{
            img.image= [UIImage imageNamed:@"icon_page_4_1.jpg"];
            text.text = @"ข่าวประชาสัมพันธ์";
        }
            break;
            
        case 1:{
            img.image= [UIImage imageNamed:@"icon_page_4_2.jpg"];
            text.text = @"ประกาศจัดซื้อจัดจ้าง";
            
        }
            break;
            
        case 2:{
            img.image= [UIImage imageNamed:@"icon_page_4_3.jpg"];
            text.text = @"ประกาศรับสมัครงาน"; // ประกาศรับสมัครงาน
        }
            break;
            
        case 3:{
            img.image= [UIImage imageNamed:@"icon_page_4_4.jpg"];
            text.text = @"ประกาศจดหมายผู้ปกครอง";
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
