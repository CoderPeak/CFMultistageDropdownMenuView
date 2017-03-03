# CFMultistageDropdownMenuView
简单好用的, 可自定义选中和非选中状态样式的 (最多支持二级的)下拉列表菜单控件---支持默认选中的条件状态改变

##### 暂未支持pod导入 
##### 因为此需求通常定制性较强, 可自定义丰富的效果---为了迎合不同需求, 建议拖入项目中使用

### demo展示 - 由于网络原因, 可能gif效果图会展示的比较卡, 可以下载运行查看demo---简单使用代码

### 使用---注: 详细数据源格式  请参考demo
- 创建使用仅需几行代码即可

```
   // 添加到当前view
   [self.view addSubview:self.multistageDropdownMenuView];
   
   
   // 创建
   _multistageDropdownMenuView = [[CFMultistageDropdownMenuView alloc] initWithFrame:CGRectMake(0, 104, CFScreenWidth, 45)];   
    _multistageDropdownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"行业分类",@"金额", @"排序", nil];
    [_multistageDropdownMenuView setupDataSourceLeftArray:leftArr rightArray:rightArr];   
    _multistageDropdownMenuView.delegate = self;    
    // 下拉列表 起始y
    _multistageDropdownMenuView.startY = CGRectGetMaxY(_multistageDropdownMenuView.frame);
    // 详细数据源格式  请参考demo    
        
```

### 效果图集

![](/公司项目实际使用.gif) 
![](/实现第一个代理方法.gif) 
![](/实现第二个代理方法.gif) 
