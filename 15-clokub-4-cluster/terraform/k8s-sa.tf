// Create SA
resource "yandex_iam_service_account" "k8s-sa" {
 name        = "k8s-sa"
 description = "for managing k8s cluster"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 folder_id = var.yandex_folder_id
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
 ]
  depends_on = [yandex_iam_service_account.k8s-sa]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 folder_id = var.yandex_folder_id
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
 ]
  depends_on = [yandex_iam_service_account.k8s-sa]
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "k8s-sa-static-key" {
  service_account_id = yandex_iam_service_account.k8s-sa.id
  description        = "Static Access Keys For Storage"
}