//
//  HJYDictSelectViewController.m
//  HaoJiYou
//
//  Created by tangliu on 14-6-13.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import "HJYDictSelectViewController.h"
#import "HJYAppDelegate.h"
#import "HJYStore.h"
#import "HJYDictSelectCell.h"
#import "HJYDict.h"

@interface HJYDictSelectViewController ()
@property (nonatomic, strong) HJYStore* store;
@end

@implementation HJYDictSelectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.store) {
        HJYAppDelegate* delegate = (HJYAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.store =  delegate.store;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger count = [self.store.dictList count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellName = @"DictSelectCell"; 
    HJYDictSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];

    //
//    // Configure the cell...
//    
    HJYDict* dict = (HJYDict*)[self.store.dictList objectAtIndex:indexPath.row];
    
    [cell.nameLabel setText:dict.name];
    
    if (dict.locked == 0) {
        cell.lockedLabel.hidden = FALSE;
        [cell.lockedLabel setText:@"已解锁"];
        
        if (dict.selected == 1) {
            [cell.unlockButton setTitle:@"已选中" forState:UIControlStateNormal];
        } else {
            [cell.unlockButton setTitle:@"选择" forState:UIControlStateNormal];
        }
    } else {
        cell.lockedLabel.hidden = TRUE;
        [cell.unlockButton setTitle:@"解锁" forState:UIControlStateNormal];
    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
