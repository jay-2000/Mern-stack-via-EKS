pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"

        // Load AWS Account ID from Jenkins credentials
        ACCOUNT_ID = credentials('aws-account-id')

        FRONTEND_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/mern-frontend"
        BACKEND_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/mern-backend"
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
                sh 'docker build -t $FRONTEND_REPO:$BUILD_NUMBER frontend/'
                sh 'docker build -t $BACKEND_REPO:$BUILD_NUMBER backend/'
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh 'docker push $FRONTEND_REPO:$BUILD_NUMBER'
                sh 'docker push $BACKEND_REPO:$BUILD_NUMBER'
            }
        }

        stage('Update Helm Values for GitOps') {
            steps {
                sh '''
                # Update frontend tag
                sed -i 's|tag:.*|tag: "${BUILD_NUMBER}"|g' helm/mern-chart/values.yaml

                # Update backend tag
                sed -i "0,/tag:/s//tag: \\"$BUILD_NUMBER\\"/" helm/mern-chart/values.yaml
                

                # Update registry
                sed -i 's|imageRegistry:.*|imageRegistry: "****.dkr.ecr.ap-south-1.amazonaws.com"|g' helm/mern-chart/values.yaml
                '''
            }
        }

        stage('Push Git Changes') {
            steps {
                sh '''
                git config user.name "jay-2000"
                git config user.email "jayparmar7654321@gmail.com"
                git remote set-url origin https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/jay-2000/Mern-stack-via-EKS.git
                git status
                git add .
                git commit -m "Update Helm image tag to ${BUILD_NUMBER}" || echo "No changes to commit"
                git push origin main
                '''
            }
        }
    }
}
