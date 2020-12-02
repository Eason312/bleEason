//
//  ViewController.m
//  Test
//
//  Created by K.O on 2018/7/20.
//  Copyright © 2018年 rela. All rights reserved.
//

#import "ViewController.h"
#import "InfoModel.h"

#import "PasswordView.h"
#import "PHProgressHUD.h"

#define channelOnPeropheralView @"peripheralView"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *categoryAry;
@property(nonatomic,strong)InfoModel *info;
@property(nonatomic,strong)UITableView *tbView;
@end


NSString *CELLID = @"NormalCellID";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"仪表设置";
    
    self.navigationController.delegate= self;
//                self.navigationItem.hidesBackButton = NO;
//
//       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"←" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    self.categoryAry = @[@"仪表/编号设置",@"报警设置",@"输入选择",@"输入设置",@"显示设置",@"固件升级"];
    UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    
    UIButton  *birthDayActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    birthDayActionBtn.frame = CGRectMake(self.view.bounds.size.width/2-150, 375, 300, 50);
    [birthDayActionBtn setTitle:@"保存设置" forState:0];
    birthDayActionBtn.backgroundColor = [UIColor blueColor];
    birthDayActionBtn.layer.cornerRadius = 12;
    birthDayActionBtn.layer.masksToBounds = YES;
//    birthDayActionBtn.titleLabel.font = LJFontRegularText(12);
    [birthDayActionBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:0];
    [self.view addSubview:birthDayActionBtn];
    [birthDayActionBtn addTarget:self action:@selector(clickBirthDayDateFilterAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [tbView addSubview:birthDayActionBtn];
    
    
    [self.view addSubview:tbView];
    tbView.tableFooterView = [[UIView alloc]init];
    
    tbView.delegate = self;
    
    tbView.dataSource = self;
    
    self.info = [[InfoModel alloc] init];
    
    [tbView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:CELLID];
    
    self.tbView = tbView;
    
    
    //初始化
    self.services = [[NSMutableArray alloc]init];
    [self babyDelegateN];

    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    [SVProgressHUD showInfoWithStatus:@"准备连接设备"];
    
    
    
    
    
    
    
    
    
}
//babyDelegate
-(void)babyDelegateN{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];

    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        [weakSelf writeValue];
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];

    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
//        if (<#condition#>) {
//            [bry beatsOver];
//        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
    */
     NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
     
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}
-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}
#pragma mark -插入table数据
-(void)insertSectionToTableView:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.services.count-1];
  //  [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)writeValue{
//    int i = 1;
  //  Byte b = 0X01;
//// NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
//    byte bytes = new byte[6];
//           bytes[0]= (byte) 0xAB;
//           bytes[1]= (byte) 0x03;
//           bytes[2]= (byte) 0x00;
//           bytes[3]= (byte) 0x01;
//           bytes[4]= (byte) 0x55;
//           bytes[5] = DataProcessing.genVerifyCode(bytes);
    
//    Byte data[];
//    data[0] = 0xAB;
//    data[1] = 0x03;
//    data[2] = 0x00;
//    data[3] = 0x01;
//    data[4] = 0x55;
//    data[5] = 0x05;
//    Byte byte[] = {0xAB,0x03,0x00,0x01,0x55,5};
//    NSData *data = [[NSData alloc] initWithBytes:byte length:6];
  //  NSData *data = [[NSData alloc] initWithBytes:data length:6];
    Byte byte[6];
    byte[0] = 0xAB;
    byte[1] = 0x03;
    byte[2] = 0x00;
    byte[3] = 0x01;
    byte[4] = 0x55;
    byte[5] = byte[0]+byte[1]+byte[2]+byte[3]+byte[4];
    
    NSData *data = [NSData dataWithBytes:byte length:6];
   // [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}
-(void)insertRowToTableView:(CBService *)service{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        PeripheralInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        PeripheralInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
            NSLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        PeripheralInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
     //   [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }

    
}

