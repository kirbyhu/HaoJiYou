//
//  HJYMainContainerController.m
//  HaoJiYou
//
//  Created by 小明明 on 14-6-9.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import "HJYMainContainerController.h"

@interface HJYMainContainerController ()

@end

@implementation HJYMainContainerController

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
    
    [self performSegueWithIdentifier:@"main_init" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"main_init"])
    {
        [self selectViewController:segue];
    }
    else if ([segue.identifier isEqualToString:@"main_start"])
    {
        [self selectViewController:segue];
    }
}

- (void)selectViewController:(UIStoryboardSegue*) segue {
    if (self.childViewControllers.count > 0) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
    }
    else {
        [self addChildViewController:segue.destinationViewController];
        ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
        [segue.destinationViewController didMoveToParentViewController:self];
    }

}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}
@end
