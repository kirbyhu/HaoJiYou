//
//  HJYMainViewController.m
//  HaoJiYou
//
//  Created by 小明明 on 14-6-1.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import "HJYMainViewController.h"
#import "SWRevealViewController.h"

@interface HJYMainViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButtonItem;

@end

@implementation HJYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.sideBarButtonItem setTarget:self.revealViewController];
    [self.sideBarButtonItem setAction:@selector(revealToggle:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
