#!/bin/bash
set -e

echo "--- INICIANDO SCRIPT Ejercicio2-2_3 ---"

# --- 0. Definición de Variables ---

# Nombres de Contenedores 
N_PC1="clab-Ejercicio2-2_3-pc1"
N_PC2="clab-Ejercicio2-2_3-pc2"
N_PC3="clab-Ejercicio2-2_3-pc3"
N_R1="clab-Ejercicio2-2_3-r1"
N_R2="clab-Ejercicio2-2_3-r2"
N_R3="clab-Ejercicio2-2_3-r3"
N_R4="clab-Ejercicio2-2_3-r4"
N_R5="clab-Ejercicio2-2_3-r5"
N_R6="clab-Ejercicio2-2_3-r6"
N_R7="clab-Ejercicio2-2_3-r7"
N_R8="clab-Ejercicio2-2_3-r8"
N_R9="clab-Ejercicio2-2_3-r9"
N_R10="clab-Ejercicio2-2_3-r10"

# IPs de Nodos
IP_PC1="10.0.1.2/24"
GW_PC1="10.0.1.1"
IP_PC2="10.0.2.2/24"
GW_PC2="10.0.2.1"
IP_PC3="10.0.3.2/24"
GW_PC3="10.0.3.1"

# IPs de Interfaces de Routers
IP_R1_E4="10.0.1.1/24"
IP_R1_E8="10.0.4.1/24"
IP_R1_E12="10.0.5.1/24"

IP_R2_E4="10.0.4.2/24"
IP_R2_E8="10.0.6.2/24"

IP_R3_E4="10.0.6.3/24"
IP_R3_E8="10.0.7.3/24"
IP_R3_E12="10.0.8.3/24"

IP_R4_E4="10.0.7.4/24"
IP_R4_E8="10.0.9.4/24"
IP_R4_E12="10.0.10.4/24"

IP_R5_E4="10.0.9.5/24"
IP_R5_E8="10.0.11.5/24"
IP_R5_E12="10.0.12.5/24"

IP_R6_E4="10.0.10.6/24"
IP_R6_E8="10.0.12.6/24"
IP_R6_E12="10.0.13.6/24"

IP_R7_E4="10.0.13.7/24"
IP_R7_E8="10.0.14.7/24"

IP_R8_E4="10.0.2.1/24"
IP_R8_E8="10.0.5.8/24"
IP_R8_E12="10.0.8.8/24"
IP_R8_E16="10.0.14.8/24"

IP_R9_E4="10.0.11.9/24"
IP_R9_E8="10.0.15.9/24"

IP_R10_E4="10.0.3.1/24"
IP_R10_E8="10.0.15.10/24"

# Redes OSPF ('network area 0')
NET_PC1="10.0.1.0/24"
NET_PC2="10.0.2.0/24"
NET_PC3="10.0.3.0/24"
NET_R1_R2="10.0.4.0/24"
NET_R1_R8="10.0.5.0/24"
NET_R2_R3="10.0.6.0/24"
NET_R3_R4="10.0.7.0/24"
NET_R3_R8="10.0.8.0/24"
NET_R4_R5="10.0.9.0/24"
NET_R4_R6="10.0.10.0/24"
NET_R5_R9="10.0.11.0/24"
NET_R5_R6="10.0.12.0/24"
NET_R6_R7="10.0.13.0/24"
NET_R7_R8="10.0.14.0/24"
NET_R9_R10="10.0.15.0/24"

# ASNs
ASN_R1=3333
ASN_R2=3333
ASN_R3=100
ASN_R4=100
ASN_R5=300
ASN_R6=200
ASN_R7=200
ASN_R8=200
ASN_R9=300
ASN_R10=4444

# Router-IDs
RTR_ID_R1="192.168.0.1"
RTR_ID_R2="192.168.0.2"
RTR_ID_R3="192.168.0.3"
RTR_ID_R4="192.168.0.4"
RTR_ID_R5="192.168.0.5"
RTR_ID_R6="192.168.0.6"
RTR_ID_R7="192.168.0.7"
RTR_ID_R8="192.168.0.8"
RTR_ID_R9="192.168.0.9"
RTR_ID_R10="192.168.0.10"

