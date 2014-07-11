#!/bin/bash

set -e

corebuild build_etc_network_interfaces.native
mv build_etc_network_interfaces.native build_etc_network_interfaces
