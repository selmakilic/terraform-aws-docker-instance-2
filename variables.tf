variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name" {   ##key name ozeldir buraya girilimesi gerekir herkes kendir keyini.
  type = string
}

variable "num_of_instance" {       # ayaga kaldirilan instance sayisi yazilir
  type = number
  default = 1
}

variable "tag" {     
  type = string
  default = "Docker-Instance"
}

variable "server-name" {
  type = string
  default = "docker-instance"
}

variable "docker-instance-ports" {
  type = list(number)
  description = "docker-instance-sec-gr-inbound-rules"
  default = [22, 80, 8080]                         ##security group olusturuldugunda burdan cekecek hangi portlsrin acik olmasini istiyorsak burda belirtip maintf te  kullanilacak
}