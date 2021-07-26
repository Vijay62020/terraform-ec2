# Configure the AWS Provider
provider "aws" {
  region     = "us-west-1"
  profile = "vick"	
}


resource "aws_key_pair" "gearman_key" {
  key_name  				 = "gearman_live-key"
  public_key 				 = "Rsa key "
}





resource "aws_ebs_volume" "gearman_volume" {
  availability_zone 			= "us-west-1c"
  size              			= 15

  tags = {
    Name 				= "Gearman Volume"
  }
}




resource "aws_volume_attachment" "gearman_att" {
  device_name 				= "/dev/sdh"
  volume_id   				= aws_ebs_volume.gearman_volume.id
  instance_id 				= aws_instance.gearman_worker.id
}





resource "aws_instance" "gearman_worker" {
  ami           	 		= var.image
  instance_type 	 		= var.instance_type
  key_name     		 		= aws_key_pair.gearman_key.id
  subnet_id                             =  "subnet-0c1255f395da55031" 
  vpc_security_group_ids                = [ "sg-08ada2672621feca0" ]
  #security_groups 			= [ "sg-05dc4262ab7ad3477" ]

  user_data				= "${file("package.sh")}"


  tags = {
    Name 				= "Gearman Worker"
  }
}

resource "aws_eip" "gearman_eip" {
  instance 				= aws_instance.gearman_worker.id
  vpc      				= true
}

