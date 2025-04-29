# terraform-ansible
Создание инфраструктуры в Яндекс облаке + установка ПО

## Описание

В данном проекте разворачивается виртуальная машина в Yandex Cloud с помощью Terraform. Затем на неё с помощью Ansible устанавливается Apache и размещается файл `index.html`.

## Используемые технологии

- Terraform — для создания инфраструктуры в Yandex Cloud
- Ansible — для конфигурации ВМ и установки ПО
- Yandex Cloud — облачный провайдер
- Ubuntu 20.04 — ОС на виртуальной машине

## Архитектура

```
Local Machine
│
├── Terraform → Yandex Cloud → ВМ (Ubuntu 20.04)
│                              └── Apache2
│                              └── index.html
└── Ansible → Конфигурация и деплой на ВМ
```

## Шаги для запуска

### 1. Инициализация Terraform
```bash
terraform init
```

### 2. Создание инфраструктуры
```bash
terraform apply
```
*Создаётся ВМ, генерируется SSH-ключ, получаем внешний IP*

### 3. Установка Apache через Ansible
```bash
ansible-playbook -i <EXTERNAL_IP>, install_apache.yml --private-key id_rsa -u ubuntu
```

### 4. Проверка
Перейдите по IP-адресу ВМ в браузере:
```
http://<EXTERNAL_IP>
```

## Файлы

- `main.tf` — конфигурация Terraform
- `install_apache.yml` — playbook Ansible
- `index.html` — файл, размещаем в корневой директории пользователя

