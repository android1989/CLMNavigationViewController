//
//  CLMNavigationController.h
//  CLMNavigationViewController
//
//  Created by Andrew Hulsizer on 3/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMNavigationRepresenter.h"
@protocol CLMNavigationControllerDelegate;

typedef void(^CLMNavigationControllerPushAnimation)(NSArray *viewControllers);
typedef void(^CLMNavigationControllerPopAnimation)(NSArray *viewControllers, UIViewController *poppedViewController);

@interface CLMNavigationController : UIViewController

@property (nonatomic, strong) CLMNavigationRepresenter *representer;
@property (nonatomic, strong) UIViewController *rootViewController;
@property(nonatomic, assign) id<CLMNavigationControllerDelegate> delegate;
@property(nonatomic,copy) NSArray *viewControllers;
@property (nonatomic, assign) CLMNavigationControllerPushAnimation pushAnimation;
@property (nonatomic, assign) CLMNavigationControllerPopAnimation popAnimation;

- (id)initWithRootViewController:(UIViewController *)rootViewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; 
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; 
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
@end

@protocol CLMNavigationControllerDelegate <NSObject>

@optional

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(CLMNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(CLMNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@interface UIViewController (CLMNavigationControllerItem)

@property(nonatomic,readonly,retain) CLMNavigationItem *navigationItem; // Created on-demand so that a view controller may customize its navigation appearance.
@property(nonatomic) BOOL hidesBottomBarWhenPushed; // If YES, then when this view controller is pushed into a controller hierarchy with a bottom bar (like a tab bar), the bottom bar will slide out. Default is NO.
@property(nonatomic,readonly,retain) CLMNavigationController *navigationController; // If this view controller has been pushed onto a navigation controller, return it.

@end
