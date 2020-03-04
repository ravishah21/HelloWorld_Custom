node{
    stage('Initialize'){
        def dockerHome = '/usr/local/bin/'
        env.PATH = "${dockerHome}/bin:${env.PATH}"
    }
    stage('GIT Check')
    {
       git credentialsId: 'git-creds', url: 'https://github.com/ravishah21/HelloWorld_Custom.git'
    }

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
}
