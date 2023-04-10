pipeline{
    agent any

    /*
        **NOTE: refresh the job page to enable the Parameters
        The "Build" on the left panel will change to "Build with Parameters"
        Build => Build with Parameters
    */
    parameters {
        booleanParam(name:'CreateResources', defaultValue:false, description: 'Apply on s3, route53 etc.')
        booleanParam(name:'DestroyResources', defaultValue:false, description: 'Destroy resources.')
    }
    environment {
        AWS_Cred = "aws_fotopie"
        // Working_Dir = ""
    }

    stages{
        
        stage('Terraform init'){
            steps{
				ansiColor('vga'){
					withAWS(credentials: "$AWS_Cred") {
						// dir("$Working_Dir") {
							sh "terraform  init"
						// }
					}
				}
            }
        }

        stage('Terraform apply'){
            when { 
                expression{ return params.CreateResources }
                expression{ return !params.DestroyResources}
            }
            steps{
				ansiColor('vga'){
					withAWS(credentials: "$AWS_Cred") {
						// dir("$Working_Dir") {
							sh "terraform  apply --auto-approve"
						// }
					}
				}
            }
        }

        stage('Terraform destroy'){
            when { 
                expression{ return !params.CreateResources }
                expression{ return params.DestroyResources }
            }
            steps{
				ansiColor('vga'){
					withAWS(credentials: "$AWS_Cred") {
						// dir("$Working_Dir") {
							sh "terraform  destroy --auto-approve"
						// }
					}
				}
            }
        }
    }

	post {
		always {
			//clean workspace
			cleanWs()
		}
	}	
}