NetworkManager sucks
====================

I mean, it's probably as good as whatever Windows does for managing WiFi networks,
but if you're a cranky UNIX beard like me having something that merely "just works" without
having to run a bunch of bullshit arcane command is completely unacceptable.

So, here's what I do.

Whenever I come across a new WiFi network on my Debian laptop, I add its details to a file called interfaces.csv

Here's an example interfaces.csv file.  Although it's a .csv file it only actually expects
pipe characters as delimiters.  If you want to use pipes in your essid or wpa key,
sorry, you're screwed.

```
home | wintermute | wpa | the future is already here, it's just not very evenly distributed
guest | virus-honeypot
kaffe1668 | kaffe1668 | wpa | sheeplove
starbucks | BTOpenzone-Starbucks | wep | 7f28f7ebfc
```

Then I run

```
build-etc-network-interfaces interfaces.csv > /etc/network/interfaces
```

The output of build-etc-network-interfaces is this:

```
# Generated file! Do not edit directly!
# This was generated on 2014-07-11 19:35:45.650963+01:00 by mbac, using the command:
# ./build_etc_network_interfaces /destroythesun/home/interfaces.csv
auto lo
iface lo inet loopback
allow-hotplug eth0
iface eth0 inet dhcp
iface wlan0_home inet dhcp
  wpa-ssid wintermute
  wpa-psk "the future is already here, it's just not very evenly distributed"

iface wlan0_guest inet dhcp
  wireless-essid virus-honeypot
  wireless-mode managed
  wireless-channel auto

iface wlan0_kaffe1668 inet dhcp
  wpa-ssid kaffe1668
  wpa-psk sheeplove

iface wlan0_starbucks inet dhcp
  wireless-essid BTOpenzone-Starbucks
  wireless-key1 7f28f7ebfc
  wireless-defaultkey 1
  wireless-keymode open
  wireless-channel auto
```

I use it in concert with a script called ~/bin/wifi (located here https://github.com/mbacarella/conf/blob/master/bin/wifi)

When I'm at home I run 'wifi home' to connect to my awesome WPA secured network
called, essid wintermute.  When I have guests over I tell them to connect to
virus-honeypot, which is a completely open unsecured wifi network.

When I'm at the hipster coffee shop I do 'wifi kaffe1668' and when I'm
at the corporate coffee shop I say 'wifi starbucks'.

Building build-network-interfaces
---------------------------------

You need an ocaml dev environment.  Follow the instructions here, otherwise build.sh won't work.

https://bitbucket.org/yminsky/core-hello-world/src/db1679304db4a18af72e1c2e2e88966293eb2843/PREREQUISITES.md?at=default

If you follow the prerequisites you should now have corebuild installed, which is a dependency of the compile.sh script.

Run compile.sh and you should now have a binary.

If that fails probably just give up and start drinking.


