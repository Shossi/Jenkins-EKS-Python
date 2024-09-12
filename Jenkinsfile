pipeline {
    agent any
    environment {
        GIT_REPO_URL = "https://github.com/Shossi/Leumi-Kubernetes"
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

        stage('push changes') {
            steps {
                script {
                    sh "git clone ${GIT_REPO_URL}"
                    dir('Leumi-Kubernetes') {
                        sh 'git checkout main'
                        withCredentials([string(credentialsId: 'GIT_CREDENTIALS_ID', variable: 'TOKEN')]) {
                            sh """
                                sed -i 's|tag: .*|tag: ${env.buildid}|' values.yaml
                                git config user.email "jenkins@yourdomain.com"
                                git config user.name "Jenkins"
                                git add values.yaml
                                git commit -m "Update image tag to ${env.buildid}"
                                git push https://${TOKEN}@github.com/Shossi/Leumi-Kubernets.git main
                            """
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
