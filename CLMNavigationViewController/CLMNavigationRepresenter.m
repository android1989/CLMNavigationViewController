//
//  CLMNavigationRepresenter.m
//  CLMNavigationViewController
//
//  Created by Andrew Hulsizer on 3/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMNavigationRepresenter.h"
#import <QuartzCore/QuartzCore.h>
#import "HelperFunctions.h"

@interface CLMNavigationRepresenter ()
{
    struct {
        unsigned shouldPushItem : 1;
        unsigned didPushItem : 1;
        unsigned shouldPopItem : 1;
        unsigned didPopItem : 1;
    } _delegateHas;
}

@property (nonatomic, strong) NSMutableArray *navigationItems;
@property (nonatomic, assign) CGPoint startLocation;
@end

@implementation CLMNavigationRepresenter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        _navigationItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setDelegate:(id)newDelegate
{
    _delegate = newDelegate;
    _delegateHas.shouldPushItem = [_delegate respondsToSelector:@selector(navigationBar:shouldPushItem:)];
    _delegateHas.didPushItem = [_delegate respondsToSelector:@selector(navigationBar:didPushItem:)];
    _delegateHas.shouldPopItem = [_delegate respondsToSelector:@selector(navigationBar:shouldPopItem:)];
    _delegateHas.didPopItem = [_delegate respondsToSelector:@selector(navigationBar:didPopItem:)];
}

- (void)pushNavigationItem:(CLMNavigationItem *)item animated:(BOOL)animated
{
    BOOL shouldPush = YES;
    
    if (_delegateHas.shouldPushItem)
    {
        shouldPush = [_delegate navigationBar:self shouldPushItem:item];
    }
    
    if (shouldPush)
    {
        UIView *newItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [newItem setBackgroundColor:randomColor()];
        [self addSubview:newItem];
        [self.navigationItems addObject:item];
        
        if (animated)
        {
            [UIView animateWithDuration:.5 animations:^{
                [self pushNewView:newItem];
            }];
        }else{
            [self pushNewView:newItem];
        }
        
        
        if (_delegateHas.didPushItem)
        {
            [_delegate navigationBar:self didPushItem:item];
        }
    }

}

- (CLMNavigationItem *)popNavigationItemAnimated:(BOOL)animated
{
    
    CLMNavigationItem *item = [self.navigationItems lastObject];
    
    if (item)
    {
        BOOL shouldPop = YES;
        
        if (_delegateHas.shouldPopItem)
        {
            shouldPop = [_delegate navigationBar:self shouldPopItem:item];
        }
        
        if (shouldPop)
        {
            [self.navigationItems removeLastObject];
            
            if (animated)
            {
                [UIView animateWithDuration:.5 animations:^{
                    [self popView];
                }];
            }else{
                [self popView];
            }
            if (_delegateHas.didPopItem)
            {
                [self.delegate navigationBar:self didPopItem:[self.navigationItems lastObject]];
            }
        }
    }
    
    return nil;
}

- (void)pushNewView:(UIView*)view
{
    [self moveStackDown];
}

- (void)popView
{
    [self moveStackUp];
    [[self.subviews objectAtIndex:[self.subviews count]-1] removeFromSuperview];
}

- (void)moveStackUp
{
    if ([self.subviews count] >= 2)
    {
        UIView *view = [self.subviews objectAtIndex:[self.subviews count]-2];
        view.layer.transform = CATransform3DIdentity;
    }
}

- (void)moveStackDown
{
        for (UIView *subview in self.subviews) {
            if ([self.subviews lastObject] != subview) {
                
                subview.layer.transform = CATransform3DConcat(CATransform3DMakeTranslation(-15, 0, 0), CATransform3DMakeScale(.75, .75, 1));
            }
        }
}

                       //Handle Interaction with views;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if( [touch view] == [self.subviews lastObject])
    {
        UIView *view = [self.subviews lastObject];
        self.startLocation = view.center;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if( [touch view] == [self.subviews lastObject])
    {
        UIView *view = [self.subviews lastObject];
        CGPoint location = [touch locationInView:self];
        view.center = location;
        
        CGFloat distance = sqrtf(pow((location.x-self.startLocation.x),2)+pow((location.y-self.startLocation.y),2));
        if (distance > 100)
        {
            [UIView animateWithDuration:.5 animations:^{
                [self moveStackUp];
            }];
        }else{
            [UIView animateWithDuration:.5 animations:^{
                [self moveStackDown];
            }];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if( [touch view] == [self.subviews lastObject])
    {
       [UIView animateWithDuration:.5 animations:^{
           UIView *view = [self.subviews lastObject];
           CGPoint location = [touch locationInView:self];
           
           
           CGFloat distance = sqrtf(pow((location.x-self.startLocation.x),2)+pow((location.y-self.startLocation.y),2));
           if (distance > 100)
           {
               [self popNavigationItemAnimated:YES];
           }else{
               view.center = self.startLocation;
               [UIView animateWithDuration:.5 animations:^{
                   [self moveStackDown];
               }];
           }
       }];
        
    }

}

@end
