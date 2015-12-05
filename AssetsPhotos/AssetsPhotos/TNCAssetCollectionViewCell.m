//
//  TNNPhotosCollectionViewCell.m
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNCAssetCollectionViewCell.h"
#import "TNCAssetOverlayView.h"
@interface TNCAssetCollectionViewCell ()

@property (nonatomic, strong) TNCAssetOverlayView *overlayView;

@end

@implementation TNCAssetCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        [self getoverlayView];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.overlayView.hidden = !selected;

}

- (void)getoverlayView
{
        _overlayView = [[TNCAssetOverlayView alloc] initWithFrame:self.contentView.bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.hidden = YES;
        [self.contentView addSubview:_overlayView];
}

//#pragma mark - Accessors
//
//- (void)image:(UIImage *)image
//{
//
//    self.imageView.image = image;
//
//}
@end
