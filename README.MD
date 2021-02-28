# Ansible + Terraform AWS EC2 creation and docker go application deployment

This project creates an EC2 machine in AWS cloud, install docker and related dependencies on it and deploy a containerized go application, serving it in HTTP and HTTPS through Nginx.

## How to run the code:

First of all, after pulling the project, please insert your AWS root access and secret key into terraform main.tf below section:

```
provider "aws" {
  region = "us-east-2"
  access_key = ""       --- INSERT YOUR ROOT ACCESS KEY HERE
  secret_key = ""       --- INSERT YOUR ROOT SECRET KEY HERE
  
}
```

Also, please insert your EC2 access key name pen under local variable private_key_path

```
locals {
  ssh_user = "ubuntu"
  key_name = "access-key"
  private_key_path = "/home/ubuntu/ansible/access-key.pem"  --- INSERT YOUR PEM FILE PATH HERE

}
```

After above configurations, Terraform should be good to go:

``` 
terraform init
terraform apply
```

At the execution logs you should be able to see Terraform provision the EC2, install docker and it's dependencies, copy Dockerfile and nginx config to EC2 and run ansible-playbook.
If everything goes well at the end you should see similar output:

```
aws_instance.my_server (local-exec): PLAY RECAP *********************************************************************
aws_instance.my_server (local-exec): 3.135.200.250              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

aws_instance.my_server: Creation complete after 3m35s [id=i-08f5caef533ef67fb]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

```

You can get the displayed IP (in above example 3.135.200.250) and navigate to it in both HTTP and HTTPS:


## HTTP:
![alt text](https://github.com/jgluchetti/ansible/blob/master/images/HTTP.jpg?raw=true)

## HTTPS - using self signed openSSL certificates:
![alt text](https://github.com/jgluchetti/ansible/blob/master/images/HTTPS.jpg?raw=true)

![alt text](https://github.com/jgluchetti/ansible/blob/master/images/HTTPS_2.jpg?raw=true)







