pipeline {
    agent any
    environment {
        SCANNER_HOME = tool 'sonar'
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/ram-nivas234/php-project.git'
                sh 'ls -la'  // Verify files after checkout
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=php-project \
                        -Dsonar.projectKey=php
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }

        // stage('OWASP FS Scan') {
        //     steps {
        //         dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
        //         dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //     }
        // }

        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs . > trivyfs.txt'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred-devcot', toolName: 'docker') {
                        sh '''
                            echo "Building Docker image..."
                            docker build --no-cache -t ramnivas23/php-project:v1 .

                            echo "Pushing Docker image to registry..."
                            docker push ramnivas23/php-project:v1
                        '''
                    }
                }
            }
        }

        stage('Deploy to Container') {
            steps {
                sh '''
                    echo "Stopping and removing old container..."
                    docker stop php || true
                    docker rm php || true

                    echo "Running new container on port 80..."
                    docker run -d --restart=always --name php -p 80:80 ramnivas23/php-project:v1

                    echo "Checking running containers..."
                    docker ps -a
                '''
            }
        }
    }
}
