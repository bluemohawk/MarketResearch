//
//  ItemForSelection.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 1/16/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ItemForSelection.h"

@implementation ItemForSelection


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    NSLog(@"called");
    
    CAShapeLayer *aLayer = [CAShapeLayer new];
    aLayer.bounds = self.frame;
    
    UIBezierPath* roundShape = [UIBezierPath bezierPathWithOvalInRect:self.frame];
    UIColor* color0 = [UIColor clearColor];
    UIColor* color1 = [UIColor blueColor];
    [color0 setFill];
    [roundShape fill];
    [color1 setStroke];
    roundShape.lineWidth = 1.53;
    [roundShape stroke];
    
    
    aLayer.path = roundShape.CGPath;
    [self.layer addSublayer:aLayer];

}


@end
