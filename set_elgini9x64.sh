#!/bin/bash

ecfreceb="/Zanthus/Zeus/pdvJava/ECFRECEB.CFG"
emul="/Zanthus/Zeus/pdvJava/EMUL.INI"
lib_u64="/Zanthus/Zeus/lib_u64"
busdev="$(lsusb | grep '20d1:7008' | awk '{print $6}')"

export ecfreceb
export emul
export lib_u64
export busdev

# shellcheck source=/dev/null
source "$ecfreceb"

if [ "$busdev" == "20d1:7008" ]; then
    echo "Elgin i9"
    if [ ! "$ecfreceb" == "izrcb_R82" ]; then
        {
        # echo "!=R82"
        echo -e 'biblioteca=izrcb_R82\n'
        echo -e 'FW_FLAGS=2'
        echo -e 'FW_MODELO_IMPRESSORA=1'
        echo -e 'FW_PORTA_USB'
        } >> "$emul"
    fi
    if [ -d "$lib_u64" ]; then
        sudo tar -zxf elginIZ82_x64.tar.gz
        rsync -ahz --info=progress2 lib_u64/ "$lib_u64"/
        sudo chmod -R 777 "$lib_u64"
        sudo ldconfig
    else
        echo -e "Diretório \"$lib_u64\" não existe!"
        exit 1
    fi
fi
