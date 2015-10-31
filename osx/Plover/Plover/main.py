import os
import shutil
import sys
import traceback

# WXVER = '2.8'
# if not hasattr(sys, 'frozen'):
#     import wxversion
#     wxversion.ensureMinimal(WXVER)
#
# import wx
import json
import glob
import time

from collections import OrderedDict

import plover.oslayer.processlock
from plover.oslayer.config import CONFIG_DIR, ASSETS_DIR
from plover.config import CONFIG_FILE, DEFAULT_DICTIONARY_FILE, Config
import plover.app as app
from plover.oslayer.keyboardcontrol import KeyboardEmulation
from plover.machine.base import STATE_ERROR, STATE_INITIALIZING, STATE_RUNNING
from plover.machine.registry import machine_registry
from plover.exception import InvalidConfigurationError
import plovermac

def show_error(title, message):
    """Report error to the user.
        
        This shows a graphical error and prints the same to the terminal.
        """
    print message
    # app = wx.PySimpleApp()
    # alert_dialog = wx.MessageDialog(None,
    #                                 message,
    #                                 title,
    #                                 wx.OK | wx.ICON_INFORMATION)
    #                                 alert_dialog.ShowModal()
    #                                 alert_dialog.Destroy()

def init_config_dir():
    """Creates plover's config dir.
        
        This usually only does anything the first time plover is launched.
        """
    # Create the configuration directory if needed.
    if not os.path.exists(CONFIG_DIR):
        os.makedirs(CONFIG_DIR)
    
    # Copy the default dictionary to the configuration directory.
    if not os.path.exists(DEFAULT_DICTIONARY_FILE):
        unified_dict = {}
        dict_filenames = glob.glob(os.path.join(ASSETS_DIR, '*.json'))
        for dict_filename in dict_filenames:
            unified_dict.update(json.load(open(dict_filename, 'rb')))
        ordered = OrderedDict(sorted(unified_dict.iteritems(), key=lambda x: x[1]))
        outfile = open(DEFAULT_DICTIONARY_FILE, 'wb')
        json.dump(ordered, outfile, indent=0, separators=(',', ': '))
    
    # Create a default configuration file if one doesn't already
    # exist.
    if not os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'wb') as f:
            f.close()


def dist_main():
    """Launch plover."""
    try:
        # Ensure only one instance of Plover is running at a time.
        with plover.oslayer.processlock.PloverLock():
            init_config_dir()
            config = Config()
            config.target_file = CONFIG_FILE
            gui = plover.gui.main.PloverGUI(config)
            gui.MainLoop()
            with open(config.target_file, 'wb') as f:
                config.save(f)
    except plover.oslayer.processlock.LockNotAcquiredException:
        show_error('Error', 'Another instance of Plover is already running.')
    except:
        show_error('Unexpected error', traceback.format_exc())
    os._exit(1)

#class PloverGUI(wx.App):
class PloverGUI():
    """The main entry point for the Plover application."""

    def __init__(self, config):
        self.config = config
#        wx.App.__init__(self, redirect=False)
        self.OnInit()

    def OnInit(self):
        """Called just before the application starts."""
        self.main_frame = MainFrame(self.config)
#        self.SetTopWindow(frame)
#        frame.Show()
        return True

    def MainLoop(self):
        # TODO: Need to enter an event loop here, after each cycle of which
        # all the wx.CallAfter callback need to be run
        # Ideally this method would call out to the host application's run loop
        # or one set up for it
        print 'MainLoop()'
        while True:
            time.sleep(1)
    
    def toggle_steno_engine(self):
        self.main_frame._toggle_steno_engine()

#def gui_thread_hook(fn, *args):
#    wx.CallAfter(fn, *args)

