//
//  HelperFunctions.h
//  CLMNavigationViewController
//
//  Created by Andrew Hulsizer on 3/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#ifndef CLMNavigationViewController_HelperFunctions_h
#define CLMNavigationViewController_HelperFunctions_h

UIColor* randomColor()
{
    rand();
    return [[UIColor alloc] initWithRed:(rand()%255)/255.0f green:(rand()%255)/255.0f blue:(rand()%255)/255.0f alpha:1];
}


#endif
