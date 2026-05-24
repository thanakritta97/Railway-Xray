#!/bin/sh

echo "🚀 Starting Railway Xray + Caddy..."

# ตั้งค่า PORT
export PORT=${PORT:-8080}

# สร้าง config Xray
cat > /xray.json << EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [{
    "tag": "vless-in",
    "port": $PORT,
    "listen": "0.0.0.0",
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "$UUID"}],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "xhttp",
      "security": "none",
      "xhttpSettings": {
        "path": "$PATH",
        "host": "$DOMAIN"
      }
    }
  }],
  "outbounds": [{"tag": "direct", "protocol": "freedom"}]
}
EOF

echo "✅ Xray config created on port $PORT"

# รัน Xray
exec xray run -c /xray.json
