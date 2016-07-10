//
//  CapsuleString.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/24/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapsuleString : UIView

@property BOOL isSelected;
@property (nonatomic) NSString *stringForSelection;

-(id)initWithTextInput:(NSString *)aString andReceivingView:(UIView *)aView;
-(void)changeApperanceWhenSelected;


@end
