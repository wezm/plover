//
//  OSPloverMac.m
//  Plover
//
//  Created by Wesley Moore on 28/11/2015.
//  Copyright © 2015 Open Steno Project. All rights reserved.
//

#import "OSPloverMac.h"
#import <Python.h>

static const NSInteger kTogglePloverMenuItemTag = 1;

static PyObject *app_assets_dir(PyObject *self, PyObject *args)
{
    NSString  *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString  *ploverPath = [resourcePath stringByAppendingPathComponent:@"plover"];
    NSString *assetsDir = [ploverPath stringByAppendingPathComponent:@"assets"];
    
    return PyString_FromString([assetsDir UTF8String]);
}

static PyObject *app_program_dir(PyObject *self, PyObject *args)
{
    NSString  *resourcePath = [[NSBundle mainBundle] resourcePath];
    return PyString_FromString([resourcePath UTF8String]);
}

static PyObject *app_config_dir(PyObject *self, PyObject *args)
{
    OSPloverMac *app = [OSPloverMac sharedInstance];
    return PyString_FromString([[app applicationDirectory] fileSystemRepresentation]);
}

static PyObject *request_access_for_assistive_devices(PyObject *self, PyObject *args)
{
    NSDictionary *options = @{(__bridge NSString *)kAXTrustedCheckOptionPrompt: @YES};
    
    if (AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options)) {
        Py_RETURN_TRUE;
    }
    else {
        Py_RETURN_FALSE;
    }
}

static PyObject *set_machine_status_label(PyObject *self, PyObject *args)
{
    const char *status_text;
    if(!PyArg_ParseTuple(args, "s", &status_text)) {
        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
    }
    NSString *statusText = [[NSString alloc] initWithCString:status_text encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        OSPloverMac *app = [OSPloverMac sharedInstance];
        app.label.stringValue = statusText;
    });
    
    
    Py_RETURN_NONE;
}

static PyObject *set_title(PyObject *self, PyObject *args)
{
    const char *title;
    if(!PyArg_ParseTuple(args, "s", &title)) {
        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
    }
    NSString *titleString = [[NSString alloc] initWithCString:title encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        OSPloverMac *app = [OSPloverMac sharedInstance];
        app.window.title = titleString;
    });
    
    Py_RETURN_NONE;
}

static PyObject *set_engine_is_running(PyObject *self, PyObject *args)
{
    int running;
    if(!PyArg_ParseTuple(args, "i", &running)) {
        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        OSPloverMac *app = [OSPloverMac sharedInstance];
        [app setEngineIsRunning:running ? YES : NO];
    });
    
    Py_RETURN_NONE;
}

static PyObject *send_string(PyObject *self, PyObject *args)
{
    const char *cString;
    
    static CGEventSourceRef eventSource = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventSource = CGEventSourceCreate(kCGEventSourceStatePrivate);
    });
    
    if(!PyArg_ParseTuple(args, "s", &cString)) {
        [[NSException exceptionWithName:@"Python Error" reason:@"Invalid parameters to send_string" userInfo:nil] raise];
    }
    
    NSString *string = [[NSString alloc] initWithCString:cString encoding:NSUTF8StringEncoding];
    
    NSLog(@"Send: \"%@\"", string);
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        CGEventRef event = CGEventCreateKeyboardEvent(eventSource, 0, true);
        CGEventKeyboardSetUnicodeString(event, 1, &c);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        
        event = CGEventCreateKeyboardEvent(eventSource, 0, false);
        CGEventKeyboardSetUnicodeString(event, 1, &c);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
    }
    
    Py_RETURN_NONE;
}

static PyObject *enable_status_button(PyObject *self, PyObject *args)
{
    int enable;
    if(!PyArg_ParseTuple(args, "i", &enable)) {
        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        OSPloverMac *app = [OSPloverMac sharedInstance];
        [app setPloverReady:enable ? YES : NO];
    });
    
    Py_RETURN_NONE;
}


static PyObject *quit_application(PyObject *self, PyObject *args)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: Extract all of this Python stuff into a class or something and pass self (as in the instance of that class here)
        OSPloverMac *sender = [OSPloverMac sharedInstance];
        [NSApp terminate:sender];
    });
    
    Py_RETURN_NONE;
}

static PyMethodDef PloverOsLayerMacMethods[] = {
    {"assets_dir",  app_assets_dir, METH_VARARGS, "app_assets_dir"},
    {"program_dir",  app_program_dir, METH_VARARGS, "app_program_dir"},
    {"config_dir",  app_config_dir, METH_VARARGS, "app_config_dir"},
    {"request_access_for_assistive_devices",  request_access_for_assistive_devices, METH_VARARGS, "request_access_for_assistive_devices"},
    {"set_machine_status_label", set_machine_status_label, METH_VARARGS, "set_machine_status_label"},
    {"set_title", set_title, METH_VARARGS, "set_title"},
    {"send_string", send_string, METH_VARARGS, "Send keypresses"},
    {"enable_status_button", enable_status_button, METH_VARARGS, "enable_status_button"},
    {"set_engine_is_running", set_engine_is_running, METH_VARARGS, "set_engine_is_running"},
    {"quit", quit_application, METH_VARARGS, "quit"},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

@interface OSPloverMac ()

@property (strong) NSThread *pythonThread;
@property (assign) PyObject *pModule;

- (void)setEngineIsRunning:(BOOL)running;

@end

@implementation OSPloverMac

+ (instancetype)sharedInstance {
    static OSPloverMac *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [OSPloverMac new];
    });
    
    return sharedInstance;
}

- (NSURL *)applicationDirectory {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    NSURL *dirPath = nil;
    
    // Find the user application support directory
    NSArray *appSupportDir = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        // Append the bundle ID to the URL for the
        // Application Support directory
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        // If the directory does not exist, this method creates it.
        // This method is only available in OS X v10.7 and iOS 5.0 or later.
        NSError *error = nil;
        if (![fileManager createDirectoryAtURL:dirPath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            [[NSException exceptionWithName:[error domain] reason:[error localizedDescription] userInfo:[error userInfo]] raise];
            return nil;
        }
    }
    
    return dirPath;
}

@end