# --- 1. Esperar a que los routers estén listos ---
echo "--- 1. Esperando a que los routers estén listos ---"
for r in ${N_R1} ${N_R2} ${N_R3} ${N_R4} ${N_R5} ${N_R6} ${N_R7} ${N_R8} ${N_R9} ${N_R10}; do
    echo "Esperando a ${r}..."
    until docker exec ${r} vtysh -c "show version" >/dev/null 2>&1
    do
        sleep 2
    done
    echo "${r} está listo."
done

# --- 2. Configurando IPs y Gateways en PCs ---
echo "--- 2. Configurando IPs y Gateways en PCs ---"
docker exec -t ${N_PC1} ip link set eth1 up
docker exec -t ${N_PC1} ip addr add ${IP_PC1} dev eth1
docker exec -t ${N_PC1} ip route replace default via ${GW_PC1}
echo "PC1 configurado."

docker exec -t ${N_PC2} ip link set eth1 up
docker exec -t ${N_PC2} ip addr add ${IP_PC2} dev eth1
docker exec -t ${N_PC2} ip route replace default via ${GW_PC2}
echo "PC2 configurado."

docker exec -t ${N_PC3} ip link set eth1 up
docker exec -t ${N_PC3} ip addr add ${IP_PC3} dev eth1
docker exec -t ${N_PC3} ip route replace default via ${GW_PC3}
echo "PC3 configurado."

# --- 3. Configurando IPs en Routers ---
echo "--- 3. Configurando IPs y Encendiendo Interfaces en Routers ---"
# R1
docker exec -t ${N_R1} ip link set Ethernet4 up && docker exec -t ${N_R1} ip addr add ${IP_R1_E4} dev Ethernet4
docker exec -t ${N_R1} ip link set Ethernet8 up && docker exec -t ${N_R1} ip addr add ${IP_R1_E8} dev Ethernet8
docker exec -t ${N_R1} ip link set Ethernet12 up && docker exec -t ${N_R1} ip addr add ${IP_R1_E12} dev Ethernet12
docker exec -t ${N_R1} ip route del default || true
echo "R1 IPs configuradas."

# R2
docker exec -t ${N_R2} ip link set Ethernet4 up && docker exec -t ${N_R2} ip addr add ${IP_R2_E4} dev Ethernet4
docker exec -t ${N_R2} ip link set Ethernet8 up && docker exec -t ${N_R2} ip addr add ${IP_R2_E8} dev Ethernet8
docker exec -t ${N_R2} ip route del default || true
echo "R2 IPs configuradas."

# R3
docker exec -t ${N_R3} ip link set Ethernet4 up && docker exec -t ${N_R3} ip addr add ${IP_R3_E4} dev Ethernet4
docker exec -t ${N_R3} ip link set Ethernet8 up && docker exec -t ${N_R3} ip addr add ${IP_R3_E8} dev Ethernet8
docker exec -t ${N_R3} ip link set Ethernet12 up && docker exec -t ${N_R3} ip addr add ${IP_R3_E12} dev Ethernet12
docker exec -t ${N_R3} ip route del default || true
echo "R3 IPs configuradas."

# R4
docker exec -t ${N_R4} ip link set Ethernet4 up && docker exec -t ${N_R4} ip addr add ${IP_R4_E4} dev Ethernet4
docker exec -t ${N_R4} ip link set Ethernet8 up && docker exec -t ${N_R4} ip addr add ${IP_R4_E8} dev Ethernet8
docker exec -t ${N_R4} ip link set Ethernet12 up && docker exec -t ${N_R4} ip addr add ${IP_R4_E12} dev Ethernet12
docker exec -t ${N_R4} ip route del default || true
echo "R4 IPs configuradas."

