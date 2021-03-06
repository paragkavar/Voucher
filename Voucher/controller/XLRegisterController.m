//
//  XLRegisterController.m
//  Voucher
//
//  Created by xie liang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLRegisterController.h"

@interface XLRegisterController ()

@end

@implementation XLRegisterController

@synthesize phoneField = _phoneField;
@synthesize verifyField = _verifyField;
@synthesize passwordField = _passwordField;
@synthesize verifyCodeStr = _verifyCodeStr;

- (void)dealloc
{
    [_phoneField release];
    [_verifyField release];
    [_passwordField release];
    [_verifyCodeStr release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _verifyCodeStr = nil;
    }
    return self;
}

- (void)setNavigationBar
{
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    naviBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg.png"]];
    [self.view addSubview:naviBar];
    [naviBar release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:naviBar.bounds];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"注册";
    [naviBar addSubview:titleLabel];
    [titleLabel release];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(10, 6, 51, 32);
    [leftItem setBackgroundImage:[UIImage imageNamed:@"go_back.png"] forState:UIControlStateNormal];
    [leftItem setTitle:@"返回" forState:UIControlStateNormal];
    leftItem.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    leftItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftItem addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:leftItem];
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)processReturnKey:(UITextField *)sender
{
    if (sender.tag == 201) {
        [_passwordField becomeFirstResponder];
    }
    if (sender.tag == 202) {
        [_passwordField resignFirstResponder];
    }
}

- (IBAction)fetchVerifyCode:(id)sender
{
    //验证电话号码
    if (![_phoneField.text stringByMatching:@"^(13|15|18)[0-9]{9}$"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入正确的手机号码！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *urlStr = [XLTools getInterfaceByKey:@"fetch_code"];
    Debug(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.requestMethod = @"POST";
    [req addPostValue:_phoneField.text forKey:@"phoneNo"];
    req.delegate = self;
    req.tag = 100;
    [req startAsynchronous];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)doRegister:(id)sender
{
    //验证电话号码
    if (![_phoneField.text stringByMatching:@"^(13|15|18)[0-9]{9}$"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入正确的手机号码！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![_verifyCodeStr isEqualToString:_verifyField.text]) {
        //验证验证码
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"验证码无效！" 
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //验证密码
    if (![_passwordField.text stringByMatching:@"^[A-Za-z0-9]{6,20}$"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"密码只能包含数字和字母在6到20位之间！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *urlStr = [XLTools getInterfaceByKey:@"user_regist"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.requestMethod = @"POST";
    req.tag = 101;
    req.delegate = self;
    [req addPostValue:_phoneField.text forKey:@"phoneNo"];
    [req addPostValue:_passwordField.text forKey:@"password"];
    [req startAsynchronous];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            if (request.tag == 100) {
                self.verifyCodeStr = [dic objectForKey:@"info"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请求发送成功，注意查收验证码短信！" 
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else {
                [XLTools saveUserInfo:[dic objectForKey:@"info"]];
                [((XLAppDelegate *)[UIApplication sharedApplication].delegate) setTabBarAsRoot];
            }
        }else {
            Debug(@"%@",[dic objectForKey:@"resultInfo"]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[dic objectForKey:@"resultInfo"] 
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else {
        Debug(@"%@",request.responseStatusCode);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"服务器内部异常！" 
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    Debug(@"网络链接或服务器问题！");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"请检查网络链接或联系管理员！" 
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
