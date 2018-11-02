#! /bin/bash

GIT="https:\/\/github.com\/mglt\/lecture-ipsec\/blob\/master"
LOCAL="\/home\/emigdan\/gitlab\/ipsec-lecture" 

sed -i -e
's/https:\/\/github.com\/mglt\/lecture-ipsec-iot\/blob\/master/\/home\/emigdan\/gitlab\/ipsec-iot-lecture/g'
./ipsec-iot-slides.md

