#!/bin/bash

echo "=== JWT Token Debug ==="

echo "1. Decode JWT token (แสดง header และ payload):"
echo "ใส่ JWT token ของคุณ:"
read token

echo -e "\nHeader:"
echo "$token" | cut -d'.' -f1 | base64 -d 2>/dev/null | jq . || echo "ต้องติดตั้ง jq"

echo -e "\nPayload:"
echo "$token" | cut -d'.' -f2 | base64 -d 2>/dev/null | jq . || echo "ต้องติดตั้ง jq"

echo -e "\n3. ตรวจสอบว่าหมดอายุหรือไม่:"
exp=$(echo "$token" | cut -d'.' -f2 | base64 -d 2>/dev/null | jq -r .exp 2>/dev/null)
if [ "$exp" != "null" ] && [ "$exp" != "" ]; then
    current_time=$(date +%s)
    if [ $exp -lt $current_time ]; then
        echo "❌ Token หมดอายุแล้ว! (exp: $exp, now: $current_time)"
    else
        echo "✅ Token ยังไม่หมดอายุ (exp: $exp, now: $current_time)"
    fi
else
    echo "❌ ไม่สามารถอ่าน exp จาก token"
fi

echo -e "\n4. ตรวจสอบ issuer:"
issuer=$(echo "$token" | cut -d'.' -f2 | base64 -d 2>/dev/null | jq -r .iss 2>/dev/null)
echo "Issuer: $issuer"
echo "ควรเป็น: https://sso.shopsthai.com"
