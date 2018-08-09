//
//  ZQMyViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyViewController.h"
#import "ZQPersonModel.h"

#import "YSPersonalHeadCell.h"
#import "YPersonDetailHeadView.h"
#import "YPersonOrderCell.h"
#import "YPersonActionCell.h"

#import "ZQFeedBackViewController.h" //意见反馈

@interface ZQMyViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YSPersonalHeadCellDelegate,YPersonDetailHeadViewDelegate>

@property (strong,nonatomic) UICollectionView *mainV;

@property (strong,nonatomic) NSArray *orderTitleArr;

@property (strong,nonatomic) NSArray *orderImageArr;

@property (strong,nonatomic) NSArray *actionTitleArr;

@property (strong,nonatomic) NSArray *actionImageArr;
@property (strong,nonatomic) ZQPersonModel *model;

@end


@implementation ZQMyViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationRightItem];
    [self initView];

}
- (void)addNavigationRightItem
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(logOutAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = __DefaultColor;
}
- (void)logOutAction
{
    [Utility setLoginStates:NO];
    self.tabBarController.selectedIndex = 0;
}
#pragma mark ==懒加载==
- (NSArray *)orderTitleArr {
    if (!_orderTitleArr) {
        _orderTitleArr = @[@"待付款",@"待处理",@"待收货",@"待评论",@"返修/退换"];
    }
    return _orderTitleArr;
}

- (NSArray *)orderImageArr {
    if (!_orderImageArr) {
        _orderImageArr = @[@"Orders_01",@"Orders_02",@"Orders_03",@"Orders_04",@"Orders_05"];
    }
    return _orderImageArr;
}


- (NSArray *)actionTitleArr {
    if (!_actionTitleArr) {
        _actionTitleArr = @[@"优惠券",@"积分商城",@"我的收藏",@"足迹",@"我的评价",@"收货地址",@"客服中心",@"意见反馈"];
    }
    return _actionTitleArr;
}

- (NSArray *)actionImageArr {
    if (!_actionImageArr) {
        _actionImageArr = @[@"coupon",@"jifen",@"my_ico_02",@"my_ico_04",@"my_ico_08",@"my_ico_06",@"my_ico_07",@"yijian"];
    }
    return _actionImageArr;
}

- (UICollectionView *)mainV {
    if (!_mainV) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _mainV = [[UICollectionView alloc]
                  initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight-50)
                  collectionViewLayout:flowLayout];
//        _mainV.backgroundColor = __BackColor;
        _mainV.backgroundColor = MainBgColor;
        _mainV.delegate = self;
        _mainV.dataSource = self;
//        _mainV.bounces = NO;
        _mainV.showsVerticalScrollIndicator = NO;
        _mainV.showsHorizontalScrollIndicator = NO;
    }
    return _mainV;
}
- (void)initView{
    [self.view addSubview:self.mainV];
    //section 0
    [_mainV registerClass:[YSPersonalHeadCell class]
forCellWithReuseIdentifier:@"YSPersonalHeadCell"];
    //section 1
    [_mainV registerClass:[YPersonDetailHeadView class]
forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
      withReuseIdentifier:@"YPersonDetailHeadView"];
    [_mainV registerClass:[YPersonOrderCell class]
forCellWithReuseIdentifier:@"YPersonOrderCell"];
    //section 2
    [_mainV registerClass:[YPersonActionCell class]
forCellWithReuseIdentifier:@"YPersonActionCell"];
    
    [_mainV registerClass:[UICollectionReusableView class]
forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
      withReuseIdentifier:@"footer"];
}
#pragma mark ==UICollectionViewDelegate==
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else if (section==1){
        return self.orderTitleArr.count;
    }else{
        return self.actionTitleArr.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cells = nil;
    if (indexPath.section ==0) {
        YSPersonalHeadCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"YSPersonalHeadCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[YSPersonalHeadCell alloc]init];
        }
        cell.delegate = self;
//        cell.userName = _model.nickName;
        cell.userName = @"用户名";
        [cell.headIV setImage:[UIImage imageNamed:@"user_head"]];
        //        cell.imageName = [UdStorage getObjectforKey:UserHead];
        cells = cell;
    }else if (indexPath.section == 1){
        YPersonOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YPersonOrderCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[YPersonOrderCell alloc]init];
        }
        cell.title = self.orderTitleArr[indexPath.row];
        cell.imageName = self.orderImageArr[indexPath.row];
        cells = cell;
    }else{
        YPersonActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YPersonActionCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[YPersonActionCell alloc]init];
        }
        cell.title = self.actionTitleArr[indexPath.row];
        cell.imageName = self.actionImageArr[indexPath.row];
        cells = cell;
    }
    return cells;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseV= nil;
    if (indexPath.section==1) {
        if (kind == UICollectionElementKindSectionHeader) {
            YPersonDetailHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YPersonDetailHeadView" forIndexPath:indexPath];
            if (!header) {
                header = [[YPersonDetailHeadView alloc]init];
            }
            header.title = @"我的订单";
            header.detail = @"查看订单";
            header.tag = 0;
            header.delegate = self;
            reuseV = header;
        }else{
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
            if (!footer) {
                footer = [[UICollectionReusableView alloc]init];
            }
            footer.backgroundColor = MainBgColor;
            reuseV =footer;
        }
    }
    return reuseV;
}


//内容距离屏幕边缘的距离 参数顺序是top,left,bottom,right
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

//x 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section==2) {
        return 1;
    }else{
        return 0;
    }
}

//y 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return 1;
    }else{
        return 0;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return CGSizeMake(__kWidth, 150);
    }else if (indexPath.section==1){
        return CGSizeMake(__kWidth/5, 70);
    }else{
        return CGSizeMake((__kWidth-3)/4, 100);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return CGSizeMake(__kWidth, 48);
    }else{
        return CGSizeZero;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==1) {
        return CGSizeMake(__kWidth, 5);
    }else{
        return CGSizeZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row==4) {
//            YReturnsViewController *vc = [[YReturnsViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else{
//            YAllOrderViewController *vc = [[YAllOrderViewController alloc]init];
//            vc.selectIndex = indexPath.row+1;
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
//            YPersonCouponViewController *vc = [[YPersonCouponViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1){
//            YPersonIntegralViewController *vc = [[YPersonIntegralViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==2){
//            YPersonCollectViewController *vc = [[YPersonCollectViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==3){
//            YFootPrintViewController *vc= [[YFootPrintViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==4) {
//            YPersonAppraiseViewController *vc = [[YPersonAppraiseViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==5) {
//            YAddressMangerViewController  *vc = [[YAddressMangerViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==6){
//            YServiceCenterViewController *vc = [[YServiceCenterViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ZQFeedBackViewController *vc = [[ZQFeedBackViewController alloc]init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark ==YSPersonalHeadCellDelegate==

-(void)seeNews{
    NSLog(@"查看消息");
//    YSystemNewsViewController *vc = [[YSystemNewsViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goSetting{
    NSLog(@"去设置");
//    YPersonMoreViewController *vc = [[YPersonMoreViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)userManage{
    NSLog(@"账户管理");
//    YPersonManagerViewController *vc = [[YPersonManagerViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==YPersonDetailHeadViewDelegate==
-(void)headDetailActionType:(NSInteger)tag{
    if (!tag) {
        NSLog(@"查看订单");
//        YAllOrderViewController *vc = [[YAllOrderViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
