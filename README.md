Requisitos
==========

 - Un bucket de S3 (el cuál a partir de ahora llamaremos **oas-repo**) con el siguiente contenido.
   - Un archivo en la ruta: `files/common/etc/ssh/ssh_known_hosts`
     El contenido de este archivo **debe** ser de la salida del comando: `ssh-keyscan -t rsa github.com`

     Esto permitirá a las instancias iniciadas en el stack identificar la identidad del servidor SSH de Github sin compromoter la seguridad. Github internamente rota sus llaves si ellos consideran que se han visto comprometidas. Por lo cuál este valor no debe estar quemado en el código. Ni tampoco debe generarse automáticamente, pues **debe** verificarse que al recibir la llave esta tiene la [firma de los servidores de Github](https://help.github.com/articles/what-are-github-s-ssh-key-fingerprints/)

 - Un rol de IAM en la cuenta (el cuál a partir de ahora llamaremos **oas-condor-role**) basado en "Amazon EC2 AWS Service Roles"
   - El rol **oas-condor-role** debe tener los siguientes privilegios.
     - `ec2:TerminateInstances` (esto le permitirá a la instancia terminarse a si misma si no se encuentra "saludable")
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
