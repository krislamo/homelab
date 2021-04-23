pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir ('environments') {
                    git branch: "${env.BRANCH}",
                        credentialsId: "${env.AUTHID}",
                        url: "${env.URL}"
                }
                ansiblePlaybook playbook: "${env.PLAYBOOK}",
                    inventory: "${env.INVENTORY}",
                    limit: params.getOrDefault('LIMIT', 'all'),
                    tags: params.getOrDefault('TAGS', 'all')
            }
        }
    }
    post {
        failure {
            mail to: "${env.EMAIL}",
                 subject: "$JOB_NAME - Build # $BUILD_NUMBER -  ${currentBuild.result}!",
                 body: "Check console output at $BUILD_URL to view the results."
        }
    }
}
