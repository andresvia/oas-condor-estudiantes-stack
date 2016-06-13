Requisitos
==========

- Un bucket de S3 (el cuál a partir de ahora llamaremos **oas-repo**) con el siguiente contenido.

  - Un archivo en la ruta: `files/common/etc/ssh/ssh_known_hosts`
    El contenido de este archivo **debe** ser de la salida del comando: `ssh-keyscan -t rsa github.com`

    Esto permitirá a las instancias iniciadas en el stack identificar la identidad del servidor SSH de Github sin compromoter la seguridad. Github internamente rota sus llaves si ellos consideran que se han visto comprometidas. Por lo cuál este valor **no** debe estar quemado en el código. Ni tampoco debe generarse desatendidamente, pues **debe** verificarse que al recibir la llave esta tiene la [firma de los servidores de Github](https://help.github.com/articles/what-are-github-s-ssh-key-fingerprints/)

    Esto se hace de la siguiente manera.

    ```
    ssh-keyscan -t rsa github.com > /tmp/github_known_host
    ssh-keygen -lf /tmp/github_known_host
    ```
- Un usuario de IAM en la cuenta de AWS (el cuál a partir de ahora llamaremos **cloudformer**) con los siguientes privilegios:
  - Los mismos privilegios del usuario **ami-builder** los cuales se listan en el proyecto **oas-condor-estudiantes-ami**.
  - Además la posibilidad de manipular "stacks" de CloudFormation, Elastic Load Balancers ELBs y AutoScaling Groups ASGs.

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
