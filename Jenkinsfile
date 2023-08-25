pipeline {
    agent any
    tools{
        maven 'maven3.8.6'
    }
    environment{     
    DOCKERHUB_CREDENTIALS=credentials('dockerhubpwd')     
}
    stages{
        stage('Build with Maven') {
            steps{
                echo 'Building with Maven'
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'Git_Cred', url: 'https://github.com/Bestedeki/web-app.git']])
                sh 'mvn clean package'
                echo 'Building done'
            }
        }
        stage('Test with SonarQube') {
            steps{
                echo 'Testing with Sonarqube'
                sh 'mvn sonar:sonar'
                echo 'Testing done'
            }
        }
        stage('Upload to Nexus') {
            steps{
                echo 'Uploading to Nexus'
                sh 'mvn deploy'
                echo 'Uploading done'
            }
        }
        stage('Slack Notification') {
            steps{
                echo 'Sending slack notification'
                slackSend channel: '#general', message: 'Build Success, kindly review and approve for further processing'
                echo 'Notification sent'
            }
        }
        stage('Send Email Notification'){
            steps{
                echo 'Sending email notification'
                emailext attachLog: true, body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:

Check console output at $BUILD_URL to view the results.''', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'bestedeki@protonmail.com'

                echo 'Email notification sent'
            }
        }
        stage('Approval') {
            steps{
                echo 'Seeking approval'
                timeout(time: 5, unit: "DAYS"){
                input message: 'Approve to production'
                }
            }
        }
        stage('Build Docker Image') {
            steps{
                echo 'Building Docker Image'
                sh 'docker rm -f mywebapp'
                sh 'docker rmi -f bestedeki/mywebapp'
                sh 'docker build -t bestedeki/mywebapp .'
                echo 'Docker image built'
                
            }
        }
        stage('Push Image to Dockerhub') {
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin' 
                sh 'docker push bestedeki/mywebapp'
            }
        }
        stage('Deploy to Tomcat'){
            steps{
                echo 'Running a Tomcat container off mywebapp docker image'
                sh 'docker run --name mywebapp -d -p 3100:8080 bestedeki/mywebapp'
                echo 'Deployment done'
            }
        }
    }
}
