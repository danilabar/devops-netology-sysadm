resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.netology-k8s-cluster.id} --external --force"
  }

  depends_on = [
    yandex_kubernetes_cluster.netology-k8s-cluster,
    yandex_kubernetes_node_group.k8s-ng
  ]
}


resource "local_file" "connect-to-db" {
  filename = "../data/phpmyadmin.yml"
  content  = <<-EOT
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: phpmyadmin-deployment
  labels:
    app: phpmyadmin
spec:
  replicas: 3
  selector:
    matchLabels:
      app: phpmyadmin
  template:
    metadata:
      labels:
        app: phpmyadmin
    spec:
      containers:
        - name: phpmyadmin
          image: phpmyadmin/phpmyadmin:latest
          ports:
            - containerPort: 80
          env:
            - name: PMA_HOST
              value: "${yandex_mdb_mysql_cluster.cluster-mysql-netology.host[0].fqdn}"
            - name: PMA_PORT
              value: "3306"
            - name: MYSQL_USER
              value: "${var.db_user}"
            - name: MYSQL_ROOT_PASSWORD
              value: "${random_password.db_password.result}"
---
apiVersion: v1
kind: Service
metadata:
  name: phpmyadmin-service
spec:
  selector:
    app: phpmyadmin
  ports:
    - port: 80
      targetPort: 80
  type: LoadBalancer
EOT

  depends_on = [
    null_resource.kubeconfig,
    yandex_mdb_mysql_cluster.cluster-mysql-netology,
    yandex_kubernetes_cluster.netology-k8s-cluster
  ]
}

resource "null_resource" "manifests" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../data/phpmyadmin.yml"
  }

  depends_on = [
    local_file.connect-to-db
  ]
}