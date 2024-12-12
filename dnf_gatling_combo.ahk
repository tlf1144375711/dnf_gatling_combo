#Requires AutoHotkey v2.0
#Warn All, MsgBox
#SingleInstance Force
#NoTrayIcon

; 初始化
Hotkey('Tab','Off')
Hotkey('LWin','Off')
arr := ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
; 主要用到的函数
SendKey(Key) {
    VK := GetKeyVK(Key), SC := GetKeySC(Key)
    DllCall('keybd_event', 'uchar', VK, 'uchar', SC, 'uint', 0, 'uptr', 0)
    Sleep(50)
    DllCall('keybd_event', 'uchar', VK, 'uchar', SC, 'uint', 2, 'uptr', 0)
}
change(*) {
    static flag := false
    if flag {
        btn.Text := '应用'
        ; 原来里面的文字是更改，现在改成应用了
        ; 意思就是说原来已经投入使用了
        ; 这个时候需要打开更改的功能
        ; 允许控件进行更改
        gun.Enabled := true
        jump.Enabled := true
        bbq.Enabled := true
        trample.Enabled := true
        ; 此时脚本进入修改模式，修改模式中不能使用热键
        Hotkey('Tab','Off')
        Hotkey('LWin','Off')
        flag := !flag
    } else {
        btn.Text := '更改'
        gun.Enabled := false
        jump.Enabled := false
        bbq.Enabled := false
        trample.Enabled := false
        ; 此时用户已经更改完状态了
        ; 用户已经点击应用
        ; 脚本应该采集更改后的信息改掉按键变量
        ; 改完按键变量后，相关函数可以被启用了
        Hotkey('Tab','On')
        Hotkey('LWin','On')
        flag := !flag
    }
}


Tab:: {
    SendKey(gun.Text)
    Sleep(100)
    SendKey(jump.Text)
    Sleep(13)
    SendKey(bbq.Text)
}
LWin:: {
    SendKey(gun.Text)
    Sleep(100)
    SendKey(jump.Text)
    Sleep(13)
    SendKey(trample.Text)
}
; Gui设置
G := Gui('+MaxSize150x270 +MinSize150x270 +Resize -MinimizeBox -MaximizeBox', 'dnf_gatling_combo')
G.MarginX := 10, G.MarginY := 10
G.SetFont('S12','Microsoft YaHei UI')
G.AddText('','格林')
G.AddText('','跳跃')
G.AddText('','BBQ')
G.AddText('','踏射')
link := G.AddLink('','<a href="https://github.com/tlf1144375711/dnf_gatling_combo">Github</a>')
link := G.AddLink('','<a href="https://space.bilibili.com/44763794">Bilibili</a>')
gun := G.AddDDL('YM W50 R10',arr)
jump := G.AddDDL('W50 R10',arr)
bbq := G.AddDDL('W50 R10',arr)
trample := G.AddDDL('W50 R10',arr)
PostMessage(0x153,-1,50,gun)
PostMessage(0x153,-1,50,jump)
PostMessage(0x153,-1,50,bbq)
PostMessage(0x153,-1,50,trample)
; 下拉框默认值初始化
gun.Text := 's'
jump.Text := 'c'
bbq.Text := 'g'
trample.Text := 'b'

btn := G.AddButton('Y+45 H40', '应用')
btn.OnEvent('Click', change)
G.AddStatusBar('','Version: 1.1')
G.Show()
G.OnEvent('Close', (*)=>ExitApp())

