//
//  CellForSudyList.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 3/25/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface CellForSudyList : PFTableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *studyTitle;
@property (weak, nonatomic) IBOutlet UILabel *studyContext;


@end
