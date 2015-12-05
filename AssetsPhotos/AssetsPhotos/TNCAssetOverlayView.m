//
//  TNNPHAssetCollectionOverlayView.m
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNCAssetOverlayView.h"
#import "TNCAssetCheckMarkView.h"
#import <QuartzCore/QuartzCore.h>

@interface TNCAssetOverlayView ()

@property (nonatomic, strong) TNCAssetCheckMarkView *checkmarkView;

@end
@implementation TNCAssetOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        
        // 创建选中层
        TNCAssetCheckMarkView *checkmarkView = [[TNCAssetCheckMarkView alloc] initWithFrame:CGRectMake(self.bounds.size.width - (4.0 + 24.0), self.bounds.size.height - (4.0 + 24.0), 24.0, 24.0)];
        checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        checkmarkView.layer.shadowColor = [[UIColor grayColor] CGColor];
        checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        checkmarkView.layer.shadowOpacity = 0.6;
        checkmarkView.layer.shadowRadius = 2.0;
        
        [self addSubview:checkmarkView];
        self.checkmarkView = checkmarkView;
    }
    
    return self;
}

@end
