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

@interface ViewController () <CFMultistageDropdownMenuViewDelegate>

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
    
    [_multistageDropdownMenuView setupDataSourceLeftArray:leftArr rightArray:rightArr];
    
    _multistageDropdownMenuView.delegate = self;
    
    // 下拉列表 起始y
    _multistageDropdownMenuView.startY = CGRectGetMaxY(_multistageDropdownMenuView.frame);
    
//    _multistageDropdownMenuView.maxRowCount = 3;
    _multistageDropdownMenuView.stateConfigDict = @{
//                                         @"selected" : @[[UIColor purpleColor], @"测试紫箭头"],
//                                         @"normal" : @[[UIColor redColor], @"测试红箭头"]
                                         };
    

    
    
    return _multistageDropdownMenuView;
    
}

#pragma mark - CFMultistageDropdownMenuViewDelegate
- (void)multistageDropdownMenuView:(CFMultistageDropdownMenuView *)multistageDropdownMenuView selecteTitleButtonIndex:(NSInteger)titleButtonIndex conditionLeftIndex:(NSInteger)leftIndex conditionRightIndex:(NSInteger)rightIndex
{
    
    
    NSString *str = [NSString stringWithFormat:@"(都是从0开始)\n 当前选中是 第%zd个title按钮, 一级条件索引是%zd,  二级条件索引是%zd",titleButtonIndex, leftIndex, rightIndex];
    
    NSString *titleStr = [multistageDropdownMenuView.defaulTitleArray objectAtIndex:titleButtonIndex];
    NSArray *leftArr = [multistageDropdownMenuView.dataSourceLeftArray objectAtIndex:titleButtonIndex];
    NSArray *rightArr = [multistageDropdownMenuView.dataSourceRightArray objectAtIndex:titleButtonIndex];
    NSString *leftStr = @"";
    NSString *rightStr = @"";
    NSString *str2 = @"";
    if (leftArr.count>0) { // 二级菜单
        leftStr = [leftArr objectAtIndex:leftIndex];
        NSArray *arr = [rightArr objectAtIndex:leftIndex];
        rightStr = [arr objectAtIndex:rightIndex];
        str2 = [NSString stringWithFormat:@"当前选中的是 \"%@\" 分类下的 \"%@\"-\"%@\"", titleStr, leftStr, rightStr];
    } else {
        rightStr = [rightArr[0] objectAtIndex:rightIndex];
        str2 = [NSString stringWithFormat:@"当前选中的是 \"%@\" 分类下的 \"%@\"", titleStr, rightStr];
    }
    
    NSMutableString *mStr22 = [NSMutableString stringWithFormat:@" "];
    NSArray *btnArr = multistageDropdownMenuView.titleButtonArray;
    for (UIButton *btn in btnArr) {
        [mStr22 appendString:[NSString stringWithFormat:@"\"%@\"", btn.titleLabel.text]];
        [mStr22 appendString:@" "];
    }
    NSString *str22 = [NSString stringWithFormat:@"当前展示的所有条件是:\n (%@)", mStr22];
   
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注: 当下拉菜单选项为一级菜单时, 一级条件索引肯定是0" message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:^{
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:str22 message:str2 preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController2 animated:NO completion:^{
                UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
                }];
                [alertController2 addAction:alertAction2];
            }];
            
        }];
       [alertController addAction:alertAction];
    }];

  
}

- (void)multistageDropdownMenuView:(CFMultistageDropdownMenuView *)multistageDropdownMenuView selectTitleButtonWithCurrentTitle:(NSString *)currentTitle currentTitleArray:(NSArray *)currentTitleArray
{
    NSMutableString *mStr = [NSMutableString stringWithFormat:@" "];
    
    for (NSString *str in currentTitleArray) {
        [mStr appendString:[NSString stringWithFormat:@"\"%@\"", str]];
        [mStr appendString:@" "];
    }
    NSString *str = [NSString stringWithFormat:@"当前选中的是 \"%@\" \n 当前展示的所有条件是:\n (%@)",currentTitle, mStr];
    

     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"第二个代理方法" message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:^{
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alertController addAction:alertAction];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
