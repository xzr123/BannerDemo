//
//  YXFindBannerLayout.m
//  NeteaseYanxuan
//
//  Created by 肖峥荣 on 2017/11/2.
//  Copyright © 2017年 肖峥荣. All rights reserved.
//

#import "YXBannerLayout.h"

@interface YXBannerLayout ()

// 每一个cell对应的布局信息的数组
@property (nonatomic, strong) NSMutableArray *attributesArray;
// 用于保存collectionView的contentsize的宽度
@property (nonatomic, assign) CGFloat contentWidth;

@end

@implementation YXBannerLayout

- (instancetype)init {
    if (self = [super init]) {
        _itemSpace = 0;
        _currentIndex = 0;
        self.attributesArray = [NSMutableArray new];
    }
    return self;
}

- (void)prepareLayout {
    //别忘记先调用super方法
    [super prepareLayout];
    //获取section为0时cell的个数，这里只考虑一个section的情况
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //清除历史布局数据，attributesArray已在init中初始化
    [self.attributesArray removeAllObjects];
    
    _contentWidth = 0;
    //为每一个item创建一个attributes并存入数组
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(_contentWidth + self.sectionInset.right, self.collectionView.frame.size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //根据当前的index计算item起始点的x,y值
    CGFloat itemX = self.sectionInset.left + (self.itemSpace + _itemSize.width) * indexPath.row;
    CGFloat itemY = self.sectionInset.top;
    
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, _itemSize.width, _itemSize.height);
    //保存contentsize的width，方便collectionViewContentSize返回
    _contentWidth = itemX + _itemSize.width + self.itemSpace;
    
    return attributes;
}

//返回rect范围内item的attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 计算停留的中心点
    CGFloat centerX = self.collectionView.contentOffset.x + self.sectionInset.left + self.itemSize.width*0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    NSInteger minIndex = 0;
    NSInteger index = 0;
    
    //遍历所有item的布局信息，计算和centerX的差值大小，并保存距离最近的item的index
    for (UICollectionViewLayoutAttributes *attrs in _attributesArray) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        // 根据item边缘与中心点的距离来计算缩放比例，距离中心点越近，展示比例越大，可以手动画一个坐标轴帮助理解缩放关系
        CGFloat scale = 1 - (delta-self.itemSize.width*0.5)*0.15 / self.itemSize.width;
        //限制最小缩放比例与最大比例
        scale = (scale>0.88) ?scale : 0.88;
        scale = (scale>1) ?1 :scale;
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        //计算最靠近中心点的item的index
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
            minIndex = index;
        }
        index ++;
    }
    
    //假如最靠近中心点的item前面还有item，则需要对前面一个item进行向右平移，使之与中间item有重合
    if (minIndex>=1) {
        UICollectionViewLayoutAttributes *preAttr = _attributesArray[minIndex-1];
        CGFloat delta = ABS(preAttr.center.x - centerX);
        //进行向右平移
        preAttr.transform = CGAffineTransformTranslate(preAttr.transform, (delta-self.itemSize.width*0.5)*0.3 , 0);
        //调整zIndex，使其处于中间item的下面
        preAttr.zIndex = -1;
    }
    return self.attributesArray;
}

//返回YES表示一旦滑动就重新计算所有布局信息
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat leftX = self.collectionView.contentOffset.x + self.sectionInset.left;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    UICollectionViewLayoutAttributes *attr = _attributesArray[_currentIndex];
    //判断需要滑到的item的index
    if (leftX > attr.frame.origin.x && _currentIndex+1 < itemCount) {
        _currentIndex += 1;
    }else if(leftX < attr.frame.origin.x && _currentIndex-1 >= 0){
        _currentIndex -= 1;
    }
    
    proposedContentOffset.x = self.collectionView.contentOffset.x;
    //设置目标位置的contentOffset
    [self.collectionView scrollRectToVisible:CGRectMake((_itemSpace + _itemSize.width) * _currentIndex, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:YES];
    
    return proposedContentOffset;
}


@end