#class MainFrame(wx.Frame):
class MainFrame():
    """The top-level GUI element of the Plover application."""

    # Class constants.
    TITLE = "Plover"
    ALERT_DIALOG_TITLE = TITLE
    ON_IMAGE_FILE = os.path.join(ASSETS_DIR, 'plover_on.png')
    OFF_IMAGE_FILE = os.path.join(ASSETS_DIR, 'plover_off.png')
    CONNECTED_IMAGE_FILE = os.path.join(ASSETS_DIR, 'connected.png')
    DISCONNECTED_IMAGE_FILE = os.path.join(ASSETS_DIR, 'disconnected.png')
    REFRESH_IMAGE_FILE = os.path.join(ASSETS_DIR, 'refresh.png')
    BORDER = 5
    RUNNING_MESSAGE = "running"
    STOPPED_MESSAGE = "stopped"
    ERROR_MESSAGE = "error"
    CONFIGURE_BUTTON_LABEL = "Configure..."
    ABOUT_BUTTON_LABEL = "About..."
    RECONNECT_BUTTON_LABEL = "Reconnect..."
    COMMAND_SUSPEND = 'SUSPEND'
    COMMAND_ADD_TRANSLATION = 'ADD_TRANSLATION'
    COMMAND_LOOKUP = 'LOOKUP'
    COMMAND_RESUME = 'RESUME'
    COMMAND_TOGGLE = 'TOGGLE'
    COMMAND_CONFIGURE = 'CONFIGURE'
    COMMAND_FOCUS = 'FOCUS'
    COMMAND_QUIT = 'QUIT'

    TOGGLE_BUTTON_TAG = 1

    def __init__(self, config):
        self.config = config
        
#        pos = wx.DefaultPosition
#        size = wx.DefaultSize
#        wx.Frame.__init__(self, None, title=self.TITLE, pos=pos, size=size,
#                          style=wx.DEFAULT_FRAME_STYLE & ~(wx.RESIZE_BORDER |
#                                                           wx.RESIZE_BOX |
#                                                           wx.MAXIMIZE_BOX))
#
#        # Status button.
#        self.on_bitmap = wx.Bitmap(self.ON_IMAGE_FILE, wx.BITMAP_TYPE_PNG)
#        self.off_bitmap = wx.Bitmap(self.OFF_IMAGE_FILE, wx.BITMAP_TYPE_PNG)
#        self.status_button = wx.BitmapButton(self, bitmap=self.on_bitmap)
#        self.status_button.Bind(wx.EVT_BUTTON, self._toggle_steno_engine)
#        plovermac.bind(self.TOGGLE_BUTTON_TAG, self._toggle_steno_engine)
#
#        # Configure button.
#        self.configure_button = wx.Button(self,
#                                          label=self.CONFIGURE_BUTTON_LABEL)
#        self.configure_button.Bind(wx.EVT_BUTTON, self._show_config_dialog)
#
#        # About button.
#        self.about_button = wx.Button(self, label=self.ABOUT_BUTTON_LABEL)
#        self.about_button.Bind(wx.EVT_BUTTON, self._show_about_dialog)
#
#        # Machine status.
#        # TODO: Figure out why spinner has darker gray background.
#        self.spinner = wx.animate.GIFAnimationCtrl(self, -1, SPINNER_FILE)
#        self.spinner.GetPlayer().UseBackgroundColour(True)
#        self.spinner.Hide()
#
#        self.connected_bitmap = wx.Bitmap(self.CONNECTED_IMAGE_FILE, 
#                                          wx.BITMAP_TYPE_PNG)
#        self.disconnected_bitmap = wx.Bitmap(self.DISCONNECTED_IMAGE_FILE, 
#                                             wx.BITMAP_TYPE_PNG)
#        self.connection_ctrl = wx.StaticBitmap(self, 
#                                               bitmap=self.disconnected_bitmap)
#
#        # Layout.
#        global_sizer = wx.BoxSizer(wx.VERTICAL)
#
#        sizer = wx.BoxSizer(wx.HORIZONTAL)
#        sizer.Add(self.status_button,
#                  flag=wx.ALL | wx.ALIGN_CENTER_VERTICAL,
#                  border=self.BORDER)
#        sizer.Add(self.configure_button,
#                  flag=wx.TOP | wx.BOTTOM | wx.RIGHT | wx.ALIGN_CENTER_VERTICAL,
#                  border=self.BORDER)
#        sizer.Add(self.about_button,
#                  flag=wx.TOP | wx.BOTTOM | wx.RIGHT | wx.ALIGN_CENTER_VERTICAL,
#                  border=self.BORDER)
#        global_sizer.Add(sizer)
#
#        sizer = wx.BoxSizer(wx.HORIZONTAL)
#        sizer.Add(self.spinner,
#                  flag=(wx.LEFT | wx.BOTTOM | wx.RIGHT | 
#                        wx.ALIGN_CENTER_VERTICAL), 
#                  border=self.BORDER)
#        sizer.Add(self.connection_ctrl, 
#                  flag=(wx.LEFT | wx.BOTTOM | wx.RIGHT | 
#                        wx.ALIGN_CENTER_VERTICAL), 
#                  border=self.BORDER)
#        longest_machine = max(machine_registry.get_all_names(), key=len)
#        longest_state = max((STATE_ERROR, STATE_INITIALIZING, STATE_RUNNING), 
#                            key=len)
#        longest_status = '%s: %s' % (longest_machine, longest_state)
#        self.machine_status_text = wx.StaticText(self, label=longest_status)
#        sizer.Add(self.machine_status_text, 
#                  flag=wx.BOTTOM | wx.RIGHT | wx.ALIGN_CENTER_VERTICAL,
#                  border=self.BORDER)
#        refresh_bitmap = wx.Bitmap(self.REFRESH_IMAGE_FILE, wx.BITMAP_TYPE_PNG)          
#        self.reconnect_button = wx.BitmapButton(self, bitmap=refresh_bitmap)
#        sizer.Add(self.reconnect_button, 
#                  flag=wx.BOTTOM | wx.RIGHT | wx.ALIGN_CENTER_VERTICAL, 
#                  border=self.BORDER)
#        self.machine_status_sizer = sizer
#        global_sizer.Add(sizer)
#        self.SetSizer(global_sizer)
#        global_sizer.Fit(self)
#        
#        self.SetRect(AdjustRectToScreen(self.GetRect()))
#
#        self.Bind(wx.EVT_CLOSE, self._quit)
#        self.Bind(wx.EVT_MOVE, self.on_move)
#        self.reconnect_button.Bind(wx.EVT_BUTTON, 
#            lambda e: app.reset_machine(self.steno_engine, self.config))

        try:
            with open(config.target_file, 'rb') as f:
                self.config.load(f)
        except InvalidConfigurationError as e:
            self._show_alert(unicode(e))
            self.config.clear()

        self.steno_engine = app.StenoEngine()
        self.steno_engine.add_callback(
            lambda s: self._update_status(s))
        self.steno_engine.set_output(
            Output(self.consume_command, self.steno_engine))

        while True:
            try:
                app.init_engine(self.steno_engine, self.config)
                break
            except InvalidConfigurationError as e:
                self._show_alert(unicode(e))
                dlg = ConfigurationDialog(self.steno_engine,
                                          self.config,
                                          parent=self)
                ret = dlg.ShowModal()
                if ret == wx.ID_CANCEL:
                    self._quit()
                    return
                    
