Requisitos
==========

- Un bucket de S3 (el cuál a partir de ahora llamaremos **oas-repo**) con el siguiente contenido.

  - Un archivo en la ruta: `files/common/etc/ssh/ssh_known_hosts`
    El contenido de este archivo **debe** contener de la salida del comando: `ssh-keyscan -t rsa github.com` el archivo puede contener otras llaves públicas sin embargo para este proyecto unicamente se necesita la de github.com.

    Esto permitirá a las instancias iniciadas en el stack identificar la identidad del servidor SSH de Github sin compromoter la seguridad. Github internamente rota sus llaves si ellos consideran que se han visto comprometidas. Por lo cuál este valor **no** debe estar quemado en el código. Ni tampoco debe generarse desatendidamente, pues **debe** verificarse que al recibir la llave esta tiene la [firma de los servidores de Github](https://help.github.com/articles/what-are-github-s-ssh-key-fingerprints/)

    Esto se hace de la siguiente manera.

    ```
    ssh-keyscan -t rsa github.com > /tmp/github_known_host
    ssh-keygen -lf /tmp/github_known_host
    ```
- Un usuario de IAM en la cuenta de AWS (el cuál a partir de ahora llamaremos **cloudformer**) con los siguientes privilegios:
  - Los mismos privilegios del usuario **ami-builder** los cuales se listan en el proyecto **oas-condor-estudiantes-ami**.
  - Poder manipular "stacks" de CloudFormation
  - Manipular Elastic Load Balancers (ELB)
  - Manipular AutoScaling Groups (ASG)
  - Durante pruebas enviar correo mediante AWS SES.
  - Permiso de lectura a otros recursos (Security Groups, etc)

    ```
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "Stmt1465787057905",
          "Action": "cloudformation:*",
          "Effect": "Allow",
          "Resource": "*"
        },
        {
          "Sid": "Stmt1465787127350",
          "Action": "elasticloadbalancing:*",
          "Effect": "Allow",
          "Resource": "*"
        },
        {
          "Sid": "Stmt1465787155819",
          "Action": "autoscaling:*",
          "Effect": "Allow",
          "Resource": "*"
        },
        {
          "Sid": "Stmt1465787155820",
          "Effect":"Allow",
          "Action":"ses:SendRawEmail",
          "Resource":"*"
        },
        {
          "Sid": "Stmt1465787155821",
          "Effect":"Allow",
          "Action":"ec2:DescribeSecurityGroups",
          "Resource":"*"
        }
      ]
    }
    ```
- Un rol de IAM en la cuenta (el cuál **debe** llamarse **oas-condor-role**) basado en "Amazon EC2 AWS Service Roles". Este rol debe tener los siguientes privilegios.
  - Los mismos privilegios del rol **oas-ami-builder-role** los cuales se listan en el proyecto **oas-condor-estudiantes-ami**.
  - Además la posibilidad de terminar instancias de EC2, esto le permitirá a la instancia terminarse a si misma.

     ```
     {
       "Version": "2012-10-17",
       "Statement": [
         {
           "Sid": "Stmt1465769105189",
           "Action": [
             "ec2:TerminateInstances"
           ],
           "Effect": "Allow",
           "Resource": "*"
         }
       ]
     }
     ```

Paso a producción
-----------------

Para pasar a producción se requiere:

- Credenciales SMTP al servicio AWS SES creado a partir de https://console.aws.amazon.com/ses/home?region=us-east-1#smtp-settings:
  - La validación de dominios de SES no hace parte del **scope** de este proyecto.
- Agregar a ElasticLoadBalancing el certificado SSL validado para el dominio a usar, documentación: http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_server-certs.html, una vez el certificado haya sido subido, este ELB puede borrarse, la plantilla de CloudFormation creará un nuevo ELB utilizando este certificado.
- Un par de llaves de SSH (RSA) la parte privada será parámetro del Stack de producción y la parte pública debe ser agregada como "Deploy key" en el repositorio de código de "condor-estudiantes".
