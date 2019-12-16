#import "AppDelegate.h"
#import "TouchBar.h"
#import <ServiceManagement/ServiceManagement.h>
#import "TouchButton.h"
#import "TouchDelegate.h"
#import <Cocoa/Cocoa.h>

static const NSTouchBarItemIdentifier muteIdentifier = @"ns.clock";
static NSString *const MASCustomShortcutKey = @"customShortcut";

@interface AppDelegate () <TouchDelegate>

@end

@implementation AppDelegate

NSButton *touchBarButton;

@synthesize statusBar;

TouchButton *button;

NSString *STATUS_ICON_BLACK = @"clock-64";

NSDateFormatter *timeformatter;
NSString *format = @"  hh:mm";
NSMutableAttributedString *colorTitle;


- (void) awakeFromNib {
    
    BOOL hideStatusBar = NO;
    BOOL statusBarButtonToggle = NO;
    BOOL useAlternateStatusBarIcons = NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hide_status_bar"] != nil) {
        hideStatusBar = [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_status_bar"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"status_bar_button_toggle"] != nil) {
        statusBarButtonToggle = [[NSUserDefaults standardUserDefaults] boolForKey:@"status_bar_button_toggle"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"status_bar_alternate_icons"] != nil) {
        useAlternateStatusBarIcons = [[NSUserDefaults standardUserDefaults] boolForKey:@"status_bar_alternate_icons"];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:hideStatusBar forKey:@"hide_status_bar"];
    [[NSUserDefaults standardUserDefaults] setBool:statusBarButtonToggle forKey:@"status_bar_button_toggle"];
    [[NSUserDefaults standardUserDefaults] setBool:useAlternateStatusBarIcons forKey:@"status_bar_alternate_icons"];
    
    if (!hideStatusBar) {
        [self setupStatusBarItem];
    }
    
}

- (void) setupStatusBarItem {
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusBar.menu = self.statusMenu;
    
    NSImage* statusImage = [self getStatusBarImage];
    
    statusImage.size = NSMakeSize(18, 18);
    
    [statusImage setTemplate:YES];
    
    self.statusBar.image = statusImage;
    self.statusBar.highlightMode = YES;
    self.statusBar.enabled = YES;
}


- (void) hideMenuBar: (BOOL) enableState {
    
    if (!enableState) {
        [self setupStatusBarItem];
    } else {
        self.statusBar = nil;
    }
}


-(void)changeColor:(id)sender
{
    
    [colorTitle addAttribute:NSForegroundColorAttributeName value:sender range:NSMakeRange(0, button.title.length)];
    [button setAttributedTitle:colorTitle];
}

-(void)UpdateTime:(id)sender
{
    NSString *time  = [timeformatter stringFromDate:[NSDate date]];
    [colorTitle.mutableString setString:time];
    [button setAttributedTitle:colorTitle];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[[[NSApplication sharedApplication] windows] lastObject] close];

    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);
    
    timeformatter = [[NSDateFormatter alloc] init];
    [timeformatter setTimeStyle: NSDateFormatterShortStyle];
    [timeformatter setDateFormat:format];
    
    NSDate *now = [NSDate date];
    NSString *newDateString = [timeformatter stringFromDate:now];
    
    
    button = [TouchButton buttonWithTitle:newDateString target:nil action:nil];
    [button setDelegate: self];
    
    NSFont *systemFont = [NSFont systemFontOfSize:16.0f];
    NSDictionary * fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:systemFont, NSFontAttributeName, nil];

    colorTitle = [[NSMutableAttributedString alloc] initWithString:[button title] attributes:fontAttributes];
    
    NSString *colorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"clock_color"];
    NSColor *color = nil;
    if (colorString == nil){
        color = [NSColor whiteColor];
    } else{
        color = [self getColorForString:colorString];
    }
    
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, button.title.length)];
    [button setAttributedTitle:colorTitle];
    
    
    NSCustomTouchBarItem *time = [[NSCustomTouchBarItem alloc] initWithIdentifier:muteIdentifier];
    time.view = button;
    [NSTouchBarItem addSystemTrayItem:time];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(UpdateTime:) userInfo:nil repeats:YES];

    touchBarButton = button;

    [NSTouchBarItem addSystemTrayItem:time];
    DFRElementSetControlStripPresenceForIdentifier(muteIdentifier, YES);

    [self enableLoginAutostart];
    
}

-(NSColor*)getColorForString:(id)sender{
    return [self colorWithHexColorString:sender];
}


- (NSImage*) getStatusBarImage {

    return [NSImage imageNamed:STATUS_ICON_BLACK];
}


-(void) enableLoginAutostart {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auto_login"] == nil) {
        return;
    }

    BOOL state = [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_login"];
    if(!SMLoginItemSetEnabled((__bridge CFStringRef)@"Nihalsharma.Clock-Launcher", !state)) {
        NSLog(@"The login was not succesfull");
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

-(double) changeState {
    return 0;
}

-(double) changeStateFixed {
    return 0;
}

-(NSColor *)colorState:(double)volume {

    if(!volume) {
        return NSColor.redColor;
    } else {
        return NSColor.clearColor;
    }
}

- (void)onPressed:(TouchButton*)sender
{
    NSLog(@"On Press clicked");
    if ([format isEqual:@"hh:mm"]){
        format = @"HH:mm";
    } else {
        format = @"hh:mm";
    }
    [timeformatter setDateFormat:format];
}

- (void)onLongPressed:(TouchButton*)sender
{
    [[[[NSApplication sharedApplication] windows] lastObject] makeKeyAndOrderFront:nil];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:true];
}

- (IBAction)prefsMenuItemAction:(id)sender {

    [self onLongPressed:sender];
}

- (IBAction)quitMenuItemAction:(id)sender {
    [NSApp terminate:nil];
}

- (NSColor*)colorWithHexColorString:(NSString*)inColorString
{
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}



@end
