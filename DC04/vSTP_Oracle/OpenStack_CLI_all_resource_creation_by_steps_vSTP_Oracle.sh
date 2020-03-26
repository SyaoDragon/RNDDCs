##########################################################################################
#  Creation of vRCS project                                                             #
##########################################################################################

openstack project create --description "vRCS project for NBatrakov using" --domain default vRCS
openstack role add --user admin --project vRCS admin
openstack quota set vRCS             \
--backup-gigabytes      500           \
--backups               3             \
--cores                 4             \
--floating-ips          7             \
--gigabytes             500           \
--instances             1             \
--key-pairs             10            \
--networks              7             \
--ports                 10            \
--properties            128           \
--ram                   4096          \
--routers               7             \
--secgroup-rules        100           \
--secgroups             10            \
--server-group-members  10            \
--server-groups         10            \
--snapshots             3            \
--subnets               100           \
--volumes               10


#########################################################
# Не используется следующие параметры
#--fixed-ips            -1
#--gigabytes_tripleo     -1
#--health_monitors       None
#--injected-file-size    10240
#--injected-files        5
#--injected-path-size    255
#--groups                10            \
#--l7_policies           None
#--listeners             None
#--load_balancers        None
#--location              None
#--name                  None
#--per-volume-gigabytes  -1
#--pools                 None
#--project               04de6733cbdb46e3b4fcd92abea40d9c
#--project_name          vRCS
#--rbac_policies         10
#--snapshots_tripleo     -1
#--subnet_pools          -1
#--volumes_tripleo       -1
#########################################################
openstack quota show vRCS
#Создаем пользователя на undercloud и в openstack в проекте
sudo adduser nbatrakov
sudo passwd nbatrakov

openstack user create --password nbatrakov --project vRCS nbatrakov
openstack user set --email nikita.batrakov@megafon.ru --description "Никита Батраков" nbatrakov

openstack role add --user nbatrakov --project vRCS            _member_
openstack role add --user syao    --project vRCS            admin
openstack role add --user sp      --project vRCS            admin

openstack flavor create \
--disk 	100           \
--ram  	4096         \
--vcpus 4             \
vRCS.default
# --swap 	16384         \

openstack flavor show vRCS.default

openstack network                                                           \
create                                                                      \
--description "This network for IMAP vRCS with other subsystems"   \
--mtu 9000                                                                  \
--project-domain nova                                                       \
--provider-network-type vlan                                                \
--provider-physical-network datacentre                                      \
--provider-segment 939                                                      \
--external                                                                  \
"939 RCS-IMAP"
#--share                                                                    \

openstack subnet create                                                       \
--subnet-range 10.169.102.224/28                                              \
--gateway 10.169.102.225                                                       \
--no-dhcp                                                                        \
--allocation-pool start=10.169.102.228,end=10.169.102.238                       \
--description "This subnetwork for IMAP vRCS with other subsystems" \
--network "939 RCS-IMAP"                                                 \
"939 RCS-IMAP subnet"

openstack network                                                           \
create                                                                      \
--description "This is internal network vRCS"   \
--mtu 9000                                                                  \
--project-domain nova                                                       \
--provider-network-type vlan                                                \
--provider-physical-network datacentre                                      \
--provider-segment 931                                                      \
--external                                                                  \
"931 RCS-Internal"
#--share                                                                    \

openstack subnet create                                                       \
--subnet-range 10.169.102.0/26                                               \
--gateway 10.169.102.1                                                        \
--no-dhcp                                                                        \
--allocation-pool start=10.169.102.4,end=10.169.102.62                        \
--description "This is internal subnetwork vRCS" \
--network "931 RCS-Internal"                                                 \
"931 RCS-Internal subnet"

openstack network                                                           \
create                                                                      \
--description "This is network vRCS for some management purpose"   \
--mtu 9000                                                                  \
--project-domain nova                                                       \
--provider-network-type vlan                                                \
--provider-physical-network datacentre                                      \
--provider-segment 930                                                      \
--external                                                                  \
"930 RCS-Management"
#--share                                                                    \

openstack subnet create                                                       \
--subnet-range 10.169.102.64/26                                               \
--gateway 10.169.102.65                                                        \
--dhcp                                                                        \
--allocation-pool start=10.169.102.68,end=10.169.102.126                         \
--description "This subnetwork vRCS for some management purpose" \
--network "930 RCS-Management"                                                 \
"930 RCS-Management subnet"

