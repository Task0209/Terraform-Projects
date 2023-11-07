provider "aws" {
  region  = var.region
}


module "vpc" {
  source          = "./vpc/"
  vpc_name = "${var.env}-${var.region}-${var.service}-vpc-${var.ver}"
  public_subnet_name = "${var.env}-${var.region}-${var.service}-public-subnet-${var.ver}"
  private_subnet_name = "${var.env}-${var.region}-${var.service}-private-subnet-${var.ver}" 
  igw_name = "${var.env}-${var.region}-${var.service}-igw-${var.ver}"
  ngw_name = "${var.env}-${var.region}-${var.service}-ngw-${var.ver}"
  pub_rt_name= "${var.env}-${var.region}-${var.service}-public-route-table-${var.ver}"
  pri_rt_name = "${var.env}-${var.region}-${var.service}-private-route-table-${var.ver}"
  pub_sg_name = "${var.env}-${var.region}-${var.service}-public-sg-${var.ver}"
  pri_sg_name = "${var.env}-${var.region}-${var.service}-private-sg-${var.ver}"
  des_cidr = var.des_cidr
}

module "ec2-linux-private" {
  source = "./ec2-linux-private/"
  count = "${var.pri_linux_instance_count}"
  pri_linux_instance_name = "${var.env}-${var.region}-${var.service}-linux-private-instance-${count.index}-${var.ver}"
  linux-key-name-pri = "${var.env}-${var.region}-${var.service}-private-impexkey-${count.index}-${var.ver}"
  linux-keyfilename-pri = "${var.env}-${var.region}-${var.service}-private-impexkeyfile-${count.index}-${var.ver}"
  pri_sg_id = module.vpc.pri_sg_id
  pri-subnet-id = module.vpc.pri-subnet-id
}

module "ec2-linux-public" {
  source = "./ec2-linux-public/"
  pub_linux_instance_name = "${var.env}-${var.region}-${var.service}-linux-public-instance-${var.ver}"
  linux-key-name-pub = "${var.env}-${var.region}-${var.service}-public-impexkey-${var.ver}"
  linux-keyfilename-pub = "${var.env}-${var.region}-${var.service}-public-impexkeyfile-${var.ver}"
  pub_sg_id = module.vpc.pub_sg_id
  pub-subnet-id = module.vpc.pub-subnet-id
}

module "ec2-windows" {
  source = "./ec2-windows/"
  count = "${var.windows_instance_count}"
  windows_instance_name = "${var.env}-${var.region}-${var.service}-windows-instance-${count.index}-${var.ver}"
  pri_sg_id = module.vpc.pri_sg_id
  pri-subnet-id = module.vpc.pri-subnet-id
}


