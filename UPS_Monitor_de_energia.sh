#!/bin/bash

# IP de um aparelho que não está num nobreak e está 24h ligado e conectado a rede interna
DESTINO="192.168.1.199"
LIMITE_TESTES=3
TIMESLEEP=60
contador=0

# funções
checa_host() {
    ip_destino=$1
    ping -c3 $ip_destino > /dev/null 2>&1
}

aguarda_sincronizar_dados() {
    sync
    sleep 30
}

executa_desligamento_NAS() {
    shutdown -h now
}

aguarda_reiniciar_ciclo() {
    sleep $TIMESLEEP
}

reset_contador_em_ping_positivo() {
    contador=0
}

while true
  do
    checa_host $DESTINO
    estado_do_host=$?

    if [ $estado_do_host -ne 0 ]; then
        contador=$((contador+1))

        if [ $contador -eq $LIMITE_TESTES ]; then
            aguarda_sincronizar_dados
            executa_desligamento_NAS
        fi
        aguarda_reiniciar_ciclo

      else
        reset_contador_em_ping_positivo
    fi
done
