//
//  ManageClass.m
//  Heart
//
//  Created by Somkid on 1/31/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ManageClass.h"

@interface ManageClass ()
{
    NSMutableArray* _list;
}
@end

@implementation ManageClass
@synthesize _table;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _list = [[NSMutableArray alloc]initWithObjects:@"Family", @"Favorite", @"Friends", nil];
    
    /*
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonAction:)];
    self.navigationItem.rightBarButtonItem = editButton;
    */
    
    // self.navigationItem.rightBarButtonItem =[NSArray arrayWithObject:self.editButton];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonAction:)];
    
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusButtonAction:)];

    
    self.navigationItem.rightBarButtonItems = @[plusButton, editButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) editButtonAction:(id)sender{
    [_table setEditing:!_table.editing animated:YES];
    
    
    if (_table.editing) {
        // [self.navigationItem.rightBarButtonItem setTitle:@"Edit mode"];

        [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setTitle:@"Save"];
    } else {
        // [self.navigationItem.rightBarButtonItem setTitle:@"Tap to edit"];
         [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setTitle:@"Edit"];
    }
}

- (IBAction) plusButtonAction:(id)sender{

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
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_list count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DragCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.text = [_list objectAtIndex:indexPath.row];
    
    return  cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            return UITableViewCellAccessoryNone;
            break;
            
        default:
            break;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            return YES;
            break;
            
        default:
            break;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
    
    [self reloadData];
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    id object = [_list objectAtIndex:sourceRow];
    
    [_list removeObjectAtIndex:sourceRow];
    [_list insertObject:object atIndex:destRow];
    
}

- (void) reloadData {
    [self._table reloadData];
}
@end
