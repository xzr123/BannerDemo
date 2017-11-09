//
//  YXFindBannerCell.m
//  NeteaseYanxuan
//
//  Created by 肖峥荣 on 2017/11/2.
//  Copyright © 2017年 肖峥荣. All rights reserved.
//

#import "YXBannerCell.h"

@interface YXBannerCell ()

@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation YXBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4.0f;
        self.clipsToBounds = YES;
        
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    self.clipsToBounds = YES;
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
}

- (void)setImg:(UIImage *)img {
    _img = img;
    if (_img) {
        _imageView.image = _img;
    }
}

- (void)layoutSubviews {
    _imageView.frame = self.bounds;
}

@end
