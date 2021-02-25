# Configuration Management Challenge

Your task is to manage the state of a node using configuration management.

Your configuration should be able to:

1. Deploy the instance. be able to provision an instance in a cloud of your like (OCI, AWS, GCP Azure), if you have any, a problem we accept a VirtualBox. We like a lot OCI.
2. Manage a HTTP Server to listen in HTTP and HTTPS
3. Delivery the application using Docker and ensure it will "survire" at restarts
4. A simple way to update the binary

You can pick the configuration management tool from the above list:

> Ansible + terraform (prefered)

> Chef + terraform

Keep in mind, an evaluator will check out your repository and will review:

1. Code design
2. Best practices

The evaluator will execute your code and it should be able to see the that the application is deployed and running.

## Things you need to known

1. `go build main.go` builds the app.
2. This application starts at port 8080 on localhost.
3. We appreciate Makefiles :)
4. Keep in mind, in the evaluator machine, does not have go compiler installed.
5. To see the content, access: https://\<host\>/

> Tests should show that this page is reachable and is specific to the content the test page sends back.

## Starting the Test

Create a branch, please, use mnemonic names. If you will use automation and add the source for ansible and terraform, create a branch named ansible.

## Delivery Instructions

1. You must provide your github or gitlab with your repo.
1. Commit your code in your repo and send it to recruitment team.
1. Please, give to us a documentation. We will read it see how to run your code.

P.S. comments matters. Please, don't rebase your code, we want see how your construction was evolved.

## Format

* This assessment must be delivered within 1 week.
* You must be prepared to walk an evaluator through all the created artifacts including tests
    * Mention anything that was asked but not delivered and why, and any additional comments.
