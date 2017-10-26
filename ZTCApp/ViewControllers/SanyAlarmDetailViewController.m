//
//  SanyAlarmDetailViewController.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/22.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "SanyAlarmDetailViewController.h"
#import "SanyDealMsgTableViewCell.h"
#import "SanyImgSelectorTableViewCell.h"
#import "SubmitTableViewCell.h"

@interface SanyAlarmDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITableView *_detailView;
    UIAlertController *_alertViewController;

    CGFloat _dealMsgCellHeight;
    UIImage *_image;
}

// 处理意见的textView
@property (nonatomic, weak) UITextView *dealMsgTextView;
@property (nonatomic, weak) SanyImgSelectorTableViewCell *imgCell;

@end

@implementation SanyAlarmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"违法详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _detailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 64.0) style:UITableViewStylePlain];
    [_detailView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailCell"];
    [_detailView registerNib:[UINib nibWithNibName:@"SanyDealMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"dealmsgCell"];
    [_detailView registerNib:[UINib nibWithNibName:@"SubmitTableViewCell" bundle:nil] forCellReuseIdentifier:@"submitCell"];
    [_detailView registerNib:[UINib nibWithNibName:@"SanyImgSelectorTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImageSelectorCell"];
    _detailView.dataSource = self;
    _detailView.delegate = self;
    _detailView.allowsSelection = NO;
    _detailView.separatorColor = [UIColor clearColor];
    [_detailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailViewTapped:)]];
    [self.view addSubview:_detailView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    _alertViewController = [UIAlertController alertControllerWithTitle:@"照片选择" message:@"选择照片来源" preferredStyle:UIAlertControllerStyleAlert];

    UIImagePickerController *imagePickVC = [[UIImagePickerController alloc] init];
    // 设置代理对象
    imagePickVC.delegate = self;
    // 开启编辑模式
    imagePickVC.allowsEditing = YES;
    // 设置媒体类型
    imagePickVC.mediaTypes = @[ @"public.image" ];

    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"从相册"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     imagePickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                     [self presentViewController:imagePickVC animated:YES completion:nil];
                                                 }];
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"拍照"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     // 要打开摄像头
                                                     if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                                                         imagePickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                         [self presentViewController:imagePickVC animated:YES completion:nil];
                                                     } else {
                                                         NSLog(@"%@", @"当前设备不支持拍摄");
                                                         return;
                                                     }
                                                 }];
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [_alertViewController addAction:act1];
    [_alertViewController addAction:act2];
    [_alertViewController addAction:act3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)detailViewTapped:(UIGestureRecognizer *)sender {
    // 收键盘
    [self.dealMsgTextView resignFirstResponder];
}

- (void)submitButtonClicked:(UIButton *)sender {
    // 上传图片
    if (_image == nil) {
        NSLog(@"照片为空");
        return;
    }
    [SANYRequestUtils sanyUploadImage:_image
                               result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                   NSLog(@"文件名:%@", result[@"rows"]);
                               }];
    // 提交按键
    NSLog(@"提交：");
}

- (void)imageSelectorButtonClicked:(UIButton *)sender {
    [self presentViewController:_alertViewController animated:YES completion:nil];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"%@   %@", self.detailInfo[@"sfName"], self.detailInfo[@"eiName"]];
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"违规原因: %@", self.detailInfo[@"paraNameShow"]];
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"违规时间: %@", self.detailInfo[@"startTime"]];
            break;
        }
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"已处理人: %@", self.detailInfo[@"dealer"]];
            break;
        }
        case 4: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.text = [NSString stringWithFormat:@"已处理意见: %@", self.detailInfo[@"dealContent"]];
            break;
        }
        case 5: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"处理时间: %@", self.detailInfo[@"dealTime"]];
            break;
        }
        case 6: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"dealmsgCell" forIndexPath:indexPath];
            SanyDealMsgTableViewCell *dealCell = (SanyDealMsgTableViewCell *) cell;
            self.dealMsgTextView = dealCell.dealTextView;
            break;
        }
        case 7: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ImageSelectorCell" forIndexPath:indexPath];
            SanyImgSelectorTableViewCell *imgSelectorCell = (SanyImgSelectorTableViewCell *) cell;
            [imgSelectorCell addTarget:self selector:@selector(imageSelectorButtonClicked:)];
            self.imgCell = imgSelectorCell;
            break;
        }
        case 8: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell" forIndexPath:indexPath];
            SubmitTableViewCell *submitCell = (SubmitTableViewCell *) cell;
            [submitCell addTarget:self selector:@selector(submitButtonClicked:)];
            break;
        }
        default: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        NSString *content = [NSString stringWithFormat:@"已处理意见: %@", self.detailInfo[@"dealContent"]];
        UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        //设置一个行高上限
        CGSize size = CGSizeMake(320, 2000);
        //计算实际frame大小，并将label的frame变成实际大小
        CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        _dealMsgCellHeight = labelsize.height * 2 + 20.0f;
        return _dealMsgCellHeight;
    } else if (indexPath.row == 6) {
        return 120.0f;
    } else if (indexPath.row == 7) {
        return 230.0f;
    } else {
        return 44.0f;
    }
}

//点击相册的取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//照片处理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *, id> *)editingInfo {
    NSLog(@"editingInfo:%@", editingInfo);
    [picker dismissViewControllerAnimated:YES completion:nil];
    _image = image;
    [self.imgCell setImageForSelectorButton:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

#pragma mark - keyboard events -

#define INTERVAL_KEYBOARD 10
///键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    [_detailView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionTop];
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (5 * 44 + 170.0 + _dealMsgCellHeight + INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);

    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //将视图上移计算好的偏移
    if (offset > 0) {
        [UIView animateWithDuration:duration
                         animations:^{
                             self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
                         }];
    }
}

///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //视图下沉恢复原状
    [UIView animateWithDuration:duration
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }];
}

@end
