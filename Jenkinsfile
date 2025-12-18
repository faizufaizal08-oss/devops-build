pipeline {
    agent any

    environment {
        IMAGE_NAME_DEV = "faizalfaizu/react-dev"
        IMAGE_NAME_PROD = "faizalfaizu/react-prod"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def branch = env.BRANCH_NAME ?: 'dev'
                    if(branch == 'dev') {
                        sh './build.sh'
                    } else if(branch == 'main') {
                        sh './build.sh'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    def branch = env.BRANCH_NAME ?: 'dev'
                    if(branch == 'dev') {
                        sh "docker tag react-static-prod ${IMAGE_NAME_DEV}"
                        sh "docker push ${IMAGE_NAME_DEV}"
                    } else if(branch == 'main') {
                        sh "docker tag react-static-prod ${IMAGE_NAME_PROD}"
                        sh "docker push ${IMAGE_NAME_PROD}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh './deploy.sh'
                }
            }
        }
    }
}
