resource "aws_key_pair" "deployer_key" {
  key_name   ="${var.name_prefix}-keyPair"
  public_key = file("prod-key.pub")
  
}