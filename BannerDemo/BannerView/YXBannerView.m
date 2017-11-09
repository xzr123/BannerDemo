//
//  YXFindBannerView.m
//  NeteaseYanxuan
//
//  Created by 肖峥荣 on 2017/11/2.
//  Copyright © 2017年 肖峥荣. All rights reserved.
//

#import "YXBannerView.h"
#import "YXBannerLayout.h"
#import "YXBannerCell.h"

@interface YXBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) YXBannerLayout *layout;

@end

@implementation YXBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadCollectionView];
    }
    return self;
}

- (void)loadCollectionView {
    _layout = [YXBannerLayout new];
    _layout.itemSize = CGSizeMake(YXBannerImgWidth, YXBannerImgWidth/1.8);;
    _layout.itemSpace = 0.0f;
    _layout.sectionInset = UIEdgeInsetsMake(12, 15, 16, 32);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YXBannerCell class]
        forCellWithReuseIdentifier:NSStringFromClass(YXBannerCell.class)];
    
    [self addSubview:_collectionView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _collectionView.frame = self.bounds;
}

- (void)setImageList:(NSArray<UIImage *> *)imageList {
    _imageList = imageList;
    if (_imageList){
        [self.collectionView reloadData];
        
        [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:NO];
    }
}

# pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YXBannerCell.class) forIndexPath:indexPath];
    cell.img = _imageList[indexPath.row];
    return cell;
}

# pragma mark - CollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked at index:%ld",(long)indexPath.row);
}

# pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 获取当前可见的items列表
    NSArray<UICollectionViewCell *> *cells = [self.collectionView visibleCells];
    if (!cells || cells.count==0) {
        return;
    }
    CGFloat centerX = self.collectionView.contentOffset.x + _layout.sectionInset.left + _layout.itemSize.width*0.5;
    
    NSInteger index = 0;
    CGFloat minDelta = MAXFLOAT;
    //获取距离中心点最近的Item的index
    for (NSInteger i=0; i<cells.count ; i++) {
        UICollectionViewCell *cell = cells[i];
        if (minDelta > ABS(cell.center.x - centerX)) {
            minDelta = ABS(cell.center.x - centerX);
            index = i;
        }
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cells[index]];
    _layout.currentIndex = indexPath.row;
}

@end
