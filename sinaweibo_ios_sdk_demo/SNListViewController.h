//
//  SNListViewController.h
//  sinaweibo_ios_sdk_demo
//
//  Created by wgdadmin on 13-1-30.
//  Copyright (c) 2013年 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNListViewController : UIViewController<SinaWeiboRequestDelegate,EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int cursor;
    EGORefreshTableHeaderView *bottomView;
    BOOL isLoading;
    UIImageView *arrowView;
}
@property (nonatomic,retain) SinaWeibo *weiBo;
@property (nonatomic,retain) UITableView *listTableView;
@property (nonatomic,retain) NSMutableArray *nameArr;
@end
