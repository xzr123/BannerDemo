//
//  YXFindBannerView.h
//  NeteaseYanxuan
//
//  Created by 肖峥荣 on 2017/11/2.
//  Copyright © 2017年 肖峥荣. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YXScreenWidth [UIScreen mainScreen].bounds.size.width
#define YXBannerImgWidthRatio 328/375.0
#define YXBannerImgWidth YXScreenWidth*YXBannerImgWidthRatio
#define YXBannerViewHeight (YXBannerImgWidth/1.8 + 28)

@interface YXBannerView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<UIImage *> *imageList;

@end
