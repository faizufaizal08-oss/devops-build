pipeline {
    agent any

    environment {
        // Docker Hub repos
        IMAGE_DEV = "faizalfaizu/react-dev"
        IMAGE_PROD = "faizalfaizu/react-prod"

        // Docker image name inside Jenkins
        IMAGE_NAME = "react-static-prod"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the branch that triggered the build
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh "docker build --no-cache -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    def branch = env.BRANCH_NAME ?: 'dev'
                    echo "Current branch: ${branch}"

                    if(branch == 'dev') {
                        echo "Tagging and pushing to dev repo..."
                        sh "docker tag ${IMAGE_NAME} ${IMAGE_DEV}:latest"
                        sh "docker push ${IMAGE_DEV}:latest"
                    } 
                    else if(branch == 'main') {
                        echo "Tagging and pushing to prod repo..."
                        sh "docker tag ${IMAGE_NAME} ${IMAGE_PROD}:latest"
                        sh "docker push ${IMAGE_PROD}:latest"
                    } 
                    else {
                        echo "Branch ${branch} not configured for Docker push."
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying container..."
                    sh """
                        CONTAINER_NAME=${IMAGE_NAME}
                        docker rm -f $CONTAINER_NAME || true
                        docker run -d -p 80:80 --name $CONTAINER_NAME ${IMAGE_NAME}
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Cleaning up Docker login"
                sh "docker logout || true"
            }
        }
    }
}
