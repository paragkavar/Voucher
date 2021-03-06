//
//  XLOptionSelectorView.m
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLOptionSelectorView.h"

@implementation XLOptionSelectorView

@synthesize titleLabel = _titleLabel;
@synthesize optionArray = _optionArray;
@synthesize optionType = _optionType;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_titleLabel release];
    [_optionArray release];
    [_optionTable release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        [self addSubview:maskView];
        [maskView release];
        
        float x = (frame.size.width - 264)/2;
        float y = (frame.size.height - 337)/2;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 264, 337)];
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"option_bg.png"]];
        [self addSubview:bgView];
        [bgView release];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(x+242, y-7, 29, 29);
        [closeBtn setImage:[UIImage imageNamed:@"optionClose.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeOption:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        self.clipsToBounds = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 5, 250, 43)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        [bgView addSubview:_titleLabel];
        
        _optionTable = [[UITableView alloc] initWithFrame:CGRectMake(6, 48, 250, 320-48)];
        _optionTable.backgroundColor = [UIColor clearColor];
        _optionTable.delegate = self;
        _optionTable.dataSource = self;
        _optionTable.separatorColor = [UIColor grayColor];
        [bgView addSubview:_optionTable];
    }
    return self;
}

- (void)closeOption:(id)sender
{
    [self removeFromSuperview];
}

- (void)loadData
{
    [_optionTable reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
//datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_optionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *cellId = @"CELLID";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId] autorelease];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    if (_optionType == DISTANCE_TYPE) {
        NSString *tmpStr = [[_optionArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        if ([tmpStr isEqualToString:@"不限"]) {
            cell.textLabel.text = tmpStr;
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@米",tmpStr];
        }
        
    }else {
        cell.textLabel.text = [[_optionArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    
    return cell;
}

//delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didSelect: value: type:)]) {
        [_delegate didSelect:[[[_optionArray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]
                       value:[[_optionArray objectAtIndex:indexPath.row] objectForKey:@"name"]
                        type:_optionType];
    }
    [self closeOption:nil];
}

@end