openstack network                                                           \
create                                                                      \
--description "This is network vRCS for some ISC-SIP purpose"   \
--mtu 9000                                                                  \
--project-domain nova                                                       \
--provider-network-type vlan                                                \
--provider-physical-network datacentre                                      \
--provider-segment 934                                                      \
--external                                                                  \
"934 RCS-ISC-SIP"

openstack subnet create                                                       \
--subnet-range 10.169.102.144/28                                               \
--gateway 10.169.102.145                                                        \
--no-dhcp                                                                        \
--allocation-pool start=10.169.102.148,end=10.169.102.158                         \
--description "This subnetwork for communication vRCS with ISC-SIP" \
--network "934 RCS-ISC-SIP"                                                 \
"934 RCS-ISC-SIP subnet"

openstack network                                                           \
create                                                                      \
--description "This is network vRCS for some MSRP purpose"   \
--mtu 9000                                                                  \
--project-domain nova                                                       \
--provider-network-type vlan                                                \
--provider-physical-network datacentre                                      \
--provider-segment 936                                                      \
--external                                                                  \
"936 RCS-MSRP"

openstack subnet create                                                       \
--subnet-range 10.169.102.176/28                                               \
--gateway 10.169.102.177                                                        \
--no-dhcp                                                                        \
--allocation-pool start=10.169.102.180,end=10.169.102.190                         \
--description "This subnetwork for communication vRCS with MSRP" \
--network "936 RCS-MSRP"                                                 \
"936 RCS-MSRP subnet"

#--dns-nameserver 172.25.250.254

openstack network                                                           \
create                                                                      \
--description "This is network vRCS for RCS-diameter-sctp2 purpose"   \
--mtu 9000                                                                  \
--project-domain nova                                                       \
--provider-network-type vlan                                                \
--provider-physical-network datacentre                                      \
--provider-segment 933                                                      \
--external                                                                  \
"933 RCS-diameter-sctp2"

openstack subnet create                                                       \
--subnet-range 10.169.102.240/28                                               \
--gateway 10.169.102.241                                                        \
--no-dhcp                                                                        \
--allocation-pool start=10.169.102.242,end=10.169.102.254                         \
--description "This subnetwork for communication vRCS with diameter-sctp2" \
--network "933 RCS-diameter-sctp2"                                                 \
"933 RCS-diameter-sctp2 subnet"

#--dns-nameserver 172.25.250.254                                             \


openstack network                                                           \
create                                                                      \
--description "This is network vRCS for RCS-diameter-sctp1 purpose"   \
--mtu 9000                                                                  \
--project-domain nova                                                       \
--provider-network-type vlan                                                \
--provider-physical-network datacentre                                      \
--provider-segment 932                                                      \
--external                                                                  \
"932 RCS-diameter-sctp1"

openstack subnet create                                                       \
--subnet-range 10.169.102.128/28                                              \
--gateway 10.169.102.129                                                        \
--no-dhcp                                                                        \
--description "This subnetwork for communication vRCS with diameter-sctp1" \
--network "932 RCS-diameter-sctp1"                                                 \
"932 RCS-diameter-sctp1 subnet"

#--dns-nameserver 172.25.250.254                       \



openstack security group create vRCS_allowall
openstack security group rule create vRCS_allowall --protocol tcp --dst-port 1:65535
openstack security group rule create vRCS_allowall --protocol udp --dst-port 1:65535
openstack security group rule create vRCS_allowall --protocol icmp --dst-port -1
openstack security group rule create vRCS_allowall --protocol 132  --dst-port 1:65535 # SCTP настройка



# Если создавать сервер
openstack server create             \
--key-name syao-key           \
--security-group vRCS_allowall     \
--flavor vRCS.ps.NGDR              \
--image CentOS7                     \
--nic net-id=$(openstack network list -f value | grep external | awk '{print$1}') \
--wait \
rnd-pcrf-ngdr

#--user-data /home/stack/user-data-scripts/userdata-enableroot-eth0

# Если запускать из volumes
nova boot --flavor vRCS.default \
--block-device source=image,id=84c50c62-b0bc-4b14-bccf-c1991830faae,dest=volume,size=100,shutdown=preserve,bootindex=0 \
--nic net-name="922 PCRF External",v4-fixed-ip="10.169.40.41" \
--nic net-name="920 PCRF Admin",v4-fixed-ip="10.169.40.13" \
--security-groups vRCS_allowall --key-name syao-key \
rnd-pcrf-ngdr

