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
    sudo tar -zxf elginIZ82_x64.tar.gz -C /Zanthus/Zeus
    sudo chmod -R 777 /Zanthus/Zeus/lib_u64
    sudo ldconfig
fi
