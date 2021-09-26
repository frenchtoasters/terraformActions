data "terraform_remote_state" "cluster" {
	backend = "s3"
	config = {
		bucket = "terraformtest"
		key = "cluster/terraform.tfstate"
		endpoint = var.OBJ_BUCKET_URL
	}
}

provider "linode" {
	token = var.LINODE_TOKEN
}

resource "linode_lke_cluster" "my-cluster" {
	k8s_version = "1.21"
	label = "my-terraform-cluster"
	region = "us-central"
	pool {
		count = 1
		type = "g6-standard-1"
	}
}

resource "local_file" "kube_config_yaml" {
	filename = "./my-cluster-kubeconfig.yaml"
	content = base64decode(linode_lke_cluster.my-cluster.kubeconfig)
}

