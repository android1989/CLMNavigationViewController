//
//  CLMViewController.m
//  CLMNavigationViewController
//
//  Created by Andrew Hulsizer on 3/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMViewController.h"
#import "CLMNavigationController.h"

@interface CLMViewController ()

@property (nonatomic, strong) UIViewController *controller1;
@property (nonatomic, strong) UIViewController *controller2;
@property (nonatomic, strong) UIViewController *controller3;
@property (nonatomic, strong) UIViewController *controller4;
@property (nonatomic, strong) UIViewController *controller5;
@property (nonatomic, strong) CLMNavigationController *navigationController;
@end

@implementation CLMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.controller1 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [self.controller1.view setFrame:self.view.frame];
    [self.controller1.view setBackgroundColor:[UIColor blackColor]];
    
    self.controller2 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [self.controller2.view setFrame:self.view.frame];
    [self.controller2.view setBackgroundColor:[UIColor redColor]];
    
    self.controller3 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [self.controller3.view setFrame:self.view.frame];
    [self.controller3.view setBackgroundColor:[UIColor orangeColor]];
    
    self.controller4 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [self.controller4.view setFrame:self.view.frame];
    [self.controller4.view setBackgroundColor:[UIColor purpleColor]];
    
    self.navigationController = [[CLMNavigationController alloc] initWithRootViewController:self.controller1];
    [self.navigationController.view setFrame:self.view.frame];
    
    [self.view insertSubview:self.navigationController.view atIndex:0];
    [self addChildViewController:self.navigationController];
    [self.navigationController didMoveToParentViewController:self];
    
    [self.navigationController pushViewController:self.controller2 animated:NO];
    
    
    [self.navigationController pushViewController:self.controller3 animated:NO];
    [self.navigationController pushViewController:self.controller4 animated:NO];
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender
{
    UIViewController *controller = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [controller.view setFrame:self.view.bounds];
    [controller.view setBackgroundColor:[[UIColor alloc] initWithRed:(rand()%255)/255.0f green:(rand()%255)/255.0f blue:(rand()%255)/255.0f alpha:1]];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)remove:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
