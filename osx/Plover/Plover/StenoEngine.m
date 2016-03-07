//
//  StenoEngine.m
//  Plover
//
//  Created by Wesley Moore on 29/11/2015.
//  Copyright © 2015 Open Steno Project. All rights reserved.
//

#import "StenoEngine.h"
#import <Python.h>

#pragma mark - Python Bindings

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
    StenoEngine *app = [StenoEngine sharedInstance];
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

//static PyObject *set_machine_status_label(PyObject *self, PyObject *args)
//{
//    const char *status_text;
//    if(!PyArg_ParseTuple(args, "s", &status_text)) {
//        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
//    }
//    NSString *statusText = [[NSString alloc] initWithCString:status_text encoding:NSUTF8StringEncoding];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        OSPloverMac *app = [OSPloverMac sharedInstance];
//        app.label.stringValue = statusText;
//    });
//    
//    
//    Py_RETURN_NONE;
//}
//
//static PyObject *set_title(PyObject *self, PyObject *args)
//{
//    const char *title;
//    if(!PyArg_ParseTuple(args, "s", &title)) {
//        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
//    }
//    NSString *titleString = [[NSString alloc] initWithCString:title encoding:NSUTF8StringEncoding];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        OSPloverMac *app = [OSPloverMac sharedInstance];
//        app.window.title = titleString;
//    });
//    
//    Py_RETURN_NONE;
//}
//
//static PyObject *set_engine_is_running(PyObject *self, PyObject *args)
//{
//    int running;
//    if(!PyArg_ParseTuple(args, "i", &running)) {
//        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        OSPloverMac *app = [OSPloverMac sharedInstance];
//        [app setEngineIsRunning:running ? YES : NO];
//    });
//    
//    Py_RETURN_NONE;
//}

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

//static PyObject *enable_status_button(PyObject *self, PyObject *args)
//{
//    int enable;
//    if(!PyArg_ParseTuple(args, "i", &enable)) {
//        [[NSException exceptionWithName:@"Python Error" reason:@"Unable to extract parameter" userInfo:nil] raise];
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        OSPloverMac *app = [OSPloverMac sharedInstance];
//        [app setPloverReady:enable ? YES : NO];
//    });
//    
//    Py_RETURN_NONE;
//}
//
//
//static PyObject *quit_application(PyObject *self, PyObject *args)
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // TODO: Extract all of this Python stuff into a class or something and pass self (as in the instance of that class here)
//        OSPloverMac *sender = [OSPloverMac sharedInstance];
//        [NSApp terminate:sender];
//    });
//    
//    Py_RETURN_NONE;
//}

// Ideally these would not be string constants, but instead and enum
// but the Python code throws around strings.
static const char *COMMAND_SUSPEND         = "SUSPEND";
static const char *COMMAND_ADD_TRANSLATION = "ADD_TRANSLATION";
static const char *COMMAND_LOOKUP          = "LOOKUP";
static const char *COMMAND_RESUME          = "RESUME";
static const char *COMMAND_TOGGLE          = "TOGGLE";
static const char *COMMAND_CONFIGURE       = "CONFIGURE";
static const char *COMMAND_FOCUS           = "FOCUS";
static const char *COMMAND_QUIT            = "QUIT";

