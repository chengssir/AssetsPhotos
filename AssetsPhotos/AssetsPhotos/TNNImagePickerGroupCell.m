//
//  TNNImagePickerGroupCell.m
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNNImagePickerGroupCell.h"
//#import "UIView+TNNAdditions.h"
//#import "TNNImagePickerThumbnailView.h"

@interface TNNImagePickerGroupCell ()
//@property (nonatomic, strong) UIImageView *ceellImageView;
//@property (nonatomic, strong) TNNImagePickerThumbnailView *thumbnailView;


@end

@implementation TNNImagePickerGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(16, 7, 68, 72);
        [self.contentView addSubview:view];
        
        self.imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, 60, 60)];
        [view addSubview:self.imageView3];
        
        self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 64, 64)];
        [view addSubview:self.imageView2];
        
        self.imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 68, 68)];
        [view addSubview:self.imageView1];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(102, 22, 220, 21)];
        self.countLabel.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:self.titleLabel];

        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(102, 46, 220, 21)];
        self.countLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.countLabel];
  
      }
    
    return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    self.imageView1.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView1.layer.borderWidth = borderWidth;
    
    self.imageView2.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView2.layer.borderWidth = borderWidth;
    
    self.imageView3.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView3.layer.borderWidth = borderWidth;
}


@end
