pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials') // Jenkins Docker Hub credentials ID
        DEV_REPO = "yourdockerhubusername/dev-repo"
        PROD_REPO = "yourdockerhubusername/prod-repo"
    }

    triggers {
        pollSCM('H/5 * * * *') // Optional; if using GitHub webhook, you can remove this
    }

    stages {

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: "*/${env.BRANCH_NAME}"]],
                          userRemoteConfigs: [[
                              url: 'https://github.com/faizufaizal08-oss/devops-build.git',
                              credentialsId: 'github-credentials-id'
                          ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = ""
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
                    def imageName = ""
                    if (env.BRANCH_NAME == 'dev') {
                        imageName = "${DEV_REPO}:${env.BUILD_NUMBER}"
                    } else if (env.BRANCH_NAME == 'main') {
                        imageName = "${PROD_REPO}:${env.BUILD_NUMBER}"
                    }

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
                        // Add your dev deployment steps here (docker-compose, kubectl, etc.)
                    } else if (env.BRANCH_NAME == 'main') {
                        echo "Deploying to PROD environment..."
                        // Add your production deployment steps here
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up Docker login"
            sh 'docker logout || true'
        }
        success {
            echo "Build and deployment successful for branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "Build failed for branch ${env.BRANCH_NAME}"
        }
    }
}
