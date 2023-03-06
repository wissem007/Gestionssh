pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        DOCKER_REGISTRY_CREDENTIALS = 'my-registry-credentials'
        DOCKER_IMAGE_NAME = 'my-image'
        DOCKER_IMAGE_TAG = 'latest'
        REMOTE_SERVER = 'remote-server.com'
        REMOTE_SERVER_CREDENTIALS = 'remote-server-credentials'
        REMOTE_SERVER_IMAGE_NAME = 'remote-image'
    }
    stages {
        stage('Build and push Docker image') {
            steps {
                script {
                    // Authenticate with the Docker registry
                    docker.withRegistry(env.DOCKER_REGISTRY, env.DOCKER_REGISTRY_CREDENTIALS) {
                        // Build the Docker image
                        def image = docker.build("${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}", '.')
                        // Push the Docker image to the registry
                        image.push()
                    }
                }
            }
        }
        stage('Deploy Docker image to remote server') {
            steps {
                script {
                    // Connect to the remote server using SSH
                    sshCommand remoteUser: 'my-ssh-user', remotePassword: env.REMOTE_SERVER_CREDENTIALS, 
                        hostName: env.REMOTE_SERVER, command: """
                        // Authenticate with the Docker registry on the remote server
                        docker login -u my-registry-user -p my-registry-password ${env.DOCKER_REGISTRY}
                        // Pull the Docker image from the registry
                        docker pull ${env.DOCKER_REGISTRY}/${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}
                        // Tag the Docker image with the remote server image name
                        docker tag ${env.DOCKER_REGISTRY}/${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG} ${env.REMOTE_SERVER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}
                        // Run the Docker image on the remote server
                        docker run -d --name ${env.REMOTE_SERVER_IMAGE_NAME} -p 80:80 ${env.REMOTE_SERVER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}
                    """
                }
            }
        }
    }
}
