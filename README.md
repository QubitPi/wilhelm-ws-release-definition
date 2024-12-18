Wilhelm WS Release Definition
-----------------------------

[![HashiCorp Packer Badge][HashiCorp Packer Badge]][HashiCorp Packer URL]
[![HashiCorp Terraform Badge][HashiCorp Terraform Badge]][HashiCorp Terraform URL]
[![Apache License][Apache License Badge]][Apache License, Version 2.0]

__wilhelm-ws-release-definition__ deploys [wilhelm-ws](https://github.com/QubitPi/wilhelm-ws) to production. Execute the
following:

1. Setup AWS credentials

   ```console
   export AWS_ACCESS_KEY_ID=
   export AWS_SECRET_ACCESS_KEY=
   ```

2. [Set Packer variables through environment variables](https://packer.qubitpi.org/packer/guides/hcl/variables#from-environment-variables)

   ```console
   export PKR_VAR_ami_region=...
   export PKR_VAR_war_source=/absolute/path/to/WAR/file
   ```
   
3. [Set Terraform variables through environment variables](https://terraform.qubitpi.org/terraform/cli/config/environment-variables#tf_var_name)

   ```console
   export TF_VAR_ec2_region=...
   export TF_VAR_ec2_name="My Webservice"
   export TF_VAR_ec2_security_groups='["My Security Group 1", "My Security Group 2", "My Security Group 3"]'
   export TF_VAR_ssh_key_pair_name='mykey'
   export TF_VAR_neo4j_uri='...'
   export TF_VAR_neo4j_username='...'
   export TF_VAR_neo4j_password='...'
   export TF_VAR_neo4j_database='...'
   ```

3. HashiCorp Deployment

   ```console
   cd hashicorp
   ./publish-image.sh
   ./deploy-instance.sh
   ```

   __[The cloud-init log can be found at](https://stackoverflow.com/questions/51882030/commands-in-user-data-are-not-executed-in-terraform#comment90735245_51887124)
   `/var/log/cloud-init-output.log`__

4. Delete old instance

License
-------

The use and distribution terms for [wilhelm-ws-release-definition]() are covered by the [Apache License, Version 2.0].

[Apache License, Version 2.0]: https://www.apache.org/licenses/LICENSE-2.0
[Apache License Badge]: https://img.shields.io/badge/Apache%202.0-F25910.svg?style=for-the-badge&logo=Apache&logoColor=white

[HashiCorp Packer Badge]: https://img.shields.io/badge/Packer-02A8EF?style=for-the-badge&logo=Packer&logoColor=white
[HashiCorp Packer URL]: https://packer.qubitpi.org/packer/docs
[HashiCorp Terraform Badge]: https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white
[HashiCorp Terraform URL]: https://terraform.qubitpi.org/terraform/docs
