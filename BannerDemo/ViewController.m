//
//  ViewController.m
//  BannerDemo
//
//  Created by 肖峥荣 on 2017/11/2.
//  Copyright © 2017年 肖峥荣. All rights reserved.
//

#import "ViewController.h"
#import "YXBannerView.h"

@interface ViewController ()

@property (nonatomic, strong) YXBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    
    _bannerView = [[YXBannerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, YXBannerViewHeight)];
    [self.view addSubview:_bannerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger i=1; i<9; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%ld",(long)i];
        UIImage *img = [UIImage imageNamed:imgName];
        [array addObject:img];
    }
    
    _bannerView.imageList = [array copy];
}

@end
