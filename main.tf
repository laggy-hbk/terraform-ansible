terraform {
  required_providers {
    yandex = {
      source  = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  service_account_key_file     = "/home/laggy/authorized_key.json"  # ключ генерируем в консоли клауда, json копируем в корневую папку
  cloud_id  = "b1gihrb8e2lfh53p9raj"
  folder_id = "b1g8lkui6tenibogtiep"
  zone      = "ru-central1-b"
}


resource "yandex_compute_instance" "vm1" {
  name        = "vm1"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8sq3r72r0caul0fn37" # Ubuntu 20.04
    }
  }

  network_interface {
    subnet_id = "e2lqlrbc60ocd2tdsp2k" # правильное имя дефолтной подсети
    nat       = true
  }

    metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/laggy-terraform-key.pub")}"  # на локальной машине генерим ключевую пару, .pub передаем на созданную ВМ (user: ubuntu)
  }
provisioner "local-exec" {
  command = <<EOT
    sleep 30 && \
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${self.network_interface.0.nat_ip_address}, playbook.yml \
    --private-key /home/laggy/.ssh/laggy-terraform-key -u ubuntu
  EOT
}
}

output "vm_ip" {
  value = yandex_compute_instance.vm1.network_interface.0.nat_ip_address     
}



variable "yc_token" {
  type      = string
  sensitive = true
}