nova boot --flavor vRCS.default --block-device source=image,id=84c50c62-b0bc-4b14-bccf-c1991830faae,dest=volume,size=100,shutdown=preserve,bootindex=0 \
--nic net-name="930 RCS-Management",v4-fixed-ip="10.169.102.74" \ #*
--nic net-name="931 RCS-Internal",v4-fixed-ip="10.169.102.9"   \
--nic net-name="932 RCS-diameter-sctp1",v4-fixed-ip="10.169.102.141"  \
--nic net-name="933 RCS-diameter-sctp2",v4-fixed-ip="10.169.102.246"    \
--nic net-name="934 RCS-ISC-SIP",v4-fixed-ip="10.169.102.150"    \
--nic net-name="936 RCS-MSRP",v4-fixed-ip="10.169.102.180"    \
--nic net-name="939 RCS-IMAP",v4-fixed-ip="10.169.102.229"    \
--security-groups vRCS_allowall                                       \
--key-name rcs                                                        \
conversation_old

openstack server delete conversation_old

nova boot --flavor vRCS.default --block-device source=image,id=84c50c62-b0bc-4b14-bccf-c1991830faae,dest=volume,size=100,shutdown=preserve,bootindex=0 \
--nic net-name="930 RCS-Management" \
--nic net-name="931 RCS-Internal",v4-fixed-ip="10.169.102.9"   \
--nic net-name="932 RCS-diameter-sctp1",v4-fixed-ip="10.169.102.141"  \
--nic net-name="933 RCS-diameter-sctp2",v4-fixed-ip="10.169.102.246"    \
--nic net-name="934 RCS-ISC-SIP",v4-fixed-ip="10.169.102.150"    \
--nic net-name="936 RCS-MSRP",v4-fixed-ip="10.169.102.180"    \
--nic net-name="939 RCS-IMAP",v4-fixed-ip="10.169.102.229"    \
--security-groups vRCS_allowall                                       \
--key-name ildar                                                        \
conversation

nova boot --flavor vRCS.default --block-device source=image,id=84c50c62-b0bc-4b14-bccf-c1991830faae,dest=volume,size=100,shutdown=preserve,bootindex=0 \
--nic net-name="930 RCS-Management" \
--nic net-name="931 RCS-Internal",v4-fixed-ip="10.169.102.9"   \
--nic net-name="932 RCS-diameter-sctp1",v4-fixed-ip="10.169.102.141"  \
--nic net-name="933 RCS-diameter-sctp2",v4-fixed-ip="10.169.102.246"    \
--nic net-name="934 RCS-ISC-SIP",v4-fixed-ip="10.169.102.150"    \
--nic net-name="936 RCS-MSRP",v4-fixed-ip="10.169.102.180"    \
--nic net-name="939 RCS-IMAP",v4-fixed-ip="10.169.102.229"    \
--security-groups vRCS_allowall                                       \
--key-name syao                                                        \
conversation_syao


nova boot --flavor vRCS.default --block-device source=image,id=84c50c62-b0bc-4b14-bccf-c1991830faae,dest=volume,size=100,shutdown=preserve,bootindex=0 \
--nic net-id="bfd74a28-2f8e-44f0-b309-02b1098549cb",v4-fixed-ip="10.169.102.74" \
--nic net-id="99838068-90d8-407e-bad3-09fbc65c6f83",v4-fixed-ip="10.169.102.9"   \
--nic net-id="283b74df-cbb7-42dc-9bcf-2d5df3bb2dc4",v4-fixed-ip="10.169.102.141"  \
--nic net-id="9d4812c5-f888-4e09-83fb-5bcb80f62934",v4-fixed-ip="10.169.102.246"    \
--nic net-id="c2ab71f6-b243-46a9-b601-227d3d2b7c79",v4-fixed-ip="10.169.102.150"    \
--nic net-id="67ab7d7f-bc3f-4e2a-9b8c-0895f92ad5c1",v4-fixed-ip="10.169.102.180"    \
--nic net-id="3d8a907d-4ad7-447e-a690-07dba563edd8",v4-fixed-ip="10.169.102.229"    \
--security-groups vRCS_allowall                                       \
--key-name rcs                                                        \
conversation

openstack server delete rnd-pcrf-ngdr
openstack subnet delete "920 PCRF Admin subnet"
openstack network delete "920 PCRF Admin"
openstack subnet delete "922 PCRF External subnet"
openstack network delete "922 PCRF External"
openstack flavor delete vRCS.ps.NGDR
openstack user delete akozlov
openstack project delete vRCS
