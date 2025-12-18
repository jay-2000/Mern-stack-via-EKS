pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"

        // load account ID from Jenkins credentials
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

        stage('Update Helm Values') {
            steps {
                sh '''
                sed -i "s/frontendTag:.*/frontendTag: \\"$BUILD_NUMBER\\"/" helm/mern/values.yaml
                sed -i "s/backendTag:.*/backendTag: \\"$BUILD_NUMBER\\"/" helm/mern/values.yaml
                '''
            }
        }

        stage('Push Git Changes') {
            steps {
                sh '''
                git add .
                git commit -m "Update tags to $BUILD_NUMBER" || echo "No changes"
                git push
                '''
            }
        }
    }
}
