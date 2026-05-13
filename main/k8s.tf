resource "kubernetes_namespace_v1" "fraud" {
  metadata {
    name = "fraud"
  }
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace_v1" "sonarqube" {
  metadata {
    name = "sonarqube"
  }
}

resource "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_namespace_v1" "dynatrace" {
  metadata {
    name = "dynatrace"
  }
}

resource "kubernetes_namespace_v1" "ecommerce" {
  metadata {
    name = "ecommerce"
  }
}

resource "kubernetes_namespace_v1" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"

  create_namespace = false

  values = [
    <<-EOT
    installCRDs: true
    EOT
  ]
}

# resource "helm_release" "sonarqube" {
#   name       = "sonarqube"
#   namespace  = kubernetes_namespace_v1.sonarqube.metadata[0].name
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "sonarqube"

#   values = [yamlencode({
#     postgresql = {
#       enabled = false
#     }
#     service = {
#       type = "LoadBalancer"
#       port = 9000
#     }
#     persistence = {
#       enabled = true
#       size    = "20Gi"
#     }
#   })]

#   depends_on = [kubernetes_namespace_v1.sonarqube]
# }