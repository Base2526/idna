//
//  AboutusViewController.m
//  SidebarDemo
//
//  Created by Somkid on 10/3/2559 BE.
//  Copyright © 2559 AppCoda. All rights reserved.
//

#import "AboutusViewController.h"

#import "SWRevealViewController.h"

@interface AboutusViewController ()

@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"เกี่ยวกับโรงเรียน";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
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
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *text = (UILabel *)[cell viewWithTag:10];
    
    switch (indexPath.row) {
            
        case 0:{
            text.text = @"ข้อมูลทั่วไป";
            
        }
            break;
            
        case 1:{
            text.text = @"ประวัติความเป็นมา";
            
        }
            break;
            
        case 2:{
            text.text = @"ปรัชญา / วิสัยทัศน์ / พันธกิจ"; // ประกาศรับสมัครงาน
        }
            break;
            
        case 3:{
            text.text = @"เกียรติภูมิสาธิตปทุมวัน";
        }
            break;
            
        case 4:{
            text.text = @"แผนที่และอาคารเรียน"; // ประกาศรับสมัครงาน
        }
            break;
            
        case 5:{
            text.text = @"คณะกรรมการบริหารโรงเรียน";
        }
            break;
        default:
            break;
    }

    
    
    return cell;
}


@end
