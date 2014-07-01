//
//  MyHomeViewController.m
//  Programer_Home
//
//  Created by 胡晓桥 on 14-6-30.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import "MyHomeViewController.h"
#import "GDataXMLNode.h"
#import "UserInfoModel.h"
#import "PAImageView.h"
#import "VPImageCropperViewController.h"
#import "GDataXMLNode.h"

@interface MyHomeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
{
    PAImageView *_paImageView;
}
@end

@implementation MyHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    label.text = @"我的主页";
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.mainView.layer.cornerRadius = 10;
    self.View2.layer.cornerRadius = 8;
    self.View3.layer.cornerRadius = 8;
    self.View4.layer.cornerRadius = 8;
    self.View5.layer.cornerRadius = 8;
    [self createBackBnt];
    
    //圆形头像
    _paImageView = [[PAImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor grayColor]];
    [self.portraitView addSubview:_paImageView];
    //加载数据
    [self loadDataFromNetwork];
}

- (void)createBackBnt
{
    UIButton *backBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    backBnt.frame = CGRectMake(0, 0, 30, 30);
    [backBnt setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBnt addTarget:self action:@selector(backToFrontView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBnt];
}

- (void)loadDataFromNetwork
{
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@",api_my_information,self.uid];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",operation.responseString);
        [self anylaseUserInfo:operation.responseData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"读取用户资料失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)anylaseUserInfo:(NSData *)data
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSString *xpath = @"/oschina/user";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    for(GDataXMLElement *element in arr)
    {
        model.name = [[element elementsForName:@"name"][0] stringValue];
        model.portraitUrl = [[element elementsForName:@"portrait"][0] stringValue];
        model.joinTime = [[element elementsForName:@"jointime"][0] stringValue];
        model.from = [[element elementsForName:@"from"][0] stringValue];
        model.dev = [[element elementsForName:@"devplatform"][0] stringValue];
        model.expertise = [[element elementsForName:@"expertise"][0] stringValue];
        model.favoriteCount = [[[element elementsForName:@"favoritecount"][0] stringValue] intValue];
        model.fansCount = [[[element elementsForName:@"fanscount"][0] stringValue] intValue];
        model.followersCount = [[[element elementsForName:@"followerscount"][0] stringValue] intValue];
    }
    [self refreshUIWithModel:model];
}

- (void)refreshUIWithModel:(UserInfoModel *)model
{
    [_paImageView setImageURL:model.portraitUrl];
    self.nameLabel.text = model.name;
    self.favouriteCountLabel.text = [NSString stringWithFormat:@"%d",model.favoriteCount];
    self.fansCountLabel.text = [NSString stringWithFormat:@"%d",model.fansCount];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%d",model.followersCount];
    self.joinTimeLabel.text = model.joinTime;
    self.fromLabel.text = model.from;
    self.devLabel.text = model.dev;
    self.expertiseLabel.text = model.expertise;
}

- (void)backToFrontView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更新头像
- (IBAction)updatePortraitImage:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"返回" otherButtonTitles:@"图库",@"拍照 ", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"拍照"])
    {
        //调取系统照相机
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }else if([buttonTitle isEqualToString:@"图库"])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *portraitImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        VPImageCropperViewController *imageCtl = [[VPImageCropperViewController alloc] initWithImage:portraitImage cropFrame:CGRectMake(0, 100,320, 320) limitScaleRatio:3.0];
        imageCtl.delegate = self;
        [self presentViewController:imageCtl animated:YES completion:nil];
    }];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [self startUpdatePortrait:UIImageJPEGRepresentation(editedImage, 0.75f)];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    
}

- (void)startUpdatePortrait:(NSData *) data
{
    //上传图片
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_userinfo_update]];
    [request setPostValue:self.uid forKey:@"uid"];
    [request addData:data withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"portrait"];
    request.delegate = self;
    [request setDidFinishSelector:@selector(requestPortrait:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

- (void)requestPortrait:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request responseString]);
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:[request responseData] options:0 error:nil];
    NSString *xpath = @"/oschina/result";
    NSArray *arr = [document nodesForXPath:xpath error:nil];
    GDataXMLElement *element = arr[0];
    NSString *alertString = [[element elementsForName:@"errorMessage"][0] stringValue];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)goToFavouriteView:(UIButton *)sender{
}
@end
