data "aws_ami" "amazon-linux-2" {   ##data kullanrak mevcut olan kaynklari okurhangi kaynaklari kullancaksak onu yazariz buraya
  owners      = ["amazon"]          ##kuullanicagimiz ami nin sahibidir yada baska yada kendi olusutursugumuz ami buraya yazabiliriz 
  most_recent = true                 ## en guncel ami cekilecektir

  filter {                         ##filrte adi verilir tipi ebs secilir 
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {                             ## filter olarak hvm sanallastirma olarak hvm kullanilicagi filtrenelir
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {                             ##64 bitlik makine secmis oluyoruz bu yazilmazsa en son cikan 256 lik en guncel makine uygulanacaktir.
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {                          ##owner olarak amazon secilmisti owner-alias ile takma adlar ile bizim ami ler cikabilir
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]          ##bu kod blogu asil onemli olan amazon2 ami kernel 5  secilmesi yani secilecek iso dosyasir.
  }                                                       ##bu tanimli filtreler ani owner-alias degistilemez tanimli filtreler  kullnailarak is kolaylasir.Filtre istenirse kullanilmayabilir.
}                                                         ##amazon ec2 consolden makine yaga kaldirilirken bu filtreler zaten kar;imiz ciker 

data "template_file" "userdata" {                            ##userdata adresi verilmis olunur.userdata local addir
  template = file("${abspath(path.module)}/userdata.sh")    ## file fonksiyonu bir dosyanin icerigini okumak icin kullanilir yani burda userdata icerigini okumaya yararr/burdaki path.module modulun adresini cagitmis olur/module yolu degisebilir absulete o path yolunu degismeyen sabit hale getirmek icin kullanilirbu daresten userdatayi almis olur 
  vars = {
    server-name = var.server-name
  }
}

resource "aws_instance" "tfmyec2" {                       ##burdaki tfmyec2 ismi degistirilebilir.
  ami = data.aws_ami.amazon-linux-2.id                    ##yukarida olusutulan data bilgisinden cekilir
  instance_type = var.instance_type                   ## var ile varible dosyasibdan degiskenler veriler islenmis olunur
  count = var.num_of_instance
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  user_data = data.template_file.userdata.rendered           ##template-file gibi script dosyalarinin cagrilip okunamasi icin rendered kullanilir ornegin ami icin id kullnilarak ami dosyaari cagrilmisti.
  tags = {
    Name = var.tag
  }
}

resource "aws_security_group" "tf-sec-gr" {           ##security group olustururken aws consolde bir tag var bir de name var onlari buraya giriyoruz
  name = "${var.tag}-terraform-sec-grp"       ##variable dosyasindan tag alacak ve terraform-sec-grp bunu da ekleyecek 
  tags = {
    Name = var.tag
  }

  dynamic "ingress" {                          ##tek tek butun portlari asagidaki content icerisindeki isleri donduracektir
    for_each = var.docker-instance-ports           ##burda variable dosyasinda 3 adet port var her biri icin ayri ayri ingress yani inbi=ound olusturucak 
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {                    ##engress yani output 
    from_port =0
    protocol = "-1"           #burdaki "-1" butun portlara acik demekir
    to_port =0
    cidr_blocks = ["0.0.0.0/0"]
  }
}