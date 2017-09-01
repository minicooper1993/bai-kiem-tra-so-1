#!/bin/bash

#check nmap da duoc cai dat chua, neu chua duoc cai thi cai nmap
dpkg -s nmap > /dev/null 2>&1

if [ $? -eq 0 ]; then 
   echo "Nmap da duoc cai"
else
   echo "Nmap chua duoc cai"
   echo "Nhap vao mat khau root de cai dat nmap"
   sudo  apt install nmap
fi

#Nhap vao dai mang can check
echo "Nhap vao dai mang can check"
read daimang;

#Su dung nmap de check cac host dang up sau do luu cac host nay ra 1 tap tin
sudo nmap -sP $daimang | cut -d ' ' -f 5 | awk '/[0-9.[0-9].[0-9].[0-9]/{print}' > bai1.txt

#Nhan dien he dieu hanh qua port su dung
while read ip;
do 
#   nmap -p 22 $ip > /dev/null 2>&1
 nc -zv $ip 22 > /dev/null 2>&1
 if [ $? -eq 0 ]; then 
    echo "Host $ip is linux"
 else
    nc -zv $ip 3389 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
       echo "Host $ip is windows"
    else
       echo "Host $ip is unknown"
    fi
 fi 
done <bai1.txt