# R5
docker exec -t ${N_R5} ip link set Ethernet4 up && docker exec -t ${N_R5} ip addr add ${IP_R5_E4} dev Ethernet4
docker exec -t ${N_R5} ip link set Ethernet8 up && docker exec -t ${N_R5} ip addr add ${IP_R5_E8} dev Ethernet8
docker exec -t ${N_R5} ip link set Ethernet12 up && docker exec -t ${N_R5} ip addr add ${IP_R5_E12} dev Ethernet12
docker exec -t ${N_R5} ip route del default || true
echo "R5 IPs configuradas."

# R6
docker exec -t ${N_R6} ip link set Ethernet4 up && docker exec -t ${N_R6} ip addr add ${IP_R6_E4} dev Ethernet4
docker exec -t ${N_R6} ip link set Ethernet8 up && docker exec -t ${N_R6} ip addr add ${IP_R6_E8} dev Ethernet8
docker exec -t ${N_R6} ip link set Ethernet12 up && docker exec -t ${N_R6} ip addr add ${IP_R6_E12} dev Ethernet12
docker exec -t ${N_R6} ip route del default || true
echo "R6 IPs configuradas."

# R7
docker exec -t ${N_R7} ip link set Ethernet4 up && docker exec -t ${N_R7} ip addr add ${IP_R7_E4} dev Ethernet4
docker exec -t ${N_R7} ip link set Ethernet8 up && docker exec -t ${N_R7} ip addr add ${IP_R7_E8} dev Ethernet8
docker exec -t ${N_R7} ip route del default || true
echo "R7 IPs configuradas."

# R8
docker exec -t ${N_R8} ip link set Ethernet4 up && docker exec -t ${N_R8} ip addr add ${IP_R8_E4} dev Ethernet4
docker exec -t ${N_R8} ip link set Ethernet8 up && docker exec -t ${N_R8} ip addr add ${IP_R8_E8} dev Ethernet8
docker exec -t ${N_R8} ip link set Ethernet12 up && docker exec -t ${N_R8} ip addr add ${IP_R8_E12} dev Ethernet12
docker exec -t ${N_R8} ip link set Ethernet16 up && docker exec -t ${N_R8} ip addr add ${IP_R8_E16} dev Ethernet16
docker exec -t ${N_R8} ip route del default || true
echo "R8 IPs configuradas."

# R9
docker exec -t ${N_R9} ip link set Ethernet4 up && docker exec -t ${N_R9} ip addr add ${IP_R9_E4} dev Ethernet4
docker exec -t ${N_R9} ip link set Ethernet8 up && docker exec -t ${N_R9} ip addr add ${IP_R9_E8} dev Ethernet8
docker exec -t ${N_R9} ip route del default || true
echo "R9 IPs configuradas."

# R10
docker exec -t ${N_R10} ip link set Ethernet4 up && docker exec -t ${N_R10} ip addr add ${IP_R10_E4} dev Ethernet4
docker exec -t ${N_R10} ip link set Ethernet8 up && docker exec -t ${N_R10} ip addr add ${IP_R10_E8} dev Ethernet8
docker exec -t ${N_R10} ip route del default || true
echo "R10 IPs configuradas."

# --- 4. Configurando OSPF  en TODOS los routers ---
echo "--- 4. Configurando OSPF en TODOS los routers ---"

# Función para OSPF 
config_ospf () {
    NODO=$1
    ROUTER_ID=$2
    shift 2
    NETWORKS=("$@")

    echo "Configurando OSPF en ${NODO} (ID: ${ROUTER_ID})"
    
    CMDS="configure terminal
    router ospf
      router-id ${ROUTER_ID}
    "
    for net in "${NETWORKS[@]}"; do
        CMDS="${CMDS}
          network ${net} area 0"
    done
    CMDS="${CMDS}
    exit
    end
    write"
    
    echo "${CMDS}" | docker exec -i ${NODO} vtysh
}

