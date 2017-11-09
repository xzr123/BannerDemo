//
//  YXFindBannerLayout.h
//  NeteaseYanxuan
//
//  Created by 肖峥荣 on 2017/11/2.
//  Copyright © 2017年 肖峥荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBannerLayout : UICollectionViewLayout

//同一行两个item之间的距离
@property (nonatomic, assign) NSInteger itemSpace;
//collectionView的section内容与collectionView边缘的间距(上，下，左，右)
@property (nonatomic, assign) UIEdgeInsets sectionInset;
//每一个Item的长宽
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) NSInteger currentIndex;

@end
