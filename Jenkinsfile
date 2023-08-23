pipeline {
    agent any
    tools {
        maven 'maven 3.8.6'
    }
    stages {
        
        stage('Build with Maven'){
            steps{
                echo 'Building with Maven'
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'Git_cred', url: 'https://github.com/Bestedeki/web-app.git']])
                sh 'mvn clean package'
                echo 'Building done'
            }
        }
        stage('Test with Sonarqube'){
            steps{
                echo 'Testing with Sonarqube'
                sh 'mvn sonar:sonar'
                echo 'Testing done'
            }
        }
        stage('Upload to Nexus'){
            steps{
                echo 'Uploading to Nexus'
                sh 'mvn deploy'
                echo 'Uploading done'
            }
        }
        stage('Build Docker Image'){
            steps{
                echo 'Building Docker Image'
                /*sh 'docker rm -f my-app'
                sh 'docker rmi -f bestedeki/my-web-app:latest' */
                sh 'docker build -t bestedeki/my-web-app:latest .'
                echo 'Docker Image built'
            }
        }
        stage('Push Docker Image to Dockerhub'){
            steps{
                withCredentials([string(credentialsId: 'bestedeki', variable: 'mydockerhubpwd')]) {
                    sh 'docker login -u bestedeki -p ${dockerhubpwd}'  
                    sh 'docker push bestedeki/my-web-app:latest'
                }
            }
        }
        stage('Deploy to Tomcat'){
            steps{
                echo 'Running a Tomcat Container off my-web-app base image'
                sh 'docker run --name my-app -d -p 1000:8080 bestedeki/my-web-app:latest'
                echo 'Deployment done'
            }
        }
    }
}
