# Azure Key Vault (디지털 금고) 생성
resource "azurerm_key_vault" "kv" {
  name                = "${var.project_name}-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # AKS가 Key Vault에서 비밀을 읽을 수 있도록 접근 정책 추가
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
    secret_permissions = [
      "Get",
      "List"
    ]
  }
}

# 현재 Azure 로그인 정보를 가져오는 데이터 소스
data "azurerm_client_config" "current" {}

# Key Vault에 PostgreSQL 접속 문자열 저장
resource "azurerm_key_vault_secret" "db_url" {
  name         = "postgresql-url"
  value        = "postgresql://${azurerm_postgresql_flexible_server.psql.administrator_login}:${var.postgresql_admin_password}@${azurerm_postgresql_flexible_server.psql.fqdn}:5432/${var.project_name}db"
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_postgresql_flexible_server.psql]
}

# Key Vault에 Redis 접속 주소 저장
resource "azurerm_key_vault_secret" "redis_host" {
  name         = "redis-host"
  value        = azurerm_redis_cache.redis.hostname
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_redis_cache.redis]
}

# Key Vault에 Redis 비밀번호 저장
resource "azurerm_key_vault_secret" "redis_pass" {
  name         = "redis-pass"
  value        = azurerm_redis_cache.redis.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_redis_cache.redis]
}

# Key Vault에 JWT 시크릿 키 저장
resource "azurerm_key_vault_secret" "jwt_secret" {
  name         = "jwt-secret" # Key Vault에 저장될 비밀의 이름
  
  # TODO: 여기에 실제 사용할 강력한 비밀 키를 넣으세요.
  # (예: 온라인 'random string generator'로 64자 이상 생성)
  value        = "YourSuperStrongAndRandomSecretKeyGoesHere123!"
  
  key_vault_id = azurerm_key_vault.kv.id
}

