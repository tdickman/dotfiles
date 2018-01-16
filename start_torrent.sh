docker run --cap-add=NET_ADMIN --device=/dev/net/tun -d \
              -v /home/tom/torrents:/data \
              -v /etc/localtime:/etc/localtime:ro \
              -e "OPENVPN_PROVIDER=PIA" \
              -e "OPENVPN_CONFIG=Netherlands" \
              -e "OPENVPN_USERNAME=p0511592" \
              -e "OPENVPN_PASSWORD=$(pass show privateinternetaccess.com | head -n 1)" \
              -p 9091:9091 \
              haugene/transmission-openvpn
