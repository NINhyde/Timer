#!/usr/local/bin/wish
###############################
# Timer.tcl 同時視聴向けタイマー #
###############################

# 初期化
# 設定保持変数の用意と初期値代入
set startTime -10
set rimitTime 3600 ;# 1h
set bgColor #00ff00 ;# green
set fgColor #0000ff ;# blue
set fontSize 30

# global variable
set TIME $startTime ;# 秒カウント変数
set RUN 0 ;# timer runing frag

# time フォント設定のために font を作成
set timeFont [ font create -size $fontSize \
		   -family "Times" ]

# subprocs
proc incrTIME { startTime rimitTime } { ;# 
    global TIME formatedTIME RUN

    while { $rimitTime > $TIME } {
	after 1000 ;# wait 1sec
	incr TIME
	set formatedTIME [ timeFormat $TIME ]
	update
	if { !$RUN } break
    }
}

proc timeFormat sec {
    set absSec $sec

    if { $sec < 0 } {
	set neg "-" ; set absSec [ expr - $sec ] 
    } else { set neg " " }
    set h [ expr $absSec / 3600 ] ; set m1 [ expr $absSec % 3600 ]
    set m [ expr $m1 / 60 ]
    set s [ expr $m1 % 60 ] 
    return [format "%s %02u:%02u:%02u" $neg $h $m $s]
}

# main
# set time 100 ;# test code

set formatedTIME [ timeFormat $TIME ]

# make wiget 
message .time -font $timeFont \
    -bg $bgColor -fg $fgColor -width 200 -bd 20 \
    -textvariable formatedTIME
button .bStart -text "スタート" -command {
    set RUN 1 ; incrTIME $startTime $rimitTime }
button .bStop -text "ストップ" -command { set RUN 0 }
button .bReset -text "リセット" -command {
    set TIME $startTime
    set formatedTIME [ timeFormat $TIME ]
}
button .bSetting -text "設定"
button .bExit -text "終了" -command { after 1000; exit }

pack .time
pack .bStart .bStop .bReset .bSetting .bExit -side left

