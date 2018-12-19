//
//  ChinaCitySelectView.m
//  ChinaCitySelect
//
//  Created by 刘康蕤 on 2017/7/31.
//  Copyright © 2017年 lkr. All rights reserved.
//

#import "ChinaCitySelectView.h"
#import "UIView+Extension.h"
//#import "NDAddressModel.h"


#define MainScreenHieght [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ChinaCitySelectView()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    float btnWidth;
    NSString *completeAddress;
    NSString *coutry;
    NSString *city;
    NSString *area;
    NSString *_regionId;//将最后选中的地址id回传
}

@property (nonatomic, strong) UIPickerView * pickView;

// 省份数组
@property (nonatomic, strong) NSMutableArray * provinceArray;
// 选择哪个省份
@property (nonatomic, assign) NSInteger proinceIndex;
// 省份id 和 name
@property (nonatomic, strong) NSDictionary * proinceDictionary;


// 城市数组
@property (nonatomic, strong) NSMutableArray * cityArray;
// 选择哪个城市
@property (nonatomic, assign) NSInteger cityIndex;
// 城市id 和 name
@property (nonatomic, strong) NSDictionary * cityDictionary;


// 地区数组
@property (nonatomic, strong) NSMutableArray * regionArray;
// 选择哪个地区
@property (nonatomic, assign) NSInteger regionIndex;
// 地区id 和 name
@property (nonatomic, strong) NSDictionary * regionDictionary;

//*****************************************************zhuyi**********************************************
@property (nonatomic,strong)UIView *mainView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *deleteBtn;

@property (nonatomic,strong)UIButton *coutryBtn;
@property (nonatomic,strong)UIButton *cityBtn;
@property (nonatomic,strong)UIButton *areaBtn;//区域
@property (nonatomic,strong)UIView *btnLineView;
@property (nonatomic,strong)UIView *LineView;

//存放三个tableview的scrollview
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UITableView *coutryTableview;
@property (nonatomic,strong)UITableView *cityTableview;
@property (nonatomic,strong)UITableView *areaTableview;

@end

@implementation ChinaCitySelectView

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.68];

        [self creatUI];
        [self initSource];
        
    }
    return self;
}

-(UITableView *)coutryTableview
{
    if (!_coutryTableview) {
        _coutryTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, _scrollView.bounds.size.height) style:(UITableViewStylePlain)];
        _coutryTableview.delegate = self;
        _coutryTableview.dataSource = self;
        _coutryTableview.tag = 100;
        _coutryTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _coutryTableview;
}

-(UITableView *)cityTableview
{
    if (!_cityTableview) {
        _cityTableview = [[UITableView alloc]initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, _scrollView.bounds.size.height) style:(UITableViewStylePlain)];
        _cityTableview.delegate = self;
        _cityTableview.dataSource = self;
        _cityTableview.tag = 101;
        _cityTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _cityTableview;
}

-(UITableView *)areaTableview
{
    if (!_areaTableview) {
        _areaTableview = [[UITableView alloc]initWithFrame:CGRectMake(2*MainScreenWidth, 0, MainScreenWidth, _scrollView.bounds.size.height) style:(UITableViewStylePlain)];
        _areaTableview.delegate = self;
        _areaTableview.dataSource = self;
        _areaTableview.tag = 102;
        _areaTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _areaTableview;
}

#pragma mark /***** zhuyi******/
-(void)creatUI{
    _mainView = [[UIView alloc]initWithFrame:(CGRectMake(0, MainScreenHieght, MainScreenWidth, MainScreenHieght/2))];
    _mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    //
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    _titleLabel.text = @"选择地区";
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_titleLabel];
    //删除按钮
    _deleteBtn = [[UIButton alloc]initWithFrame:(CGRectMake(MainScreenWidth-30-12, 10, 30, 30))];
    [_deleteBtn setImage:[UIImage imageNamed:@"弹出层_关闭icon"] forState:(UIControlStateNormal)];
    [_mainView addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    //省份选择按钮
    btnWidth = MainScreenWidth/3;
    for (int i = 0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRectMake(i*btnWidth, 50, btnWidth, 30))];
        //    [_deleteBtn setImage:[UIImage imageNamed:@"00温馨提示_关闭icon@2x"] forState:(UIControlStateNormal)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_mainView addSubview:btn];
        [btn setTitle:@"请选择" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            _coutryBtn =btn;
            btn.selected = YES;
        }
        else if(i == 1){
            _cityBtn = btn;
            _cityBtn.hidden = YES;
        }
        else
        {
            _areaBtn = btn;
            _areaBtn.hidden = YES;
        }
    }
    
    _LineView = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(_coutryBtn.frame), MainScreenWidth, 1))];
    _LineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_mainView addSubview:_LineView];
    //按钮下划线
    _btnLineView = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(_coutryBtn.frame)-1, btnWidth, 3))];
    _btnLineView.backgroundColor = [UIColor redColor];
    [_mainView addSubview:_btnLineView];
    //添加scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(_LineView.frame), MainScreenWidth, _mainView.bounds.size.height- CGRectGetMaxY(_LineView.frame)))];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_mainView addSubview:_scrollView];
    self.scrollView.contentSize = CGSizeMake(1*MainScreenWidth, _mainView.bounds.size.height- CGRectGetMaxY(_LineView.frame));
    //添加省份tableview
    [_scrollView addSubview:self.coutryTableview];
}

