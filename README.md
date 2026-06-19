Miniproyecto el cual se encargara de por medio del uso de jenkins + terraform , conectarse a floci de forma local y habilitar servicios por medio de los templates de terraform.

Tecnologias a usar:
- Jenkins (Habilitacion de jenkins en un contenedor)
- Terraform (Habilitacion del plugin de terraform en jenkins)
- Floci (Instalacion de floci en un contenedor el cual permite habilitar servicios de aws de forma local https://github.com/floci-io/floci)

Inicio de floci 

Comando aws cli para conectarse a floci de forma local.

Primero se deben exportar las variables de entorno para el uso del cli de aws.

export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=

Luego en la carpetas ~/.aws/config y ~/.aws/credential, se debe configurar un perfil y agregar las credenciales asociadas.


Se deja documentacion floci para configuracion de cliente:
https://floci.io/floci/getting-started/aws-setup/


Comando cliente de ejemplo para listar los s3 existentes:

aws s3 ls --profile floci --endpoint-url http://localhost:4566

Comandos para terraform:

- terraform init
- terraform plan -out=miplan.tfplan
- terraform apply miplan-tfplan


Rollback:

- terraform destroy -auto-approve
