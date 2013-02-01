//
//  SNListViewController.m
//  sinaweibo_ios_sdk_demo
//
//  Created by wgdadmin on 13-1-30.
//  Copyright (c) 2013年 SINA. All rights reserved.
//

#import "SNListViewController.h"

@interface SNListViewController ()

@end

@implementation SNListViewController
@synthesize listTableView;
@synthesize nameArr;
@synthesize weiBo;

-(void)dealloc
{
    [weiBo release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50,self.view.frame.size.width , self.view.frame.size.height - 150)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.listTableView = tableView;
    [tableView release];
    [self.view addSubview:self.listTableView];
    
   // bottomView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, self.listTableView.frame.size.height, 320, 60)];
    bottomView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
    bottomView.delegate = self;
   [self.listTableView addSubview:bottomView];
    [bottomView release];
    
    
	// Do any additional setup after loading the view.

    [self getFollowers:0];
//    arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow.png"]];
//    [self.view addSubview:arrowView];
//    
//    UIButton  *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 25, 50, 30)];
//    [self.view addSubview:btn];
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
  
}

-(void)change
{
    static int i = 0;
    arrowView.layer.transform = CATransform3DMakeRotation((M_PI /(4* 90)) * 90.0*i,0, 0, 1.0f);
    i++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)nameArr
{
    if(!nameArr)
    {
        nameArr = [[NSMutableArray alloc] init];
    }
    return nameArr;
}

-(void)loadView
{
    UIView *temp = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = temp;
    self.view.backgroundColor = [UIColor whiteColor];
    [temp release];
}

#pragma mark --SinaWeiBoDelegate
//- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response;
//- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data;

-(void)getFollowers:(int )cursor
{
    isLoading = YES;
    NSString *url = @"friendships/followers.json";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"李开复" forKey:@"screen_name"];
    int count = 10;
     [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    NSString *cursorStr = [NSString stringWithFormat:@"%d",cursor*count];
    [dic setObject:cursorStr forKey:@"cursor"];
    [self.weiBo requestWithURL:url params:dic httpMethod:@"GET" delegate:self];
    [dic release];
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error :%@",error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"result:%@",result);
    cursor = [[result objectForKey:@"next_cursor"] intValue];
    
    NSMutableArray *tempArr = [result objectForKey:@"users"];
    for(NSDictionary *item in tempArr)
    {
        NSString *name = [item objectForKey:@"name"];
        [self.nameArr addObject:name];
    }
   //   bottomView.frame=CGRectMake(0, 30*(self.nameArr.count), 320, 60);
    [self.listTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
     [bottomView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listTableView];
    isLoading = NO;
}

#pragma mark  --EGODelegate
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    
    return isLoading;
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
     cursor = 0;
    self.nameArr = nil;
    [self.listTableView reloadData];
    [self getFollowers:cursor];
}

-(void)egoRefreshTableFootDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
   
    [self getFollowers:cursor];
}

#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"nameIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell)
    {
        cell = [[[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    cell.textLabel.text = [self.nameArr objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark -- UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [bottomView egoRefreshScrollViewDidScroll:self.listTableView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [bottomView egoRefreshScrollViewDidEndDragging:self.listTableView];
    
}

@end
