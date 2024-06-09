# Infraestructura como codigo

## Introducción
Todos los recursos utilizados en este proyecto fueron desplegados con *Infraestructura como Código (IaC)*, específicamente con la herramienta llamada **Terraform**. Todos los archivos utilizados para la ejecución del mismo se encuentran en la carpeta [terraform](/example-voting-app/terraform/).


## Estructura de la carpeta
```
📦terraform
 ┣ 📂modules
 ┃ ┣ 📂acr          # Despliega el Azure Container Registry
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┣ 📜output.tf
 ┃ ┃ ┗ 📜vars.tf
 ┃ ┣ 📂aks          # Despliega el Azure Kubernetes Sevice (AKS) y asignación de rol AcrPull
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┣ 📜output.tf
 ┃ ┃ ┗ 📜vars.tf
 ┃ ┣ 📂dns          # Despliega una Zona DNS
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┣ 📜output.tf
 ┃ ┃ ┗ 📜vars.tf
 ┃ ┗ 📂rg           # Despliega el grupo derecursos principal
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┣ 📜output.tf
 ┃ ┃ ┗ 📜vars.tf
 ┣ 📜main.tf
 ┣ 📜output.tf
 ┣ 📜provider.tf
 ┗ 📜vars.tf
```
## Consideraciones

Tomando en cuenta *Coding Standard*, por lo que tal como se puede observar en esta carpeta, la infraestructura se encuentra dividida en módulos, para asegurar la reutilización del código. Por otro lado, cada una de las variables están debidamente definidas y descritas en cada `vars.tf` por lo que se entiende claramente el propósito de cada uno de ellas, esto en conjunto con un debido espaciado de la asignación de valores, mejoran significativamente la legibilidad y calidad del código. 


La finalidad de esta infraestructura es automatizar el proceso del despliegue del *clúster de kubernetes en Azure (AKS)*, tal como se muestra en el siguiente diagrama, este despliega automáticamente el grupo de recursos del proyecto, una *Zona DNS*, un *registro de contenedores (ACR)* y finalmente el *clúster de kubernetes (AKS)* el cual ira atado automáticamente al registro de contenedores y el grupo de recursos previamente creados.


![Infraestructura en la nube](images/IacInfraestructre.png)


Las variables requeridas para el despliegue de estos recursos son las siguientes: 

| Variable            | Descripción                                                      | Valor actual              |
| ------------------- | ---------------------------------------------------------------- | ------------------------  | 
| resource_group_name | Nombre del grupo de recursos donde estaran alojados los recursos | rg-example-voting-app     |
| location            | Localización fisica donde estarán alojados los servicios         | eastus2                   |
| cluster_name        | Nombre deseado para el cluster a crear                           | aks-example-voting-app    |
| dns_prefix          | Prefijo DNS asignado al cluster a desplegar                      | example-voting-app        |
| cluster_sku_tier    | Es el plan de costo que tendrá el cluster a despegar             | Standard                  |
| node_pool_name      | Nombre del VMSS que se desplegará para el AKS                    | agent                     |
| node_count          | Cantidad de nodos que estararán disponible para el AKS           | Standard_D2s_v3           |
| node_pool_vmsize    | Esta es la categoria del VMSS del clúster                        | acrregistrovotingapp      |
| registry_name       | Nombre del registro de contenedores (ACR)                        | Basic                     |
| domain_name         | Nombre de dominio de la Zona DNS                                 | cluster-demostracion.live |


Dichas variables se encuentran dentro de una lista, de esta forma es posible crear un nuevo cluster con cada unos los elementos necesarios simplemente añadiéndole un elemento mas a dicha lista con los valores deseados. Tal como se muestra a continuación:


### Declaración de variables en `vars.tf` para un clúster:

```
default = [
      {
        resource_group_name = "rg-example-voting-app-PRIMERO"
        location = "eastus2"
        aks_list = [{
            cluster_name = "aks-example-voting-app-PRIMERO"
            dns_prefix = "example-voting-app"
            cluster_sku_tier = "Standard"
            node_pool_name = "agent"
            node_count = 1
            node_pool_vmsize = "Standard_D2s_v3"
            registry_name = "acrregistrovotingappprimero"
            registry_sku_tier = "Basic"
            domain_name = "PRIMERO-cluster-demostracion.live"
       }
     ]
    }
  ]
```

### Servicios a desplegar:

