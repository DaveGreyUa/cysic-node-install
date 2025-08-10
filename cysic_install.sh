#!/bin/bash

# 1. Оновлення пакетів
echo "Обновление пакетов [5%=>......................................]"
sudo apt update -y

# 2. Перевірка та встановлення figlet і lolcat
echo "Обновление пакетов [15%=====>.................................]"
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
echo "---------------------------------------------------------------"
echo "---------------Установка ноды Verifier Cysic.------------------"
echo "---------------------------------------------------------------"

# 5. Запит адреси EVM
read -p "Пожалуйста, введите ваш EVM адрес для вознаграждения: " EVM_ADDRESS

# 6. Виконання команди встановлення з підстановкою адреси
echo "Выполнение скрипта установки [35%=======>.....................]"
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh && bash ~/setup_linux.sh "$EVM_ADDRESS"

# 7. Створення файлу системної служби
echo "Создание системной службы Cysic [63%===============>..........]"
sudo tee /etc/systemd/system/cysic.service > /dev/null << EOF
[Unit]
Description=Cysic Verifier Node
After=network-online.target

[Service]
User=$USER
ExecStart=/bin/bash -c 'cd $HOME/cysic-verifier && bash start.sh'
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# 8. Перезавантаження конфігурації systemd та запуск служби
echo "Перезагрузка systemd и запуск службы [97%==================>..]"
sudo systemctl daemon-reload
sudo systemctl enable cysic
sudo systemctl start cysic

echo "---------------------------------------------------------------"
echo "-Установка завершена. Нода Cysic запущена как системная служба-"
echo "---------------------------------------------------------------"
echo "Для просмотра логов в реальном времени выполните:"
echo "sudo journalctl -u cysic -f --no-hostname -o cat"
