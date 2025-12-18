pipeline {
    agent any

    environment {
        DEV_REPO  = "faizalfaizu/react-dev-repo"
        PROD_REPO = "faizalfaizu/react-prod-repo"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName
                    if (env.BRANCH_NAME == 'dev') {
                        imageName = "${DEV_REPO}:${env.BUILD_NUMBER}"
                    } else if (env.BRANCH_NAME == 'main') {
                        imageName = "${PROD_REPO}:${env.BUILD_NUMBER}"
                    } else {
                        error "Branch ${env.BRANCH_NAME} is not configured for Docker build"
                    }

                    docker.build(imageName)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    def imageName = (env.BRANCH_NAME == 'dev') ?
                        "${DEV_REPO}:${env.BUILD_NUMBER}" :
                        "${PROD_REPO}:${env.BUILD_NUMBER}"

                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image(imageName).push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        echo "Deploying to DEV environment..."
                    } else if (env.BRANCH_NAME == 'main') {
                        echo "Deploying to PROD environment..."
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'docker logout || true'
            }
        }
        success {
            echo "Build and deployment successful for branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "Build failed for branch ${env.BRANCH_NAME}"
        }
    }
}