```
. . .
  # module.resource-group["rg-example-voting-app-PRIMERO"].azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + location = "eastus2"
      + name     = "rg-example-voting-app-PRIMERO"
    }

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].azurerm_kubernetes_cluster.aks will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
. . .
      + name                                = "aks-example-voting-app-PRIMERO"
. . .
    }

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].azurerm_role_assignment.ra_aks will be created
  + resource "azurerm_role_assignment" "ra_aks" {
      + role_definition_name             = "AcrPull"
. . .
    }

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].module.azure-containter-registry.azurerm_container_registry.acr will be created
  + resource "azurerm_container_registry" "acr" {
. . .
      + name                          = "acrregistrovotingappprimero"
. . .
    }

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].module.azure-dns-zone.azurerm_dns_zone.dns will be created
  + resource "azurerm_dns_zone" "dns" {
      + name                      = "PRIMERO-cluster-demostracion.live"
. . .
    }

Plan: 5 to add, 0 to change, 0 to destroy.
```

### Declaración de variables en vars.tf para dos clúster:
```
  default = [
    {
      resource_group_name = "rg-example-voting-app-PRIMERO"
      location = "eastus2"
      aks_list = [{
          cluster_name = "aks-example-voting-app-PRIMERO"
          dns_prefix = "example-voting-app-PRIMERO"
          cluster_sku_tier = "Standard"
          node_pool_name = "agent"
          node_count = 1
          node_pool_vmsize = "Standard_D2s_v3"
          registry_name = "acrregistrovotingappprimero"
          registry_sku_tier = "Basic"
          domain_name = "PRIMERO-cluster-demostracion.live"
        }
      ]
    },
    {
      resource_group_name = "rg-example-voting-app-SEGUNDO"
      location = "eastus2"
      aks_list = [{
          cluster_name = "aks-example-voting-app-SEGUNDO"
          dns_prefix = "example-voting-app-SEGUNDO"
          cluster_sku_tier = "Standard"
          node_pool_name = "agent"
          node_count = 1
          node_pool_vmsize = "Standard_D2s_v3"
          registry_name = "acrregistrovotingappsegundo"
          registry_sku_tier = "Basic"
          domain_name = "SEGUNDO-cluster-demostracion.live"
        }
      ]
    }
  ]
```

### Servicios a desplegar:

```
  # module.resource-group["rg-example-voting-app-PRIMERO"].azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
. . .
      + name     = "rg-example-voting-app-PRIMERO"
. . .
    }

  # module.resource-group["rg-example-voting-app-SEGUNDO"].azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
. . .
      + name     = "rg-example-voting-app-SEGUNDO"
. . .
}

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].azurerm_kubernetes_cluster.aks will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
. . .
      + name                                = "aks-example-voting-app-PRIMERO"
. . .
    }

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].azurerm_role_assignment.ra_aks will be created
  + resource "azurerm_role_assignment" "ra_aks" {
. . .
      + role_definition_name             = "AcrPull"
. . .
    }

  # module.resource-group["rg-example-voting-app-SEGUNDO"].module.azure-kubernetes-service["aks-example-voting-app-SEGUNDO"].azurerm_kubernetes_cluster.aks will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
. . .
      + name                                = "aks-example-voting-app-SEGUNDO"
. . .
    }

  # module.resource-group["rg-example-voting-app-SEGUNDO"].module.azure-kubernetes-service["aks-example-voting-app-SEGUNDO"].azurerm_role_assignment.ra_aks will be created
  + resource "azurerm_role_assignment" "ra_aks" {
. . .
      + role_definition_name             = "AcrPull"
. . .
    }

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].module.azure-containter-registry.azurerm_container_registry.acr will be created
  + resource "azurerm_container_registry" "acr" {
. . .
      + name                          = "acrregistrovotingappprimero"
. . .
    }

  # module.resource-group["rg-example-voting-app-PRIMERO"].module.azure-kubernetes-service["aks-example-voting-app-PRIMERO"].module.azure-dns-zone.azurerm_dns_zone.dns will be created
  + resource "azurerm_dns_zone" "dns" {
. . .
      + name                      = "PRIMERO-cluster-demostracion.live"
. . .
    }

  # module.resource-group["rg-example-voting-app-SEGUNDO"].module.azure-kubernetes-service["aks-example-voting-app-SEGUNDO"].module.azure-containter-registry.azurerm_container_registry.acr will be created
  + resource "azurerm_container_registry" "acr" {
. . .
      + name                          = "acrregistrovotingappsegundo"
. . .
    }

  # module.resource-group["rg-example-voting-app-SEGUNDO"].module.azure-kubernetes-service["aks-example-voting-app-SEGUNDO"].module.azure-dns-zone.azurerm_dns_zone.dns will be created
  + resource "azurerm_dns_zone" "dns" {
. . .
      + name                      = "SEGUNDO-cluster-demostracion.live"
. . .
    }

Plan: 10 to add, 0 to change, 0 to destroy.
```
---
## Procedimiento
1.	Inicialmente se deben proveer las credenciales para acceder al ambiente en el que serán desplegados los recursos, en este caso será *Azure*, por lo que se accederá con el comando `az login`. Esto abrirá una pestaña en el navegador predeterminado con la Ventana de login de Microsoft, en la cual se deben colocar las credenciales de acceso para el tenant en la que se desean desplegar los recursos. 

