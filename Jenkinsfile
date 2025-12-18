pipeline {
    agent any

    environment {
        IMAGE_DEV = "faizalfaizu/react-dev"
        IMAGE_PROD = "faizalfaizu/react-prod"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Detect current branch
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    env.BRANCH = branch
                    echo "Building Docker image for branch: ${branch}"

                    // Use branch-specific image
                    if(branch == 'dev') {
                        sh "docker build -t ${IMAGE_DEV}:latest ."
                    } else if(branch == 'main') {
                        sh "docker build -t ${IMAGE_PROD}:latest ."
                    } else {
                        error "Branch ${branch} not configured for build"
                    }
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }

                script {
                    if(env.BRANCH == 'dev') {
                        sh "docker push ${IMAGE_DEV}:latest"
                    } else if(env.BRANCH == 'main') {
                        sh "docker push ${IMAGE_PROD}:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def imageToRun = env.BRANCH == 'dev' ? IMAGE_DEV : IMAGE_PROD
                    sh """
                        docker rm -f react-app || true
                        docker run -d -p 80:80 --name react-app ${imageToRun}:latest
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
