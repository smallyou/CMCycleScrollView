//
//  CMCycleScrollView.m
//  CMCycleScrollView
//
//  Created by 23 on 2017/10/16.
//  Copyright © 2017年 kinglian. All rights reserved.
//

#import "CMCycleScrollView.h"


@interface CMCycleScrollView() <UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UIPageControl *pageControl;

@property(nonatomic,weak) CMCycleCell *leftView;

@property(nonatomic,weak) CMCycleCell *middleView;

@property(nonatomic,weak) CMCycleCell *rightView;

@property(nonatomic,assign) NSUInteger currentPage;

@property(nonatomic,weak) NSTimer *timer;



@end

@implementation CMCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置UI
        [self setupUI];
    }
    return self;
}
- (void)dealloc
{
    [self.timer invalidate];
}

#pragma mark - 设置UI
/**设置UI*/
- (void)setupUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    CMCycleCell *leftView = [[CMCycleCell alloc] init];
    [self.scrollView addSubview:leftView];
    self.leftView = leftView;
    
    CMCycleCell *middleView = [[CMCycleCell alloc] init];
    [self.scrollView addSubview:middleView];
    self.middleView = middleView;
    
    CMCycleCell *rightView = [[CMCycleCell alloc] init];
    [self.scrollView addSubview:rightView];
    self.rightView = rightView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 0;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    pageControl.hidesForSinglePage = !self.displayPageControlForSinglePage;
    [self addSubview:pageControl];
    self.pageControl = pageControl;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.leftView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.middleView.frame = CGRectMake(CGRectGetMaxX(self.leftView.frame), 0, self.frame.size.width, self.frame.size.height);
    self.rightView.frame = CGRectMake(CGRectGetMaxX(self.middleView.frame), 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);

    [self.pageControl sizeToFit];
    self.pageControl.center = CGPointMake(self.center.x, self.bounds.size.height - 10);
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前的滚动index
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    
    //计算当前应该显示的index
    if (index == 2) {
        self.currentPage = ((self.currentPage + 1) + self.images.count )% self.images.count;
    }else if (index == 0){
        self.currentPage = ((self.currentPage - 1) + self.images.count) % self.images.count;
    }
    
    //切换内容
    [self changeContentAtIndex:self.currentPage];
    
    //更新pageControl
    self.pageControl.currentPage = self.currentPage;
    
    //滚动到中间位置
    [self.scrollView setContentOffset: CGPointMake(self.frame.size.width, 0)];
}

#pragma mark - 方法
/**切换内容*/
- (void)changeContentAtIndex:(NSInteger )index
{
    //取出模型
    CMCycleModel *leftModel, *middleModel, *rightModel;
    NSInteger leftIndex, rightIndex;
    leftIndex   = index - 1;
    rightIndex  = index + 1;
    if (leftIndex == -1) {
        leftIndex = self.images.count - 1;
    }
    if (rightIndex == self.images.count) {
        rightIndex = 0;
    }
    middleModel = self.images[index];
    leftModel   = self.images[leftIndex];
    rightModel  = self.images[rightIndex];
    
    //修改内容
    self.leftView.model = leftModel;
    self.middleView.model = middleModel;
    self.rightView.model = rightModel;
}
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    //更新默认值
    [self changeContentAtIndex:self.currentPage];
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPage = self.currentPage;
    
    //移除之前的计时器
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    
    //如果个数少于1个，就不加载定时器了
    if (images.count <= 1) {
        return;
    }
    
    //重新加载计时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timeCount:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    
}

- (void)timeCount:(NSTimer *)timer
{
    //设置page
    self.currentPage++;
    if (self.currentPage == self.images.count) {
        self.currentPage = 0;
    }
    
    //切换指定page的内容
    [self changeContentAtIndex:self.currentPage];
    self.pageControl.currentPage = self.currentPage;
    
    //制造滚动的视觉
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];

}

- (void)setCallback:(Callback)callback
{
    _callback = callback;
    
    self.leftView.callback = self.rightView.callback = self.middleView.callback = callback;
}

- (void)setDisplayImageDesc:(BOOL)displayImageDesc
{
    _displayImageDesc = displayImageDesc;
    
    self.leftView.displayLabel = self.rightView.displayLabel = self.middleView.displayLabel = displayImageDesc;
}

@end





@implementation CMCycleModel

@end



@implementation CMCycleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置UI
        [self setupUI];
    }
    return self;
}


#pragma mark - 设置UI
/**设置UI*/
- (void)setupUI
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)]];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    self.descLabel = label;
    
}

- (void)setModel:(CMCycleModel *)model
{
    _model = model;
    
    self.imageView.image = model.placeholder;
    self.descLabel.text = model.imageDesc;
    [self.descLabel sizeToFit];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    [self.descLabel sizeToFit];
    self.descLabel.frame = CGRectMake(self.frame.size.width - 10 - self.descLabel.bounds.size.width, self.frame.size.height - 10 - self.descLabel.bounds.size.height, self.descLabel.bounds.size.width, self.descLabel.bounds.size.height);
    self.descLabel.hidden = !self.displayLabel;
}

- (void)tapImageView
{
    if (self.callback) {
        self.callback(self.model);
    }
}



@end


















