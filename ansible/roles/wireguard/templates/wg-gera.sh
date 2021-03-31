#!/bin/bash

servidor_nome="vpn-aws"
servidor_endereco="3.86.139.178:41194"
servidor_pubkey="{{ wg_pub_key.stdout}}"
servidor_subnet="10.251.251.0/24"
servidor_rotas=("10.251.0.0/16")

########################################################
########################################################
########################################################
########################################################

if [[ -z "$2" ]]; then
    echo -e "WGEN v1.0.0 - $servidor_nome"
    echo -e "Uso: $(basename $0) nome_utilizador fim_ip"
    echo -e "Exemplo: $(basename $0) \"Mayara Alves\" 18"
    exit
fi

cliente_nome="$1"
cliente_ip="$(echo $servidor_subnet | cut -s -d. -f1-3).$2/$(echo $servidor_subnet | cut -s -d/ -f2)"
clifile="wg-$(echo $servidor_nome | tr A-Z a-z)-$cliente_nome.conf"
privkey=$(wg genkey)
pubkey=$(echo $privkey | wg pubkey)

echo -e "#########################################################" >$clifile
echo -e "### CONFIGURAÇÃO DO CLIENTE #############################\n" >>$clifile
cat <<EOF >>$clifile
########################################
# Configuração: $cliente_nome
########################################

[Interface]
# PublicKey = $pubkey
PrivateKey = $privkey
Address = $cliente_ip
DNS = 10.251.0.2

[Peer]
PersistentKeepalive = 25
PublicKey = $servidor_pubkey
Endpoint = $servidor_endereco
AllowedIPs = $servidor_subnet,$(echo ${servidor_rotas[@]} | sed -e 's/ /,/g')
EOF
echo -e "\n#########################################################\n\n" >>$clifile

#echo -e "#########################################################"
#echo -e "### CONFIGURAÇÃO DO SERVIDOR ############################\n"
cat <<EOF
########################################
# Cliente: $cliente_nome
[Peer]
PublicKey = $pubkey
# PrivateKey = $privkey
AllowedIPs = $(echo $servidor_subnet | cut -s -d. -f1-3).$2/32
########################################
EOF
#echo -e "\n#########################################################"