/**展示或关闭*/
-(void)popShowOrCloseView:(BOOL)isOpen{
    if (isOpen) {//展开
        self.y = 0;
        [UIView animateWithDuration:0.3 animations:^{
            _mainView.y = MainScreenHieght/2;
        }];
        
    }else{//关闭
        [UIView animateWithDuration:0.3 animations:^{
            _mainView.y = MainScreenHieght;
        } completion:^(BOOL finished) {
            self.y = MainScreenHieght;
        }];
        
    }
}

//城市按钮选择事件
-(void)chooseClick:(UIButton *)btn{
    btn.selected = YES;
    //scrollView滚动到特定的地方
    [self.scrollView scrollRectToVisible:CGRectMake(btn.tag*MainScreenWidth, 0, MainScreenWidth, _mainView.height- CGRectGetMaxY(_LineView.frame)) animated:YES];
    [self seleIndex:btn.tag];
}
#pragma mark 按钮切换状态
-(void)seleIndex:(NSInteger )tag
{
    _btnLineView.frame = CGRectMake(tag*btnWidth, CGRectGetMaxY(_coutryBtn.frame), btnWidth, 2);
    //scrollView滚动到特定的地方
    [self.scrollView scrollRectToVisible:CGRectMake(tag*MainScreenWidth, 0, MainScreenWidth, _mainView.height- CGRectGetMaxY(_LineView.frame)) animated:YES];
    
    if (tag == 0) {
        _cityBtn.selected = NO;
        _areaBtn.selected = NO;
    }
    else if (tag == 1)
    {
        _coutryBtn.selected = NO;
        _areaBtn.selected = NO;
    }
    else{
        _cityBtn.selected = NO;
        _coutryBtn.selected = NO;
    }
}

#pragma mark 点击删除按钮
-(void)deleteClick{
    if (_selectCityBlock) {
        _selectCityBlock(nil,nil);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_selectCityBlock) {
        _selectCityBlock(nil,nil);
    }
}

#pragma mark /***** setter ******/
- (NSMutableArray *)dataSource {
    if (!_provinceArray) {
        _provinceArray = [[NSMutableArray alloc] init];
    }
    return _provinceArray;
}

#pragma mark /***** dataSource *****/
- (void)initSource {
    
    _proinceIndex = 0;
    _cityIndex = 0;
    _regionIndex = 0;
    //
//    [self loadOrderMessageRequest:@"" typeNum:0];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"address"
                                                          ofType:@"plist"];
    NSArray * array  = [NSArray arrayWithContentsOfFile:filePath];

//    Log(@"arrar = %@",array);
    _provinceArray = [NSMutableArray arrayWithArray:array];
    _cityArray = [NSMutableArray arrayWithArray:[[_provinceArray objectAtIndex:_proinceIndex] objectForKey:@"cityList"]];
    _regionArray = [NSMutableArray arrayWithArray:[[_cityArray objectAtIndex:_cityIndex] objectForKey:@"regionList"]];

    // 设置最初的城市
    _proinceDictionary = @{@"provinceId":[_provinceArray[_proinceIndex] objectForKey:@"provinceId"],@"provinceName":[_provinceArray[_proinceIndex] objectForKey:@"provinceName"]};
    _cityDictionary = @{@"cityId":[_cityArray[_cityIndex] objectForKey:@"cityId"],@"cityName":[_cityArray[_cityIndex] objectForKey:@"cityName"]};
    _regionDictionary = @{@"regionId":[_regionArray[_regionIndex] objectForKey:@"regionId"],@"regionName":[_regionArray[_regionIndex] objectForKey:@"regionName"]};

//    [_pickView reloadAllComponents];
    [_coutryTableview reloadData];

}


#pragma mark --- tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 100:
        {
            return _provinceArray.count;
        }
            break;
        case 101:
        {
            return _cityArray.count;
        }
            break;
        case 102:
        {
            return _regionArray.count;
        }
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"NDWishCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    switch (tableView.tag) {
        case 100:
        {
            
            cell.textLabel.text = [_provinceArray[indexPath.row] objectForKey:@"provinceName"];
            if (_proinceIndex == indexPath.row) {
                cell.textLabel.textColor = [UIColor redColor];
            }
        }
            break;
        case 101:
        {
            cell.textLabel.text = [_cityArray[indexPath.row] objectForKey:@"cityName"];
            if (_cityIndex == indexPath.row) {
                cell.textLabel.textColor = [UIColor redColor];
            }
        }
            break;
        case 102:
        {
            cell.textLabel.text = [_regionArray[indexPath.row] objectForKey:@"regionName"];
            if (_regionIndex == indexPath.row) {
                cell.textLabel.textColor = [UIColor redColor];
            }
        }
            break;
            
        default:
            cell.textLabel.text = @"";
            break;
    }
    return cell;
}

