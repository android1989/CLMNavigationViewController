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

- (void)pushNavigationItem:(CLMNavigationItem *)item animated:(BOOL)animated
{
    UIView *newItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [newItem setBackgroundColor:randomColor()];
    [self addSubview:newItem];
    [self animatePushNewView:newItem];
    [self.delegate navigationBar:self didPushItem:item];
}

- (CLMNavigationItem *)popNavigationItemAnimated:(BOOL)animated
{
    CLMNavigationItem *item = [self.navigationItems lastObject];
    [self animatePopView];
    [self.navigationItems removeLastObject];
    [self.delegate navigationBar:self didPopItem:[self.navigationItems lastObject]];
    
    return item;
}

- (void)animatePushNewView:(UIView*)view
{
    [self moveStackDown];
}

- (void)animatePopView
{
    
    [self moveStackUp];
    [[self.subviews objectAtIndex:[self.subviews count]-1] removeFromSuperview];
}

- (void)moveStackUp
{
    [UIView animateWithDuration:.5 animations:^{
        if ([self.subviews count] >= 2)
        {
            UIView *view = [self.subviews objectAtIndex:[self.subviews count]-2];
            view.layer.transform = CATransform3DIdentity;
        }
    }];
}

- (void)moveStackDown
{
    [UIView animateWithDuration:.5 animations:^{
        for (UIView *subview in self.subviews) {
            if ([self.subviews lastObject] != subview) {
                
                subview.layer.transform = CATransform3DConcat(CATransform3DMakeTranslation(-15, 0, 0), CATransform3DMakeScale(.75, .75, 1));
            }
        }
    }];

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
            [self moveStackUp];
        }else{
            [self moveStackDown];
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
               [self popNavigationItemAnimated:NO];
           }else{
               view.center = self.startLocation;
               [self moveStackDown];
           }
       }];
        
    }

}

@end
