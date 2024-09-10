pipeline {
    agent any
    environment {
        buildid = "${currentBuild.number}"
        registry = "yossizxc/weather"
        IMG_NAME = ""
        REGISTRY_URL = "https://index.docker.io/v1/"
    }
    stages {
        stage('Build') {
            steps {
                dir('src') {
                    script {
                        sh "sudo docker-compose build"
                    }
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    IMG_NAME = "${registry}:${env.buildid}"
                    echo "Image name: ${IMG_NAME}"
                    sh "sudo docker tag src-gunicorn:latest ${IMG_NAME}"
                    docker.withRegistry("${REGISTRY_URL}", 'docker_creds') {
                        docker.image("${IMG_NAME}").push()
                    }
                }
            }
        }

        stage('Configure Kubectl') {
            steps {
                script {
                    sh """
                        aws eks update-kubeconfig --name eks-cluster-dev --region eu-central-1
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                        helm upgrade --install weather-app ./helm --set image.tag=${env.buildid}
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
            sh "docker rmi $(docker images --filter 'dangling=true' -q --no-trunc)"
            sh "docker system prune -af"
        }
    }
}