static PyObject *consume_command(PyObject *self, PyObject *args)
{
    // Unpack the arguments to get the command
    const char *command;
    StenoEngine *engine = [StenoEngine sharedInstance];

    if(!PyArg_ParseTuple(args, "s", &command)) {
        [[NSException exceptionWithName:@"Python Error" reason:@"Invalid parameters to consume_command" userInfo:nil] raise];
    }
    
    // These commands can be used whether plover is active or not.
    if (strcmp(command, COMMAND_RESUME) == 0) {
//        self.steno_engine.set_is_running(True)
        [engine setIsRunning:YES];
        
        Py_RETURN_TRUE;
    }
    else if (strcmp(command, COMMAND_TOGGLE) == 0) {
//        self.steno_engine.set_is_running(not self.steno_engine.is_running)
        [engine setIsRunning:![engine isRunning]];
        Py_RETURN_TRUE;
    }
    else if (strcmp(command, COMMAND_QUIT) == 0) {
//        self._quit()
        Py_RETURN_TRUE;
    }

    if (![engine isRunning]) {
        Py_RETURN_FALSE;
    }
    
    
    // These commands can only be run when plover is active.
    if (strcmp(command, COMMAND_SUSPEND) == 0) {
//        self.steno_engine.set_is_running(False)
        [engine setIsRunning:NO];
        Py_RETURN_TRUE;
    }
    else if (strcmp(command, COMMAND_CONFIGURE) == 0) {
//        self._show_config_dialog()
        Py_RETURN_TRUE;
    }
    else if (strcmp(command, COMMAND_FOCUS) == 0) {
//            def f():
//                self.Raise()
//                self.Iconize(False)
//            f()
        Py_RETURN_TRUE;
    }
    else if (strcmp(command, COMMAND_ADD_TRANSLATION) == 0) {
//        plover.gui.add_translation.Show(self, self.steno_engine, self.config)
        Py_RETURN_TRUE;
    }
    else if (strcmp(command, COMMAND_LOOKUP) == 0) {
//        plover.gui.lookup.Show(self, self.steno_engine, self.config)
        Py_RETURN_TRUE;
    }
    
    Py_RETURN_FALSE;
}

static const char *STATE_STOPPED      = "closed";
static const char *STATE_INITIALIZING = "initializing";
static const char *STATE_RUNNING      = "connected";
static const char *STATE_ERROR        = "disconnected";

// Called for changes of the is_running state
static PyObject *update_status(PyObject *self, PyObject *args) {
    const char *state;
    
    if(!PyArg_ParseTuple(args, "z", &state)) { // z = (string, Unicode or None) [const char *], NULL if None
        [[NSException exceptionWithName:@"Python Error" reason:@"Invalid parameters to update_status" userInfo:nil] raise];
    }

    NSLog(@"update_status: %s", state ? state : "None");
    
    // Turn state string into enum value
    StenoEngineState newState;
    if (state == NULL) {
        newState = StenoEngineStateNone;
    }
    else if (strcmp(state, STATE_STOPPED) == 0) {
        newState = StenoEngineStateStopped;
    }
    else if (strcmp(state, STATE_INITIALIZING) == 0) {
        newState = StenoEngineStateInitializing;
    }
    else if (strcmp(state, STATE_RUNNING) == 0) {
        newState = StenoEngineStateRunning;
    }
    else if (strcmp(state, STATE_ERROR) == 0) {
        newState = StenoEngineStateError;
    }
    else {
        NSString *reason = [NSString stringWithFormat:@"Unknown state, '%s', in update_status", state];
        [[NSException exceptionWithName:@"Steno Engine Error" reason:reason userInfo:nil] raise];
    }
    
    [[[StenoEngine sharedInstance] delegate] stenoEngine:[StenoEngine sharedInstance] stateDidChange:newState];

    Py_RETURN_NONE;
}

static PyMethodDef PloverOsLayerMacMethods[] = {
    {"assets_dir",  app_assets_dir, METH_VARARGS, "app_assets_dir"},
    {"program_dir",  app_program_dir, METH_VARARGS, "app_program_dir"},
    {"config_dir",  app_config_dir, METH_VARARGS, "app_config_dir"},
    {"request_access_for_assistive_devices",  request_access_for_assistive_devices, METH_VARARGS, "request_access_for_assistive_devices"},
//    {"set_machine_status_label", set_machine_status_label, METH_VARARGS, "set_machine_status_label"},
//    {"set_title", set_title, METH_VARARGS, "set_title"},
    {"send_string", send_string, METH_VARARGS, "Send keypresses"},
//    {"enable_status_button", enable_status_button, METH_VARARGS, "enable_status_button"},
//    {"set_engine_is_running", set_engine_is_running, METH_VARARGS, "set_engine_is_running"},
//    {"quit", quit_application, METH_VARARGS, "quit"},
    {"consume_command", consume_command, METH_VARARGS, "consume_command"},
    {"update_status", update_status, METH_VARARGS, "update_status"},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

#pragma mark - Steno Engine

@interface StenoEngine ()

@property (strong) NSThread *pythonThread;
@property (assign) PyObject *pModule;

- (NSURL *)applicationDirectory;

@end

@implementation StenoEngine

+ (instancetype)sharedInstance {
    static StenoEngine *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [StenoEngine new];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pythonThread = [[NSThread alloc] initWithTarget:self selector:@selector(runPlover) object:nil];
    }
    return self;
}

