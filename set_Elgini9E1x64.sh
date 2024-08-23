#!/bin/bash

# Verifique se o usuário é root (UID 0)
if [[ $EUID -ne 0 ]]; then
    echo "Deve executar como Super Usuário."
    exit 1
fi

# Variáveis para o ambiente
ecfreceb="/Zanthus/Zeus/pdvJava/ECFRECEB.CFG"
emul="/Zanthus/Zeus/pdvJava/EMUL.INI"
lib_u64="/Zanthus/Zeus/lib_u64"
# pacote="so_u64_E1-01.08.00.tar.gz"
busdev="$(lsusb | grep '20d1:7008' | awk '{print $6}')"

# Exportar variáveis para o ambiente
export ecfreceb
export emul
export lib_u64
export pacote
export busdev

# shellcheck source=/dev/null
source "$ecfreceb"

# Verifica se IRQ != i9
if [ "$busdev" == "20d1:7008" ]; then
    echo "Elgin i9"
    # Verifica se IZ != R82 e configura
    if [ ! "$ecfreceb" == "izrcb_R82" ]; then
        echo "Configurando IZ para R82..."
        echo -e 'biblioteca=izrcb_R82\n' >"$ecfreceb"
        echo "Configurando EMUL.INI..."
        # Verifica se o parâmetro FW_INVERTE_GAVETA já existe e não está comentado
        if grep -q "^[^#]*FW_INVERTE_GAVETA" "$emul"; then
            # Adiciona as configurações necessárias com o parâmetro FW_INVERTE_GAVETA
            {
                echo -e 'FW_FLAGS=1'
                echo -e 'FW_MODELO_IMPRESSORA=0'
                echo -e 'FW_PORTA_USB'
                echo -e 'FW_INVERTE_GAVETA'
            } >"$emul"
        else
            # Adiciona as configurações necessárias
            {
                echo -e 'FW_FLAGS=2'
                echo -e 'FW_MODELO_IMPRESSORA=0'
                echo -e 'FW_PORTA_USB'
            } >"$emul"
        fi
    else
        if grep -q "^[^#]*FW_INVERTE_GAVETA" "$emul"; then
            # Adiciona as configurações necessárias com o parâmetro FW_INVERTE_GAVETA
			# cmd
			sed -i "s/FW_FLAGS=""${FW_FLAGS}""/FW_FLAGS=1/" "$emul"
			sed -i "s/FW_MODELO_IMPRESSORA=""${FW_MODELO_IMPRESSORA}""/FW_MODELO_IMPRESSORA=0/" "$emul"
			# cmd
        else
            # Adiciona as configurações necessárias
			# cmd
			sed -i "s/FW_FLAGS=""${FW_FLAGS}""/FW_FLAGS=2/" "$emul"
			sed -i "s/FW_MODELO_IMPRESSORA=""${FW_MODELO_IMPRESSORA}""/FW_MODELO_IMPRESSORA=0/" "$emul"
			# cmd
        fi
    fi
    # Configura bibliotecas so_u64+E1
    # if [ -d "$lib_u64" ]; then
    #     echo "Copiando bibliotecas..."
    #     tar -zxf "$pacote"
    #     rsync -ahz --info=progress2 so_u64/ "$lib_u64"/
    #     chmod -R 777 "$lib_u64"
    #     ldconfig
    # else
    #     echo -e "Diretório \"$lib_u64\" não existe!"
    #     exit 1
    # fi
fi
