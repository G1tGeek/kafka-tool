pipeline {
    
    agent any
    
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select action: apply or destroy')
    }
    
    environment {
        TERRAFORM_WORKSPACE = "${WORKSPACE}/terraform"
        KAFKA_WORKSPACE = "${WORKSPACE}/ansible"
        PRODUCER_WORKSPACE = "${WORKSPACE}/producer"
        DB_WORKSPACE = "${WORKSPACE}/database"
        CONSUMER_WORKSPACE = "${WORKSPACE}/consumer"
    }
    
    stages {
        
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/G1tGeek/kafka-tool.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh "terraform -chdir=${env.TERRAFORM_WORKSPACE} init"
            }
        }
        
        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh "terraform -chdir=${env.TERRAFORM_WORKSPACE} apply --auto-approve"
            }
        }
        
        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                sh "terraform -chdir=${env.TERRAFORM_WORKSPACE} destroy --auto-approve"
            }
        }
        
        stage('Extract Kafka Host 1 IP') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    def kafkaHostIP1 = readFile(file: "/var/lib/jenkins/workspace/one-click/terraform/kafka1.txt").trim()
                    env.KAFKA_HOST1 = kafkaHostIP1
                }
            }
        }

        stage('Extract Kafka Host 2 IP') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    def kafkaHostIP2 = readFile(file: "/var/lib/jenkins/workspace/one-click/terraform/kafka2.txt").trim()
                    env.KAFKA_HOST2 = kafkaHostIP2
                }
            }
        }
        stage('Extract Kafka Host 3 IP') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    def kafkaHostIP3 = readFile(file: "/var/lib/jenkins/workspace/one-click/terraform/kafka3.txt").trim()
                    env.KAFKA_HOST3 = kafkaHostIP3
                }
            }
        }
        stage('Install Kafka') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                ansiblePlaybook credentialsId: 'c479b83a-afdb-4eec-9037-f5631f535905',
                disableHostKeyChecking: true,
                installation: 'ansible',
                inventory: "${env.KAFKA_WORKSPACE}/aws_ec2.yml",
                playbook: "${env.KAFKA_WORKSPACE}/install.yml",
                extraVars: 
                [
                kafka_host1: "${env.KAFKA_HOST1}",
                kafka_host2: "${env.KAFKA_HOST2}",
                kafka_host3: "${env.KAFKA_HOST3}"
                ]
            }
        }
        
        stage('Kafka producer API') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                ansiblePlaybook credentialsId: 'c479b83a-afdb-4eec-9037-f5631f535905',
                disableHostKeyChecking: true,
                installation: 'ansible',
                inventory: "${env.PRODUCER_WORKSPACE}/aws_ec2.yml",
                playbook: "${env.PRODUCER_WORKSPACE}/install.yml",
                extraVars: [kafka_host: "${env.KAFKA_HOST1}"]
            }
        }
        
        stage('Install MongoDB') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                ansiblePlaybook credentialsId: 'c479b83a-afdb-4eec-9037-f5631f535905',
                disableHostKeyChecking: true,
                installation: 'ansible',
                inventory: "${env.DB_WORKSPACE}/aws_ec2.yml",
                playbook: "${env.DB_WORKSPACE}/install.yml"
            }
        }
        
        stage('Kafka Consumer API') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                ansiblePlaybook(
                    credentialsId: 'c479b83a-afdb-4eec-9037-f5631f535905',
                    disableHostKeyChecking: true,
                    installation: 'ansible',
                    inventory: "${env.CONSUMER_WORKSPACE}/aws_ec2.yml",
                    playbook: "${env.CONSUMER_WORKSPACE}/install.yml",
                    extraVars: [kafka_host: "${env.KAFKA_HOST1}"]
                )
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            slackSend channel: 'noti',
                      message: "SUCCESS: Pipeline '${env.JOB_NAME}' [#${env.BUILD_NUMBER}] completed successfully. Check the details: ${env.BUILD_URL}"
        }
        failure {
            echo 'Pipeline failed!'
            slackSend channel: 'noti',
                      message: "FAILURE: Pipeline '${env.JOB_NAME}' [#${env.BUILD_NUMBER}] failed. Check the details: ${env.BUILD_URL}"
        }
    }
}
