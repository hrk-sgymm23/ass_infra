# サブネット
resource "aws_subnet" "public-subnet" {
  vpc_id = var.vpc_id
  for_each = toset(var.availability_zones)
  availability_zone = each.value
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, index(var.availability_zones, each.value))
  map_public_ip_on_launch = true
  tags = {
    public = true
    Zone = each.value
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = var.vpc_id
  for_each = toset(var.availability_zones)
  availability_zone = each.value
  # + lengsすることでCIDRが重複せず、連続するようになる。
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, index(var.availability_zones, each.value) + length(aws_subnet.public-subnet))
  tags = {
    Private = true
    Zone = each.value
  }
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id
}

# ルートテーブル
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Public = true
  }
}

resource "aws_route_table" "private" {
  for_each = toset(var.availability_zones)
  vpc_id   = var.vpc_id
  tags = {
    Private = true
    Zone    = each.value
  }
}

# ElasticIP
resource "aws_eip" "main" {
  for_each = toset(var.availability_zones)
  vpc = true
  tags = {
    Zone = each.value
  }
}

# NatGateway
resource "aws_nat_gateway" "main" {
  for_each = toset(var.availability_zones)
  allocation_id = aws_eip.main[each.value].id
  subnet_id = aws_subnet.public-subnet[each.value].id
  depends_on = [ aws_internet_gateway.main ]
  tags = {
    Zone = each.value
  }
}

# ゲートウェイとルートテーブルの紐付け
# パブリック
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.main.id
  egress_only_gateway_id = "0.0.0.0/0"
}

# プライベート
resource "aws_route" "private_route" {
  for_each = toset(var.availability_zones)
  route_table_id = aws_route_table.private.id
  nat_gateway_id = aws_nat_gateway.main[each.value].id
}


# ゲートウェイとサブネットの紐付け
# パブリック
resource "aws_route_table_association" "public_association" {
  for_each = toset(var.availability_zones)
  subnet_id = aws_subnet.public-subnet[each.value].id
  route_table_id = aws_route_table.public.id
}

# プライベート
resource "aws_route_table_association" "private_association" {
  for_each = toset(var.availability_zones)
  subnet_id = aws_subnet.private-subnet[each.value].id
  route_table_id = aws_route_table.public[each.value].id
}