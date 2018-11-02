#! /bin/bash

GIT="https:\/\/github.com\/mglt\/lecture-ipsec\/blob\/master"
LOCAL="\/home\/emigdan\/gitlab\/ipsec-lecture" 

sed -i -e
's/\/home\/emigdan\/gitlab\/ipsec-iot-lecture/https:\/\/github.com\/mglt\/lecture-ipsec-iot\/blob\/master/g'
./ipsec-iot-slides.md

