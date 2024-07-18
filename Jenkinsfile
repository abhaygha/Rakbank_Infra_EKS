pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TERRAFORM_VERSION = '1.5.6'
        WORKSPACE_NAME = 'default'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Terraform') {
            steps {
                script {
                    def terraformHome = tool name: 'Terraform', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
                    env.PATH = "${terraformHome}/bin:${env.PATH}"
                }
            }
        }

        stage('Configure AWS Credentials') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
                AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
            }
            steps {
                script {
                    withAWS(role: 'arn:aws:iam::891377120087:role/github-action-role', region: "${AWS_REGION}") {
                        sh 'aws sts get-caller-identity'
                    }
                }
            }
        }

        stage('Debug - List files') {
            steps {
                sh 'ls -l terraform'
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Select Terraform Workspace') {
            steps {
                dir('terraform') {
                    script {
                        def workspaceExists = sh(script: "terraform workspace list | grep -w ${WORKSPACE_NAME}", returnStatus: true) == 0
                        if (workspaceExists) {
                            sh "terraform workspace select ${WORKSPACE_NAME}"
                        } else {
                            sh "terraform workspace new ${WORKSPACE_NAME}"
                        }
                    }
                }
            }
        }

        stage('Validate Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
