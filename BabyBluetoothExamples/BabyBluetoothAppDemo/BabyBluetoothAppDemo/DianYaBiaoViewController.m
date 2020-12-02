//
//  DianYaBiaoViewController.m
//  BabyBluetoothAppDemo
//
//  Created by Eason on 2020/11/4.
//  Copyright © 2020 刘彦玮. All rights reserved.
//

#import "DianYaBiaoViewController.h"
#import "VTingPromotView.h"
#import "TableViewCell.h"
@interface DianYaBiaoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSArray *house_Code;
    
}


@property (weak, nonatomic) IBOutlet UITableView *tableview;



/**
 *  标题
 */
@property(nonatomic, strong) NSArray *titles;
/**
 *  占位文字
 */
@property(nonatomic, strong) NSArray *placeHolders;

/**
 *  姓名
 */
@property(nonatomic, weak) UITextField *nameTextField;

/**
 *  年龄
 */
@property(nonatomic, weak) UITextField *ageTextField;

/**
 *  地址
 */
@property(nonatomic, weak) UITextField *addressTextField;

@property(nonatomic, weak) TableViewCell *customCell;

@end

@implementation DianYaBiaoViewController
static NSString * const ID = @"textFieldCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电压表设置";
// NSString *dianya= [[NSUserDefaults standardUserDefaults]objectForKey:@"dianyabiao"];
//    if (dianya ==nil) {
//        _dateString = @"123";
//    }else{
//        _dateString = dianya;
//
////    }
//    _customCell.contentTextField.delegate = self;
//
//
//    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
//    myPickerView.delegate = self;
//    myPickerView.dataSource = self;
//    myPickerView.showsSelectionIndicator = YES;
//    _customCell.contentTextField.inputView = myPickerView;
//    house_Code = [NSArray arrayWithObjects:@"OFF",@"ON",nil];
//
//    [ _customCell.contentTextField addTarget:self action:@selector(textFieldStataEditing:) forControlEvents:UIControlEventEditingDidBegin];
    self.navigationController.delegate= self;
                self.navigationItem.hidesBackButton = NO;
     
       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"←" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
//        self.navigationItem.backBarButtonItem = item;

    
   // [self.tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)backBarButton{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
}
- (IBAction)saveBtn:(id)sender {
    NSLog(@"点击了保存键");
    
    
}

-(void)textFieldStataEditing:(UITextField*)textField{

    if (textField.tag ==1) {

        [textField resignFirstResponder];

        NSLog(@"8888888888888888");

        return;

    }

    if (textField.tag == 0) {

        [textField resignFirstResponder];

        NSLog(@"88888889999999");

        return;

    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
//    NSString *cellIdentifier = @"RemoteRecordCell";
//       //当状态为显示当前的设备列表信息时
//      RemoteRecordCell *cell =  (RemoteRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//       if (cell == nil)
//       {
//           UINib *nib=[UINib nibWithNibName:@"CameraListCell" bundle:nil];
//           [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
//           cell =  (RemoteRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//       }
    // 在这里把每个cell的textField 赋值给 事先声明好的UITextField类型的属性
    // 以后直接操作控制器的这些属性就可以拿到每个textField的值
 
//    switch (indexPath.row) {
//        case 0:
//            // 姓名
//            cell.contentTextField.tag=0;
//            self.nameTextField = cell.contentTextField;
//
//            break;
//        case 1:
//            // 年龄
//            self.ageTextField = cell.contentTextField;
//            break;
//        case 2:
//            // 地址
//            self.addressTextField = cell.contentTextField;
//            break;
//        default:
//            break;
//    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _customCell = (TableViewCell *)cell;
    _customCell.titleLabel.text = self.titles[indexPath.row];
    _customCell.contentTextField.placeholder = self.placeHolders[indexPath.row];
//    if (indexPath.row==0) {
//        _customCell.contentTextField.text=@"121212";
//    }
    
 
    
}



//点击UITextField的响应事件
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
  //点击这个方法 就相当于点击了一个按钮，在这里做自己想做的
    if(textField == _customCell.contentTextField){
        
       
        [textField resignFirstResponder];
        NSLog(@"1111111");
    }
}
 
//点击UITextField--Return响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
    return YES;
}
- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"仪表类型/编号设置",@"报警设置",@"输入选择",@"输入设置",@"显示设置"];
    }
    return _titles;
}
- (NSArray *)placeHolders
{
    if (!_placeHolders) {
        _placeHolders = @[@"请输入类型",@"请输入报警值",@"请选择型号",@"",@"亮度设置"];
    }
    return _placeHolders;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"121212112");
//    if (indexPath.row == 0) {
//        VTingPromotView *view = [[VTingPromotView alloc] initWithFrame:self.view.bounds andStyle:VTingPromotCheck];
//        view.block = ^(NSString *name){
//            NSLog(@"结果为:%@",name);
//            [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"dianyabiao"];
//            //_dateString = name;
//        };
//        [view showPopViewAnimate:YES];
//
//           }
    
 
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
//      [[self.tabBarController tabBar] setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
   
    [self.tableview reloadData];
//      [[self.tabBarController tabBar] setHidden:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
