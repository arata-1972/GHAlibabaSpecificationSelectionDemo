//
//  ViewController.m
//  GHAlibabaSpecificationSelectionDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 macBookPro. All rights reserved.
//

#import "ViewController.h"
#import "GHAlibabaSpecificationSelection.h"
#import "GHHTTPSessionManager.h"
#import "MJExtension.h"
#import "GHSpecificationSelectionModel.h"
#import "GHAlibabaSpecificationSelectionModel.h"
#import "ToastTool.h"
#import "GHSpecificationSelectionImageModel.h"
#import "GHPopView.h"

#define weakself(self)          __weak __typeof(self) weakSelf = self


#ifdef DEBUG
#define NSLog(format, ...) printf("%s\n", [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

@interface ViewController ()

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) GHAlibabaSpecificationSelection *alibabaSpecificationSelection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData {
    [ToastTool makeToastActivity:self.view];
    weakself(self);

    NSString *url = @"http://mock-api.com/7zxXywz3.mock/data";
    [[GHHTTPSessionManager sharedManager] getGoodDetailsWithUrl:url finishedBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"responseObject%@",responseObject);
         NSDictionary *dict = (NSDictionary *)responseObject;
        NSArray *colors = dict[@"color"];
        NSArray *data = dict[@"data"];
        NSDictionary *sectePrice = dict[@"sectePrice"];
        NSMutableArray *specifications = [NSMutableArray array];
        for (NSDictionary *dataDict in data) {
            GHSpecificationSelectionModel *specificationSelectionModel = [GHSpecificationSelectionModel mj_objectWithKeyValues:dataDict];
            NSArray *images = dataDict[@"images"];
            NSMutableArray *imagesArray = [NSMutableArray array];
            for (NSDictionary *imageDict in images) {
                GHSpecificationSelectionImageModel *specificationSelectionImageModel = [GHSpecificationSelectionImageModel mj_objectWithKeyValues:imageDict];
                [imagesArray addObject:specificationSelectionImageModel];
            }
            specificationSelectionModel.images = imagesArray.copy;
            [specifications addObject:specificationSelectionModel];
        }
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSInteger i = 0; i < colors.count; i++) {
            GHAlibabaSpecificationSelectionModel *alibabaSpecificationSelectionModel = [[GHAlibabaSpecificationSelectionModel alloc]init];
            NSString *colorStr = colors[i];
            for (NSInteger j = 0; j < specifications.count; j++) {
                GHSpecificationSelectionModel *specificationSelectionModel = specifications[j];
                NSMutableArray *dataArray = [NSMutableArray array];
                if ([specificationSelectionModel.color isEqualToString:colorStr]) {
                    [dataArray addObject:specificationSelectionModel];
                }
                alibabaSpecificationSelectionModel.specifications = dataArray.copy;
            }
            alibabaSpecificationSelectionModel.colorStr = colorStr;
            [dataArray addObject:alibabaSpecificationSelectionModel];
        }
        [ToastTool makeToastActivity:weakSelf.view toastToolCompleteBlock:^{
            weakSelf.alibabaSpecificationSelection.dataArray = dataArray;
            [weakSelf.alibabaSpecificationSelection show];
        }];
    }];
}

- (GHAlibabaSpecificationSelection *)alibabaSpecificationSelection {
    if (_alibabaSpecificationSelection == nil) {
        _alibabaSpecificationSelection = [[GHAlibabaSpecificationSelection alloc]init];
    }
    return _alibabaSpecificationSelection;
}

@end
