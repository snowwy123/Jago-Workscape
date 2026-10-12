// SPDX-License-Identifier: MIT
using System;using System.IO;using System.Runtime.InteropServices;
sealed partial class WorkspaceWindow {
 [DllImport("user32.dll")]static extern bool AttachThreadInput(uint first,uint second,bool attach);
 [DllImport("user32.dll")]static extern uint GetWindowThreadProcessId(IntPtr window,out uint process);
 [DllImport("kernel32.dll")]static extern uint GetCurrentThreadId();
 // SetParent embeds a separate process's window, but does not reliably route
 // keyboard focus. Share input queues for its embedded lifetime only.
 void LinkKeyboard(WorkTab tab){if(tab.keyboardThread!=0)return;string detached=Path.Combine(tab.folder,"detached.json");var ready=json.Deserialize<System.Collections.Generic.Dictionary<string,object>>(ReadShared(File.Exists(detached)?detached:Path.Combine(tab.folder,"ready.json")));uint pid;uint target=GetWindowThreadProcessId(new IntPtr(Convert.ToInt64(ready["handle"])),out pid);if(target==0)throw new Exception("The studio window is not ready for keyboard focus.");if(target==GetCurrentThreadId())return;if(!AttachThreadInput(GetCurrentThreadId(),target,true))throw new Exception("Could not connect studio keyboard focus. Retry this tab.");tab.keyboardThread=target;}
 void UnlinkKeyboard(WorkTab tab){if(tab.keyboardThread==0)return;AttachThreadInput(GetCurrentThreadId(),tab.keyboardThread,false);tab.keyboardThread=0;}
}
