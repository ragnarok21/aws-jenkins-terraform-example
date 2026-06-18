terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    dynamodb = "http://localhost:4566"
  }
}

# ─── Variables ────────────────────────────────────────────────────────────────

variable "aws_region" {
  description = "Región AWS donde se desplegará DynamoDB"
  type        = string
  default     = "us-east-1"
}

variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
  default     = "Prueba_Tabla"
}

variable "environment" {
  description = "Ambiente del despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "billing_mode" {
  description = "Modo de facturación: PAY_PER_REQUEST o PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
}

# ─── DynamoDB Table ───────────────────────────────────────────────────────────

resource "aws_dynamodb_table" "main" {
  name         = "${var.table_name}-${var.environment}"
  billing_mode = var.billing_mode
  hash_key     = "id"
  range_key    = "createdAt"

  attribute {
    name = "id"
    type = "S" # S = String, N = Number, B = Binary
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  # Índice secundario global (GSI) para consultar por status
  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    range_key       = "createdAt"
    projection_type = "ALL"
  }

  # TTL para expiración automática de registros
  ttl {
    attribute_name = "expiresAt"
    enabled        = true
  }

  # Point-in-time recovery (backup automático)
  point_in_time_recovery {
    enabled = true
  }

  # Encriptación en reposo
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "${var.table_name}-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ─── Outputs ──────────────────────────────────────────────────────────────────

output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB creada"
  value       = aws_dynamodb_table.main.name
}

output "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB"
  value       = aws_dynamodb_table.main.arn
}

output "dynamodb_table_id" {
  description = "ID de la tabla DynamoDB"
  value       = aws_dynamodb_table.main.id
}
