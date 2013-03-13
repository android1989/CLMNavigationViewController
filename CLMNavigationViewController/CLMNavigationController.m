//
//  CLMNavigationController.m
//  CLMNavigationViewController
//
//  Created by Andrew Hulsizer on 3/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMNavigationController.h"



@interface CLMNavigationController () <CLMNavigationRepresenterDelegate>
{
    struct {
        unsigned didShowViewController : 1;
        unsigned willShowViewController : 1;
    } _delegateHas;
}

@property (nonatomic, strong) NSMutableArray *navigationStack;

@property (nonatomic, strong) UIViewController *visibleViewController;

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

- (void)setDelegate:(id<CLMNavigationControllerDelegate>)newDelegate
{
    _delegate = newDelegate;
    _delegateHas.didShowViewController = [_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)];
    _delegateHas.willShowViewController = [_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)];
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
    assert(![self.navigationStack containsObject:viewController]);
    
    [self.navigationStack addObject:viewController];
    [self.view insertSubview:viewController.view belowSubview:self.representer];
    
    [self.representer pushNavigationItem:viewController.navigationItem animated:animated];
    [viewController willMoveToParentViewController:self];
    
    [_visibleViewController viewWillDisappear:YES];
    [viewController viewWillAppear:YES];
    
    if (_delegateHas.willShowViewController) {
        [_delegate navigationController:self willShowViewController:viewController animated:YES];
    }
    
    if (animated && self.pushAnimation)
    {
        self.pushAnimation(self.navigationStack);
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //quit if trying to pop the root
    if ([self.navigationStack count] <= 1)
    {
        return nil;
    }
    
    UIViewController *lastObject = [self.navigationStack lastObject];
    
    //cut the cycle
    [self.representer setDelegate:nil];
    [self.representer popNavigationItemAnimated:animated];
    [self.representer setDelegate:self];
    
    if (animated && self.popAnimation)
    {
        [lastObject willMoveToParentViewController:nil];
        [lastObject didMoveToParentViewController:nil];
        [self.navigationStack removeLastObject];
        
        UIViewController *newTopController = [self.navigationStack lastObject];
        
        [_visibleViewController viewWillDisappear:YES];
        [newTopController viewWillAppear:YES];
        
        if (_delegateHas.willShowViewController) {
            [_delegate navigationController:self willShowViewController:newTopController animated:YES];
        }

        self.popAnimation(self.navigationStack, lastObject);
        
    }else{
       
        [lastObject willMoveToParentViewController:nil];
        [lastObject.view removeFromSuperview];
        [lastObject didMoveToParentViewController:nil];
        [self.navigationStack removeLastObject];
        
        UIViewController *newTopController = [self.navigationStack lastObject];
        
        [_visibleViewController viewWillDisappear:YES];
        [newTopController viewWillAppear:YES];
        
        if (_delegateHas.willShowViewController) {
            [_delegate navigationController:self willShowViewController:newTopController animated:YES];
        }

    }

        
    return lastObject;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *poppedViewControllers = [[NSMutableArray alloc] init];
        
    if ([self.navigationStack containsObject:viewController])
    {
        while (self.topViewController != viewController)
        {
            UIViewController *poppedViewController = [self popViewControllerAnimated:animated];
            if (poppedViewController) {
                [poppedViewControllers addObject:poppedViewController];
            }
        }
    }
    
    return poppedViewControllers;
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

- (UIViewController*)topViewController
{
    return [self.navigationStack lastObject];
}

#pragma mark - Navigation Representer

- (BOOL)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter shouldPopItem:(CLMNavigationItem *)item
{
    [self popViewControllerAnimated:YES];
    return NO;
}

- (void)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter didPopItem:(CLMNavigationItem *)item
{

}

- (void)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter didPushItem:(CLMNavigationItem *)item
{
    
}
@end
