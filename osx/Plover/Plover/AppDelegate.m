//
//  AppDelegate.m
//  Plover
//
//  Created by Wesley Moore on 13/10/2015.
//  Copyright © 2015 Open Steno Project. All rights reserved.
//

#import "AppDelegate.h"
#import <Python.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *label;
@end

/*
 ASSETS_DIR = app.assets_dir()
 PROGRAM_DIR = app.program_dir()
 CONFIG_DIR = app.config_dir()
 */

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
    AppDelegate *appDelegate = (AppDelegate *)[NSApp delegate];
    return PyString_FromString([[appDelegate applicationDirectory] fileSystemRepresentation]);
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

static PyMethodDef PloverOsLayerMacMethods[] = {
    {"assets_dir",  app_assets_dir, METH_VARARGS, "app_assets_dir"},
    {"program_dir",  app_program_dir, METH_VARARGS, "app_program_dir"},
    {"config_dir",  app_config_dir, METH_VARARGS, "app_config_dir"},
    {"request_access_for_assistive_devices",  request_access_for_assistive_devices, METH_VARARGS, "request_access_for_assistive_devices"},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification  {
    // Insert code here to initialize your application
    
    
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (NSURL *)applicationDirectory
{
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



- (IBAction)doPython:(id)sender {
    Py_SetProgramName("plover");  /* optional but recommended */
//    Py_Initialize();
//    PyRun_SimpleString("from time import time,ctime\n"
//                       "print 'Today is',ctime(time())\n");
//    Py_Finalize();    
    PyObject *pName, *pModule, *pDict, *pFunc;
    PyObject *pArgs, *pValue;
    int i;
    
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
    
    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    
    if (pModule != NULL) {
        
        pFunc = PyObject_GetAttrString(pModule, "main");
        /* pFunc is a new reference */
        
        // Call the main function with the path to the config dir
        if (pFunc && PyCallable_Check(pFunc)) {
            pArgs = PyTuple_New(0);
//            PyObject *pyConfigFilePath = PyString_FromString([configFile fileSystemRepresentation]);
//            NSAssert(pyConfigFilePath != NULL, nil);
//            PyTuple_SetItem(pArgs, 0, pyConfigFilePath);
            
            pValue = PyObject_CallObject(pFunc, pArgs);
            Py_DECREF(pArgs);
            if (pValue != NULL) {
                printf("Result of call: %ld\n", PyInt_AsLong(pValue));
                Py_DECREF(pValue);
            }
            else {
                Py_DECREF(pFunc);
                Py_DECREF(pModule);
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
        Py_DECREF(pModule);
    }
    else {
        PyErr_Print();
        fprintf(stderr, "Failed to load\n");
    }
    Py_Finalize();
}

@end
