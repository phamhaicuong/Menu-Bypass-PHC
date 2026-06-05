#import <UIKit/UIKit.h>

// --- 1. KHAI BÁO CẤU TRÚC GIAO DIỆN MENU ---
@interface PHC_BypassMenu : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *urlInput;
@property (nonatomic, strong) UITextField *keyOutput;
@property (nonatomic, strong) UIButton *bypassBtn;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation PHC_BypassMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Nền Menu
        self.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:14.0/255.0 blue:20.0/255.0 alpha:0.95];
        self.layer.cornerRadius = 16.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.45 blue:1.0 alpha:0.4].CGColor;
        
        self.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.45 blue:1.0 alpha:1.0].CGColor;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 15.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        
        // Tiêu đề
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, frame.size.width - 20, 30)];
        titleLabel.text = @"PHẠM HẢI CƯỜNG";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBlack];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.33 blue:1.0 alpha:1.0].CGColor;
        titleLabel.layer.shadowRadius = 8.0;
        titleLabel.layer.shadowOpacity = 1.0;
        titleLabel.layer.shadowOffset = CGSizeMake(0, 0);
        [self addSubview:titleLabel];
        
        // Ô dán link
        self.urlInput = [[UITextField alloc] initWithFrame:CGRectMake(20, 75, frame.size.width - 40, 42)];
        self.urlInput.placeholder = @" Dán link Get Key vào đây...";
        self.urlInput.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:34.0/255.0 blue:51.0/255.0 alpha:1.0];
        self.urlInput.textColor = [UIColor whiteColor];
        self.urlInput.layer.cornerRadius = 8.0;
        self.urlInput.layer.borderWidth = 1.0;
        self.urlInput.layer.borderColor = [UIColor colorWithRed:42.0/255.0 green:59.0/255.0 blue:92.0/255.0 alpha:1.0].CGColor;
        self.urlInput.font = [UIFont systemFontOfSize:13];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
        self.urlInput.leftView = paddingView;
        self.urlInput.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.urlInput];
        
        // Nút Bypass Gradient
        self.bypassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bypassBtn.frame = CGRectMake(20, 135, frame.size.width - 40, 45);
        [self.bypassBtn setTitle:@"BYPASS NGAY" forState:UIControlStateNormal];
        [self.bypassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.bypassBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBlack];
        self.bypassBtn.layer.cornerRadius = 8.0;
        self.bypassBtn.layer.masksToBounds = YES;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bypassBtn.bounds;
        gradient.colors = @[(id)[UIColor colorWithRed:0.0 green:0.33 blue:1.0 alpha:1.0].CGColor, 
                            (id)[UIColor colorWithRed:1.0 green:0.0 blue:0.23 alpha:1.0].CGColor];
        gradient.startPoint = CGPointMake(0.0, 0.5);
        gradient.endPoint = CGPointMake(1.0, 0.5);
        [self.bypassBtn.layer insertSublayer:gradient atIndex:0];
        
        [self.bypassBtn addTarget:self action:@selector(startZenBypassRequest) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bypassBtn];
        
        // Trạng thái
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 195, frame.size.width - 20, 15)];
        self.statusLabel.text = @"Trạng thái: Sẵn sàng";
        self.statusLabel.textColor = [UIColor lightGrayColor];
        self.statusLabel.font = [UIFont italicSystemFontOfSize:12];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];
        
        // Ô xuất Key kết quả
        self.keyOutput = [[UITextField alloc] initWithFrame:CGRectMake(20, 220, frame.size.width - 40, 42)];
        self.keyOutput.placeholder = @" Kết quả Key sẽ xuất hiện ở đây...";
        self.keyOutput.backgroundColor = [UIColor colorWithRed:17.0/255.0 green:21.0/255.0 blue:32.0/255.0 alpha:1.0];
        self.keyOutput.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.53 alpha:1.0];
        self.keyOutput.layer.cornerRadius = 8.0;
        self.keyOutput.layer.borderWidth = 1.0;
        self.keyOutput.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:68.0/255.0 blue:85.0/255.0 alpha:1.0].CGColor;
        self.keyOutput.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        self.keyOutput.textAlignment = NSTextAlignmentCenter;
        
        UIView *paddingViewOut = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
        self.keyOutput.leftView = paddingViewOut;
        self.keyOutput.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.keyOutput];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

// --- 2. GỬI LỆNH LÊN SERVER IZEN ---
- (void)startZenBypassRequest {
    [self endEditing:YES];
    NSString *inputUrl = self.urlInput.text;
    
    if (inputUrl.length == 0 || [inputUrl isEqualToString:@""]) {
        self.statusLabel.text = @"Chưa nhập link kìa sếp!";
        self.statusLabel.textColor = [UIColor systemRedColor];
        return;
    }
    
    self.statusLabel.text = @"Đang bypass ngầm, xin chờ...";
    self.statusLabel.textColor = [UIColor systemOrangeColor];
    self.bypassBtn.enabled = NO;
    self.bypassBtn.alpha = 0.6;
    
    NSString *encodedUrl = [inputUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *apiUrlString = [NSString stringWithFormat:@"https://api.izen.lol/v1/bypass?url=%@", encodedUrl];
    NSURL *url = [NSURL URLWithString:apiUrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bypassBtn.enabled = YES;
            self.bypassBtn.alpha = 1.0;
            
            if (error) {
                self.statusLabel.text = @"Lỗi mạng hoặc Server izen không phản hồi.";
                self.statusLabel.textColor = [UIColor systemRedColor];
                return;
            }
            
            NSError *jsonError = nil;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            
            if (!jsonError && jsonResponse) {
                NSString *extractedKey = jsonResponse[@"destination"] ? jsonResponse[@"destination"] : (jsonResponse[@"key"] ? jsonResponse[@"key"] : jsonResponse[@"result"]);
                
                if (extractedKey && ![extractedKey isEqualToString:@""]) {
                    self.keyOutput.text = extractedKey;
                    self.statusLabel.text = @"Bypass thành công! Bấm để copy.";
                    self.statusLabel.textColor = [UIColor systemGreenColor];
                } else {
                    self.statusLabel.text = @"Thất bại: API không đọc được link này.";
                    self.statusLabel.textColor = [UIColor systemRedColor];
                }
            } else {
                NSString *rawText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (rawText.length > 0) {
                    self.keyOutput.text = rawText;
                    self.statusLabel.text = @"Bypass hoàn tất.";
                    self.statusLabel.textColor = [UIColor systemGreenColor];
                }
            }
        });
    }];
    
    [task resume];
}
@end

// --- ĐÂY CHÍNH LÀ ĐOẠN KHAI BÁO MÀN HÌNH ĐỂ FIX LỖI EXIT CODE 2 ---
@interface LoadingScreenViewController : UIViewController
- (UIView *)view;
@end

// --- 3. TIÊM VÀO GAME ROBLOX ---
%hook LoadingScreenViewController
- (void)viewDidLoad {
    %orig;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat menuWidth = 340;
    CGFloat menuHeight = 290;
    
    PHC_BypassMenu *myMenu = [[PHC_BypassMenu alloc] initWithFrame:CGRectMake((screenWidth - menuWidth) / 2, 80, menuWidth, menuHeight)];
    
    [self.view addSubview:myMenu];
}
%end