# Configurar OSPF en cada router
config_ospf ${N_R1} ${RTR_ID_R1} ${NET_PC1} ${NET_R1_R2} ${NET_R1_R8}
config_ospf ${N_R2} ${RTR_ID_R2} ${NET_R1_R2} ${NET_R2_R3}
config_ospf ${N_R3} ${RTR_ID_R3} ${NET_R2_R3} ${NET_R3_R4} ${NET_R3_R8}
config_ospf ${N_R4} ${RTR_ID_R4} ${NET_R3_R4} ${NET_R4_R5} ${NET_R4_R6}
config_ospf ${N_R5} ${RTR_ID_R5} ${NET_R4_R5} ${NET_R5_R9} ${NET_R5_R6}
config_ospf ${N_R6} ${RTR_ID_R6} ${NET_R4_R6} ${NET_R5_R6} ${NET_R6_R7}
config_ospf ${N_R7} ${RTR_ID_R7} ${NET_R6_R7} ${NET_R7_R8}
config_ospf ${N_R8} ${RTR_ID_R8} ${NET_PC2} ${NET_R1_R8} ${NET_R3_R8} ${NET_R7_R8}
config_ospf ${N_R9} ${RTR_ID_R9} ${NET_R5_R9} ${NET_R9_R10}
config_ospf ${N_R10} ${RTR_ID_R10} ${NET_PC3} ${NET_R9_R10}

# --- 5. Configurando BGP CON POLÍTICAS ---
echo "--- 5. Configurando BGP CON POLÍTICAS ---"

