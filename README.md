# Main scripts 
## uniform-api
simple bash script for querying the unifi API with some example scripts

## unifi-api.sh
script for querying the api, using credentials from config.txt

```
unifi-api.sh <api_endpoint> <tmp_file>
```


## config.txt
rename config.txt.template to config.txt and edit the file

```
mv config.txt.template config.txt
vi config.txt
```

# Example scripts

## demo.sh
A few simple querys:

```
tgohde@p51:~/unifi-api$ ./demo.sh
Version 7.1.68
Subsystem WLAN: ok
Subsystem LAN: ok
Subsystem WAN: ok
                          usw      US8P60  e0:63:da:xx:yy
         AP 1. OG         uap        U7LT  18:e8:29:xx:yy
   AP 1.OG Kueche         uap       U7PG2  f4:92:bf:xx:yy
                          usw        US24  18:e8:29:xx:yy
            AP DG         uap        U7LT  18:e8:29:xx:yy
                          ugw        UGW3  e0:63:da:xx:yy
```                          

## unifi_devices.sh
created device_extrakt.json

Content:

```
cat device_extrakt.json |jq .
{
  "model": "US8P60",
  "ip": "192.168.0.156",
  "mac": "e0:63:da:54:xx:yy",
  "dns": "unifi-sw-8.intern.tld."
}
{
  "model": "US24",
  "ip": "192.168.0.155",
  "mac": "18:e8:29:b1:xx:yy",
  "dns": "unifi-sw-24.intern.tld."
}
{
  "model": "UGW3",
  "ip": "192.168.0.254",
  "mac": "e0:63:da:54:xx:yy",
  "dns": "usg.intern.tld."
}
```

Create a table with jtbl:

```
cat device_extrakt.json | jq -c | jtbl
model    ip             mac                dns
-------  -------------  -----------------  -------------------------
US8P60   192.168.0.156  e0:63:da:54:xx:yy  unifi-sw-8.intern.tld.
US24     192.168.0.155  18:e8:29:b1:xx:yy  unifi-sw-24.intern.tld.
UGW3     192.168.0.254  e0:63:da:54:xx:yy  usg.intern.tld.
```

## unifi_clients.sh

```
./unifi_clients.sh
| is_wired   | hostname            | ip            |   uptime | mac               | oui                                     |   first_seen |   last_seen |   tx_bytes |   rx_bytes |
|------------|---------------------|---------------|----------|-------------------|-----------------------------------------|--------------|-------------|------------|------------|
| False      | tasmota-6FF921-6433 | 192.168.0.40  |     3357 | 84:0d:8e:6f:xx:yy | Espressif Inc.                          |   1658010632 |  1667127473 |      14296 |     156900 |
| False      | Pixel-4a            | 192.168.0.135 |     4843 | f8:0f:f9:dd:xx:yy | Google, Inc.                            |   1638827929 |  1667127473 |   33979391 |     597483 |
| False      |                     | 192.168.0.75  |     8160 | 60:1d:91:61:xx:yy | Motorola Mobility LLC, a Lenovo Company |   1661547417 |  1667127473 |  748577976 |   28225600 |
| False      | p51                 | 192.168.0.109 |    13822 | 28:c6:3f:9d:xx:yy | Intel Corporate                         |   1638370052 |  1667127473 |  263706700 |   15929046 |
| False      | tasmota-05ACE9-3305 | 192.168.0.35  |   131479 | ec:fa:bc:05:xx:yy | Espressif Inc.                          |   1656605655 |  1667127481 |     519780 |    6506635 |
| False      | tasmota-192F5D-3933 | 192.168.0.46  |   132949 | 70:03:9f:19:xx:yy | Espressif Inc.                          |   1658226849 |  1667127473 |     454301 |    6635346 |
| False      | tasmota-30BBF8-7160 | 192.168.0.37  |   132966 | bc:dd:c2:30:xx:yy | Espressif Inc.                          |   1656667426 |  1667127473 |     458460 |    6181675 |
| True       | EPSONAA488B         |               |       46 | 38:9d:92:aa:xx:yy | SeikoEps                                |   1610627302 |  1667127476 |            |            |
| True       |                     | 192.168.0.6   |    41644 | e4:11:5b:13:xx:yy | HewlettP                                |   1603299243 |  1667127476 |            |            |
| True       | NPI1182E3           | 192.168.0.233 |    52230 | 94:57:a5:11:xx:yy | Hewlett Packard                         |   1639320187 |  1667127476 |            |            |
| True       | mmrp3               | 192.168.0.172 |   587332 | b8:27:eb:6e:xx:yy | Raspberry Pi Foundation                 |   1660040270 |  1667127476 |            |            |
| True       | t530                | 192.168.0.107 |   598371 | 3c:97:0e:cc:xx:yy | Wistron InfoComm(Kunshan)Co.,Ltd.       |   1666464823 |  1667127497 |            |            |
| True       |                     | 192.168.0.177 |   820180 | 00:0c:29:5d:xx:yy | VMware, Inc.                            |   1666307348 |  1667127476 |            |            |
| True       | raspi43             | 192.168.0.163 |  1664205 | dc:a6:32:b3:xx:yy | Raspberry Pi Trading Ltd                |   1663497417 |  1667127476 |            |            |
| True       |                     | 192.168.0.61  |  1664206 | 00:0c:29:6b:xx:yy | Vmware                                  |   1585977801 |  1667127476 |            |            |
| True       | SqueezeboxRadio     | 192.168.0.199 |  1664216 | 00:04:20:28:xx:yy | Slim Devices, Inc.                      |   1663497417 |  1667127497 |            |            |
```
