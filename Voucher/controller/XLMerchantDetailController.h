//
//  XLMerchantDetailController.h
//  Voucher
//
//  Created by xie liang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLVoucherCell.h"
#import "CTLoadImageOperation.h"
#import "XLSinaEngine.h"
#import "XLTouchLabel.h"

@interface XLMerchantDetailController : UIViewController
<UITableViewDelegate,UITableViewDataSource,XLVoucherCellDelegate,XLSinaEngineDelegate>
{
    NSArray *_dataArray;
    
    NSOperationQueue *_queue;
    
    XLSinaEngine *_sinaEngine;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSDictionary *merchantInfo;
@property(nonatomic,retain) IBOutlet UIImageView *logoView;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *addressLabel;
@property(nonatomic,retain) IBOutlet UILabel *numLabel;
@property(nonatomic,retain) IBOutlet XLTouchLabel *phoneLabel;
@property(nonatomic,retain) IBOutlet XLTouchLabel *descLabel;

- (IBAction)shareToSina:(id)sender;

@end
