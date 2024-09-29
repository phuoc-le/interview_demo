
resource "aws_vpc" "vpc" {
  cidr_block = var.cidrs
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_dns_support             = var.enable_dns_support

  tags = {
    Name = var.vpc_name
    Environment = var.env
  }
}

resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${lower(var.env)}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${lower(var.env)}-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "eks_worker_subnets" {
  count      = length(var.eks_worker_subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.eks_worker_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${lower(var.env)}-eks-worker-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb": 1
    "kubernetes.io/cluster/${var.cluster_name}": "shared"
  }
}

resource "aws_subnet" "eks_control_plane_subnets" {
  count      = length(var.eks_control_plane_subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.eks_control_plane_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${lower(var.env)}-eks-control-plane-subnet-${count.index + 1}"
    "kubernetes.io/role/elb": 1
    "kubernetes.io/cluster/${var.cluster_name}": "shared"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${lower(var.env)}-internet-gateway"
  }
}


resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${lower(var.env)}-public-rtb"
  }
}

resource "aws_route_table" "eks_control_plane" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${lower(var.env)}-eks-control-plane-rtb"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_default_route_table.public.id
}

resource "aws_route_table_association" "eks_control_plane" {
  count = length(var.eks_control_plane_subnet_cidrs)
  subnet_id = element(aws_subnet.eks_control_plane_subnets[*].id, count.index)
  route_table_id = aws_route_table.eks_control_plane.id
}

resource "aws_eip" "nat_gateway" {
  tags = {
    Name = "${var.env} NAT Gateway"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = element(aws_subnet.public_subnets[*].id, 0)
  tags = {
    Name = "${var.env} NAT Gateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${lower(var.env)}-private-rtb"
  }
  depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_route_table" "eks_worker" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${lower(var.env)}-eks-worker-rtb"
  }
  depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "eks_worker" {
  count = length(var.eks_worker_subnet_cidrs)
  subnet_id = element(aws_subnet.eks_worker_subnets[*].id, count.index)
  route_table_id = aws_route_table.eks_worker.id
}