# --- R1 (ASN 3333) ---
echo "Configurando BGP en R1 (ASN 3333)"
docker exec -i ${N_R1} vtysh <<EOF
configure terminal
ip prefix-list PC_NET seq 10 permit ${NET_PC1}
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
router bgp ${ASN_R1}
  bgp router-id ${RTR_ID_R1}
  ! Vecino iBGP (R2)
  neighbor ${IP_R2_E4%%/*} remote-as ${ASN_R2}
  neighbor ${IP_R2_E4%%/*} update-source ${IP_R1_E8%%/*}
  ! Vecino eBGP (R8)
  neighbor ${IP_R8_E8%%/*} remote-as ${ASN_R8}
  neighbor ${IP_R8_E8%%/*} ebgp-multihop 2
  neighbor ${IP_R8_E8%%/*} update-source ${IP_R1_E12%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R2_E4%%/*} activate
    neighbor ${IP_R2_E4%%/*} next-hop-self
    neighbor ${IP_R2_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R2_E4%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R8_E8%%/*} activate
    neighbor ${IP_R8_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R8_E8%%/*} route-map REDIST_CONNECTED out
    ! Anunciar la red de PC1
    redistribute connected route-map REDIST_CONNECTED
  exit-address-family
exit
end
write
EOF

# --- R2 (ASN 3333) ---
echo "Configurando BGP en R2 (ASN 3333)"
docker exec -i ${N_R2} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit any
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R2}
  bgp router-id ${RTR_ID_R2}
  ! Vecino iBGP (R1)
  neighbor ${IP_R1_E8%%/*} remote-as ${ASN_R1}
  neighbor ${IP_R1_E8%%/*} update-source ${IP_R2_E4%%/*}
  ! Vecino eBGP (R3)
  neighbor ${IP_R3_E4%%/*} remote-as ${ASN_R3}
  neighbor ${IP_R3_E4%%/*} ebgp-multihop 2
  neighbor ${IP_R3_E4%%/*} update-source ${IP_R2_E8%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R1_E8%%/*} activate
    neighbor ${IP_R1_E8%%/*} next-hop-self
    neighbor ${IP_R1_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R1_E8%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R3_E4%%/*} activate
    neighbor ${IP_R3_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R3_E4%%/*} route-map REDIST_CONNECTED out
  exit-address-family
exit
end
write
EOF

# --- R3 (ASN 100) ---
echo "Configurando BGP en R3 (ASN 100)"
docker exec -i ${N_R3} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit any
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R3}
  bgp router-id ${RTR_ID_R3}
  ! Vecino iBGP (R4)
  neighbor ${IP_R4_E4%%/*} remote-as ${ASN_R4}
  neighbor ${IP_R4_E4%%/*} update-source ${IP_R3_E8%%/*}
  ! Vecino eBGP (R2)
  neighbor ${IP_R2_E8%%/*} remote-as ${ASN_R2}
  neighbor ${IP_R2_E8%%/*} ebgp-multihop 2
  neighbor ${IP_R2_E8%%/*} update-source ${IP_R3_E4%%/*}
  ! Vecino eBGP (R8)
  neighbor ${IP_R8_E12%%/*} remote-as ${ASN_R8}
  neighbor ${IP_R8_E12%%/*} ebgp-multihop 2
  neighbor ${IP_R8_E12%%/*} update-source ${IP_R3_E12%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R4_E4%%/*} activate
    neighbor ${IP_R4_E4%%/*} next-hop-self
    neighbor ${IP_R4_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R4_E4%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R2_E8%%/*} activate
    neighbor ${IP_R2_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R2_E8%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R8_E12%%/*} activate
    neighbor ${IP_R8_E12%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R8_E12%%/*} route-map REDIST_CONNECTED out
  exit-address-family
exit
end
write
EOF

# --- R4 (ASN 100) ---
echo "Configurando BGP en R4 (ASN 100)"
docker exec -i ${N_R4} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit any
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R4}
  bgp router-id ${RTR_ID_R4}
  ! Vecino iBGP (R3)
  neighbor ${IP_R3_E8%%/*} remote-as ${ASN_R3}
  neighbor ${IP_R3_E8%%/*} update-source ${IP_R4_E4%%/*}
  ! Vecino eBGP (R5)
  neighbor ${IP_R5_E4%%/*} remote-as ${ASN_R5}
  neighbor ${IP_R5_E4%%/*} ebgp-multihop 2
  neighbor ${IP_R5_E4%%/*} update-source ${IP_R4_E8%%/*}
  ! Vecino eBGP (R6)
  neighbor ${IP_R6_E4%%/*} remote-as ${ASN_R6}
  neighbor ${IP_R6_E4%%/*} ebgp-multihop 2
  neighbor ${IP_R6_E4%%/*} update-source ${IP_R4_E12%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R3_E8%%/*} activate
    neighbor ${IP_R3_E8%%/*} next-hop-self
    neighbor ${IP_R3_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R3_E8%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R5_E4%%/*} activate
    neighbor ${IP_R5_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R5_E4%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R6_E4%%/*} activate
    neighbor ${IP_R6_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R6_E4%%/*} route-map REDIST_CONNECTED out
  exit-address-family
exit
end
write
EOF

# --- R5 (ASN 300) ---
echo "Configurando BGP en R5 (ASN 300)"
docker exec -i ${N_R5} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit any
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R5}
  bgp router-id ${RTR_ID_R5}
  ! Vecino iBGP (R9)
  neighbor ${IP_R9_E4%%/*} remote-as ${ASN_R9}
  neighbor ${IP_R9_E4%%/*} update-source ${IP_R5_E8%%/*}
  ! Vecino eBGP (R4)
  neighbor ${IP_R4_E8%%/*} remote-as ${ASN_R4}
  neighbor ${IP_R4_E8%%/*} ebgp-multihop 2
  neighbor ${IP_R4_E8%%/*} update-source ${IP_R5_E4%%/*}
  ! Vecino eBGP (R6)
  neighbor ${IP_R6_E8%%/*} remote-as ${ASN_R6}
  neighbor ${IP_R6_E8%%/*} ebgp-multihop 2
  neighbor ${IP_R6_E8%%/*} update-source ${IP_R5_E12%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R9_E4%%/*} activate
    neighbor ${IP_R9_E4%%/*} next-hop-self
    neighbor ${IP_R9_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R9_E4%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R4_E8%%/*} activate
    neighbor ${IP_R4_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R4_E8%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R6_E8%%/*} activate
    neighbor ${IP_R6_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R6_E8%%/*} route-map REDIST_CONNECTED out
  exit-address-family
exit
end
write
EOF

# --- R6 (ASN 200) ---
echo "Configurando BGP en R6 (ASN 200)"
docker exec -i ${N_R6} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit any
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R6}
  bgp router-id ${RTR_ID_R6}
  ! Vecinos iBGP (Full Mesh)
  neighbor ${IP_R7_E4%%/*} remote-as ${ASN_R7}
  neighbor ${IP_R7_E4%%/*} update-source ${IP_R6_E12%%/*}
  neighbor ${IP_R8_E12%%/*} remote-as ${ASN_R8}
  neighbor ${IP_R8_E12%%/*} update-source ${IP_R6_E4%%/*}
  ! Vecino eBGP (R4)
  neighbor ${IP_R4_E12%%/*} remote-as ${ASN_R4}
  neighbor ${IP_R4_E12%%/*} ebgp-multihop 2
  neighbor ${IP_R4_E12%%/*} update-source ${IP_R6_E4%%/*}
  ! Vecino eBGP (R5)
  neighbor ${IP_R5_E12%%/*} remote-as ${ASN_R5}
  neighbor ${IP_R5_E12%%/*} ebgp-multihop 2
  neighbor ${IP_R5_E12%%/*} update-source ${IP_R6_E8%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R7_E4%%/*} activate
    neighbor ${IP_R7_E4%%/*} next-hop-self
    neighbor ${IP_R7_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R7_E4%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R8_E12%%/*} activate
    neighbor ${IP_R8_E12%%/*} next-hop-self
    neighbor ${IP_R8_E12%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R8_E12%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R4_E12%%/*} activate
    neighbor ${IP_R4_E12%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R4_E12%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R5_E12%%/*} activate
    neighbor ${IP_R5_E12%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R5_E12%%/*} route-map REDIST_CONNECTED out
  exit-address-family
exit
end
write
EOF

# --- R7 (ASN 200) ---
echo "Configurando BGP en R7 (ASN 200)"
docker exec -i ${N_R7} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit any
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R7}
  bgp router-id ${RTR_ID_R7}
  ! Vecinos iBGP (Full Mesh)
  neighbor ${IP_R6_E12%%/*} remote-as ${ASN_R6}
  neighbor ${IP_R6_E12%%/*} update-source ${IP_R7_E4%%/*}
  neighbor ${IP_R8_E16%%/*} remote-as ${ASN_R8}
  neighbor ${IP_R8_E16%%/*} update-source ${IP_R7_E8%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R6_E12%%/*} activate
    neighbor ${IP_R6_E12%%/*} next-hop-self
    neighbor ${IP_R6_E12%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R6_E12%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R8_E16%%/*} activate
    neighbor ${IP_R8_E16%%/*} next-hop-self
    neighbor ${IP_R8_E16%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R8_E16%%/*} route-map REDIST_CONNECTED out
  exit-address-family
exit
end
write
EOF

# --- R8 (ASN 200) ---
echo "Configurando BGP en R8 (ASN 200)"
docker exec -i ${N_R8} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit ${NET_PC2}
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R8}
  bgp router-id ${RTR_ID_R8}
  ! Vecinos iBGP (Full Mesh)
  neighbor ${IP_R6_E4%%/*} remote-as ${ASN_R6}
  neighbor ${IP_R6_E4%%/*} update-source ${IP_R8_E8%%/*}
  neighbor ${IP_R7_E8%%/*} remote-as ${ASN_R7}
  neighbor ${IP_R7_E8%%/*} update-source ${IP_R8_E16%%/*}
  ! Vecino eBGP (R1)
  neighbor ${IP_R1_E12%%/*} remote-as ${ASN_R1}
  neighbor ${IP_R1_E12%%/*} ebgp-multihop 2
  neighbor ${IP_R1_E12%%/*} update-source ${IP_R8_E8%%/*}
  ! Vecino eBGP (R3)
  neighbor ${IP_R3_E12%%/*} remote-as ${ASN_R3}
  neighbor ${IP_R3_E12%%/*} ebgp-multihop 2
  neighbor ${IP_R3_E12%%/*} update-source ${IP_R8_E12%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R6_E4%%/*} activate
    neighbor ${IP_R6_E4%%/*} next-hop-self
    neighbor ${IP_R6_E4%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R6_E4%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R7_E8%%/*} activate
    neighbor ${IP_R7_E8%%/*} next-hop-self
    neighbor ${IP_R7_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R7_E8%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R1_E12%%/*} activate
    neighbor ${IP_R1_E12%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R1_E12%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R3_E12%%/*} activate
    neighbor ${IP_R3_E12%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R3_E12%%/*} route-map REDIST_CONNECTED out
    ! Anunciar la red de PC2
    redistribute connected route-map REDIST_CONNECTED
  exit-address-family
exit
end
write
EOF

# --- R9 (ASN 300) ---
echo "Configurando BGP en R9 (ASN 300)"
docker exec -i ${N_R9} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit any
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R9}
  bgp router-id ${RTR_ID_R9}
  ! Vecino iBGP (R5)
  neighbor ${IP_R5_E8%%/*} remote-as ${ASN_R5}
  neighbor ${IP_R5_E8%%/*} update-source ${IP_R9_E4%%/*}
  ! Vecino eBGP (R10)
  neighbor ${IP_R10_E8%%/*} remote-as ${ASN_R10}
  neighbor ${IP_R10_E8%%/*} ebgp-multihop 2
  neighbor ${IP_R10_E8%%/*} update-source ${IP_R9_E8%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R5_E8%%/*} activate
    neighbor ${IP_R5_E8%%/*} next-hop-self
    neighbor ${IP_R5_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R5_E8%%/*} route-map REDIST_CONNECTED out
    !
    neighbor ${IP_R10_E8%%/*} activate
    neighbor ${IP_R10_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R10_E8%%/*} route-map REDIST_CONNECTED out
  exit-address-family
exit
end
write
EOF

# --- R10 (ASN 4444) ---
echo "Configurando BGP en R10 (ASN 4444)"
docker exec -i ${N_R10} vtysh <<EOF
configure terminal
! Políticas
ip prefix-list PC_NET seq 10 permit ${NET_PC3}
route-map REDIST_CONNECTED permit 10
  match ip address prefix-list PC_NET
exit
route-map IMPORT-ALL permit 10
exit
! Router BGP
router bgp ${ASN_R10}
  bgp router-id ${RTR_ID_R10}
  ! Vecino eBGP (R9)
  neighbor ${IP_R9_E8%%/*} remote-as ${ASN_R9}
  neighbor ${IP_R9_E8%%/*} ebgp-multihop 2
  neighbor ${IP_R9_E8%%/*} update-source ${IP_R10_E8%%/*}
  !
  address-family ipv4 unicast
    neighbor ${IP_R9_E8%%/*} activate
    neighbor ${IP_R9_E8%%/*} route-map IMPORT-ALL in
    neighbor ${IP_R9_E8%%/*} route-map REDIST_CONNECTED out
    ! Anunciar la red de PC3
    redistribute connected route-map REDIST_CONNECTED
  exit-address-family
exit
end
write
EOF

echo "--- Configuración BGP COMPLETA ---"
echo "--- Laboratorio LISTO ---"
echo ""
echo "Espera 2/3 min para que OSPF y BGP converjan."
echo ""
echo "Prueba (Ping pc1 -> pc2):"
echo "docker exec -it ${N_PC1} ping 10.0.2.2"
echo ""
echo "Prueba (Ping pc1 -> pc3):"
echo "docker exec -it ${N_PC1} ping 10.0.3.2"
echo ""
echo "prueba BGP (r1):"
echo "docker exec -it ${N_R1} vtysh -c 'show ip bgp summary'"
