#!/bin/bash

source /Zanthus/Zeus/pdvJava/ECFRECEB.CFG

busdev="$(lsusb | grep '20d1:7008' | awk '{print $6}')"
export busdev

if [ "$busdev" == "20d1:7008" ]; then
    echo "Elgin i9"
    if [ ! "$biblioteca" == "izrcb_R82" ]; then
        # echo "!=R82"
        echo -e 'biblioteca=izrcb_R82\n' | sudo tee /Zanthus/Zeus/pdvJava/ECFRECEB.CFG >> /dev/null
        echo -e 'FW_FLAGS=2' | sudo tee /Zanthus/Zeus/pdvJava/EMUL.INI >> /dev/null
        echo -e 'FW_MODELO_IMPRESSORA=1' | sudo tee -a /Zanthus/Zeus/pdvJava/EMUL.INI >> /dev/null
        echo -e 'FW_PORTA_USB' | sudo tee -a /Zanthus/Zeus/pdvJava/EMUL.INI >> /dev/null
    fi
    if [ -d /Zanthus/Zeus/lib_u64 ]; then
    sudo tar -zxf elginIZ82_x64.tar.gz
    rsync -ahz --info=progress2 lib_u64/ /Zanthus/Zeus/lib_u64/
    sudo chmod -R 777 /Zanthus/Zeus/lib_u64
    sudo ldconfig
    else
    echo -e "Diretório \"/Zanthus/Zeus/lib_u64\" não existe!"
    exit 1
fi