#        self.steno_engine.add_stroke_listener(
#            StrokeDisplayDialog.stroke_handler)
#        if self.config.get_show_stroke_display():
#            StrokeDisplayDialog.display(self, self.config)

#        self.steno_engine.formatter.add_listener(
#            SuggestionsDisplayDialog.stroke_handler)
#        if self.config.get_show_suggestions_display():
#            SuggestionsDisplayDialog.display(self, self.config, self.steno_engine)

#        pos = (config.get_main_frame_x(), config.get_main_frame_y())
#        self.SetPosition(pos)

    def consume_command(self, command):
        # The first commands can be used whether plover is active or not.
        if command == self.COMMAND_RESUME:
            self.steno_engine.set_is_running(True)
            return True
        elif command == self.COMMAND_TOGGLE:
            self.steno_engine.set_is_running(not self.steno_engine.is_running)
            return True
        elif command == self.COMMAND_QUIT:
            self._quit()
            return True

        if not self.steno_engine.is_running:
            return False

        # These commands can only be run when plover is active.
        if command == self.COMMAND_SUSPEND:
            self.steno_engine.set_is_running(False)
            return True
        elif command == self.COMMAND_CONFIGURE:
            self._show_config_dialog()
            return True
        elif command == self.COMMAND_FOCUS:
            def f():
                self.Raise()
                self.Iconize(False)
            f()
            return True
        elif command == self.COMMAND_ADD_TRANSLATION:
            plover.gui.add_translation.Show(self, self.steno_engine, self.config)
            return True
        elif command == self.COMMAND_LOOKUP:
            plover.gui.lookup.Show(self, self.steno_engine, self.config)
            return True
            
        return False

    def _update_status(self, state):
        if state:
            machine_name = machine_registry.resolve_alias(
                self.config.get_machine_type())
            # self.machine_status_text.SetLabel('%s: %s' % (machine_name, state))
            plovermac.set_machine_status_label('%s: %s' % (machine_name, state))
            # self.reconnect_button.Show(state == STATE_ERROR)
            # self.spinner.Show(state == STATE_INITIALIZING)
            # self.connection_ctrl.Show(state != STATE_INITIALIZING)
            # if state == STATE_INITIALIZING:
            #     self.spinner.Play()
            # else:
            #     self.spinner.Stop()
            if state == STATE_RUNNING:
                # self.connection_ctrl.SetBitmap(self.connected_bitmap)
                # plovermac.set_connected(True)
                pass
            elif state == STATE_ERROR:
                # self.connection_ctrl.SetBitmap(self.disconnected_bitmap)
                # plovermac.set_connected(False)
                pass
            # self.machine_status_sizer.Layout()
        if self.steno_engine.machine:
            # self.status_button.Enable()
            plovermac.enable_status_button(True)
            plovermac.set_engine_is_running(self.steno_engine.is_running)
            if self.steno_engine.is_running:
                # self.status_button.SetBitmapLabel(self.on_bitmap)
                # self.SetTitle("%s: %s" % (self.TITLE, self.RUNNING_MESSAGE))
                plovermac.set_title("%s: %s" % (self.TITLE, self.RUNNING_MESSAGE))
            else:
                # self.status_button.SetBitmapLabel(self.off_bitmap)
                # self.SetTitle("%s: %s" % (self.TITLE, self.STOPPED_MESSAGE))
                plovermac.set_title("%s: %s" % (self.TITLE, self.STOPPED_MESSAGE))
        else:
            # self.status_button.Disable()
            plovermac.enable_status_button(False)
            # self.status_button.SetBitmapLabel(self.off_bitmap)
            # self.SetTitle("%s: %s" % (self.TITLE, self.ERROR_MESSAGE))
            plovermac.set_title("%s: %s" % (self.TITLE, self.ERROR_MESSAGE))

    def _quit(self, event=None):
        if self.steno_engine:
            self.steno_engine.destroy()
        self.Destroy()

    def _toggle_steno_engine(self, event=None):
        """Called when the status button is clicked."""
        self.steno_engine.set_is_running(not self.steno_engine.is_running)

    def _show_config_dialog(self, event=None):
        dlg = ConfigurationDialog(self.steno_engine,
                                  self.config,
                                  parent=self)
        dlg.Show()

    def _show_about_dialog(self, event=None):
        """Called when the About... button is clicked."""
        info = wx.AboutDialogInfo()
        info.Name = __software_name__
        info.Version = __version__
        info.Copyright = __copyright__
        info.Description = __long_description__
        info.WebSite = __url__
        info.Developers = __credits__
        info.License = __license__
        wx.AboutBox(info)

    def _show_alert(self, message):
        alert_dialog = wx.MessageDialog(self,
                                        message,
                                        self.ALERT_DIALOG_TITLE,
                                        wx.OK | wx.ICON_INFORMATION)
        alert_dialog.ShowModal()
        alert_dialog.Destroy()

    def on_move(self, event):
        pos = self.GetScreenPositionTuple()
        self.config.set_main_frame_x(pos[0]) 
        self.config.set_main_frame_y(pos[1])
        event.Skip()
        

