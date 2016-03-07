//
//  AppDelegate.m
//  Plover
//
//  Created by Wesley Moore on 13/10/2015.
//  Copyright © 2015 Open Steno Project. All rights reserved.
//

#import "AppDelegate.h"
#import "StenoEngine.h"

@interface AppDelegate () <StenoEngineDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSMenu *statusMenu;

@property (strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification  {
    StenoEngine *engine = [StenoEngine sharedInstance];
    [engine setDelegate:self];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.menu = self.statusMenu;
    NSStatusBarButton *button = self.statusItem.button;
    button.image = [NSImage imageNamed:@"Status Icon Off"];
    
    [engine start];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[StenoEngine sharedInstance] shutdown];
}

#pragma mark - Actions

- (IBAction)togglePlover:(id)sender {
    StenoEngine *engine = [StenoEngine sharedInstance];
    [engine setIsRunning:![engine isRunning]];
}

#pragma mark - StenoEngineDelegate

- (void)stenoEngine:(StenoEngine *)engine stateDidChange:(StenoEngineState)state {
    NSLog(@"%@: %d", NSStringFromSelector(_cmd), (int)newState);

    switch (state) {
        case StenoEngineStateInitializing:
            [self.spinner startAnimation:self];
            break;
            
        case StenoEngineStateRunning:
            [self.spinner stopAnimation:self];
            break;
            
        case StenoEngineStateError:
            [self.spinner stopAnimation:self];
            break;
            
        default:
            break;
    }
    //        if (state != StenoEngineStateNone) {
    //            machine_name = machine_registry.resolve_alias(
    //                self.config.get_machine_type())
    //            # self.machine_status_text.SetLabel('%s: %s' % (machine_name, state))
    //            plovermac.set_machine_status_label('%s: %s' % (machine_name, state))
    //            # self.reconnect_button.Show(state == STATE_ERROR)
    //            # self.spinner.Show(state == STATE_INITIALIZING)
    //            # self.connection_ctrl.Show(state != STATE_INITIALIZING)
    //            # if state == STATE_INITIALIZING:
    //            #     self.spinner.Play()
    //            # else:
    //            #     self.spinner.Stop()
    //            if state == STATE_RUNNING:
    //                # self.connection_ctrl.SetBitmap(self.connected_bitmap)
    //                # plovermac.set_connected(True)
    //                pass
    //            elif state == STATE_ERROR:
    //                # self.connection_ctrl.SetBitmap(self.disconnected_bitmap)
    //                # plovermac.set_connected(False)
    //                pass
    //            # self.machine_status_sizer.Layout()
        }
    //
    //    if (self.steno_engine.machine) {
    ////                    # self.status_button.Enable()
    ////            plovermac.enable_status_button(True)
    ////            plovermac.set_engine_is_running(self.steno_engine.is_running)
    ////            if self.steno_engine.is_running:
    ////                # self.status_button.SetBitmapLabel(self.on_bitmap)
    ////                # self.SetTitle("%s: %s" % (self.TITLE, self.RUNNING_MESSAGE))
    ////                plovermac.set_title("%s: %s" % (self.TITLE, self.RUNNING_MESSAGE))
    ////            else:
    ////                # self.status_button.SetBitmapLabel(self.off_bitmap)
    ////                # self.SetTitle("%s: %s" % (self.TITLE, self.STOPPED_MESSAGE))
    ////                plovermac.set_title("%s: %s" % (self.TITLE, self.STOPPED_MESSAGE))
    //
    //    }
    //    else {
    ////            # self.status_button.Disable()
    ////            plovermac.enable_status_button(False)
    ////            # self.status_button.SetBitmapLabel(self.off_bitmap)
    ////            # self.SetTitle("%s: %s" % (self.TITLE, self.ERROR_MESSAGE))
    ////            plovermac.set_title("%s: %s" % (self.TITLE, self.ERROR_MESSAGE))
    //    }

}

@end