```
> az login
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "XXXXXXXXXXX-XXXX-XXXXXX-XXXX-XXXXXXXXXXX",
    "id": "XXXXXXXXXXX-XXXX-XXXXXX-XXXX-XXXXXXXXXXX",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "XXXXXXXXXXX-XXXX-XXXXXX-XXXX-XXXXXXXXXXX",
    "user": {
      "name": "example@sample.com",
      "type": "user"
    }
  }
]
```


2.	Este paso es sumamente importante, se debe cerciorar de que la suscripción activa es la correcta ya que en caso de contar con los permisos necesarios en la suscripción equivocada, se desplegaran los servicios erróneamente, pudiendo esto incurrir en gastos significantes. para cambiar la susbripción activa se utiliza el siguiente comando:
```
az account set --subscription "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```


3.	Dentro del directorio en los que se encuentran los archivos de terraform, se debe inicializar el directorio de trabajo y esto se logra con el comando `terraform init`.

```
> terraform init

Initializing the backend...
Initializing modules...
- resource-group in modules\rg
- resource-group.azure-kubernetes-service in modules\aks
- resource-group.azure-kubernetes-service.azure-containter-registry in modules\acr
- resource-group.azure-kubernetes-service.azure-dns-zone in modules\dns

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "3.106.1"...
- Finding latest version of hashicorp/azuread...
- Installing hashicorp/azurerm v3.106.1...
- Installed hashicorp/azurerm v3.106.1 (signed by HashiCorp)
- Installing hashicorp/azuread v2.51.0...
- Installed hashicorp/azuread v2.51.0 (signed by HashiCorp)
. . .
Terraform has been successfully initialized!
. . .
```


4.	Luego de esto fue necesario validar si la sintaxis del proyecto es correcta, además de previsualizar los recursos que serán desplegados, para ellos fue necesario el comando `terraform plan`.
```
> terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.resource-group["rg-example-voting-app"].azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
. . .
    }
  # module.resource-group["rg-example-voting-app"].module.azure-kubernetes-service["aks-example-voting-app"].azurerm_kubernetes_cluster.aks will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
. . .
    }
  # module.resource-group["rg-example-voting-app"].module.azure-kubernetes-service["aks-example-voting-app"].azurerm_role_assignment.ra_aks will be created
  + resource "azurerm_role_assignment" "ra_aks" {
. . .
    }
  # module.resource-group["rg-example-voting-app"].module.azure-kubernetes-service["aks-example-voting-app"].module.azure-containter-registry.azurerm_container_registry.acr will be created
  + resource "azurerm_container_registry" "acr" {
. . .
    }
  # module.resource-group["rg-example-voting-app"].module.azure-kubernetes-service["aks-example-voting-app"].module.azure-dns-zone.azurerm_dns_zone.dns will be created
  + resource "azurerm_dns_zone" "dns" {
. . .
    }

Plan: 5 to add, 0 to change, 0 to destroy.
```

5.	Dado que el plan fue exitoso, se procede con el despliegue de los servicios, para ello se utiliza el comando `terraform apply` este mostrará en pantalla un mensaje similar a la generada por plan, pero este pedirá al usuario una confirmación de *yes*, por lo que se debe ingresar textualmente esta palabra y automáticamente comenzará a crear los servicios descritos.
```
> terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

. . .

Plan: 5 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.resource-group["rg-example-voting-app"].azurerm_resource_group.rg: Creating...
module.resource-group["rg-example-voting-app"].azurerm_resource_group.rg: Still creating... [10s elapsed]
module.resource-group["rg-example-voting-app"].azurerm_resource_group.rg: Creation complete after 14s [id=/subscriptions/111111111-123e12-2222-33333-4444444/resourceGroups/rg-example-voting-app]
module.resource-group["rg-example-voting-app"].module.azure-kubernetes-service["aks-example-voting-app"].module.azure-dns-zone.azurerm_dns_zone.dns: Creating...

. . .
```

6.	Una vez finalizado, notificará si el despliegue fue exitoso e indicará la cantidad de recursos que han sido creados.
```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

7.	Los recursos desplegaso pueden comprobarse desde la interfaz gráfica de Azure (Azure Portal).

![Infraestructura en la nube](images/Azure_Portal.jpg)