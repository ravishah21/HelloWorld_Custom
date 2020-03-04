node{
    try{
        notifyBuild('NEW BUILT INITIATED')

        stage('Initialize'){
            def dockerHome = '/usr/local/bin/'
            env.PATH = "${dockerHome}/bin:${env.PATH}"
        }

        notifyBuild('VERIFYING GITHUB CREDENTIALS')
        stage('GIT Check')
        {
           git credentialsId: 'git-creds', url: 'https://github.com/ravishah21/HelloWorld_Custom.git'
        }

    /* ***********Work in progress****************
        stage('stop old Ngrok process'){
            try {
                sh label: '', script: 'ps -ef | grep ngrok | grep -v grep | awk \'{print $2}\' | xargs kill'
            }
            catch (exc) {
                echo ' No Ngrok tunnel running'
            }
        }
        stage('start new Ngrok tunnel'){
            sh label: '', script: './ngrok_run_after_boot.sh'
        }
    ***********Work in progress**************** */

        notifyBuild('BUILDING DOCKER IMAGE')
        stage ('Build Docker Image'){
            sh 'echo $PATH'
            sh  'docker build -t ravishah21/helloworld_custom:v1.0 .'
        }

        notifyBuild('PUSHING DOCKER IMAGE')
        stage('Push Docker image'){
           withCredentials([string(credentialsId: 'secret', variable: 'dockersecret')]) {

            sh "docker login -u ravishah21 -p ${dockersecret}"
           }
            sh 'docker push ravishah21/helloworld_custom:v1.0'
        }

        notifyBuild('REMOVING OLD CONTAINER')
        stage ('remove old container'){
            sh 'docker rm helloworld_custom -f'
        }

        notifyBuild('ADDING NEW CONTAINER')
        stage ('add new container application'){
          sh 'docker run --name helloworld_custom -d --publish 8082:5000  ravishah21/helloworld_custom:v1.0'
        }
    }
/*
        stage('Email')
          steps{
        }
*/

    catch (e) {
    // If there was an exception thrown, the build failed
    currentBuild.result = "FAILED"
    throw e
  } finally {
    // Success or failure, always send notifications
    sh 'echo currentBuild.result'
    notifyBuild(currentBuild.result)
  }
}

def notifyBuild(String buildStatus = 'NEW BUILT INITIATED') {
  // build status of null means successful
  sh 'echo buildStatus'
  buildStatus =  buildStatus ?: 'SUCCESSFUL'
  sh 'echo buildStatus'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'BUILDING DOCKER IMAGE') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'VERIFYING GITHUB CREDENTIALS') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'PUSHING DOCKER IMAGE') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'REMOVING OLD CONTAINER') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'ADDING NEW CONTAINER') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend ( botUser: true,
            channel: 'jenkins-stream',
            color: colorCode,
            message: summary,
            tokenCredentialId: 'slack-token')
}
