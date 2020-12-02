//
//  ttttViewController.m
//  BabyBluetoothAppDemo
//
//  Created by Eason on 2020/10/27.
//  Copyright © 2020 刘彦玮. All rights reserved.
//

#import "ttttViewController.h"
#import "SVProgressHUD.h"
#import "RadarView.h"
#import "LXBannerView.h"
#import "RemoteRecordCell.h"
#import "ViewController.h"
#import "WKFRadarView.h"

#import "CXAlterButton.h"
#import "CXAlterItemButton.h"
#import "AboutUsViewController.h"
#import "HcdActionSheet.h"

#import "DianYaBiaoViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface ttttViewController ()<CXAlterButtonDelegate>{
    NSMutableArray *peripheralDataArray;
    BabyBluetooth *baby;
    __weak IBOutlet UIImageView *viewImage;
    
    WKFRadarView *rv ;
    __weak IBOutlet UIView *AddView;
    
    __weak IBOutlet UIButton *searchBtn;
    
    UIView *view;
    
}

@property (nonatomic, strong) LXBannerView *bannerView;
@end
static NSString *const ZTBLanguageChangedNotification = @"ZTBLanguageChangedNotification"; //
//当前语言
static NSString *const appLanguage = @"appLanguage";
@implementation ttttViewController
#pragma mark - lazy load
- (LXBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [LXBannerView bannerViewWithFrame:CGRectMake(0, 0,Width , 300) style:LXBannerViewStyle_Loop imgArray:@[@"timg.jpeg", @"timg.jpeg", @"timg.jpeg", @"timg.jpeg", @"timg.jpeg"]];
//#warning 自定义是否开启定时轮播（openTimer为YES开启，openTimer为No或者下面代码不写均为关闭）
//        _bannerView.openTimer = NO;
//        if (_bannerView.startTimerBlock) {
//            _bannerView.startTimerBlock(2.0);
//        }
    }
    return _bannerView;
}
- (void)viewDidLoad {
    
  
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
      [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
  //  AddView.backgroundColor=[UIColor clearColor];
    
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height+100)];
    view.backgroundColor = [UIColor blackColor];
   
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backg"]];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_background"]];
//    self.tableView.backgroundColor = [UIColor clearColor];
//               [self.tableView setBackgroundView:imageView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RemoteRecordCell" bundle:nil] forCellReuseIdentifier:@"RemoteRecordCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   // [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    NSLog(@"viewDidLoad");
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    CXAlterButton *button = [[CXAlterButton alloc]initWithImage:[UIImage imageNamed:@"add_fill"]highLightImage:[UIImage imageNamed:@"add-Highed"] Direction:DirectionTypeUp];
    
    CXAlterItemButton *item1 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"lllll"]];
    
    CXAlterItemButton *item2 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"about"]];
    
   // CXAlterItemButton *item3 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"item3"]];
    
    [button addButtonItems:@[item1, item2]];
    
    button.buttonCenter = CGPointMake(AddView.frame.size.width/2-25, AddView.frame.size.height-70);
    button.buttonSize = CGSizeMake(50, 50);
    button.animationDuration = 0.5;
    button.delegate = self;
    [AddView addSubview:button];
    
    
    

    [self.view addSubview:self.bannerView];
    [self.view addSubview:view];
    [view addSubview:searchBtn];
   
    
}
#pragma mark 加号的点击处
- (void)AlterButton:(CXAlterButton *)button clickItemButtonAtIndex:(NSUInteger)index
{
    NSLog(@"you clicked  %lu button", (unsigned long)index);
    [baby cancelScan];
    if ((unsigned long)index == 1) {
        AboutUsViewController*mima = [AboutUsViewController new];
        [self.navigationController pushViewController:mima animated:YES];
    }
    if ((unsigned long)index == 0) {
        HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"英文",@"中文"]
attachTitle:@"切换语言设置"];
                                                                                                     
sheet.seletedButtonIndex  = ^(NSInteger index) {
 NSLog(@"%ld", (long)index);
    if ((long)index==1) {
        NSLog(@"你选择了英文");
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:appLanguage];
          [[NSUserDefaults standardUserDefaults] synchronize];
           [[NSNotificationCenter defaultCenter] postNotificationName:ZTBLanguageChangedNotification object:nil];
    }else if((long)index==2){
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:appLanguage];
           [[NSUserDefaults standardUserDefaults] synchronize];
           [[NSNotificationCenter defaultCenter] postNotificationName:ZTBLanguageChangedNotification object:nil];
        NSLog(@"你选择了中文");
        
    }
};
            //Log out? Disconnect from the trailer."
            //Localized(@"LogoutKUS")
