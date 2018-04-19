#import "ViewController.h"
#import "AppDelegate.h"
#include <ServiceManagement/SMLoginItem.h>


static NSString *const MASCustomShortcutKey = @"customShortcut";

static void *MASObservingContext = &MASObservingContext;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auto_login"] == nil) {
    
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"auto_login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
        
    BOOL state = [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_login"];
    [self.autoLoginState setState: !state];
    
    BOOL hideStatusBarState = [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_status_bar"];
    [self.showInMenuBarState setState: hideStatusBarState];
    
    NSLog(@"View Load");
}

-(void)viewDidAppear {
    [super viewDidAppear];
    [[self.view window] setTitle:@"Clock Bar"];
    [[self.view window] center];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    [[[[NSApplication sharedApplication] windows] lastObject] setTitle:@"Clock Bar"];
}

- (IBAction)quitPressed:(id)sender {
    [NSApp terminate:nil]; //TODO or quit about window
}

- (IBAction)onLoginStartChanged:(id)sender {
    NSLog(@"Login start changed");
    NSInteger state = [self.autoLoginState state];
    BOOL enableState = NO;
    if(state == NSOnState) {
        enableState = YES;
    }
    if(SMLoginItemSetEnabled((__bridge CFStringRef)@"Nihalsharma.Clock-Launcher", enableState)) {
        [[NSUserDefaults standardUserDefaults] setBool:!enableState forKey:@"auto_login"];
    }
}

- (IBAction)showMenuBarChanged:(id)sender {

    NSInteger state = [self.showInMenuBarState state];

    BOOL enableState = NO;
    if(state == NSOnState) {
        enableState = YES;
    }

    [[NSUserDefaults standardUserDefaults] setBool:enableState forKey:@"hide_status_bar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    [appDelegate hideMenuBar:enableState];

    
    if (enableState == YES) {
    
        NSString *msgText = @"Long press on the Touch Bar Clock Button to show Preferences when the Menu Item is disabled.";
        
        NSAlert* msgBox = [[NSAlert alloc] init] ;
        [msgBox setMessageText:msgText];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }
    
}


- (IBAction)whiteButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSColor *color = [appDelegate colorWithHexColorString:@"FFFFFF"];
    [[NSUserDefaults standardUserDefaults] setObject:@"FFFFFF" forKey:@"clock_color"];
    [appDelegate changeColor:color];
}

- (IBAction)greenButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSColor *color = [appDelegate colorWithHexColorString:@"00FF00"];
    [[NSUserDefaults standardUserDefaults] setObject:@"00FF00" forKey:@"clock_color"];
    [appDelegate changeColor:color];
}

- (IBAction)pinkButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSColor *color = [appDelegate colorWithHexColorString:@"FE69F3"];
    [[NSUserDefaults standardUserDefaults] setObject:@"FE69F3" forKey:@"clock_color"];
    [appDelegate changeColor:color];
}

- (IBAction)redButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSColor *color = [appDelegate colorWithHexColorString:@"FF0000"];
    [[NSUserDefaults standardUserDefaults] setObject:@"FF00000" forKey:@"clock_color"];
    [appDelegate changeColor:color];
}

- (IBAction)yellowButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSColor *color = [appDelegate colorWithHexColorString:@"FFFF00"];
    [[NSUserDefaults standardUserDefaults] setObject:@"FFFF00" forKey:@"clock_color"];
    [appDelegate changeColor:color];
}

- (IBAction)blueButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSColor *color = [appDelegate colorWithHexColorString:@"30E6FF"];
    [[NSUserDefaults standardUserDefaults] setObject:@"30E6FF" forKey:@"clock_color"];
    [appDelegate changeColor:color];
}

@end
