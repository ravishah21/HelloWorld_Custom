node{
    try{
        notifyBuild('STARTED')

        stage('Initialize'){
            def dockerHome = '/usr/local/bin/'
            env.PATH = "${dockerHome}/bin:${env.PATH}"
        }
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

        stage ('Build Docker Images'){
            sh 'echo $PATH'
            sh  'docker build -t ravishah21/helloworld_custom:v1.0 .'
        }
        stage('Push Docker image'){
           withCredentials([string(credentialsId: 'secret', variable: 'dockersecret')]) {

            sh "docker login -u ravishah21 -p ${dockersecret}"
           }
            sh 'docker push ravishah21/helloworld_custom:v1.0'
        }
        stage ('remove old container'){
            sh 'docker rm helloworld_custom -f'
        }

        stage ('add new container application'){
          sh 'docker run --name helloworld_custom -d --publish 8082:5000  ravishah21/helloworld_custom:v1.0'
        }

        stage('Email')
          steps{
        }
    }
    catch (e) {
    // If there was an exception thrown, the build failed
    currentBuild.result = "FAILED"
    throw e
  } finally {
    // Success or failure, always send notifications
    notifyBuild(currentBuild.result)
  }
}

def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
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
  slackSend botUser: true,
  channel: 'jenkins-stream',
  color: colorCode,
  message: summary,
  tokenCredentialId: 'slack-token'
//  slackSend (color: colorCode, message: summary)
}
