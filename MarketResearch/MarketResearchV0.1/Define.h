//
//  Define.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 7/10/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Define : NSObject


    //#define isIphone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 480)

    //#define isIPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

    //Define

    //#define SCREEN_WIDTH (isIphone5 ? 568:480, isIPad ? 1024:1024)
    //#define SCREEN_HEIGHT (isIphone5 ? 320:320, isIPAD ? 768:768)

#define SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H [[UIScreen mainScreen] bounds].size.height



@end
