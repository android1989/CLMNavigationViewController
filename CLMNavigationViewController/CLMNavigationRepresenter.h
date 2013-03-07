//
//  CLMNavigationRepresenter.h
//  CLMNavigationViewController
//
//  Created by Andrew Hulsizer on 3/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLMNavigationItem;
@protocol CLMNavigationRepresenterDelegate;

@interface CLMNavigationRepresenter : UIView

@property (nonatomic, assign) id<CLMNavigationRepresenterDelegate> delegate;
// Pushing a navigation item displays the item's title in the center of the navigation bar.
// The previous top navigation item (if it exists) is displayed as a "back" button on the left.
- (void)pushNavigationItem:(CLMNavigationItem *)item animated:(BOOL)animated;
- (CLMNavigationItem *)popNavigationItemAnimated:(BOOL)animated; // Returns the item that was popped.
@end


@protocol CLMNavigationRepresenterDelegate <NSObject>

@optional

- (BOOL)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter shouldPushItem:(CLMNavigationItem *)item; // called to push. return NO not to.
- (void)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter didPushItem:(CLMNavigationItem *)item;    // called at end of animation of push or immediately if not animated
- (BOOL)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter shouldPopItem:(CLMNavigationItem *)item;  // same as push methods
- (void)navigationBar:(CLMNavigationRepresenter *)navigationRepresenter didPopItem:(CLMNavigationItem *)item;

@end


@interface CLMNavigationItem : NSObject

@end