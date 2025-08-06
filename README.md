This application manages a static URL and associated QR code for karafun pointers, so the printed QR code always points to the current karafun session. 

## Components
QR Code for static link
Python listener sets URL by manual request and then bounces to nginx with new numeric argument
Nginx redirects to karaoke.com session URL

## Cloud Resources
Route 53 records
GCE Virtual Machine

## Files
* qrcode.png
* kfbouncy.py
* default
* external_ip.txt
* route53-updater.sh
