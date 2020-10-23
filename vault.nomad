job "vault.service" {
  region      = "[[.region]]"
  datacenters = ["[[.datacenter]]"]
  type = "service"
  group "vault" {
    count = [[.count]]
    task "vault.service" {
      driver = "exec"
      resources {
        cpu = [[.cpu]]
        memory = [[.memory]]
      }
      artifact {
        source      = "https://releases.hashicorp.com/vault/[[.version]]/vault_[[.version]]_${attr.kernel.name}_${attr.cpu.arch}.zip"
        destination = "/tmp/"
        options {
          checksum = [[.checksum]]
        }
      }
      template {
        data        = <<EOF
        ui = true
        cluster_name = "${namespace}-demostack"

        storage "file" {
          path = "/opt/vault/data"
        }

        listener "tcp" {
          address = ":8200"
          tls_disable = 1
        }
        EOF
        destination = "/etc/vault.d/vault.hcl"
      }
      config {
        command = "/tmp/vault"
        args = ["server", "config=/etc/vault.d/vault.hcl"]
      }
    }
  }
}
