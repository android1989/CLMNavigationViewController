//
//  CLMNavigationController.m
//  CLMNavigationViewController
//
//  Created by Andrew Hulsizer on 3/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMNavigationController.h"

@interface CLMNavigationController () <CLMNavigationRepresenterDelegate>

@property (nonatomic, strong) NSMutableArray *navigationStack;

@end

@implementation CLMNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _representer = [[CLMNavigationRepresenter alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        [_representer setBackgroundColor:[UIColor clearColor]];
        _representer.delegate = self;
        _rootViewController = rootViewController;
        _navigationStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _representer = [[CLMNavigationRepresenter alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        [_representer setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addSubview:self.rootViewController.view];
    [self.view addSubview:self.representer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.representer pushNavigationItem:viewController.navigationItem animated:animated];
    [self.navigationStack addObject:viewController];
    [self.view insertSubview:viewController.view belowSubview:self.representer];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.representer popNavigationItemAnimated:animated];
    return [self.navigationStack lastObject];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *view = [self.navigationStack lastObject];
    while (view != viewController)
    {
        view = [self popViewControllerAnimated:animated];
    }
    
    return self.navigationStack;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self popToViewController:self.rootViewController animated:animated];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [self popToRootViewControllerAnimated:animated];
    
    for (UIViewController *controller in viewControllers)
    {
        [self pushViewController:controller animated:animated];
    }
}

#pragma mark - Navigation Representer
- (void)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter didPopItem:(CLMNavigationItem *)item
{
    UIViewController *lastObject = [self.navigationStack lastObject];
    [lastObject.view removeFromSuperview];
    [self.navigationStack removeLastObject];
}

- (void)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter didPushItem:(CLMNavigationItem *)item
{
    
}
@end
