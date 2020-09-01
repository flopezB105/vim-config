#!/bin/bash
#los 40 dance
#mpv https://21233.live.streamtheworld.com/LOS40_DANCE_SC
#cope
#mpv https://net1-cope-rrcast.flumotion.com/cope/net1-low.mp3
#Rock fm
#mpv https://rockfm-cope-rrcast.flumotion.com/cope/rockfm-low.mp3
#ser
#mpv https://20863.live.streamtheworld.com/CADENASER_SC
#megastar
#https://megastar-cope.flumotion.com/chunks.m3u8

los40Dance="https://21233.live.streamtheworld.com/LOS40_DANCE_SC"
cope="https://net1-cope-rrcast.flumotion.com/cope/net1-low.mp3"
rockFM="https://rockfm-cope-rrcast.flumotion.com/cope/rockfm-low.mp3"
ser="https://20863.live.streamtheworld.com/CADENASER_SC"
megastar="https://megastar-cope.flumotion.com/chunks.m3u8"
europaFm="https://livefastly-webs.europafm.com/europafm/audio/chunklist.m3u8"
m80="https://19983.live.streamtheworld.com/LOS40_CLASSIC_SC"
rMarca="https://radiomarca.streaming-pro.com:8031/radiomarca.mp3"

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Backtitle here"
TITLE="Title here"
MENU="Choose one of the following options:"

OPTIONS=(1 "los40Dance"
         2 "cope"
         3 "rockfm"
         4 "ser"
         5 "megastar"
         6 "europafm"
         7 "m80"
         8 "radioMarca")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "los40Dance"
            mpv $los40Dance
            ;;
        2)
            echo "cope"
            mpv $cope
            ;;
        3)
            echo "rockfm"
            mpv $rockfm
            ;;
        4)
            echo "ser"
            mpv $ser
            ;;
        5)
            echo "megastar"
            mpv $megastar
            ;;
        6)
            echo "europaFm"
            mpv $europaFm
            ;;
        7)
            echo "m80"
            mpv $m80
            ;;
        8)
            echo "radioMarca"
            mpv $rMarca
            ;;
esac
