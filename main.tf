provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "k8s-key" {
  key_name   = "k8s-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCeVcJk1LFCHhnJv97EDw0S7TVoB+Tb5KPDpbTVIq6jPP/ruGLs7Tq0LB2dVnt3bQQR7yOpsVtOjyyrDpcn64nCabh/gP9+eVOQUYdjEAepQEksUhoKq0yU/W5Jtz5O6k9kKhBNkffGkIfhlEWT8AR7DVSQ+F2961YPpcrML453+WaT6CjG1sJw5ZRR1f5vFvjZi45f0YE3kMTkhboCgoHH9l9xIGaRA35Hpf8ab9gJKpCzgEhzYHYKEI+f/jD/VDWlkeOoedtmW1yYrVO7KPNxBgKfIQWUjxn9w9eS/gcL5GSwMPc4tW2UjOIhEtJbsWrJcbiJ8G4WGHdMY1WuwG+crZlMN5sSPoTzRrJ5pV08m7I07y3LuvxDuSPWLD+veivz0bsKBFZEYn365yNDrZA8q33qbm2jE5S2Lz36iZasfrIiJjiffPRoefBloU24HucYS3MZEDM2ATu9WCKdO99MqQJYUVAkAOKbdiNAwMGtpjj1g14vA8sh2DXmNJFTMDs= samuel@MacBook-de-Samuel.local"
}

resource "aws_security_group" "k8s-sg" {

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks   = ["0.0.0.0/0"]
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
  }
}

resource "aws_instance" "kubernetes-worker" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t3.medium"
  key_name      = "k8s-key"
  count         = 2
  tags          = {
    name = "k8s"
    type = "worker"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}

resource "aws_instance" "kubernetes-master" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t3.medium"
  key_name      = "k8s-key"
  count         = 1
  tags          = {
    name = "k8s"
    type = "master"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}