class Output(object):
    def __init__(self, engine_command_callback, engine):
        self.engine_command_callback = engine_command_callback
        self.keyboard_control = KeyboardEmulation()
        self.engine = engine

    def send_backspaces(self, b):
        # wx.CallAfter(self.keyboard_control.send_backspaces, b)
        self.keyboard_control.send_backspaces(b)

    def send_string(self, t):
        # wx.CallAfter(self.keyboard_control.send_string, t)
        self.keyboard_control.send_string(t)

    def send_key_combination(self, c):
        # wx.CallAfter(self.keyboard_control.send_key_combination, c)
        self.keyboard_control.send_key_combination(c)

    # TODO: test all the commands now
    def send_engine_command(self, c):
        result = self.engine_command_callback(c)
        if result and not self.engine.is_running:
            self.engine.machine.suppress = self.send_backspaces

def main():
    """Launch plover."""
    
    global gui
    
    try:
        # Ensure only one instance of Plover is running at a time.
        with plover.oslayer.processlock.PloverLock():
            init_config_dir()
            config = Config()
            config.target_file = CONFIG_FILE
            gui = PloverGUI(config)
            gui.MainLoop()
            with open(config.target_file, 'wb') as f:
                config.save(f)
    except plover.oslayer.processlock.LockNotAcquiredException:
        show_error('Error', 'Another instance of Plover is already running.')
    except:
        show_error('Unexpected error', traceback.format_exc())
#    os._exit(1)

