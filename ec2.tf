#this is the public key you can use to access your machine, I generated that with sshkey_gen on my laptop and copied public key and paste in the file, 
#after that I have changed private key to ppk to access machine via putty keygen
resource "aws_key_pair" "tf_demo" {
  key_name   = "tf_demo"
  public_key =  "${file("tf_demo.pub")}"
}

#Public instance
 resource "aws_instance" "Pubec2" {            
  ami           = "ami-5b673c34"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pubsubnet[0].id}"
  key_name = "${aws_key_pair.tf_demo.key_name}"
  user_data = "${file("userdata.sh")}"
  #security_groups = [aws_security_group.sg.id]
  vpc_security_group_ids =  ["${aws_security_group.sg.id}"]
  #most_recent = true
  #lifecycle {
   # create_before_destroy = true
  #}

  tags = {
    Name = "PublicInstance"
  }
}

#Private instance
 resource "aws_instance" "Prvc2" {            
  ami           = "ami-5b673c34"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.prvsubnet[0].id}"
  key_name = "${aws_key_pair.tf_demo.key_name}"
  user_data = "${file("userdata.sh")}"
  #security_groups = [aws_security_group.sg.id]
  vpc_security_group_ids =  ["${aws_security_group.sg.id}"]

  tags = {
    Name = "PrivateInstance"
  }
}


##there is a chalange to eip more than one ec2 instance
#resource "aws_eip_association" "eip_assoc" {
  #instance_id   = aws_instance.web.id
 # allocation_id = aws_eip.eip_manager.id
#}


 