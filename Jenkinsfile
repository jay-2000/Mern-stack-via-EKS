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
                sh """
                    docker build -t $FRONTEND_REPO:$BUILD_NUMBER frontend/
                    docker build -t $BACKEND_REPO:$BUILD_NUMBER backend/
                """
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
                echo "🔧 Updating Helm values.yaml with new image tags..."

                # Update registry
                sed -i "s|^imageRegistry:.*|imageRegistry: \\"${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com\\"|" $VALUES_FILE

                # Update frontend tag
                sed -i "s|tag:.*|tag: \\"${BUILD_NUMBER}\\"|g" $VALUES_FILE

                # Update backend tag
                sed -i "0,/backend:/!b; :a; n; /tag:/s|tag:.*|tag: \\"${BUILD_NUMBER}\\"|; ta" $VALUES_FILE

                echo "✔ Updated Helm values.yaml:"
                cat $VALUES_FILE
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
