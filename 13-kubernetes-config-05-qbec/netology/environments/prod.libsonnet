local prod = import './stage.libsonnet';

prod {
  components +: {
    backend +: {
      replicas: 3,
    },
    frontend +: {
      replicas: 3,
    },
    db +: {
      replicas: 3,
    },
    endpoint: {
      address: "54.162.128.250"
    }
  }
}