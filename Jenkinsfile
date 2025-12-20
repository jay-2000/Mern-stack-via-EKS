pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"

        // AWS Account ID stored as Jenkins secret text
        ACCOUNT_ID = credentials('aws-account-id')

        FRONTEND_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/mern-frontend"
        BACKEND_REPO  = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/mern-backend"

        VALUES_FILE = "helm/mern-chart/values.yaml"
    }

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/jay-2000/Mern-stack-via-EKS.git',
                    credentialsId: 'github-token'
            }
        }

        stage('AWS ECR Login') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                    | docker login --username AWS --password-stdin \
                      $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    // your backend API URL routed through ALB
                    def BACKEND_API_URL = "http://http://k8s-default-merningr-0d5e0b1ab8-1245109416.ap-south-1.elb.amazonaws.com/api"
                    // OR if using domain: https://mern.yourdomain.com/api

                    sh """
                        docker build \
                            --build-arg REACT_APP_BACKEND_URL=${BACKEND_API_URL} \
                            -t $FRONTEND_REPO:$BUILD_NUMBER frontend/

                        docker build \
                            -t $BACKEND_REPO:$BUILD_NUMBER backend/
                    """
                }
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh """
                    docker push $FRONTEND_REPO:$BUILD_NUMBER
                    docker push $BACKEND_REPO:$BUILD_NUMBER
                """
            }
        }

        stage('Update Helm Values (GitOps)') {
            steps {
                sh '''
                chmod +x scripts/update-values.sh

                ./scripts/update-values.sh $BUILD_NUMBER $BUILD_NUMBER
                '''
            }
        }

        stage('Commit & Push Git Changes') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-token',
                    usernameVariable: 'GIT_USERNAME',
                    passwordVariable: 'GIT_TOKEN'
                )]) {

                    sh '''
                        git config user.name "jay-2000"
                        git config user.email "jayparmar7654321@gmail.com"

                        git remote set-url origin https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/jay-2000/Mern-stack-via-EKS.git

                        git add helm/mern-chart/values.yaml
                        git commit -m "CI: Update image tags for build ${BUILD_NUMBER}" || echo "No changes to commit"
                        git push origin main
                    '''
                }
            }
        }
    }
}
