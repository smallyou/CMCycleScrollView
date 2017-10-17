//
//  CMCycleScrollView.h
//  CMCycleScrollView
//
//  Created by 23 on 2017/10/16.
//  Copyright © 2017年 kinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCycleModel;
typedef void(^Callback)(CMCycleModel *cycleModel);

#pragma mark - CMCyleScrollView

@interface CMCycleScrollView : UIView

/**当只有一个数据时，是否显示分页按钮, 默认是NO*/
@property(nonatomic,assign) BOOL displayPageControlForSinglePage;

/**是否显示图片描述,默认是不显示*/
@property(nonatomic,assign) BOOL displayImageDesc;

/**初始化默认的图片*/
@property(nonatomic,strong) UIImage *defaultImage;

/**图片数据*/
@property(nonatomic,strong) NSArray<CMCycleModel *> *images;

/**点击图片后的回调*/
@property(nonatomic,copy) Callback callback;

@end




#pragma mark - CMCycleModel

@interface CMCycleModel : NSObject

/**
 服务器图片的链接
 如果是从服务器上加载，则不能为nil
 如果是从本地加载，可为nil
 */
@property(nonatomic,copy) NSString *imageUrl;

/**
 如果是从服务器加载，则placeholder表示每张图片对应的占位图片，可为nil
 如果是加载本地图片，则placeholder表示本地图片，不能为nil
 */
@property(nonatomic,strong) UIImage *placeholder;

/**图片的描述，可为nil*/
@property(nonatomic,copy) NSString *imageDesc;

@end


#pragma mark - CMCycleCell

@interface CMCycleCell: UIView

@property(nonatomic,strong) CMCycleModel *model;

/**imageView*/
@property(nonatomic,weak) UIImageView *imageView;
/**描述label*/
@property(nonatomic,weak) UILabel *descLabel;
/**点击图片后的回调*/
@property(nonatomic,copy) Callback callback;
/**是否显示描述label*/
@property(nonatomic,assign) BOOL displayLabel;


@end









