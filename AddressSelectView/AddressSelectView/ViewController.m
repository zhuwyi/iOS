//
//  ViewController.m
//  AddressSelectView
//
//  Created by ND on 2018/12/18.
//  Copyright © 2018 ND. All rights reserved.
//

#import "ViewController.h"
#import "ChinaCitySelectView.h"

@interface ViewController ()

@property (nonatomic,strong)UILabel *addressLab;
@property (nonatomic,strong)ChinaCitySelectView *citySelectView;

@end

@implementation ViewController

-(ChinaCitySelectView *)citySelectView
{
    if (!_citySelectView) {
        _citySelectView  = [[ChinaCitySelectView alloc]initWithFrame:(CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height))];
        _citySelectView.selectCityBlock = ^(NSString *address,NSString *regionId){
            NSLog(@"地区：regionId=%@",regionId);
            [_citySelectView popShowOrCloseView:NO];
            if (address) {

                _addressLab.text = address;
            }
        };
    }
    return _citySelectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *chooseAddressBtn = [[UIButton alloc]initWithFrame:(CGRectMake((self.view.bounds.size.width-100)/2, 300, 100, 40))];
    [chooseAddressBtn setTitle:@"选择地址" forState:(UIControlStateNormal)];
    chooseAddressBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:chooseAddressBtn];
    [chooseAddressBtn addTarget:self action:@selector(choose) forControlEvents:(UIControlEventTouchUpInside)];
    //
    _addressLab = [[UILabel alloc]initWithFrame:(CGRectMake((self.view.bounds.size.width-250)/2, CGRectGetMaxY(chooseAddressBtn.frame)+50, 250, 30))];
    _addressLab.font = [UIFont systemFontOfSize:15];
    _addressLab.textAlignment = NSTextAlignmentCenter;
    _addressLab.text = @"暂未选择地区";
    _addressLab.text = @"暂未选择地区";
    _addressLab.text = @"暂未选择地区";

    [self.view addSubview:_addressLab];
    
    [self.view addSubview:self.citySelectView];
    
}
#pragma mark 选择地址
-(void)choose{
    [_citySelectView popShowOrCloseView:YES];

}

@end
