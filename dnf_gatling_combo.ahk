#Requires AutoHotkey v2.0
#Warn All, MsgBox
#SingleInstance Force
#NoTrayIcon
; 开启时默认关闭tab和win热键
Hotkey('Tab', 'Off')
Hotkey('LWin', 'Off')
arr := ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
; 主要用到的函数
SendKey(Key) {
    VK := GetKeyVK(Key), SC := GetKeySC(Key)
    DllCall('keybd_event', 'uchar', VK, 'uchar', SC, 'uint', 0, 'uptr', 0)
    Sleep(50)
    DllCall('keybd_event', 'uchar', VK, 'uchar', SC, 'uint', 2, 'uptr', 0)
}
; 点击gui中的按钮会调用该函数，该函数负责切换程序的状态，开启或关闭热键
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
        Hotkey('Tab', 'Off')
        Hotkey('LWin', 'Off')
        btn.Focus()
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
        Hotkey('Tab', 'On')
        Hotkey('LWin', 'On')
        IniWrite(gun.Text, 'config.ini', 'skill', 'gun')
        IniWrite(jump.Text, 'config.ini', 'skill', 'jump')
        IniWrite(bbq.Text, 'config.ini', 'skill', 'bbq')
        IniWrite(trample.Text, 'config.ini', 'skill', 'trample')
        btn.Focus()
        flag := !flag
    }
}
; 格林扯bbq
Tab:: {
    SendKey(gun.Text)
    Sleep(100)
    SendKey(jump.Text)
    Sleep(13)
    SendKey(bbq.Text)
}
; 格林扯踏射
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
G.SetFont('S12', 'Microsoft YaHei UI')
G.AddText('', '格林')
G.AddText('', '跳跃')
G.AddText('', 'BBQ')
G.AddText('', '踏射')
link := G.AddLink('', '<a href="https://github.com/tlf1144375711/dnf_gatling_combo">Github</a>')
link := G.AddLink('', '<a href="https://space.bilibili.com/44763794">Bilibili</a>')
gun := G.AddDDL('YM W50 R10', arr)
jump := G.AddDDL('W50 R10 Y+12', arr)
bbq := G.AddDDL('W50 R10 Y+12', arr)
trample := G.AddDDL('W50 R10 Y+12', arr)

; 下拉框默认值从ini中读取，如果不存在ini则赋给默认值
try {
    ini_gun := IniRead('config.ini', 'skill', 'gun')
    ini_jump := IniRead('config.ini', 'skill', 'jump')
    ini_bbq := IniRead('config.ini', 'skill', 'bbq')
    ini_trample := IniRead('config.ini', 'skill', 'trample')
} catch {
    IniWrite('s', 'config.ini', 'skill', 'gun')
    IniWrite('c', 'config.ini', 'skill', 'jump')
    IniWrite('g', 'config.ini', 'skill', 'bbq')
    IniWrite('b', 'config.ini', 'skill', 'trample')
} finally {
    ini_gun := IniRead('config.ini', 'skill', 'gun')
    ini_jump := IniRead('config.ini', 'skill', 'jump')
    ini_bbq := IniRead('config.ini', 'skill', 'bbq')
    ini_trample := IniRead('config.ini', 'skill', 'trample')
    gun.Text := ini_gun
    jump.Text := ini_jump
    bbq.Text := ini_bbq
    trample.Text := ini_trample
}
btn := G.AddButton('Y+30 H40', '应用')
btn.OnEvent('Click', change)
btn.Focus()
G.AddStatusBar('', 'Version: 2.2')
G.Show()
G.OnEvent('Close', (*) => ExitApp())