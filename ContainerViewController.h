//
//  ContainerViewController.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ParseUI/ParseUI.h>
#import "Study_Parse.h"
#import "Introduction.h"


@interface ContainerViewController : UIViewController <RecordButton_Delegate>

@property (nonatomic) Study_Parse *selectedStudy_Parse;

@end
