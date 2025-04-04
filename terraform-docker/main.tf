resource "docker_image" "youtube-terraform" {
	name   = "youtube-terraform"
	keep_locally = true
	build {
	  context = "./app"
	  dockerfile = "Dockerfile"
	}
}

resource "docker_container" "terraform-container" {
	name = "terraform-container"
	image = docker_image.youtube-terraform.image_id
	ports {
	  internal = "5000"
	  external = "5000"
	}
}