#pragma mark --- tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (tableView.tag) {
        case 100:
        {
            _proinceIndex = indexPath.row;
            _cityIndex = 0;
            _regionIndex = 0;
            self.cityArray = [_provinceArray[_proinceIndex] objectForKey:@"cityList"];
            self.regionArray = [_cityArray[_cityIndex] objectForKey:@"regionList"];
//            [self loadOrderMessageRequest:[_provinceArray[indexPath.row] objectForKey:@"regionId"] typeNum:1];
            self.scrollView.contentSize = CGSizeMake(2*MainScreenWidth, _mainView.height- CGRectGetMaxY(_LineView.frame));
            //添加城市tableview
            [_scrollView addSubview:self.cityTableview];
            [_coutryTableview reloadData];
            [_cityTableview reloadData];
            [_areaTableview reloadData];
            
            _proinceDictionary = @{@"provinceId":[_provinceArray[_proinceIndex] objectForKey:@"provinceId"],@"provinceName":[_provinceArray[_proinceIndex] objectForKey:@"provinceName"]};
//            _cityDictionary = @{@"cityId":[_cityArray[_cityIndex] objectForKey:@"regionId"],@"cityName":[_cityArray[_cityIndex] objectForKey:@"regionName"]};
//            _regionDictionary = @{@"regionId":[_regionArray[_regionIndex] objectForKey:@"regionId"],@"regionName":[_regionArray[_regionIndex] objectForKey:@"regionName"]};
            //
            [_coutryBtn setTitle:[_proinceDictionary objectForKey:@"provinceName"] forState:UIControlStateNormal];
            [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
            _cityBtn.hidden = NO;
            _cityBtn.selected = YES;
            _areaBtn.hidden = YES;
            [self seleIndex:1];
        }
            break;
        case 101:
        {
            _cityIndex = indexPath.row;
            _regionIndex = 0;
            self.regionArray = [_cityArray[_cityIndex] objectForKey:@"regionList"];
//            [self loadOrderMessageRequest:[_cityArray[indexPath.row] objectForKey:@"regionId"] typeNum:2];
            
            _regionId = [_cityArray[indexPath.row] objectForKey:@"cityId"];
            self.scrollView.contentSize = CGSizeMake(3*MainScreenWidth, _mainView.height- CGRectGetMaxY(_LineView.frame));
            if (_regionArray.count==0) {
                [_areaBtn setTitle:@"无" forState:UIControlStateNormal];
                if (_selectCityBlock) {//只有两层时回传
                    _selectCityBlock(completeAddress,_regionId);
                }
            }
            //添加区域tableview
            [_scrollView addSubview:self.areaTableview];
            [_cityTableview reloadData];
            [_areaTableview reloadData];
            
            _cityDictionary = @{@"cityId":[_cityArray[_cityIndex] objectForKey:@"cityId"],@"cityName":[_cityArray[_cityIndex] objectForKey:@"cityName"]};
            _regionDictionary = nil;
//            _regionDictionary = @{@"regionId":[_regionArray[_regionIndex] objectForKey:@"regionId"],@"regionName":[_regionArray[_regionIndex] objectForKey:@"regionName"]};
            //
            [_cityBtn setTitle:[_cityDictionary objectForKey:@"cityName"] forState:UIControlStateNormal];
            [_areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            _areaBtn.hidden = NO;
            _areaBtn.selected = YES;
            [self seleIndex:2];
        }
            break;
        case 102:
        {
            _regionIndex = indexPath.row;
            [_areaTableview reloadData];
            //
            _regionId = [_regionArray[indexPath.row] objectForKey:@"regionId"];
            _regionDictionary = @{@"regionId":[_regionArray[_regionIndex] objectForKey:@"regionId"],@"regionName":[_regionArray[_regionIndex] objectForKey:@"regionName"]};
            [_areaBtn setTitle:[_regionDictionary objectForKey:@"regionName"] forState:UIControlStateNormal];
            _areaBtn.selected = NO;
        }
            break;
            
        default:
            break;
    }
    NSLog(@"省份：%@",[_proinceDictionary objectForKey:@"provinceName"]);
    NSLog(@"城市：%@",[_cityDictionary objectForKey:@"cityName"]);
    NSLog(@"地区：%@",[_regionDictionary objectForKey:@"regionName"]);
    coutry = [_proinceDictionary objectForKey:@"provinceName"];
    city = [_cityDictionary objectForKey:@"cityName"];
    area = [_regionDictionary objectForKey:@"regionName"];
    if (coutry&&city) {
        if (area) {
            completeAddress = [NSString stringWithFormat:@"%@/%@/%@",coutry,city,area];
        }
        else{
            completeAddress = [NSString stringWithFormat:@"%@/%@",coutry,city];
        }
    }
    if (tableView == _areaTableview) {
        if (_selectCityBlock) {
            _selectCityBlock(completeAddress,_regionId);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //判断scrollow是否是当前的scrollow
    if (self.scrollView == scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        NSLog(@"page====%ld",(long)page);
        [self seleIndex:page];
    }
}

@end