[[UIApplication sharedApplication].keyWindow addSubview:sheet];
[sheet showHcdActionSheet];
    }
    
    
}


//-(void)viewDidAppear:(BOOL)animated{
//    NSLog(@"viewDidAppear");
// 
//    //baby.scanForPeripherals().begin().stop(10);
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    NSLog(@"viewWillDisappear");
// //   searchVViewController*mima = [[searchVViewController alloc]init];
//   //  [self.navigationController pushViewController:mima animated:YES];
//   // [self presentViewController:mima animated:NO completion:nil];
//}
//-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"0000000000000000000000");
//   // [self.view addSubview:searchBtn];
//   // viewImage.hidden = NO;
//  
//}
- (IBAction)searchB:(UIButton *)sender {
    
    [self babyDelegate];
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    
    
   
    
    sender.enabled = NO;
    CGFloat sw = Width;
    CGFloat sh = Height;
    dispatch_source_t disTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
     __block int i = 5;
     dispatch_source_set_timer(disTimer, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0ull * NSEC_PER_SEC);
     dispatch_source_set_event_handler(disTimer, ^{
         
//         float KMainWidth = [UIScreen mainScreen].bounds.size.width;
//         float KMainHeight = [UIScreen mainScreen].bounds.size.height;
         
         [self.view setBackgroundColor:[UIColor whiteColor]];
         rv = [[WKFRadarView alloc]initWithFrame:CGRectMake(0, (Width-Height)/2, Width, Width) andThumbnail:@"uuuu"];
         [self.view addSubview:rv];
        // RadarView *rv = [[RadarView alloc] initWithFrame:CGRectMake(0 , 0, sw / 2, sw / 2)];
     if (--i > 0) {
     [sender setTitle:[NSString stringWithFormat:@"正在搜索..."] forState:UIControlStateNormal];
         [rv animationWithDuraton:3   ];
         rv.center = CGPointMake(sw / 2, sh / 2);
         [self.view addSubview:rv];
     }
     else {
         dispatch_source_cancel(disTimer);
     }
     });
     dispatch_source_set_cancel_handler(disTimer, ^{
     NSLog(@"timer cancle");
     sender.enabled = YES;
         searchBtn.hidden= YES;
//         viewImage.hidden = YES;
         view.hidden = YES;
         rv.hidden = YES;
         
    
         
         
     //[sender setTitle:@"搜索仪表..." forState:UIControlStateNormal];
     });
    
     dispatch_resume(disTimer);
  
    
    
}





#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
   
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
#pragma mark--过滤设备的方法
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {

        //最常用的场景是查找某一个前缀开头的设备
//        if ([peripheralName hasPrefix:@"Eason"] ) {
//            return YES;
//        }
//        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];

    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
       
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
        
        参数分别使用在下面这几个地方，若不使用参数则传nil
        - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
        - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
        - [peripheral discoverServices:discoverWithServices];
        - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
        
        该方法支持channel版本:
            [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    

}




#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSArray *peripherals = [peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [peripheralDataArray addObject:item];
        
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return peripheralDataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *cellIdentifier = @"RemoteRecordCell";
       //当状态为显示当前的设备列表信息时
      RemoteRecordCell *cell =  (RemoteRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       if (cell == nil)
       {
           UINib *nib=[UINib nibWithNibName:@"CameraListCell" bundle:nil];
           [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
           cell =  (RemoteRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       }
    
    
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    //蓝牙名字
   // cell.textLabel.text = peripheralName;
    //信号和服务
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    cell.nameLabel.text = peripheralName;
   // [cell.BtnBle setImage:[UIImage imageNamed:@"uuuu"] forState:UIControlStateHighlighted];
    
    [cell.BtnBle addTarget:self
        action:@selector(BtnClick)
      forControlEvents:UIControlEventTouchUpInside];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


//MyView中的按钮的事件
- (void)BtnClick
{
 
    NSLog(@"-=-=-=-=-=-=-=-=-=-=");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    [baby cancelScan];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

   ViewController *vc = [[ViewController alloc]init];
    
   // PeripheralViewController *vc = [[PeripheralViewController alloc]init];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    vc.currPeripheral = peripheral;
  vc->baby = self->baby;
 [self.navigationController pushViewController:vc animated:YES];


}





//CATransition *transition = [CATransition animation];
//transition.duration = 0.3;
//transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//transition.type = kCATransitionPush;
//transition.subtype = kCATransitionFromLeft;
//[self.view.window.layer addAnimation:transition forKey:nil];
//[self dismissModalViewControllerAnimated:NO];


@end
