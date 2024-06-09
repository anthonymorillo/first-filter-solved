sudo apt update # Actualizar la lista de paquetes


sudo apt -y install git # Instalar git


curl -sL https://aka.ms/InstallAzureCLIDeb  | sudo bash # Instalación de Azure CLI


# Instalación de Powershell:
sudo apt-get install -y wget apt-transport-https software-properties-common # Instalar los paquetes de pre-requesito
source /etc/os-release # Version de ubuntu
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb # Descargar las llaves del repositorio de Microsoft
sudo dpkg -i packages-microsoft-prod.deb # Registrar las llaves del repositorio de Microsoft
rm packages-microsoft-prod. # Borrar el archivo con las llaves del repositorio de Microsoft
sudo apt-get update # Actualizar la lista de paquetes despues de añadir packages.microsoft.com
sudo apt-get install -y powershell # Instalar PowerShell


# Instalación de Docker:
sudo apt -y install ca-certificates curl 
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg  -o /etc/apt/keyrings/docker.asc 
sudo chmod a+r /etc/apt/keyrings/docker.asc 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io  docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 


#  Instalación de kubectl:
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg 
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg 
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/  /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list 
sudo apt-get update 
sudo apt-get install -y kubectl


# Instalación de Helm:
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 
chmod 700 get_helm.sh
./get_helm.sh

# Instalación de Java:
sudo apt install openjdk-17-jdk