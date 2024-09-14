resource "aws_secretsmanager_secret" "tls_secret" {
  name        = "tls-secret"
  description = "TLS certificate and private key for weather app"
}

resource "aws_secretsmanager_secret_version" "my_tls_secret_version" {
  secret_id     = aws_secretsmanager_secret.tls_secret.id
  secret_string = jsonencode({
    "tls.crt" = file("/home/yossi/tls.crt"),
    "tls.key" = file("/home/yossi/tls.key")
  })
}