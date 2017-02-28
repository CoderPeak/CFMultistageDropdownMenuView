//
//  ViewController.m
//  CFMultistageDropdownMenuView
//
//  Created by Peak on 17/2/28.
//  Copyright © 2017年 Peak. All rights reserved.
//

#import "ViewController.h"
#import "CFMacro.h"
#import "CFMultistageDropdownMenuView.h"

@interface ViewController ()

/* CFMultistageDropdownMenuView */
@property (nonatomic, strong) CFMultistageDropdownMenuView *multistageDropdownMenuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 配置展示结果talbeview
//    [self.view addSubview:self.showTableView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CFScreenWidth, 88)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = CFRandomColor;
    titleL.numberOfLines = 0;
    titleL.text = @"CFMultistageDropdownMenuView 展示demo\n交流QQ 545486205\n 个人github网址 https://github.com/CoderPeak";
    [self.view addSubview:titleL];
    
    // 配置CFDropDownMenuView
    [self.view addSubview:self.multistageDropdownMenuView];

}

#pragma mark - lazy
/* 配置CFDropDownMenuView */
- (CFMultistageDropdownMenuView *)multistageDropdownMenuView
{
    // DEMO
    _multistageDropdownMenuView = [[CFMultistageDropdownMenuView alloc] initWithFrame:CGRectMake(0, 104, CFScreenWidth, 45)];
    
    _multistageDropdownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"行业分类",@"金额", @"排序", nil];
    
    // 注:  数据源一般由网络请求
    // 格式参照如下 - 一般后台返回的格式如此
    NSArray *leftArr = @[
                         // 二级菜单 的 一级菜单
                         @[@"全部分类", @"特色餐饮", @"服装鞋包", @"美容养生", @"饰品玩具", @"家居建材", @"节能环保", @"O2O落地", @"生活服务"],
                         // 一级菜单
                         @[],
                         // 一级菜单
                         @[]
                         ];
    NSArray *rightArr = @[
                          // 对应dataSourceLeftArray
                          @[
                              // 二级菜单 的 二级菜单
                              // 全部分类
                              @[@"全部"],
                              // 特色餐饮
                              @[@"全部", @"小吃快餐", @"火锅", @"自助餐", @"江浙菜", @"生日蛋糕", @"茶饮", @"烤鱼", @"川湘菜", @"西餐牛排", @"甜点", @"面馆", @"粤菜"],
                              // 服装鞋包
                              @[@"全部", @"单肩包", @"长靴", @"短靴", @"凉鞋"],
                              // 美容养生
                              @[@"全部", @"护肤品", @"其他"],
                              // 饰品玩具
                              @[@"全部", @"项链吊坠", @"潮流眼镜", @"品质手表", @"卡通公仔"],
                              // 家居建材
                              @[@"全部", @"装修设计", @"墙纸", @"卫浴用品"],
                              // 节能环保
                              @[@"全部", @"园艺用品", @"其他"],
                              // O2O落地
                              @[@"全部", @"网站制作", @"IT技能", @"办公软件", @"会计职称"],
                              // 生活服务
                              @[@"全部", @"旅游休闲", @"家庭保洁", @"数码维修", @"商务服务", @"宠物服务", @"汽车服务", @"婚庆服务", @"其他"]
                              ],
                          @[
                              // 一级菜单
                              // 金额
                              @[@"全部", @"一万以下", @"1-5万", @"5-10万", @"10-15万", @"15-20万", @"20万以上"]
                              ],
                          @[
                              // 一级菜单
                              // 排序
                              @[@"全部", @"人气最高", @"最新加入", @"金额从低到高", @"金额从高到低"]
                              ]
                          
                          ];
    
    [_multistageDropdownMenuView setupLeftArray:leftArr rightArray:rightArr];
    
//    _multistageDropdownMenuView.delegate = self;
//    
//    // 下拉列表 起始y    
    _multistageDropdownMenuView.startY = CGRectGetMaxY(_multistageDropdownMenuView.frame);
    
    /**
     *  回调方式一: block
     */
//    __weak typeof(self) weakSelf = self;
//    _multistageDropdownMenuView.chooseConditionBlock = ^(NSString *currentTitle, NSArray *currentTitleArray){
//        /**
//         实际开发情况 --- 仅需要拿到currentTitle / currentTitleArray 作为参数 向服务器请求数据即可
//         */
//        NSMutableString *totalTitleStr = [[NSMutableString alloc] init];
//        NSMutableString *totalStr = [[NSMutableString alloc] init];
//        for (NSInteger i = 0; i < currentTitleArray.count; i++) {
//            if (!([currentTitleArray[i] isEqualToString:@"工作岗位"]
//                  || [currentTitleArray[i] isEqualToString:@"薪资"] || [currentTitleArray[i] isEqualToString:@"工作经验"])) {
//                [totalStr appendString:currentTitleArray[i]];
//            }
//            
//            if (0 == i) {
//                [totalTitleStr appendString:@"("];
//            }
//            [totalTitleStr appendString:currentTitleArray[i]];
//            if (i == currentTitleArray.count-1) {
//                [totalTitleStr appendString:@")"];
//                break ;
//            }
//            [totalTitleStr appendString:@"---"];
//            
//        }
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"职位筛选信息" message:[NSString stringWithFormat:@"您当前选中的是\n(%@)\n 当前所有展示的是\n%@", currentTitle, totalTitleStr] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            // 匹配数据源
//            NSString *totalString = totalStr;
//            // 如果筛选条件包含全部, 则截取掉
//            if ([totalStr containsString:@"全部"]) {
//                totalString = [totalStr stringByReplacingOccurrencesOfString:@"全部" withString:@""];
//            }
//            NSLog(@"totalString  %@", totalString);
//            if (totalString.length != 0) {  // 条件 只是  全部
//                NSArray *allDataSourceArr = weakSelf.allDataSourceArr;
//                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
//                for (NSInteger i = 0; i < allDataSourceArr.count; i++) {
//                    NSString *str = allDataSourceArr[i];
//                    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//                    
//                    if ([str containsString:totalString]) {
//                        [tempArr addObject:allDataSourceArr[i]];
//                    }
//                }
//                // 赋值筛选后的数据源
//                weakSelf.dataSourceArr = tempArr;
//                NSLog(@"筛选后数据源  %@", weakSelf.dataSourceArr);
//                
//                // 重新刷新表格  --  显示刷新后的数据
//                [weakSelf.showTableView reloadData];
//            }
//            
//            
//            UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"共有 %zd 条结果", weakSelf.dataSourceArr.count] preferredStyle:UIAlertControllerStyleAlert];
//            [weakSelf presentViewController:alertController2 animated:NO completion:^{
//                UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                }];
//                [alertController2 addAction:alertAction2];
//            }];
//            
//        }];
//        [alertController addAction:alertAction];
//        [weakSelf presentViewController:alertController animated:NO completion:^{
//        }];
//    };
    
    
    return _multistageDropdownMenuView;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