//退出时断开连接
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

//-(void)backBarButton{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    //[self dismissModalViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:NO completion:nil];
//
//
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryAry.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];

    cell.category =self.categoryAry[indexPath.row];
    cell.info = self.info;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PickerView *vi = [[PickerView alloc] init];
    vi.tag = 100+indexPath.row;
    vi.delegate = self;
  // // PasswordView *infoO =[[PasswordView alloc] init];
//    if (indexPath.row==6) {
//        vi.type = PickerViewTypeSex;
//
//    }
    
    if (indexPath.row==1) {
        PasswordView* passView = [[PasswordView alloc] initWithTitle:@"电压(8-16V)" cancelBtn:@"取消" sureBtn:@"确定" btnClickBlock:^(NSInteger index,NSString* str) {
            if (index == 0) {
                NSLog(@"0000000");
            }else if (index == 1){
                NSLog(@"111111");

                int intString = [str intValue];
                if (intString < 8||intString > 16) {
                    [PHProgressHUD showError:@"无效值输入"];
                }else{
                    self.info.heigh = [NSString stringWithFormat:@"%@",str];;

                }


                NSLog(@"^^^^^%d",intString);

            }

        }];
        [passView show];
//        vi.type = PickerViewTypeHeigh;
//        vi.selectComponent = 2;
        //[self.view addSubview:vi];
    }
  
  //  [self.tbView reloadData];
    if (indexPath.row==2) {
        vi.type = PickerViewTypeWeight;
        [self.view addSubview:vi];
    }
    if (indexPath.row==3) {
        vi.type = PickerViewTypeBirthday;
        [self.view addSubview:vi];
    }
    
    if (indexPath.row==4) {
        vi.type = PickerViewTypeTime;
        [self.view addSubview:vi];
    }
    
    
    if (indexPath.row==5) {
        vi.array = [self rangAry];
        vi.type = PickerViewTypeRange;
        vi.selectComponent = 2;
        [self.view addSubview:vi];
        
    }
    
    if (indexPath.row==0) {
        vi.type = PickerViewTypeCity;
        [self.view addSubview:vi];
    }
    [self.tbView reloadData];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
;
    [self.tbView reloadData];
    NSLog(@"将要出现");
}

- (void)viewDidAppear:(BOOL)animated{
    [self.tbView reloadData];
    NSLog(@"已经出现");
}

-(void)clickBirthDayDateFilterAction
{
    NSLog(@"点击了保存设置");
    NSLog(@"结果：%@-%@-%@-%@-%@-%@",self.info.city, self.info.heigh,self.info.weight,self.info.birthday, self.info.time, self.info.rang);
}
-(void)pickerView:(UIView *)pickerView result:(NSString *)string{
    
    NSLog(@"结果：%@-%@-%@-%@-%@-%@",self.info.city, self.info.heigh,self.info.weight,self.info.birthday, self.info.time, self.info.rang);
    
//    if (pickerView.tag-100==6) {
//
//        self.info.sex = string;
//
//
//    }
    if (pickerView.tag-100==0) {
        self.info.city = string;
        NSLog(@"city：%@",string);
        
        
    }
    if (pickerView.tag-100==1) {
      self.info.heigh = [NSString stringWithFormat:@"%@",string];;
    }
    
    if (pickerView.tag-100==2) {
       self.info.weight = [NSString stringWithFormat:@"%@",string];
    }
    if (pickerView.tag-100==3) {
        self.info.birthday = string;
    }
    
    if (pickerView.tag-100==4) {
        self.info.time = string;
    }
    
    
    if (pickerView.tag-100==5) {
    self.info.rang = string;
        
        
    }
    
  
    
    [self.tbView reloadData];
}





- (NSMutableArray *)rangAry{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 100; i <= 120; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arr addObject:str];
    }
    return arr;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
