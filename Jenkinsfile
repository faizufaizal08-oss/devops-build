pipeline {
    agent any

    environment {
        IMAGE_NAME = "react-static-prod"
        DOCKERHUB_USER = "faizufaizal08" 
        DEV_REPO = "${DOCKERHUB_USER}/dev"
        PROD_REPO = "${DOCKERHUB_USER}/prod"
    }

    stages {

        stage('Checkout') {
            steps {
                
                git branch: env.BRANCH_NAME,
                    url: 'https://github.com/faizufaizal08-oss/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev' || env.BRANCH_NAME == 'master') {
                        
                        withCredentials([usernamePassword(
                            credentialsId: 'dockerhub-creds',
                            usernameVariable: 'DOCKERHUB_USERNAME',
                            passwordVariable: 'DOCKERHUB_PASSWORD'
                        )]) {
                            def repo = (env.BRANCH_NAME == 'dev') ? "${DEV_REPO}:latest" : "${PROD_REPO}:latest"
                            sh """
                                docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
                                docker tag $IMAGE_NAME $repo
                                docker push $repo
                            """
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                sh './deploy.sh'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker login'
            sh 'docker logout'
        }
    }
}
