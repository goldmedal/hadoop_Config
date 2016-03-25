#!/bin/bash
lvresize -L -$1 /dev/VolGroup/lv_home
lvresize -L +$1 /dev/VolGroup/lv_root
resize2fs /dev/VolGroup/lv_root