- (void)start {
    [self.pythonThread start];
}

- (void)shutdown {
    if (self.pModule != NULL) {
        Py_DECREF(self.pModule);
        self.pModule = NULL;
    }
}

- (void)runPlover {
    Py_SetProgramName("plover");  /* optional but recommended */
    
    PyObject *pName, *pFunc;
    PyObject *pArgs, *pValue;
    
    Py_Initialize();
    
    // Set up the search path to include the plover code
    // TODO: Extract into method appendPath:@foo"
    NSString  *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString  *ploverPath = [resourcePath stringByAppendingPathComponent:@"plover"];
    NSString  *virtualenvPath = [resourcePath stringByAppendingPathComponent:[NSString  pathWithComponents:@[@"virtualenv", @"lib", @"python2.7", @"site-packages"]]];
    NSString  *pythonInitFormat =
    @"import sys\n"
    @"import site\n"
    @"site.addsitedir('%@')\n"
    @"sys.path.append('%@')\n"
    @"sys.path.append('%@')\n"
    ;
    
    NSString  *pythonInit = [NSString stringWithFormat:pythonInitFormat, virtualenvPath, resourcePath, ploverPath];
    if (PyRun_SimpleString([pythonInit UTF8String]) != 0) {
        [[NSException exceptionWithName:@"Python Error" reason:@"Error initialising the python interpreter" userInfo:nil] raise];
    }
    //    PyRun_SimpleString("print sys.path\nprint site.getsitepackages()");
    
    Py_InitModule("plovermac", PloverOsLayerMacMethods);
    
    pName = PyString_FromString("main");
    /* Error checking of pName left out */
    
    self.pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    
    if (self.pModule != NULL) {
        
        pFunc = PyObject_GetAttrString(self.pModule, "main");
        /* pFunc is a new reference */
        
        // Call the main function
        if (pFunc && PyCallable_Check(pFunc)) {
            pArgs = PyTuple_New(0);
            //            PyObject *pyConfigFilePath = PyString_FromString([configFile fileSystemRepresentation]);
            //            NSAssert(pyConfigFilePath != NULL, nil);
            //            PyTuple_SetItem(pArgs, 0, pyConfigFilePath);
            
            NSLog(@"Calling Python main");
            pValue = PyObject_CallObject(pFunc, pArgs);
            NSLog(@"Python main returned");
            Py_DECREF(pArgs);
            if (pValue != NULL) {
                printf("Result of call: %ld\n", PyInt_AsLong(pValue));
                Py_DECREF(pValue);
            }
            else {
                Py_DECREF(pFunc);
                Py_DECREF(self.pModule);
                PyErr_Print();
                fprintf(stderr,"Call failed\n");
            }
        }
        else {
            if (PyErr_Occurred())
                PyErr_Print();
            fprintf(stderr, "Cannot find function\n");
        }
        Py_XDECREF(pFunc);
        Py_DECREF(self.pModule);
    }
    else {
        PyErr_Print();
        fprintf(stderr, "Failed to load\n");
    }
    Py_Finalize();
}

- (IBAction)togglePlover:(id)sender {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Retrieve the gui
    PyObject *pGuiObject;
    
    pGuiObject = PyObject_GetAttrString(self.pModule, "gui");
    if (pGuiObject && PyInstance_Check(pGuiObject)) {
        PyObject *pToggleMeth;
        NSLog(@"Got GUI");
        
        pToggleMeth = PyObject_GetAttrString(pGuiObject, "toggle_steno_engine");
        if (pToggleMeth && PyCallable_Check(pToggleMeth)) {
            NSLog(@"Calling toggle_steno_engine");
            PyObject *pArgs = PyTuple_New(0);
            PyObject *pRet = PyObject_CallObject(pToggleMeth, pArgs);
            Py_DECREF(pArgs);
            Py_XDECREF(pRet);
        }
        else {
            NSLog(@"Error getting toggle_steno_engine");
        }
        Py_XDECREF(pToggleMeth);
        
        
        //        PyObject *pRet = PyObject_CallMethod(pGuiObject, "", );
        //        Py_DECREF(pRet);
    }
    else {
        NSLog(@"Error getting gui");
    }
    Py_XDECREF(pGuiObject);
    
    /* Perform Python actions here. */
    //    result = CallSomeFunction();
    /* evaluate result or handle exception */
    
    /* Release the thread. No Python API allowed beyond this point. */
    PyGILState_Release(gstate);
}

