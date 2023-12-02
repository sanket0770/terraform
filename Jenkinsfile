pipeline {
    agent any
  

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Python Script') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '25c9050a-a97c-46f2-9968-26db13b6e929', accessKeyVariable: 'AKIAX3LNWYOGIVRPHOXY', secretKeyVariable: '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']]) 
                
                    {                
                        bat 'python pscript.py'
                    }
                }
            }
        }
    }
}
