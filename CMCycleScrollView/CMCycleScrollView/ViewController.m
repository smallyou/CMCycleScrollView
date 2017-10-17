//
//  ViewController.m
//  CMCycleScrollView
//
//  Created by 23 on 2017/10/16.
//  Copyright © 2017年 kinglian. All rights reserved.
//

#import "ViewController.h"
#import "CMCycleScrollView.h"



@interface ViewController ()

@property(nonatomic,weak) CMCycleScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CMCycleScrollView *scrollView = [[CMCycleScrollView alloc] init];
    scrollView.callback = ^(CMCycleModel *cycleModel) {
        NSLog(@"tap %@", cycleModel.imageDesc);
    };
    scrollView.displayImageDesc = YES;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0 ; i < 6; i++) {
        CMCycleModel *model = [[CMCycleModel alloc] init];
        model.imageDesc = [NSString stringWithFormat:@"%zd", i];
        NSString *name = [NSString stringWithFormat:@"cycle_image%zd",i+1];
        UIImage *image = [UIImage imageNamed:name];
        model.placeholder = image;
        [arrayM addObject:model];
    }
    scrollView.images = arrayM;
    
    scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 200, self.view.frame.size.width, 180);
}



@end
