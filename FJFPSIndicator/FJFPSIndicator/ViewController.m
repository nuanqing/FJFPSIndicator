//
//  ViewController.m
//  FJFPSIndicator
//
//  Created by MacBook on 2018/1/3.
//  Copyright © 2018年 MacBook. All rights reserved.
//

#import "ViewController.h"
#import "FJFPSIndicator.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FJFPSIndicator sharedInstance] start];
    _dataArray = [NSMutableArray array];
    [self createData];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)createData{
    
    for (int i = 0; i < 1000; i ++) {
        [_dataArray addObject:@{@"name":[self randomName],@"icon":@"100.jpg"}];
    }
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = _dataArray[indexPath.row];
    //IO操作耗费CPU
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld",(NSInteger)((rand()/(double)INT_MAX) * 6)] ofType:@"jpg"];
    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    cell.imageView.layer.cornerRadius = 5.0f;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 3);
    cell.imageView.layer.shadowOpacity = 1;
    //从内存中读
    //cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    
    cell.textLabel.text = dict[@"name"];
    
    //开启光栅化
    //cell.layer.shouldRasterize = YES;
    //cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    return cell;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = [UIScreen mainScreen].bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSString *)randomName{
    NSArray *namesArray = @[@"小李",@"小王",@"小张",@"小房"];
    NSUInteger index = (rand()/(double)INT_MAX) * [namesArray count];
    return namesArray[index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