- (BOOL)isRunning {
    BOOL running = NO;
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Retrieve the gui
    PyObject *pGuiObject;
    
    pGuiObject = PyObject_GetAttrString(self.pModule, "gui");
    if (pGuiObject && PyInstance_Check(pGuiObject)) {
        PyObject *pToggleMeth;
        NSLog(@"Got GUI");
        
        pToggleMeth = PyObject_GetAttrString(pGuiObject, "engine_is_running");
        if (pToggleMeth && PyCallable_Check(pToggleMeth)) {
            NSLog(@"Calling engine_is_running");
            PyObject *pArgs = PyTuple_New(0);
            PyObject *pRet = PyObject_CallObject(pToggleMeth, pArgs);
            running = PyObject_IsTrue(pRet) ? YES : NO;
            Py_DECREF(pArgs);
            Py_XDECREF(pRet);
        }
        else {
            NSLog(@"Error getting engine_is_running");
        }
        Py_XDECREF(pToggleMeth);
    }
    else {
        NSLog(@"Error getting gui");
    }
    Py_XDECREF(pGuiObject);
    
    /* Perform Python actions here. */
    //    result = CallSomeFunction();
    /* evaluate result or handle exception */
    
    /* Release the thread. No Python API allowed beyond this point. */
    PyGILState_Release(gstate);
    
    return running;
}

- (void)setIsRunning:(BOOL)running {
//    NSStatusBarButton *button = self.statusItem.button;
//    
//    NSMenuItem *enablePloverMenuItem = [self.statusMenu itemWithTag:kTogglePloverMenuItemTag];
//    if (running) {
//        enablePloverMenuItem.title = NSLocalizedString(@"Turn Plover Off", nil);
//        button.image = [NSImage imageNamed:@"Status Icon"];
//    }
//    else {
//        enablePloverMenuItem.title = NSLocalizedString(@"Turn Plover On", nil);
//        button.image = [NSImage imageNamed:@"Status Icon Off"];
//    }
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Retrieve the gui
    PyObject *pGuiObject;
    
    pGuiObject = PyObject_GetAttrString(self.pModule, "gui");
    if (pGuiObject && PyInstance_Check(pGuiObject)) {
        PyObject *pToggleMeth;
        NSLog(@"Got GUI");
        
        pToggleMeth = PyObject_GetAttrString(pGuiObject, "set_engine_is_running");
        if (pToggleMeth && PyCallable_Check(pToggleMeth)) {
            NSLog(@"Calling set_engine_is_running");
            PyObject *pArgs = PyTuple_New(1);
            PyObject *argRunning = running ? Py_True : Py_False;
            PyTuple_SET_ITEM(pArgs, 0, argRunning);
            
            PyObject *pRet = PyObject_CallObject(pToggleMeth, pArgs);
            Py_DECREF(pArgs);
            Py_XDECREF(pRet);
        }
        else {
            NSLog(@"Error getting engine_is_running");
        }
        Py_XDECREF(pToggleMeth);
    }
    else {
        NSLog(@"Error getting gui");
    }
    Py_XDECREF(pGuiObject);
    
    /* Perform Python actions here. */
    //    result = CallSomeFunction();
    /* evaluate result or handle exception */
    
    /* Release the thread. No Python API allowed beyond this point. */
    PyGILState_Release(gstate);
}

//- (void)setPloverReady:(BOOL)ready {
//    NSMenuItem *enablePloverMenuItem = [self.statusMenu itemWithTag:kTogglePloverMenuItemTag];
//    self.togglePloverButton.enabled = ready;
//    enablePloverMenuItem.enabled = ready;
//}

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