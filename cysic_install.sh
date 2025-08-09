#!/bin/bash

# 1. Оновлення пакетів
echo "Оновлення пакетів..."
sudo apt update -y

# 2. Перевірка та встановлення figlet і lolcat
echo "Перевірка та встановлення figlet і lolcat..."
if ! command -v figlet &> /dev/null; then
    sudo apt install figlet -y
fi

if ! command -v lolcat &> /dev/null; then
    sudo apt install lolcat -y
fi

# 3. Виведення figlet тексту
if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
    figlet "by DaveGrey" | lolcat
fi

# 4. Оголошення про початок встановлення
echo "---"
echo "Починається встановлення ноди Verifier Cysic."
echo "---"

# 5. Запит адреси EVM
read -p "Будь ласка, введіть вашу EVM адресу для винагороди: " EVM_ADDRESS

# 6. Виконання команди встановлення з підстановкою адреси
echo "Виконання скрипту встановлення..."
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh && bash ~/setup_linux.sh "$EVM_ADDRESS"

# 7. Перевірка та встановлення screen
echo "Перевірка та встановлення screen..."
if ! command -v screen &> /dev/null; then
    sudo apt install screen -y
fi

# 8. Запуск нової сесії screen
echo "Запуск нової сесії screen під назвою 'cysic'..."
screen -S cysic

# 9. Запуск вузла
echo "Запуск вузла Verifier Cysic..."
screen -S cysic -X stuff "cd ~/cysic-verifier/ && bash start.sh$(printf '\r')"
