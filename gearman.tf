# Configure the AWS Provider
provider "aws" {
  region     = "us-west-1"
  profile = "vick"	
}


resource "aws_key_pair" "gearman_key" {
  key_name  				 = "gearman_live-key"
  public_key 				 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzTZu0y/vmoOmdrbIKBhx1uDRk1JfD/aW+jFjqx++vD8NEYxtcrsSocFMJrBtkpwPTU9OfA9XtJEu01T6SgW2espqul0v98pHzSGfMCOabU5tzAGyW5Y+p1+pTeG3FfAQo8qLgRBnfIs0mjrh1dcsLCBr9B39jvhge5JEx7YJdAWBSLi6ra07t5o04rTu9wJAuXAZ1MM0m5K6fo7vbdUVu7GgJS82VOC1T/1uuVA5NDmGSFVkkmuEBvpsX8kS2anlk0gU9GPwTJbp3dk6ydHySB3XOZiacXYqwNAK9mktPOrh5WqJ/vUZSjtOsPhDtkStmJMLmqCCn0kUZMyGhlhkj ubuntu@jerryme2020"
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

